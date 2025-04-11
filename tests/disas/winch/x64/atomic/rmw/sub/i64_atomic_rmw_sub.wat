;;! target = "x86_64"
;;! test = "winch"

(module
  (memory 1 1 shared)
  (func (export "_start") (result i64)
        (i64.atomic.rmw.sub (i32.const 0) (i64.const 42))))
;; wasm[0]::function[0]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    8(%rdi), %r11
;;       movq    0x10(%r11), %r11
;;       addq    $0x10, %r11
;;       cmpq    %rsp, %r11
;;       ja      0x63
;;   1c: movq    %rdi, %r14
;;       subq    $0x10, %rsp
;;       movq    %rdi, 8(%rsp)
;;       movq    %rsi, (%rsp)
;;       movq    $0x2a, %rax
;;       movl    $0, %ecx
;;       andq    $7, %rcx
;;       cmpq    $0, %rcx
;;       jne     0x65
;;   46: movl    $0, %ecx
;;       movq    0x38(%r14), %r11
;;       movq    (%r11), %rdx
;;       addq    %rcx, %rdx
;;       negq    %rax
;;       lock xaddq %rax, (%rdx)
;;       addq    $0x10, %rsp
;;       popq    %rbp
;;       retq
;;   63: ud2
;;   65: ud2
