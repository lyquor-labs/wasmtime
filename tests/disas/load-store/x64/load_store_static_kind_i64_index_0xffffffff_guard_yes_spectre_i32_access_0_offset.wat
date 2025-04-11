;;! target = "x86_64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -W memory64 -O static-memory-forced -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

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
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       xorq    %r9, %r9
;;       movq    %rdx, %r8
;;       addq    0x40(%rdi), %r8
;;       cmpq    0x13(%rip), %rdx
;;       cmovaq  %r9, %r8
;;       movl    %ecx, (%r8)
;;       movq    %rbp, %rsp
;;       popq    %rbp
;;       retq
;;   21: addb    %al, (%rax)
;;   23: addb    %al, (%rax)
;;   25: addb    %al, (%rax)
;;   27: addb    %bh, %ah
;;
;; wasm[0]::function[1]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       xorq    %r9, %r9
;;       movq    %rdx, %r8
;;       addq    0x40(%rdi), %r8
;;       cmpq    0x13(%rip), %rdx
;;       cmovaq  %r9, %r8
;;       movl    (%r8), %eax
;;       movq    %rbp, %rsp
;;       popq    %rbp
;;       retq
;;   61: addb    %al, (%rax)
;;   63: addb    %al, (%rax)
;;   65: addb    %al, (%rax)
;;   67: addb    %bh, %ah
