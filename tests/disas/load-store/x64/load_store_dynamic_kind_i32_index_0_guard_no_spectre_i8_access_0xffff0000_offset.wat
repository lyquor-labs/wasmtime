;;! target = "x86_64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

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
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movl    %edx, %r8d
;;       movq    %r8, %r10
;;       addq    0x27(%rip), %r10
;;       jb      0x33
;;   17: cmpq    0x48(%rdi), %r10
;;       ja      0x35
;;   21: addq    0x40(%rdi), %r8
;;       movl    $0xffff0000, %edi
;;       movb    %cl, (%r8, %rdi)
;;       movq    %rbp, %rsp
;;       popq    %rbp
;;       retq
;;   33: ud2
;;   35: ud2
;;   37: addb    %al, (%rcx)
;;   39: addb    %bh, %bh
;;   3b: incl    (%rax)
;;   3d: addb    %al, (%rax)
;;
;; wasm[0]::function[1]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movl    %edx, %r8d
;;       movq    %r8, %r10
;;       addq    0x27(%rip), %r10
;;       jb      0x74
;;   57: cmpq    0x48(%rdi), %r10
;;       ja      0x76
;;   61: addq    0x40(%rdi), %r8
;;       movl    $0xffff0000, %edi
;;       movzbq  (%r8, %rdi), %rax
;;       movq    %rbp, %rsp
;;       popq    %rbp
;;       retq
;;   74: ud2
;;   76: ud2
;;   78: addl    %eax, (%rax)
