//! Interface with the external assembler crate.

use super::{
    regs, Amode, Gpr, Inst, LabelUse, MachBuffer, MachLabel, OperandVisitor, OperandVisitorImpl,
    SyntheticAmode, VCodeConstant, WritableGpr, WritableXmm, Xmm,
};
use crate::ir::TrapCode;
use cranelift_assembler_x64 as asm;
use std::string::String;

/// Define the types of registers Cranelift will use.
#[derive(Clone, Debug)]
pub struct CraneliftRegisters;
impl asm::Registers for CraneliftRegisters {
    type ReadGpr = Gpr;
    type ReadWriteGpr = PairedGpr;
    type ReadXmm = Xmm;
    type ReadWriteXmm = PairedXmm;
}

/// A pair of registers, one for reading and one for writing.
///
/// Due to how Cranelift's SSA form, we must track the read and write registers
/// separately prior to register allocation. Once register allocation is
/// complete, we expect the hardware encoding for both `read` and `write` to be
/// the same.
#[derive(Clone, Copy, Debug)]
pub struct PairedGpr {
    pub(crate) read: Gpr,
    pub(crate) write: WritableGpr,
}

impl asm::AsReg for PairedGpr {
    fn enc(&self) -> u8 {
        let PairedGpr { read, write } = self;
        let read = enc_gpr(read);
        let write = enc_gpr(&write.to_reg());
        assert_eq!(read, write);
        write
    }

    fn to_string(&self, size: Option<asm::Size>) -> String {
        if self.read.is_real() {
            asm::gpr::enc::to_string(self.enc(), size.unwrap()).into()
        } else {
            let read = self.read.to_reg();
            let write = self.write.to_reg().to_reg();
            format!("(%{write:?} <- %{read:?})")
        }
    }

    fn new(_: u8) -> Self {
        panic!("disallow creation of new assembler registers")
    }
}

/// A pair of XMM registers, one for reading and one for writing.
#[derive(Clone, Copy, Debug)]
pub struct PairedXmm {
    pub(crate) read: Xmm,
    pub(crate) write: WritableXmm,
}

impl asm::AsReg for PairedXmm {
    fn enc(&self) -> u8 {
        let PairedXmm { read, write } = self;
        let read = enc_xmm(read);
        let write = enc_xmm(&write.to_reg());
        assert_eq!(read, write);
        write
    }

    fn to_string(&self, size: Option<asm::Size>) -> String {
        assert!(size.is_none(), "XMM registers do not have size variants");
        if self.read.is_real() {
            asm::xmm::enc::to_string(self.enc()).into()
        } else {
            let read = self.read.to_reg();
            let write = self.write.to_reg().to_reg();
            format!("(%{write:?} <- %{read:?})")
        }
    }

    fn new(_: u8) -> Self {
        panic!("disallow creation of new assembler registers")
    }
}

/// This bridges the gap between codegen and assembler for general purpose register types.
impl asm::AsReg for Gpr {
    fn enc(&self) -> u8 {
        enc_gpr(self)
    }

    fn to_string(&self, size: Option<asm::Size>) -> String {
        if self.is_real() {
            asm::gpr::enc::to_string(self.enc(), size.unwrap()).into()
        } else {
            format!("%{:?}", self.to_reg())
        }
    }

    fn new(_: u8) -> Self {
        panic!("disallow creation of new assembler registers")
    }
}

/// This bridges the gap between codegen and assembler for xmm register types.
impl asm::AsReg for Xmm {
    fn enc(&self) -> u8 {
        enc_xmm(self)
    }

    fn to_string(&self, size: Option<asm::Size>) -> String {
        assert!(size.is_none(), "XMM registers do not have size variants");
        if self.is_real() {
            asm::xmm::enc::to_string(self.enc()).into()
        } else {
            format!("%{:?}", self.to_reg())
        }
    }

    fn new(_: u8) -> Self {
        panic!("disallow creation of new assembler registers")
    }
}

/// A helper method for extracting the hardware encoding of a general purpose register.
#[inline]
fn enc_gpr(gpr: &Gpr) -> u8 {
    if let Some(real) = gpr.to_reg().to_real_reg() {
        real.hw_enc()
    } else {
        unreachable!()
    }
}

/// A helper method for extracting the hardware encoding of an xmm register.
#[inline]
fn enc_xmm(xmm: &Xmm) -> u8 {
    if let Some(real) = xmm.to_reg().to_real_reg() {
        real.hw_enc()
    } else {
        unreachable!()
    }
}

/// A wrapper to implement the `cranelift-assembler-x64` register allocation trait,
/// `RegallocVisitor`, in terms of the trait used in Cranelift,
/// `OperandVisitor`.
pub(crate) struct RegallocVisitor<'a, T>
where
    T: OperandVisitorImpl,
{
    pub collector: &'a mut T,
}

impl<'a, T: OperandVisitor> asm::RegisterVisitor<CraneliftRegisters> for RegallocVisitor<'a, T> {
    fn read(&mut self, reg: &mut Gpr) {
        self.collector.reg_use(reg);
    }

    fn read_write(&mut self, reg: &mut PairedGpr) {
        let PairedGpr { read, write } = reg;
        self.collector.reg_use(read);
        self.collector.reg_reuse_def(write, 0);
    }

    fn fixed_read(&mut self, _reg: &Gpr) {
        todo!()
    }

    fn fixed_read_write(&mut self, _reg: &PairedGpr) {
        todo!()
    }

    fn read_xmm(&mut self, reg: &mut Xmm) {
        self.collector.reg_use(reg);
    }

    fn read_write_xmm(&mut self, reg: &mut PairedXmm) {
        let PairedXmm { read, write } = reg;
        self.collector.reg_use(read);
        self.collector.reg_reuse_def(write, 0);
    }

    fn fixed_read_xmm(&mut self, _reg: &Xmm) {
        todo!()
    }

    fn fixed_read_write_xmm(&mut self, _reg: &PairedXmm) {
        todo!()
    }
}

impl Into<asm::Amode<Gpr>> for SyntheticAmode {
    fn into(self) -> asm::Amode<Gpr> {
        match self {
            SyntheticAmode::Real(amode) => amode.into(),
            SyntheticAmode::IncomingArg { offset } => asm::Amode::ImmReg {
                base: Gpr::unwrap_new(regs::rbp()),
                simm32: asm::AmodeOffsetPlusKnownOffset {
                    simm32: (-i32::try_from(offset).unwrap()).into(),
                    offset: Some(offsets::KEY_INCOMING_ARG),
                },
                trap: None,
            },
            SyntheticAmode::SlotOffset { simm32 } => asm::Amode::ImmReg {
                base: Gpr::unwrap_new(regs::rbp()),
                simm32: asm::AmodeOffsetPlusKnownOffset {
                    simm32: simm32.into(),
                    offset: Some(offsets::KEY_SLOT_OFFSET),
                },
                trap: None,
            },
            SyntheticAmode::ConstantOffset(vcode_constant) => asm::Amode::RipRelative {
                target: asm::DeferredTarget::Constant(asm::Constant(vcode_constant.as_u32())),
            },
        }
    }
}

impl Into<asm::Amode<Gpr>> for Amode {
    fn into(self) -> asm::Amode<Gpr> {
        match self {
            Amode::ImmReg {
                simm32,
                base,
                flags,
            } => asm::Amode::ImmReg {
                simm32: asm::AmodeOffsetPlusKnownOffset {
                    simm32: simm32.into(),
                    offset: None,
                },
                base: Gpr::unwrap_new(base),
                trap: flags.trap_code().map(Into::into),
            },
            Amode::ImmRegRegShift {
                simm32,
                base,
                index,
                shift,
                flags,
            } => asm::Amode::ImmRegRegShift {
                base,
                index: asm::NonRspGpr::new(index),
                scale: asm::Scale::new(shift),
                simm32: simm32.into(),
                trap: flags.trap_code().map(Into::into),
            },
            Amode::RipRelative { target } => asm::Amode::RipRelative {
                target: asm::DeferredTarget::Label(asm::Label(target.as_u32())),
            },
        }
    }
}

/// Keep track of the offset slots to fill in during emission; see
/// `KnownOffsetTable`.
pub mod offsets {
    pub const KEY_INCOMING_ARG: usize = 0;
    pub const KEY_SLOT_OFFSET: usize = 1;
}

impl asm::CodeSink for MachBuffer<Inst> {
    fn put1(&mut self, value: u8) {
        self.put1(value)
    }

    fn put2(&mut self, value: u16) {
        self.put2(value)
    }

    fn put4(&mut self, value: u32) {
        self.put4(value)
    }

    fn put8(&mut self, value: u64) {
        self.put8(value)
    }

    fn current_offset(&self) -> u32 {
        self.cur_offset()
    }

    fn use_label_at_offset(&mut self, offset: u32, label: asm::Label) {
        self.use_label_at_offset(offset, label.into(), LabelUse::JmpRel32);
    }

    fn add_trap(&mut self, code: asm::TrapCode) {
        self.add_trap(code.into());
    }

    fn get_label_for_constant(&mut self, c: asm::Constant) -> asm::Label {
        self.get_label_for_constant(c.into()).into()
    }
}

impl From<asm::TrapCode> for TrapCode {
    fn from(value: asm::TrapCode) -> Self {
        Self::from_raw(value.0)
    }
}

impl From<TrapCode> for asm::TrapCode {
    fn from(value: TrapCode) -> Self {
        Self(value.as_raw())
    }
}

impl From<asm::Label> for MachLabel {
    fn from(value: asm::Label) -> Self {
        Self::from_u32(value.0)
    }
}

impl From<MachLabel> for asm::Label {
    fn from(value: MachLabel) -> Self {
        Self(value.as_u32())
    }
}

impl From<asm::Constant> for VCodeConstant {
    fn from(value: asm::Constant) -> Self {
        Self::from_u32(value.0)
    }
}

// Include code generated by `cranelift-codegen/meta/src/gen_asm.rs`. This file
// contains a `isle_assembler_methods!` macro with Rust implementations of all
// the assembler instructions exposed to ISLE.
include!(concat!(env!("OUT_DIR"), "/assembler-isle-macro.rs"));
pub(crate) use isle_assembler_methods;

#[cfg(test)]
mod tests {
    use super::asm::{AsReg, Size};
    use super::PairedGpr;
    use crate::isa::x64::args::{FromWritableReg, Gpr, WritableGpr, WritableXmm, Xmm};
    use crate::isa::x64::inst::external::PairedXmm;
    use crate::{Reg, Writable};
    use regalloc2::{RegClass, VReg};

    #[test]
    fn pretty_print_registers() {
        // For logging, we need to be able to pretty-print the virtual registers
        // that Cranelift uses before register allocation. This test ensures
        // that these remain printable using the `AsReg::to_string` interface
        // (see issue #10631).

        let v200: Reg = VReg::new(200, RegClass::Int).into();
        let gpr200 = Gpr::new(v200).unwrap();
        assert_eq!(gpr200.to_string(Some(Size::Quadword)), "%v200");

        let v300: Reg = VReg::new(300, RegClass::Int).into();
        let wgpr300 = WritableGpr::from_writable_reg(Writable::from_reg(v300).into()).unwrap();
        let pair = PairedGpr {
            read: gpr200,
            write: wgpr300,
        };
        assert_eq!(pair.to_string(Some(Size::Quadword)), "(%v300 <- %v200)");

        let v400: Reg = VReg::new(400, RegClass::Float).into();
        let xmm400 = Xmm::new(v400).unwrap();
        assert_eq!(xmm400.to_string(None), "%v400");

        let v500: Reg = VReg::new(500, RegClass::Float).into();
        let wxmm500 = WritableXmm::from_writable_reg(Writable::from_reg(v500).into()).unwrap();
        let pair = PairedXmm {
            read: xmm400,
            write: wxmm500,
        };
        assert_eq!(pair.to_string(None), "(%v500 <- %v400)");
    }
}
