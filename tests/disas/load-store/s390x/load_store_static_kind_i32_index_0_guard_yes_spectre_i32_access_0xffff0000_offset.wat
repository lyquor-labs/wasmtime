;;! target = "s390x"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-forced -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store offset=0xffff0000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load offset=0xffff0000))

;; wasm[0]::function[0]:
;;       lg      %r1, 8(%r2)
;;       lg      %r1, 0x10(%r1)
;;       la      %r1, 0xa0(%r1)
;;       clgrtle %r15, %r1
;;       stmg    %r14, %r15, 0x70(%r15)
;;       lgr     %r1, %r15
;;       aghi    %r15, -0xa0
;;       stg     %r1, 0(%r15)
;;       llgfr   %r7, %r4
;;       lghi    %r6, 0
;;       lgr     %r3, %r7
;;       ag      %r3, 0x40(%r2)
;;       llilh   %r2, 0xffff
;;       agrk    %r4, %r3, %r2
;;       clgfi   %r7, 0xfffc
;;       locgrh  %r4, %r6
;;       strv    %r5, 0(%r4)
;;       lmg     %r14, %r15, 0x110(%r15)
;;       br      %r14
;;
;; wasm[0]::function[1]:
;;       lg      %r1, 8(%r2)
;;       lg      %r1, 0x10(%r1)
;;       la      %r1, 0xa0(%r1)
;;       clgrtle %r15, %r1
;;       stmg    %r14, %r15, 0x70(%r15)
;;       lgr     %r1, %r15
;;       aghi    %r15, -0xa0
;;       stg     %r1, 0(%r15)
;;       llgfr   %r6, %r4
;;       lghi    %r5, 0
;;       lgr     %r7, %r6
;;       ag      %r7, 0x40(%r2)
;;       llilh   %r2, 0xffff
;;       agrk    %r4, %r7, %r2
;;       clgfi   %r6, 0xfffc
;;       locgrh  %r4, %r5
;;       lrv     %r2, 0(%r4)
;;       lmg     %r14, %r15, 0x110(%r15)
;;       br      %r14
