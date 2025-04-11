;;! target = "aarch64"
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
    i32.store offset=0)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load offset=0))

;; wasm[0]::function[0]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       orr     x6, xzr, #0xfffffffc
;;       cmp     x4, x6
;;       cset    x9, hi
;;       uxtb    w8, w9
;;       cbnz    x8, #0x2c
;;   1c: ldr     x9, [x2, #0x40]
;;       str     w5, [x9, x4]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   2c: .byte   0x1f, 0xc1, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       orr     x6, xzr, #0xfffffffc
;;       cmp     x4, x6
;;       cset    x9, hi
;;       uxtb    w8, w9
;;       cbnz    x8, #0x6c
;;   5c: ldr     x9, [x2, #0x40]
;;       ldr     w2, [x9, x4]
;;       ldp     x29, x30, [sp], #0x10
;;       ret
;;   6c: .byte   0x1f, 0xc1, 0x00, 0x00
