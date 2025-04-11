;;! target = "aarch64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -O static-memory-maximum-size=0 -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

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
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x9, [x2, #0x48]
;;       mov     w10, w4
;;       cmp     x10, x9
;;       cset    x10, hi
;;       uxtb    w10, w10
;;       cbnz    x10, #0x34
;;   20: ldr     x11, [x2, #0x40]
;;       add     x11, x11, #1, lsl #12
;;       strb    w5, [x11, w4, uxtw]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   34: .byte   0x1f, 0xc1, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x9, [x2, #0x48]
;;       mov     w10, w4
;;       cmp     x10, x9
;;       cset    x10, hi
;;       uxtb    w10, w10
;;       cbnz    x10, #0x74
;;   60: ldr     x11, [x2, #0x40]
;;       add     x10, x11, #1, lsl #12
;;       ldrb    w2, [x10, w4, uxtw]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   74: .byte   0x1f, 0xc1, 0x00, 0x00
