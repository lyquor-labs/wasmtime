;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -W memory64 -O static-memory-forced -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0x1000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load8_u offset=0x1000))

;; wasm[0]::function[0]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       auipc   a1, 0
;;       ld      a1, 0x38(a1)
;;       bgeu    a1, a2, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       ld      a1, 0x50(a0)
;;       add     a1, a1, a2
;;       lui     t6, 1
;;       add     t6, t6, a1
;;       sb      a3, 0(t6)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       .byte   0xff, 0xef, 0xff, 0xff
;;       .byte   0x00, 0x00, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       auipc   a1, 0
;;       ld      a1, 0x38(a1)
;;       bgeu    a1, a2, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       ld      a1, 0x50(a0)
;;       add     a1, a1, a2
;;       lui     t6, 1
;;       add     t6, t6, a1
;;       lbu     a0, 0(t6)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       .byte   0xff, 0xef, 0xff, 0xff
;;       .byte   0x00, 0x00, 0x00, 0x00
