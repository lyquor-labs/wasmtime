;;! target = "aarch64"
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
    i32.store offset=0x1000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load offset=0x1000))

;; wasm[0]::function[0]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x14, [x2, #0x48]
;;       ldr     x13, [x2, #0x40]
;;       mov     w12, w4
;;       mov     x15, #0x1004
;;       sub     x14, x14, x15
;;       mov     x15, #0
;;       add     x13, x13, w4, uxtw
;;       add     x13, x13, #1, lsl #12
;;       cmp     x12, x14
;;       csel    x13, x15, x13, hi
;;       csdb
;;       str     w5, [x13]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       ldr     x14, [x2, #0x48]
;;       ldr     x13, [x2, #0x40]
;;       mov     w12, w4
;;       mov     x15, #0x1004
;;       sub     x14, x14, x15
;;       mov     x15, #0
;;       add     x13, x13, w4, uxtw
;;       add     x13, x13, #1, lsl #12
;;       cmp     x12, x14
;;       csel    x13, x15, x13, hi
;;       csdb
;;       ldr     w2, [x13]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
