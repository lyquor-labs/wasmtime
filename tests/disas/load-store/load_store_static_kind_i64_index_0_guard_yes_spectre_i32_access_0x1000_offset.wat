;;! target = "x86_64"
;;! test = "clif"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -W memory64 -O static-memory-forced -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store offset=0x1000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load offset=0x1000))

;; function u0:0(i64 vmctx, i64, i64, i32) tail {
;;     gv0 = vmctx
;;     gv1 = load.i64 notrap aligned readonly gv0+8
;;     gv2 = load.i64 notrap aligned gv1+16
;;     gv3 = vmctx
;;     gv4 = load.i64 notrap aligned gv3+96
;;     gv5 = load.i64 notrap aligned readonly can_move checked gv3+88
;;     stack_limit = gv2
;;
;;                                 block0(v0: i64, v1: i64, v2: i64, v3: i32):
;; @0040                               v4 = iconst.i64 0xffff_effc
;; @0040                               v5 = icmp ugt v2, v4  ; v4 = 0xffff_effc
;; @0040                               v6 = load.i64 notrap aligned readonly can_move checked v0+88
;; @0040                               v7 = iadd v6, v2
;; @0040                               v8 = iconst.i64 4096
;; @0040                               v9 = iadd v7, v8  ; v8 = 4096
;; @0040                               v10 = iconst.i64 0
;; @0040                               v11 = select_spectre_guard v5, v10, v9  ; v10 = 0
;; @0040                               store little heap v3, v11
;; @0044                               jump block1
;;
;;                                 block1:
;; @0044                               return
;; }
;;
;; function u0:1(i64 vmctx, i64, i64) -> i32 tail {
;;     gv0 = vmctx
;;     gv1 = load.i64 notrap aligned readonly gv0+8
;;     gv2 = load.i64 notrap aligned gv1+16
;;     gv3 = vmctx
;;     gv4 = load.i64 notrap aligned gv3+96
;;     gv5 = load.i64 notrap aligned readonly can_move checked gv3+88
;;     stack_limit = gv2
;;
;;                                 block0(v0: i64, v1: i64, v2: i64):
;; @0049                               v4 = iconst.i64 0xffff_effc
;; @0049                               v5 = icmp ugt v2, v4  ; v4 = 0xffff_effc
;; @0049                               v6 = load.i64 notrap aligned readonly can_move checked v0+88
;; @0049                               v7 = iadd v6, v2
;; @0049                               v8 = iconst.i64 4096
;; @0049                               v9 = iadd v7, v8  ; v8 = 4096
;; @0049                               v10 = iconst.i64 0
;; @0049                               v11 = select_spectre_guard v5, v10, v9  ; v10 = 0
;; @0049                               v12 = load.i32 little heap v11
;; @004d                               jump block1
;;
;;                                 block1:
;; @004d                               return v12
;; }
