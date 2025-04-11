;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0x1000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0x1000))

;; wasm[0]::function[0]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       ld      a5, 0x48(a0)
;;       slli    a4, a2, 0x20
;;       srli    a1, a4, 0x20
;;       lui     a4, 1
;;       addi    a2, a4, 1
;;       sub     a5, a5, a2
;;       bgeu    a5, a1, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       ld      a0, 0x40(a0)
;;       add     a0, a0, a1
;;       lui     t6, 1
;;       add     t6, t6, a0
;;       sb      a3, 0(t6)
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
;;       ld      a5, 0x48(a0)
;;       slli    a4, a2, 0x20
;;       srli    a1, a4, 0x20
;;       lui     a4, 1
;;       addi    a2, a4, 1
;;       sub     a5, a5, a2
;;       bgeu    a5, a1, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       ld      a0, 0x40(a0)
;;       add     a0, a0, a1
;;       lui     t6, 1
;;       add     t6, t6, a0
;;       lbu     a0, 0(t6)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
