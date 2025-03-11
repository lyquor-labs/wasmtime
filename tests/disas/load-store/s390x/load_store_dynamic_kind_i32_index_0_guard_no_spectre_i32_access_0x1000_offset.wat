;;! target = "s390x"
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
    i32.store offset=0x1000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load offset=0x1000))

;; wasm[0]::function[0]:
;;       lg      %r1, 8(%r2)
;;       lg      %r1, 0x10(%r1)
;;       la      %r1, 0xa0(%r1)
;;       clgrtle %r15, %r1
;;       stmg    %r14, %r15, 0x70(%r15)
;;       lgr     %r1, %r15
;;       aghi    %r15, -0xa0
;;       stg     %r1, 0(%r15)
;;       lgr     %r6, %r4
;;       lg      %r4, 0x58(%r2)
;;       llgfr   %r3, %r6
;;       aghi    %r4, -0x1004
;;       clgr    %r3, %r4
;;       jgh     0x40
;;       ag      %r3, 0x50(%r2)
;;       lghi    %r6, 0x1000
;;       strv    %r5, 0(%r6, %r3)
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
;;       lgr     %r6, %r4
;;       lg      %r4, 0x58(%r2)
;;       llgfr   %r3, %r6
;;       aghi    %r4, -0x1004
;;       clgr    %r3, %r4
;;       jgh     0x9c
;;       ag      %r3, 0x50(%r2)
;;       lghi    %r6, 0x1000
;;       lrv     %r2, 0(%r6, %r3)
;;       lmg     %r14, %r15, 0x110(%r15)
;;       br      %r14
