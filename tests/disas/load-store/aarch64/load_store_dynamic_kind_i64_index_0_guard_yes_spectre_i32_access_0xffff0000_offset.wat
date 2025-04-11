;;! target = "aarch64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -W memory64 -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store offset=0xffff0000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load offset=0xffff0000))

;; wasm[0]::function[0]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       mov     w12, #-0xfffc
;;       adds    x12, x4, x12
;;       b.hs    #0x44
;;   14: ldr     x13, [x2, #0x48]
;;       ldr     x15, [x2, #0x40]
;;       mov     x14, #0
;;       add     x15, x15, x4
;;       mov     x0, #0xffff0000
;;       add     x15, x15, x0
;;       cmp     x12, x13
;;       csel    x14, x14, x15, hi
;;       csdb
;;       str     w5, [x14]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   44: .byte   0x1f, 0xc1, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       mov     w12, #-0xfffc
;;       adds    x12, x4, x12
;;       b.hs    #0xa4
;;   74: ldr     x13, [x2, #0x48]
;;       ldr     x15, [x2, #0x40]
;;       mov     x14, #0
;;       add     x15, x15, x4
;;       mov     x0, #0xffff0000
;;       add     x15, x15, x0
;;       cmp     x12, x13
;;       csel    x14, x14, x15, hi
;;       csdb
;;       ldr     w2, [x14]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   a4: .byte   0x1f, 0xc1, 0x00, 0x00
