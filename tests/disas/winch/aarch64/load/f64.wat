;;! target = "aarch64"
;;! test = "winch"
(module
  (memory (data "\00\00\00\00\00\00\f4\7f"))

  (func (export "f64.load") (result f64) (f64.load (i32.const 0)))
)
;; wasm[0]::function[0]:
;;       stp     x29, x30, [sp, #-0x10]!
;;       mov     x29, sp
;;       str     x28, [sp, #-0x10]!
;;       mov     x28, sp
;;       mov     x9, x0
;;       sub     x28, x28, #0x10
;;       mov     sp, x28
;;       stur    x0, [x28, #8]
;;       stur    x1, [x28]
;;       mov     x16, #0
;;       mov     w0, w16
;;       ldur    x1, [x9, #0x40]
;;       add     x1, x1, x0, uxtx
;;       ldur    d0, [x1]
;;       add     x28, x28, #0x10
;;       mov     sp, x28
;;       mov     sp, x28
;;       ldr     x28, [sp], #0x10
;;       ldp     x29, x30, [sp], #0x10
;;       ret
