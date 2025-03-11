;;! target = "x86_64"
;;! test = "clif"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0x1000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0x1000))

;; function u0:0(i64 vmctx, i64, i32, i32) tail {
;;     gv0 = vmctx
;;     gv1 = load.i64 notrap aligned readonly gv0+8
;;     gv2 = load.i64 notrap aligned gv1+16
;;     gv3 = vmctx
;;     gv4 = load.i64 notrap aligned gv3+88
;;     gv5 = load.i64 notrap aligned can_move checked gv3+80
;;     stack_limit = gv2
;;
;;                                 block0(v0: i64, v1: i64, v2: i32, v3: i32):
;; @0040                               v4 = uextend.i64 v2
;; @0040                               v5 = load.i64 notrap aligned v0+88
;; @0040                               v6 = iconst.i64 4097
;; @0040                               v7 = isub v5, v6  ; v6 = 4097
;; @0040                               v8 = icmp ugt v4, v7
;; @0040                               v9 = load.i64 notrap aligned can_move checked v0+80
;; @0040                               v10 = iadd v9, v4
;; @0040                               v11 = iconst.i64 4096
;; @0040                               v12 = iadd v10, v11  ; v11 = 4096
;; @0040                               v13 = iconst.i64 0
;; @0040                               v14 = select_spectre_guard v8, v13, v12  ; v13 = 0
;; @0040                               istore8 little heap v3, v14
;; @0044                               jump block1
;;
;;                                 block1:
;; @0044                               return
;; }
;;
;; function u0:1(i64 vmctx, i64, i32) -> i32 tail {
;;     gv0 = vmctx
;;     gv1 = load.i64 notrap aligned readonly gv0+8
;;     gv2 = load.i64 notrap aligned gv1+16
;;     gv3 = vmctx
;;     gv4 = load.i64 notrap aligned gv3+88
;;     gv5 = load.i64 notrap aligned can_move checked gv3+80
;;     stack_limit = gv2
;;
;;                                 block0(v0: i64, v1: i64, v2: i32):
;; @0049                               v4 = uextend.i64 v2
;; @0049                               v5 = load.i64 notrap aligned v0+88
;; @0049                               v6 = iconst.i64 4097
;; @0049                               v7 = isub v5, v6  ; v6 = 4097
;; @0049                               v8 = icmp ugt v4, v7
;; @0049                               v9 = load.i64 notrap aligned can_move checked v0+80
;; @0049                               v10 = iadd v9, v4
;; @0049                               v11 = iconst.i64 4096
;; @0049                               v12 = iadd v10, v11  ; v11 = 4096
;; @0049                               v13 = iconst.i64 0
;; @0049                               v14 = select_spectre_guard v8, v13, v12  ; v13 = 0
;; @0049                               v15 = uload8.i32 little heap v14
;; @004d                               jump block1
;;
;;                                 block1:
;; @004d                               return v15
;; }
