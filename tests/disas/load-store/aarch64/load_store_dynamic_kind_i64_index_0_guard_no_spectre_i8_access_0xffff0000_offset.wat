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
    i32.store8 offset=0xffff0000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load8_u offset=0xffff0000))

;; wasm[0]::function[0]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       mov     w11, #-0xffff
;;       adds    x11, x4, x11
;;       b.hs    #0x40
;;   14: ldr     x12, [x2, #0x48]
;;       cmp     x11, x12
;;       cset    x13, hi
;;       uxtb    w13, w13
;;       cbnz    x13, #0x44
;;   28: ldr     x14, [x2, #0x40]
;;       add     x14, x14, x4
;;       mov     x15, #0xffff0000
;;       strb    w5, [x14, x15]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   40: .byte   0x1f, 0xc1, 0x00, 0x00
;;   44: .byte   0x1f, 0xc1, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       mov     w11, #-0xffff
;;       adds    x11, x4, x11
;;       b.hs    #0xa0
;;   74: ldr     x12, [x2, #0x48]
;;       cmp     x11, x12
;;       cset    x13, hi
;;       uxtb    w13, w13
;;       cbnz    x13, #0xa4
;;   88: ldr     x14, [x2, #0x40]
;;       add     x14, x14, x4
;;       mov     x15, #0xffff0000
;;       ldrb    w2, [x14, x15]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   a0: .byte   0x1f, 0xc1, 0x00, 0x00
;;   a4: .byte   0x1f, 0xc1, 0x00, 0x00
