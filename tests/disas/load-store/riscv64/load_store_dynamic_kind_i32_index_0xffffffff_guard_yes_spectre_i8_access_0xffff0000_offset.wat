;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-maximum-size=0 -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0xffff0000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0xffff0000))

;; wasm[0]::function[0]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       ld      a4, 0x48(a0)
;;       ld      a5, 0x40(a0)
;;       slli    a2, a2, 0x20
;;       srli    a0, a2, 0x20
;;       sltu    a4, a4, a0
;;       add     a5, a5, a0
;;       lui     a2, 0xffff
;;       slli    a0, a2, 4
;;       add     a5, a5, a0
;;       neg     a1, a4
;;       not     a4, a1
;;       and     a5, a5, a4
;;       sb      a3, 0(a5)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;
;; wasm[0]::function[1]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       ld      a3, 0x48(a0)
;;       ld      a4, 0x40(a0)
;;       slli    a2, a2, 0x20
;;       srli    a5, a2, 0x20
;;       sltu    a3, a3, a5
;;       add     a4, a4, a5
;;       lui     a2, 0xffff
;;       slli    a5, a2, 4
;;       add     a4, a4, a5
;;       neg     a1, a3
;;       not     a3, a1
;;       and     a5, a4, a3
;;       lbu     a0, 0(a5)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
