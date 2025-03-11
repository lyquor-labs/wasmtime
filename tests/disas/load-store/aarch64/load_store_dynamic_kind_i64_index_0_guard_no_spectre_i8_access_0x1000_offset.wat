;;! target = "aarch64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -W memory64 -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

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
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x10, [x2, #0x58]
;;       mov     x11, #0x1001
;;       sub     x10, x10, x11
;;       cmp     x4, x10
;;       cset    x11, hi
;;       uxtb    w11, w11
;;       cbnz    x11, #0x38
;;   24: ldr     x12, [x2, #0x50]
;;       add     x12, x12, #1, lsl #12
;;       strb    w5, [x12, x4]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   38: .byte   0x1f, 0xc1, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x10, [x2, #0x58]
;;       mov     x11, #0x1001
;;       sub     x10, x10, x11
;;       cmp     x4, x10
;;       cset    x11, hi
;;       uxtb    w11, w11
;;       cbnz    x11, #0x78
;;   64: ldr     x12, [x2, #0x50]
;;       add     x11, x12, #1, lsl #12
;;       ldrb    w2, [x11, x4]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   78: .byte   0x1f, 0xc1, 0x00, 0x00
