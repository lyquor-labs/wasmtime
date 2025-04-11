;;! target = "x86_64"
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
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    0x48(%rdi), %r10
;;       movq    0x40(%rdi), %rdi
;;       movl    %edx, %eax
;;       subq    $0x1004, %r10
;;       xorq    %rdx, %rdx
;;       leaq    0x1000(%rdi, %rax), %rsi
;;       cmpq    %r10, %rax
;;       cmovaq  %rdx, %rsi
;;       movl    %ecx, (%rsi)
;;       movq    %rbp, %rsp
;;       popq    %rbp
;;       retq
;;
;; wasm[0]::function[1]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    0x48(%rdi), %r10
;;       movq    0x40(%rdi), %rdi
;;       movl    %edx, %eax
;;       subq    $0x1004, %r10
;;       xorq    %rcx, %rcx
;;       leaq    0x1000(%rdi, %rax), %rsi
;;       cmpq    %r10, %rax
;;       cmovaq  %rcx, %rsi
;;       movl    (%rsi), %eax
;;       movq    %rbp, %rsp
;;       popq    %rbp
;;       retq
