;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

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
;;       mv      a1, a0
;;       slli    a4, a2, 0x20
;;       srli    a0, a4, 0x20
;;       auipc   a5, 0
;;       ld      a5, 0x54(a5)
;;       add     a5, a0, a5
;;       bgeu    a5, a0, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       mv      a2, a1
;;       ld      a1, 0x58(a2)
;;       ld      a2, 0x50(a2)
;;       sltu    a1, a1, a5
;;       add     a0, a2, a0
;;       lui     a5, 0xffff
;;       slli    a2, a5, 4
;;       add     a0, a0, a2
;;       neg     a4, a1
;;       not     a1, a4
;;       and     a2, a0, a1
;;       sb      a3, 0(a2)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;       .byte   0x01, 0x00, 0xff, 0xff
;;       .byte   0x00, 0x00, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       mv      a1, a0
;;       slli    a4, a2, 0x20
;;       srli    a0, a4, 0x20
;;       auipc   a5, 0
;;       ld      a5, 0x54(a5)
;;       add     a5, a0, a5
;;       bgeu    a5, a0, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       mv      a2, a1
;;       ld      a1, 0x58(a2)
;;       ld      a2, 0x50(a2)
;;       sltu    a1, a1, a5
;;       add     a0, a2, a0
;;       lui     a5, 0xffff
;;       slli    a2, a5, 4
;;       add     a0, a0, a2
;;       neg     a4, a1
;;       not     a1, a4
;;       and     a2, a0, a1
;;       lbu     a0, 0(a2)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;       .byte   0x01, 0x00, 0xff, 0xff
;;       .byte   0x00, 0x00, 0x00, 0x00
