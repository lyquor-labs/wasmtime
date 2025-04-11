;;! target = "aarch64"
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
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x11, [x2, #0x48]
;;       ldr     x14, [x2, #0x40]
;;       mov     w12, w4
;;       mov     x13, #0
;;       add     x14, x14, w4, uxtw
;;       mov     x15, #0xffff0000
;;       add     x14, x14, x15
;;       cmp     x12, x11
;;       csel    x12, x13, x14, hi
;;       csdb
;;       strb    w5, [x12]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x11, [x2, #0x48]
;;       ldr     x14, [x2, #0x40]
;;       mov     w12, w4
;;       mov     x13, #0
;;       add     x14, x14, w4, uxtw
;;       mov     x15, #0xffff0000
;;       add     x14, x14, x15
;;       cmp     x12, x11
;;       csel    x12, x13, x14, hi
;;       csdb
;;       ldrb    w2, [x12]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
