(load "transformer-macros.ss")

;;----------------------------------------------------------------------
;; EOPL support

;; aexpression datatype
(define lit-aexp
  (lambda args (return* (cons 'lit-aexp args))))
(define var-aexp
  (lambda args (return* (cons 'var-aexp args))))
(define lexical-address-aexp
  (lambda args (return* (cons 'lexical-address-aexp args))))
(define if-aexp
  (lambda args (return* (cons 'if-aexp args))))
(define help-aexp
  (lambda args (return* (cons 'help-aexp args))))
(define assign-aexp
  (lambda args (return* (cons 'assign-aexp args))))
(define func-aexp
  (lambda args (return* (cons 'func-aexp args))))
(define callback-aexp
  (lambda args (return* (cons 'callback-aexp args))))
(define define-aexp
  (lambda args (return* (cons 'define-aexp args))))
(define define!-aexp
  (lambda args (return* (cons 'define!-aexp args))))
(define define-syntax-aexp
  (lambda args (return* (cons 'define-syntax-aexp args))))
(define begin-aexp
  (lambda args (return* (cons 'begin-aexp args))))
(define lambda-aexp
  (lambda args (return* (cons 'lambda-aexp args))))
(define mu-lambda-aexp
  (lambda args (return* (cons 'mu-lambda-aexp args))))
(define trace-lambda-aexp
  (lambda args (return* (cons 'trace-lambda-aexp args))))
(define mu-trace-lambda-aexp
  (lambda args (return* (cons 'mu-trace-lambda-aexp args))))
(define app-aexp
  (lambda args (return* (cons 'app-aexp args))))
(define try-catch-aexp
  (lambda args (return* (cons 'try-catch-aexp args))))
(define try-finally-aexp
  (lambda args (return* (cons 'try-finally-aexp args))))
(define try-catch-finally-aexp
  (lambda args (return* (cons 'try-catch-finally-aexp args))))
(define raise-aexp
  (lambda args (return* (cons 'raise-aexp args))))
(define choose-aexp
  (lambda args (return* (cons 'choose-aexp args))))

;;----------------------------------------------------------------------

;; global registers
(define pc 'undefined)
(define aclauses_reg 'undefined)
(define action_reg 'undefined)
(define adatum-list_reg 'undefined)
(define adatum_reg 'undefined)
(define ap1_reg 'undefined)
(define ap2_reg 'undefined)
(define ap_reg 'undefined)
(define apair1_reg 'undefined)
(define apair2_reg 'undefined)
(define args_reg 'undefined)
(define avar_reg 'undefined)
(define ax_reg 'undefined)
(define bindings_reg 'undefined)
(define bodies_reg 'undefined)
(define buffer_reg 'undefined)
(define cdrs_reg 'undefined)
(define char_reg 'undefined)
(define chars_reg 'undefined)
(define clauses_reg 'undefined)
(define components_reg 'undefined)
(define contours_reg 'undefined)
(define datum_reg 'undefined)
(define depth_reg 'undefined)
(define dk_reg 'undefined)
(define env2_reg 'undefined)
(define env_reg 'undefined)
(define exception_reg 'undefined)
(define exp_reg 'undefined)
(define expected-terminator_reg 'undefined)
(define exps_reg 'undefined)
(define fail_reg 'undefined)
(define fields_reg 'undefined)
(define filename_reg 'undefined)
(define filenames_reg 'undefined)
(define final_reg 'undefined)
(define frames_reg 'undefined)
(define generator_reg 'undefined)
(define gk_reg 'undefined)
(define handler_reg 'undefined)
(define i_reg 'undefined)
(define id_reg 'undefined)
(define info_reg 'undefined)
(define input_reg 'undefined)
(define iterator_reg 'undefined)
(define k2_reg 'undefined)
(define k_reg 'undefined)
(define keyword_reg 'undefined)
(define line_reg 'undefined)
(define list1_reg 'undefined)
(define list2_reg 'undefined)
(define lists_reg 'undefined)
(define ls1_reg 'undefined)
(define ls2_reg 'undefined)
(define ls_reg 'undefined)
(define lst_reg 'undefined)
(define macro_reg 'undefined)
(define module_reg 'undefined)
(define msg_reg 'undefined)
(define name_reg 'undefined)
(define offset_reg 'undefined)
(define p1_reg 'undefined)
(define p2_reg 'undefined)
(define pair1_reg 'undefined)
(define pair2_reg 'undefined)
(define path_reg 'undefined)
(define pattern_reg 'undefined)
(define proc_reg 'undefined)
(define procs_reg 'undefined)
(define s_reg 'undefined)
(define senv_reg 'undefined)
(define sexps_reg 'undefined)
(define sk_reg 'undefined)
(define src_reg 'undefined)
(define sum_reg 'undefined)
(define token-type_reg 'undefined)
(define tokens_reg 'undefined)
(define v1_reg 'undefined)
(define v2_reg 'undefined)
(define value1_reg 'undefined)
(define value2_reg 'undefined)
(define value3_reg 'undefined)
(define value4_reg 'undefined)
(define value_reg 'undefined)
(define var-info_reg 'undefined)
(define var_reg 'undefined)
(define variant_reg 'undefined)
(define variants_reg 'undefined)
(define vars_reg 'undefined)
(define x_reg 'undefined)
(define y_reg 'undefined)

;; temporary registers
(define temp_2 'undefined)
(define temp_3 'undefined)
(define temp_4 'undefined)
(define temp_1 'undefined)

(define make-cont
  (lambda args (return* (cons 'continuation args))))

(define*
  apply-cont
  (lambda () (apply! (cadr k_reg) (cddr k_reg))))

(define <cont-1>
  (lambda (chars fail k)
    (set! value3_reg fail)
    (set! value2_reg chars)
    (set! value1_reg value_reg)
    (set! k_reg k)
    (set! pc apply-cont3)))

(define <cont-2>
  (lambda (v1 info k)
    (set! value_reg (list pair-tag v1 value_reg info))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-3>
  (lambda (x info k)
    (set! k_reg (make-cont <cont-2> value_reg info k))
    (set! info_reg 'none)
    (set! x_reg (cdr x))
    (set! pc annotate-cps)))

(define <cont-4>
  (lambda (k)
    (set! value_reg (list->vector value_reg))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-5>
  (lambda (v1 k)
    (set! value_reg (cons v1 value_reg))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-6>
  (lambda (x k)
    (set! k_reg (make-cont <cont-5> value_reg k))
    (set! x_reg (cdr x))
    (set! pc unannotate-cps)))

(define <cont-7>
  (lambda (x k)
    (set! k_reg (make-cont <cont-5> value_reg k))
    (set! x_reg (caddr x))
    (set! pc unannotate-cps)))

(define <cont-8>
  (lambda (end tokens-left fail k)
    (set! value4_reg fail)
    (set! value3_reg tokens-left)
    (set! value2_reg end)
    (set! value1_reg value_reg)
    (set! k_reg k)
    (set! pc apply-cont4)))

(define <cont-9>
  (lambda (end tokens fail k)
    (set! value4_reg fail)
    (set! value3_reg (rest-of tokens))
    (set! value2_reg end)
    (set! value1_reg value_reg)
    (set! k_reg k)
    (set! pc apply-cont4)))

(define <cont-10>
  (lambda (src start tokens handler fail k)
    (set! k_reg (make-cont4 <cont4-3> src start value_reg k))
    (set! fail_reg fail)
    (set! handler_reg handler)
    (set! src_reg src)
    (set! tokens_reg (rest-of tokens))
    (set! pc read-sexp)))

(define <cont-11>
  (lambda ()
    (set! final_reg value_reg)
    (set! pc pc-halt-signal)))

(define <cont-12>
  (lambda (adatum senv info handler fail k)
    (let ((formals-list 'undefined) (name 'undefined))
      (set! name (untag-atom^ (cadr^ adatum)))
      (set! formals-list
        (if (list? value_reg)
            value_reg
            (cons (last value_reg) (head value_reg))))
      (set! k_reg (make-cont2 <cont2-16> name value_reg info k))
      (set! fail_reg fail)
      (set! handler_reg handler)
      (set! senv_reg (cons formals-list senv))
      (set! adatum-list_reg (cdddr^ adatum))
      (set! pc aparse-all))))

(define <cont-13>
  (lambda (adatum senv info handler fail k)
    (let ((formals-list 'undefined))
      (set! formals-list
        (if (list? value_reg)
            value_reg
            (cons (last value_reg) (head value_reg))))
      (set! k_reg (make-cont2 <cont2-17> value_reg info k))
      (set! fail_reg fail)
      (set! handler_reg handler)
      (set! senv_reg (cons formals-list senv))
      (set! adatum-list_reg (cddr^ adatum))
      (set! pc aparse-all))))

(define <cont-14>
  (lambda (aclauses name info fail k)
    (set! value2_reg fail)
    (set! value1_reg
      (define-syntax-aexp name value_reg aclauses info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont-15>
  (lambda (senv info handler fail k)
    (set! k_reg k)
    (set! fail_reg fail)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum_reg (replace-info value_reg info))
    (set! pc aparse)))

(define <cont-16>
  (lambda (senv info handler fail k)
    (set! k_reg (make-cont <cont-15> senv info handler fail k))
    (set! info_reg 'none)
    (set! x_reg value_reg)
    (set! pc annotate-cps)))

(define <cont-17>
  (lambda (adatum senv info handler fail k)
    (if (original-source-info? adatum)
        (begin
          (set! k_reg k)
          (set! fail_reg fail)
          (set! handler_reg handler)
          (set! senv_reg senv)
          (set! adatum_reg
            (replace-info value_reg (snoc 'quasiquote info)))
          (set! pc aparse))
        (begin
          (set! k_reg k)
          (set! fail_reg fail)
          (set! handler_reg handler)
          (set! senv_reg senv)
          (set! adatum_reg (replace-info value_reg info))
          (set! pc aparse)))))

(define <cont-18>
  (lambda (adatum senv info handler fail k)
    (set! k_reg
      (make-cont <cont-17> adatum senv info handler fail k))
    (set! info_reg 'none)
    (set! x_reg value_reg)
    (set! pc annotate-cps)))

(define <cont-19>
  (lambda (info fail k)
    (set! value2_reg fail)
    (set! value1_reg (lit-aexp (cadr value_reg) info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont-20>
  (lambda (info fail k)
    (set! value2_reg fail)
    (set! value1_reg (lit-aexp value_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont-21>
  (lambda (msg info handler fail)
    (set! fail_reg fail)
    (set! exception_reg
      (make-exception "ParseError" (format "~s ~a" msg value_reg)
        (get-srcfile info) (get-start-line info)
        (get-start-char info)))
    (set! handler_reg handler)
    (set! pc apply-handler2)))

(define <cont-22>
  (lambda (bindings k)
    (set! value_reg
      (append
        (list 'let)
        (append (list (list (car^ bindings))) (list value_reg))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-23>
  (lambda (clauses var k)
    (let ((clause 'undefined))
      (set! clause (car^ clauses))
      (if (eq?^ (car^ clause) 'else)
          (begin
            (set! value_reg (cons clause value_reg))
            (set! k_reg k)
            (set! pc apply-cont))
          (if (symbol?^ (car^ clause))
              (begin
                (set! value_reg
                  (cons
                    (append
                      (list
                        (append
                          (list 'eq?)
                          (append
                            (list var)
                            (list (append (list 'quote) (list (car^ clause)))))))
                      (at^ (cdr^ clause)))
                    value_reg))
                (set! k_reg k)
                (set! pc apply-cont))
              (begin
                (set! value_reg
                  (cons
                    (append
                      (list
                        (append
                          (list 'memq)
                          (append
                            (list var)
                            (list (append (list 'quote) (list (car^ clause)))))))
                      (at^ (cdr^ clause)))
                    value_reg))
                (set! k_reg k)
                (set! pc apply-cont)))))))

(define <cont-24>
  (lambda (fields name k2)
    (let ((constructor-def 'undefined))
      (set! constructor-def
        (append
          (list 'define)
          (append
            (list name)
            (list
              (append
                (list 'lambda)
                (append
                  (list 'args)
                  (list
                    (append
                      (list 'if)
                      (append
                        (list
                          (append
                            (list '=)
                            (append
                              (list (append (list 'length) (list 'args)))
                              (list (length^ fields)))))
                        (append
                          (list value_reg)
                          (list
                            (append
                              (list 'error)
                              (append
                                (list (append (list 'quote) (list name)))
                                (list "wrong number of arguments"))))))))))))))
      (set! value2_reg constructor-def)
      (set! value1_reg name)
      (set! k_reg k2)
      (set! pc apply-cont2))))

(define <cont-25>
  (lambda (cdrs fields name k)
    (set! value_reg
      (append
        (list 'if)
        (append
          (list
            (append
              (list (cadar^ fields))
              (list (append (list 'car) (list cdrs)))))
          (append
            (list value_reg)
            (list
              (append
                (list 'error)
                (append
                  (list (append (list 'quote) (list name)))
                  (append
                    (list "~a is not of type ~a")
                    (append
                      (list (append (list 'car) (list cdrs)))
                      (list
                        (append (list 'quote) (list (cadar^ fields)))))))))))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-26>
  (lambda (adatum macro-keyword fail k)
    (if (has-source-info? value_reg)
        (begin
          (set! value2_reg fail)
          (set! value1_reg value_reg)
          (set! k_reg k)
          (set! pc apply-cont2))
        (let ((info 'undefined))
          (set! info (get-source-info adatum))
          (if (original-source-info? adatum)
              (begin
                (set! value2_reg fail)
                (set! value1_reg
                  (replace-info value_reg (snoc macro-keyword info)))
                (set! k_reg k)
                (set! pc apply-cont2))
              (begin
                (set! value2_reg fail)
                (set! value1_reg (replace-info value_reg info))
                (set! k_reg k)
                (set! pc apply-cont2)))))))

(define <cont-27>
  (lambda (adatum macro-keyword fail k)
    (set! k_reg
      (make-cont <cont-26> adatum macro-keyword fail k))
    (set! info_reg 'none)
    (set! x_reg value_reg)
    (set! pc annotate-cps)))

(define <cont-28>
  (lambda (aclauses adatum clauses right-apattern
           right-pattern handler fail k)
    (if value_reg
        (begin
          (set! k2_reg (make-cont2 <cont2-46> fail k))
          (set! ap_reg right-apattern)
          (set! s_reg value_reg)
          (set! pattern_reg right-pattern)
          (set! pc instantiate^))
        (begin
          (set! k_reg k)
          (set! fail_reg fail)
          (set! handler_reg handler)
          (set! adatum_reg adatum)
          (set! aclauses_reg (cdr^ aclauses))
          (set! clauses_reg (cdr clauses))
          (set! pc process-macro-clauses^)))))

(define <cont-29>
  (lambda (aclauses adatum clauses left-apattern left-pattern
           right-apattern right-pattern handler fail k)
    (set! k_reg
      (make-cont <cont-28> aclauses adatum clauses right-apattern
        right-pattern handler fail k))
    (set! ap2_reg adatum)
    (set! ap1_reg left-apattern)
    (set! p2_reg value_reg)
    (set! p1_reg left-pattern)
    (set! pc unify-patterns^)))

(define <cont-30>
  (lambda (v1 k)
    (set! value_reg
      (append (list 'append) (append (list v1) (list value_reg))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-31>
  (lambda (ax depth k)
    (set! k_reg (make-cont <cont-30> value_reg k))
    (set! depth_reg depth)
    (set! ax_reg (cdr^ ax))
    (set! pc qq-expand-cps)))

(define <cont-32>
  (lambda (k)
    (set! value_reg
      (append (list 'list->vector) (list value_reg)))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-33>
  (lambda (depth k)
    (set! k_reg (make-cont <cont-32> k))
    (set! depth_reg depth)
    (set! ax_reg value_reg)
    (set! pc qq-expand-cps)))

(define <cont-34>
  (lambda (ax k)
    (set! value_reg
      (append
        (list 'cons)
        (append
          (list (append (list 'quote) (list (car^ ax))))
          (list value_reg))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-35>
  (lambda (k)
    (set! value_reg
      (append
        (list 'cons)
        (append
          (list (append (list 'quote) (list 'quasiquote)))
          (list value_reg))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-36>
  (lambda (v1 k)
    (set! value_reg
      (append
        (list 'list)
        (list
          (append
            (list 'append)
            (append (list v1) (list value_reg))))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-37>
  (lambda (ax depth k)
    (set! k_reg (make-cont <cont-36> value_reg k))
    (set! depth_reg depth)
    (set! ax_reg (cdr^ ax))
    (set! pc qq-expand-cps)))

(define <cont-38>
  (lambda (k)
    (set! value_reg (append (list 'list) (list value_reg)))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-39>
  (lambda (ax k)
    (set! value_reg
      (append
        (list 'list)
        (list
          (append
            (list 'cons)
            (append
              (list (append (list 'quote) (list (car^ ax))))
              (list value_reg))))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-40>
  (lambda (k)
    (set! value_reg
      (append
        (list 'list)
        (list
          (append
            (list 'cons)
            (append
              (list (append (list 'quote) (list 'quasiquote)))
              (list value_reg))))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont-41>
  (lambda (args handler fail k2)
    (set! k_reg (make-cont2 <cont2-74> args handler k2))
    (set! fail_reg fail)
    (set! handler_reg handler)
    (set! senv_reg (initial-contours (cadr args)))
    (set! adatum_reg value_reg)
    (set! pc aparse)))

(define <cont-42>
  (lambda (handler fail k2)
    (set! k_reg (make-cont2 <cont2-75> handler k2))
    (set! fail_reg fail)
    (set! handler_reg handler)
    (set! senv_reg (initial-contours toplevel-env))
    (set! adatum_reg value_reg)
    (set! pc aparse)))

(define <cont-43>
  (lambda (handler fail k2)
    (set! k_reg k2)
    (set! fail_reg fail)
    (set! handler_reg handler)
    (set! senv_reg (initial-contours toplevel-env))
    (set! adatum_reg value_reg)
    (set! pc aparse)))

(define <cont-44>
  (lambda (fail k2)
    (set! value2_reg fail)
    (set! value1_reg value_reg)
    (set! k_reg k2)
    (set! pc apply-cont2)))

(define <cont-45>
  (lambda (x y k)
    (if value_reg
        (begin
          (set! k_reg k)
          (set! y_reg (cdr y))
          (set! x_reg (cdr x))
          (set! pc equal-objects?))
        (begin
          (set! value_reg #f)
          (set! k_reg k)
          (set! pc apply-cont)))))

(define <cont-46>
  (lambda (i v1 v2 k)
    (if value_reg
        (begin
          (set! k_reg k)
          (set! i_reg (- i 1))
          (set! v2_reg v2)
          (set! v1_reg v1)
          (set! pc equal-vectors?))
        (begin
          (set! value_reg #f)
          (set! k_reg k)
          (set! pc apply-cont)))))

(define <cont-47>
  (lambda (ls x y info handler fail k)
    (if value_reg
        (begin
          (set! value2_reg fail)
          (set! value1_reg y)
          (set! k_reg k)
          (set! pc apply-cont2))
        (begin
          (set! k_reg k)
          (set! fail_reg fail)
          (set! handler_reg handler)
          (set! info_reg info)
          (set! ls_reg ls)
          (set! y_reg (cdr y))
          (set! x_reg x)
          (set! pc member-loop)))))

(define <cont-48>
  (lambda (pattern var k)
    (if value_reg
        (begin
          (set! value_reg #t)
          (set! k_reg k)
          (set! pc apply-cont))
        (begin
          (set! k_reg k)
          (set! pattern_reg (cdr pattern))
          (set! var_reg var)
          (set! pc occurs?)))))

(define <cont-49>
  (lambda (ap2 p1 p2 k)
    (if value_reg
        (begin
          (set! value_reg #f)
          (set! k_reg k)
          (set! pc apply-cont))
        (begin
          (set! value_reg (make-sub 'unit p1 p2 ap2))
          (set! k_reg k)
          (set! pc apply-cont)))))

(define <cont-50>
  (lambda (s-car k)
    (if (not value_reg)
        (begin
          (set! value_reg #f)
          (set! k_reg k)
          (set! pc apply-cont))
        (begin
          (set! value_reg (make-sub 'composite s-car value_reg))
          (set! k_reg k)
          (set! pc apply-cont)))))

(define <cont-51>
  (lambda (apair1 apair2 pair1 pair2 k)
    (if (not value_reg)
        (begin
          (set! value_reg #f)
          (set! k_reg k)
          (set! pc apply-cont))
        (begin
          (set! k2_reg
            (make-cont2 <cont2-98> apair2 pair2 value_reg k))
          (set! ap_reg (cdr^ apair1))
          (set! s_reg value_reg)
          (set! pattern_reg (cdr pair1))
          (set! pc instantiate^)))))

(define make-cont2
  (lambda args (return* (cons 'continuation2 args))))

(define*
  apply-cont2
  (lambda () (apply! (cadr k_reg) (cddr k_reg))))

(define <cont2-1>
  (lambda (token k)
    (set! value1_reg (cons token value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-2>
  (lambda ()
    (set! final_reg value1_reg)
    (set! pc pc-halt-signal)))

(define <cont2-3>
  (lambda (k)
    (set! value1_reg (binding-value value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-4>
  (lambda (k)
    (set! value1_reg (dlr-env-lookup value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-5>
  (lambda (v1 info k)
    (set! value1_reg (app-aexp v1 value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-6>
  (lambda (adatum senv info handler k)
    (set! k_reg (make-cont2 <cont2-5> value1_reg info k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum-list_reg (cdr^ adatum))
    (set! pc aparse-all)))

(define <cont2-7>
  (lambda (info k)
    (set! value1_reg (choose-aexp value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-8>
  (lambda (info k)
    (set! value1_reg (raise-aexp value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-9>
  (lambda (cexps cvar body info k)
    (set! value1_reg
      (try-catch-finally-aexp body cvar cexps value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-10>
  (lambda (adatum cvar senv body info handler k)
    (set! k_reg
      (make-cont2 <cont2-9> value1_reg cvar body info k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum-list_reg (try-catch-finally-exps^ adatum))
    (set! pc aparse-all)))

(define <cont2-11>
  (lambda (adatum senv info handler k)
    (let ((cvar 'undefined))
      (set! cvar (catch-var^ adatum))
      (set! k_reg
        (make-cont2 <cont2-10> adatum cvar senv value1_reg info
          handler k))
      (set! fail_reg value2_reg)
      (set! handler_reg handler)
      (set! senv_reg (cons (list cvar) senv))
      (set! adatum-list_reg (catch-exps^ adatum))
      (set! pc aparse-all))))

(define <cont2-12>
  (lambda (body info k)
    (set! value1_reg (try-finally-aexp body value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-13>
  (lambda (adatum senv info handler k)
    (set! k_reg (make-cont2 <cont2-12> value1_reg info k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum-list_reg (try-finally-exps^ adatum))
    (set! pc aparse-all)))

(define <cont2-14>
  (lambda (cvar body info k)
    (set! value1_reg (try-catch-aexp body cvar value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-15>
  (lambda (adatum senv info handler k)
    (let ((cvar 'undefined))
      (set! cvar (catch-var^ adatum))
      (set! k_reg (make-cont2 <cont2-14> cvar value1_reg info k))
      (set! fail_reg value2_reg)
      (set! handler_reg handler)
      (set! senv_reg (cons (list cvar) senv))
      (set! adatum-list_reg (catch-exps^ adatum))
      (set! pc aparse-all))))

(define <cont2-16>
  (lambda (name formals info k)
    (if (list? formals)
        (begin
          (set! value1_reg
            (trace-lambda-aexp name formals value1_reg info))
          (set! k_reg k)
          (set! pc apply-cont2))
        (begin
          (set! value1_reg
            (mu-trace-lambda-aexp name (head formals) (last formals)
              value1_reg info))
          (set! k_reg k)
          (set! pc apply-cont2)))))

(define <cont2-17>
  (lambda (formals info k)
    (if (list? formals)
        (begin
          (set! value1_reg (lambda-aexp formals value1_reg info))
          (set! k_reg k)
          (set! pc apply-cont2))
        (begin
          (set! value1_reg
            (mu-lambda-aexp
              (head formals)
              (last formals)
              value1_reg
              info))
          (set! k_reg k)
          (set! pc apply-cont2)))))

(define <cont2-18>
  (lambda (info k)
    (set! value1_reg (begin-aexp value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-19>
  (lambda (adatum info k)
    (set! value1_reg
      (define!-aexp
        (define-var^ adatum)
        (define-docstring^ adatum)
        value1_reg
        info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-20>
  (lambda (adatum info k)
    (set! value1_reg
      (define!-aexp (define-var^ adatum) "" value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-21>
  (lambda (adatum info k)
    (set! value1_reg
      (define-aexp
        (define-var^ adatum)
        (define-docstring^ adatum)
        value1_reg
        info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-22>
  (lambda (adatum info k)
    (set! value1_reg
      (define-aexp (define-var^ adatum) "" value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-23>
  (lambda (info k)
    (set! value1_reg (callback-aexp value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-24>
  (lambda (info k)
    (set! value1_reg (func-aexp value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-25>
  (lambda (adatum info k)
    (let ((var-info 'undefined))
      (set! var-info (get-source-info (cadr^ adatum)))
      (set! value1_reg
        (assign-aexp
          (untag-atom^ (cadr^ adatum))
          value1_reg
          var-info
          info))
      (set! k_reg k)
      (set! pc apply-cont2))))

(define <cont2-26>
  (lambda (v1 v2 info k)
    (set! value1_reg (if-aexp v1 v2 value1_reg info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-27>
  (lambda (adatum senv v1 info handler k)
    (set! k_reg (make-cont2 <cont2-26> v1 value1_reg info k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum_reg (cadddr^ adatum))
    (set! pc aparse)))

(define <cont2-28>
  (lambda (adatum senv info handler k)
    (set! k_reg
      (make-cont2 <cont2-27> adatum senv value1_reg info handler
        k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum_reg (caddr^ adatum))
    (set! pc aparse)))

(define <cont2-29>
  (lambda (v1 info k)
    (set! value1_reg
      (if-aexp v1 value1_reg (lit-aexp #f 'none) info))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-30>
  (lambda (adatum senv info handler k)
    (set! k_reg (make-cont2 <cont2-29> value1_reg info k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum_reg (caddr^ adatum))
    (set! pc aparse)))

(define <cont2-31>
  (lambda (senv handler k)
    (set! k_reg k)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum_reg value1_reg)
    (set! pc aparse)))

(define <cont2-32>
  (lambda (a k)
    (set! value1_reg (cons a value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-33>
  (lambda (adatum-list senv handler k)
    (set! k_reg (make-cont2 <cont2-32> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum-list_reg (cdr^ adatum-list))
    (set! pc aparse-all)))

(define <cont2-34>
  (lambda (v1 k)
    (set! value1_reg (cons v1 value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-35>
  (lambda (senv src tokens-left handler k)
    (set! k_reg (make-cont2 <cont2-34> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! src_reg src)
    (set! tokens_reg tokens-left)
    (set! pc aparse-sexps)))

(define <cont2-36>
  (lambda (bodies k)
    (set! value_reg
      (append
        (list 'let)
        (append
          (list value1_reg)
          (append value2_reg (at^ bodies)))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont2-37>
  (lambda (procs vars k2)
    (set! value2_reg
      (cons
        (append
          (list 'set!)
          (append (list (car^ vars)) (list (car^ procs))))
        value2_reg))
    (set! value1_reg
      (cons
        (append
          (list (car^ vars))
          (list (append (list 'quote) (list 'undefined))))
        value1_reg))
    (set! k_reg k2)
    (set! pc apply-cont2)))

(define <cont2-38>
  (lambda (exp k)
    (set! value_reg
      (append
        (list 'let)
        (append
          (list
            (append (list (append (list 'r) (list exp))) value1_reg))
          (list (append (list 'cond) value2_reg)))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont2-39>
  (lambda (clauses var k2)
    (let ((clause 'undefined))
      (set! clause (car^ clauses))
      (if (eq?^ (car^ clause) 'else)
          (begin
            (set! value2_reg
              (cons (list 'else (list 'else-code)) value2_reg))
            (set! value1_reg
              (cons
                (append
                  (list 'else-code)
                  (list
                    (append
                      (list 'lambda)
                      (append (list '()) (at^ (cdr^ clause))))))
                value1_reg))
            (set! k_reg k2)
            (set! pc apply-cont2))
          (if (symbol?^ (car^ clause))
              (let ((name 'undefined))
                (set! name (car^ clause))
                (set! value2_reg
                  (cons
                    (append
                      (list
                        (append
                          (list 'eq?)
                          (append
                            (list var)
                            (list (append (list 'quote) (list (car^ clause)))))))
                      (list (list name)))
                    value2_reg))
                (set! value1_reg
                  (cons
                    (append
                      (list name)
                      (list
                        (append
                          (list 'lambda)
                          (append (list '()) (at^ (cdr^ clause))))))
                    value1_reg))
                (set! k_reg k2)
                (set! pc apply-cont2))
              (let ((name 'undefined))
                (set! name (caar^ clause))
                (set! value2_reg
                  (cons
                    (append
                      (list
                        (append
                          (list 'memq)
                          (append
                            (list var)
                            (list (append (list 'quote) (list (car^ clause)))))))
                      (list (list name)))
                    value2_reg))
                (set! value1_reg
                  (cons
                    (append
                      (list name)
                      (list
                        (append
                          (list 'lambda)
                          (append (list '()) (at^ (cdr^ clause))))))
                    value1_reg))
                (set! k_reg k2)
                (set! pc apply-cont2)))))))

(define <cont2-40>
  (lambda (clauses var k2)
    (let ((clause 'undefined))
      (set! clause (car^ clauses))
      (if (eq?^ (car^ clause) 'else)
          (begin
            (set! value2_reg
              (cons
                (append (list 'else) (list (list 'else-code)))
                value2_reg))
            (set! value1_reg
              (cons
                (append
                  (list 'else-code)
                  (list
                    (append
                      (list 'lambda)
                      (append (list '()) (at^ (cdr^ clause))))))
                value1_reg))
            (set! k_reg k2)
            (set! pc apply-cont2))
          (if (symbol?^ (car^ clause))
              (let ((name 'undefined))
                (set! name (car^ clause))
                (set! value2_reg
                  (cons
                    (append
                      (list
                        (append
                          (list 'eq?)
                          (append
                            (list (append (list 'car) (list var)))
                            (list (append (list 'quote) (list (car^ clause)))))))
                      (list
                        (append
                          (list 'apply)
                          (append
                            (list name)
                            (list (append (list 'cdr) (list var)))))))
                    value2_reg))
                (set! value1_reg
                  (cons
                    (append
                      (list name)
                      (list
                        (append
                          (list 'lambda)
                          (append (list (cadr^ clause)) (at^ (cddr^ clause))))))
                    value1_reg))
                (set! k_reg k2)
                (set! pc apply-cont2))
              (let ((name 'undefined))
                (set! name (caar^ clause))
                (set! value2_reg
                  (cons
                    (append
                      (list
                        (append
                          (list 'memq)
                          (append
                            (list (append (list 'car) (list var)))
                            (list (append (list 'quote) (list (car^ clause)))))))
                      (list
                        (append
                          (list 'apply)
                          (append
                            (list name)
                            (list (append (list 'cdr) (list var)))))))
                    value2_reg))
                (set! value1_reg
                  (cons
                    (append
                      (list name)
                      (list
                        (append
                          (list 'lambda)
                          (append (list (cadr^ clause)) (at^ (cddr^ clause))))))
                    value1_reg))
                (set! k_reg k2)
                (set! pc apply-cont2)))))))

(define <cont2-41>
  (lambda (type-tester-name k)
    (let ((tester-def 'undefined))
      (set! tester-def
        (append
          (list 'define)
          (append
            (list type-tester-name)
            (list
              (append
                (list 'lambda)
                (append
                  (list (list 'x))
                  (list
                    (append
                      (list 'and)
                      (append
                        (list (append (list 'pair?) (list 'x)))
                        (list
                          (append
                            (list 'not)
                            (list
                              (append
                                (list 'not)
                                (list
                                  (append
                                    (list 'memq)
                                    (append
                                      (list (append (list 'car) (list 'x)))
                                      (list
                                        (append (list 'quote) (list value1_reg)))))))))))))))))))
      (set! value_reg
        (append
          (list 'begin)
          (append (list tester-def) value2_reg)))
      (set! k_reg k)
      (set! pc apply-cont))))

(define <cont2-42>
  (lambda (def name k2)
    (set! value2_reg (cons def value2_reg))
    (set! value1_reg (cons name value1_reg))
    (set! k_reg k2)
    (set! pc apply-cont2)))

(define <cont2-43>
  (lambda (variants k2)
    (set! k2_reg
      (make-cont2 <cont2-42> value2_reg value1_reg k2))
    (set! variants_reg (cdr^ variants))
    (set! pc make-dd-variant-constructors^)))

(define <cont2-44>
  (lambda (exp type-name type-tester-name k)
    (set! value_reg
      (append
        (list 'let)
        (append
          (list
            (append (list (append (list 'r) (list exp))) value1_reg))
          (list
            (append
              (list 'if)
              (append
                (list
                  (append
                    (list 'not)
                    (list (append (list type-tester-name) (list 'r)))))
                (append
                  (list
                    (append
                      (list 'error)
                      (append
                        (list (append (list 'quote) (list 'cases)))
                        (append
                          (list "~a is not a valid ~a")
                          (append
                            (list 'r)
                            (list (append (list 'quote) (list type-name))))))))
                  (list (append (list 'cond) value2_reg)))))))))
    (set! k_reg k)
    (set! pc apply-cont)))

(define <cont2-45>
  (lambda (macro-keyword k)
    (set! value1_reg
      (replace-info
        value1_reg
        (snoc macro-keyword (get-source-info value1_reg))))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-46>
  (lambda (fail k)
    (set! value1_reg value2_reg)
    (set! value2_reg fail)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-47>
  (lambda ()
    (set! *last-fail* value2_reg)
    (set! final_reg value1_reg)
    (set! pc pc-halt-signal)))

(define <cont2-48>
  (lambda ()
    (set! k_reg REP-k)
    (set! fail_reg value2_reg)
    (set! handler_reg REP-handler)
    (set! env_reg toplevel-env)
    (set! exp_reg value1_reg)
    (set! pc m)))

(define <cont2-49>
  (lambda () (set! final_reg #t) (set! pc pc-halt-signal)))

(define <cont2-50>
  (lambda ()
    (set! k_reg (make-cont2 <cont2-49>))
    (set! fail_reg value2_reg)
    (set! handler_reg try-parse-handler)
    (set! senv_reg (initial-contours toplevel-env))
    (set! src_reg 'stdin)
    (set! tokens_reg value1_reg)
    (set! pc aparse-sexps)))

(define <cont2-51>
  (lambda (exp k)
    (handle-debug-info exp value1_reg)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-52>
  (lambda (exp k)
    (pop-stack-trace! exp)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-53>
  (lambda (args exp env info handler k)
    (if *use-stack-trace* (push-stack-trace! exp))
    (if (dlr-proc? value1_reg)
        (let ((result 'undefined))
          (set! result (dlr-apply value1_reg args))
          (if *use-stack-trace* (pop-stack-trace! exp))
          (set! value1_reg result)
          (set! k_reg k)
          (set! pc apply-cont2))
        (if (procedure-object? value1_reg)
            (if *use-stack-trace*
                (begin
                  (set! k2_reg (make-cont2 <cont2-52> exp k))
                  (set! fail_reg value2_reg)
                  (set! handler_reg handler)
                  (set! info_reg info)
                  (set! env2_reg env)
                  (set! args_reg args)
                  (set! proc_reg value1_reg)
                  (set! pc apply-proc))
                (begin
                  (set! k2_reg k)
                  (set! fail_reg value2_reg)
                  (set! handler_reg handler)
                  (set! info_reg info)
                  (set! env2_reg env)
                  (set! args_reg args)
                  (set! proc_reg value1_reg)
                  (set! pc apply-proc)))
            (begin
              (set! fail_reg value2_reg)
              (set! handler_reg handler)
              (set! info_reg info)
              (set! msg_reg
                (format "attempt to apply non-procedure '~a'" value1_reg))
              (set! pc runtime-error))))))

(define <cont2-54>
  (lambda (exp operator env info handler k)
    (set! k_reg
      (make-cont2 <cont2-53> value1_reg exp env info handler k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! exp_reg operator)
    (set! pc m)))

(define <cont2-55>
  (lambda (handler)
    (set! fail_reg value2_reg)
    (set! exception_reg value1_reg)
    (set! handler_reg handler)
    (set! pc apply-handler2)))

(define <cont2-56>
  (lambda (v k)
    (set! value1_reg v)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-57>
  (lambda (fexps env handler k)
    (set! k_reg (make-cont2 <cont2-56> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! exps_reg fexps)
    (set! pc eval-sequence)))

(define <cont2-58>
  (lambda (aclauses clauses k)
    (set-binding-value!
      value1_reg
      (make-pattern-macro^ clauses aclauses))
    (set! value1_reg void-value)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-59>
  (lambda (docstring var k)
    (if (procedure-object? value1_reg)
        (set-global-value! var (dlr-func value1_reg))
        (set-global-value! var value1_reg))
    (set-global-docstring! var docstring)
    (set! value1_reg void-value)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-60>
  (lambda (docstring rhs-value k)
    (set-binding-value! value1_reg rhs-value)
    (set-binding-docstring! value1_reg docstring)
    (set! value1_reg void-value)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-61>
  (lambda (docstring var env handler k)
    (set! k_reg (make-cont2 <cont2-60> docstring value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! var_reg var)
    (set! pc lookup-binding-in-first-frame)))

(define <cont2-62>
  (lambda (rhs-value k)
    (let ((old-value 'undefined))
      (set! old-value (binding-value value1_reg))
      (set-binding-value! value1_reg rhs-value)
      (let ((new-fail 'undefined))
        (set! new-fail
          (make-fail <fail-2> value1_reg old-value value2_reg))
        (set! value2_reg new-fail)
        (set! value1_reg void-value)
        (set! k_reg k)
        (set! pc apply-cont2)))))

(define <cont2-63>
  (lambda (rhs-value k)
    (let ((old-value 'undefined))
      (set! old-value (dlr-env-lookup value1_reg))
      (set-global-value! value1_reg rhs-value)
      (let ((new-fail 'undefined))
        (set! new-fail
          (make-fail <fail-4> old-value value1_reg value2_reg))
        (set! value2_reg new-fail)
        (set! value1_reg void-value)
        (set! k_reg k)
        (set! pc apply-cont2)))))

(define <cont2-64>
  (lambda (var var-info env handler k)
    (set! sk_reg (make-cont2 <cont2-62> value1_reg k))
    (set! dk_reg (make-cont3 <cont3-4> value1_reg k))
    (set! gk_reg (make-cont2 <cont2-63> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! var-info_reg var-info)
    (set! env_reg env)
    (set! var_reg var)
    (set! pc lookup-variable)))

(define <cont2-65>
  (lambda (k)
    (set! value1_reg (binding-docstring value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-66>
  (lambda (k)
    (set! value1_reg (help (dlr-env-lookup value1_reg)))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-67>
  (lambda (else-exp then-exp env handler k)
    (if value1_reg
        (begin
          (set! k_reg k)
          (set! fail_reg value2_reg)
          (set! handler_reg handler)
          (set! env_reg env)
          (set! exp_reg then-exp)
          (set! pc m))
        (begin
          (set! k_reg k)
          (set! fail_reg value2_reg)
          (set! handler_reg handler)
          (set! env_reg env)
          (set! exp_reg else-exp)
          (set! pc m)))))

(define <cont2-68>
  (lambda (k)
    (set! value1_reg (callback value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-69>
  (lambda (k)
    (set! value1_reg (dlr-func value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-70>
  (lambda (exps env handler k)
    (set! k_reg (make-cont2 <cont2-34> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! exps_reg (cdr exps))
    (set! pc m*)))

(define <cont2-71>
  (lambda (exps env handler k)
    (set! k_reg k)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! exps_reg (cdr exps))
    (set! pc eval-sequence)))

(define <cont2-72>
  (lambda (e handler)
    (set! fail_reg value2_reg)
    (set! exception_reg e)
    (set! handler_reg handler)
    (set! pc apply-handler2)))

(define <cont2-73>
  (lambda (trace-depth k2)
    (set! trace-depth (- trace-depth 1))
    (printf
      "~areturn: ~s~%"
      (make-trace-depth-string trace-depth)
      value1_reg)
    (set! k_reg k2)
    (set! pc apply-cont2)))

(define <cont2-74>
  (lambda (args handler k2)
    (set! k_reg k2)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg (cadr args))
    (set! exp_reg value1_reg)
    (set! pc m)))

(define <cont2-75>
  (lambda (handler k2)
    (set! k_reg k2)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg toplevel-env)
    (set! exp_reg value1_reg)
    (set! pc m)))

(define <cont2-76>
  (lambda (handler k2)
    (set! k_reg (make-cont4 <cont4-11> handler k2))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! src_reg 'stdin)
    (set! tokens_reg value1_reg)
    (set! pc read-sexp)))

(define <cont2-77>
  (lambda (handler k2)
    (set! k_reg (make-cont4 <cont4-12> handler k2))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! src_reg 'stdin)
    (set! tokens_reg value1_reg)
    (set! pc read-sexp)))

(define <cont2-78>
  (lambda (k)
    (if (null? load-stack)
        (printf "WARNING: empty load-stack encountered!\n")
        (set! load-stack (cdr load-stack)))
    (set! value1_reg void-value)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-79>
  (lambda (filename env2 handler k)
    (set! k_reg (make-cont2 <cont2-78> k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env2_reg env2)
    (set! src_reg filename)
    (set! tokens_reg value1_reg)
    (set! pc read-and-eval-asexps)))

(define <cont2-80>
  (lambda (src tokens-left env2 handler k)
    (if (token-type? (first tokens-left) 'end-marker)
        (begin (set! k_reg k) (set! pc apply-cont2))
        (begin
          (set! k_reg k)
          (set! fail_reg value2_reg)
          (set! handler_reg handler)
          (set! env2_reg env2)
          (set! src_reg src)
          (set! tokens_reg tokens-left)
          (set! pc read-and-eval-asexps)))))

(define <cont2-81>
  (lambda (src tokens-left env2 handler k)
    (set! k_reg
      (make-cont2 <cont2-80> src tokens-left env2 handler k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env2)
    (set! exp_reg value1_reg)
    (set! pc m)))

(define <cont2-82>
  (lambda (filenames env2 info handler k)
    (set! k_reg k)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! info_reg info)
    (set! env2_reg env2)
    (set! filenames_reg (cdr filenames))
    (set! pc load-files)))

(define <cont2-83>
  (lambda (lst k2)
    (if (member (car lst) value1_reg)
        (begin (set! k_reg k2) (set! pc apply-cont2))
        (begin
          (set! value1_reg (cons (car lst) value1_reg))
          (set! k_reg k2)
          (set! pc apply-cont2)))))

(define <cont2-84>
  (lambda (filename handler k2)
    (let ((module 'undefined))
      (set! module (make-toplevel-env))
      (set-binding-value! value1_reg module)
      (set! k_reg k2)
      (set! fail_reg value2_reg)
      (set! handler_reg handler)
      (set! info_reg 'none)
      (set! env2_reg module)
      (set! filename_reg filename)
      (set! pc load-file))))

(define <cont2-85>
  (lambda (args sym info handler k)
    (if (null? (cdr args))
        (begin (set! k_reg k) (set! pc apply-cont2))
        (if (not (environment? value1_reg))
            (begin
              (set! fail_reg value2_reg)
              (set! handler_reg handler)
              (set! info_reg info)
              (set! msg_reg (format "invalid module '~a'" sym))
              (set! pc runtime-error))
            (begin
              (set! k_reg k)
              (set! fail_reg value2_reg)
              (set! handler_reg handler)
              (set! info_reg info)
              (set! env_reg value1_reg)
              (set! args_reg (cdr args))
              (set! pc get-primitive))))))

(define <cont2-86>
  (lambda (ls1 k2)
    (set! value1_reg (cons (car ls1) value1_reg))
    (set! k_reg k2)
    (set! pc apply-cont2)))

(define <cont2-87>
  (lambda (lists k2)
    (set! k2_reg k2)
    (set! fail_reg value2_reg)
    (set! ls2_reg value1_reg)
    (set! ls1_reg (car lists))
    (set! pc append2)))

(define <cont2-88>
  (lambda (iterator proc env handler k)
    (set! k_reg k)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! iterator_reg iterator)
    (set! proc_reg proc)
    (set! pc iterate-continue)))

(define <cont2-89>
  (lambda (iterator proc env handler k)
    (set! k_reg (make-cont2 <cont2-34> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! iterator_reg iterator)
    (set! proc_reg proc)
    (set! pc iterate-collect-continue)))

(define <cont2-90>
  (lambda (list1 proc env handler k)
    (set! k_reg (make-cont2 <cont2-34> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! list1_reg (cdr list1))
    (set! proc_reg proc)
    (set! pc map1)))

(define <cont2-91>
  (lambda (list1 proc k)
    (set! value1_reg
      (cons (dlr-apply proc (list (car list1))) value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-92>
  (lambda (list1 list2 proc env handler k)
    (set! k_reg (make-cont2 <cont2-34> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! list2_reg (cdr list2))
    (set! list1_reg (cdr list1))
    (set! proc_reg proc)
    (set! pc map2)))

(define <cont2-93>
  (lambda (list1 list2 proc k)
    (set! value1_reg
      (cons
        (dlr-apply proc (list (car list1) (car list2)))
        value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-94>
  (lambda (lists proc env handler k)
    (set! k_reg (make-cont2 <cont2-34> value1_reg k))
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! lists_reg (map cdr lists))
    (set! proc_reg proc)
    (set! pc mapN)))

(define <cont2-95>
  (lambda (lists proc k)
    (set! value1_reg
      (cons (dlr-apply proc (map car lists)) value1_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont2-96>
  (lambda (arg-list proc env handler k)
    (set! k_reg k)
    (set! fail_reg value2_reg)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! lists_reg (map cdr arg-list))
    (set! proc_reg proc)
    (set! pc for-each-primitive)))

(define <cont2-97>
  (lambda (new-acdr1 new-cdr1 s-car k)
    (set! k_reg (make-cont <cont-50> s-car k))
    (set! ap2_reg value2_reg)
    (set! ap1_reg new-acdr1)
    (set! p2_reg value1_reg)
    (set! p1_reg new-cdr1)
    (set! pc unify-patterns^)))

(define <cont2-98>
  (lambda (apair2 pair2 s-car k)
    (set! k2_reg
      (make-cont2 <cont2-97> value2_reg value1_reg s-car k))
    (set! ap_reg (cdr^ apair2))
    (set! s_reg s-car)
    (set! pattern_reg (cdr pair2))
    (set! pc instantiate^)))

(define <cont2-99>
  (lambda (a aa ap k2)
    (set! value2_reg (cons^ aa value2_reg (get-source-info ap)))
    (set! value1_reg (cons a value1_reg))
    (set! k_reg k2)
    (set! pc apply-cont2)))

(define <cont2-100>
  (lambda (ap pattern s k2)
    (set! k2_reg
      (make-cont2 <cont2-99> value1_reg value2_reg ap k2))
    (set! ap_reg (cdr^ ap))
    (set! s_reg s)
    (set! pattern_reg (cdr pattern))
    (set! pc instantiate^)))

(define <cont2-101>
  (lambda (s2 k2)
    (set! k2_reg k2)
    (set! ap_reg value2_reg)
    (set! s_reg s2)
    (set! pattern_reg value1_reg)
    (set! pc instantiate^)))

(define make-cont3
  (lambda args (return* (cons 'continuation3 args))))

(define*
  apply-cont3
  (lambda () (apply! (cadr k_reg) (cddr k_reg))))

(define <cont3-1>
  (lambda (src handler k)
    (if (token-type? value1_reg 'end-marker)
        (begin
          (set! value2_reg value3_reg)
          (set! value1_reg (list value1_reg))
          (set! k_reg k)
          (set! pc apply-cont2))
        (begin
          (set! k_reg (make-cont2 <cont2-1> value1_reg k))
          (set! fail_reg value3_reg)
          (set! handler_reg handler)
          (set! src_reg src)
          (set! chars_reg value2_reg)
          (set! pc scan-input-loop)))))

(define <cont3-2>
  (lambda ()
    (set! final_reg value1_reg)
    (set! pc pc-halt-signal)))

(define <cont3-3>
  (lambda (k)
    (set! value1_reg
      (get-external-member value1_reg value2_reg))
    (set! value2_reg value3_reg)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <cont3-4>
  (lambda (rhs-value k)
    (let ((old-value 'undefined))
      (set! old-value (get-external-member value1_reg value2_reg))
      (set-external-member! value1_reg value2_reg rhs-value)
      (let ((new-fail 'undefined))
        (set! new-fail
          (make-fail <fail-3> value2_reg value1_reg old-value
            value3_reg))
        (set! value2_reg new-fail)
        (set! value1_reg void-value)
        (set! k_reg k)
        (set! pc apply-cont2)))))

(define <cont3-5>
  (lambda (k)
    (set! value1_reg
      (help (get-external-member value1_reg value2_reg)))
    (set! value2_reg value3_reg)
    (set! k_reg k)
    (set! pc apply-cont2)))

(define make-cont4
  (lambda args (return* (cons 'continuation4 args))))

(define*
  apply-cont4
  (lambda () (apply! (cadr k_reg) (cddr k_reg))))

(define <cont4-1>
  (lambda (src start k)
    (set! k_reg
      (make-cont <cont-8> value2_reg value3_reg value4_reg k))
    (set! info_reg (make-info src start value2_reg))
    (set! x_reg (list->vector value1_reg))
    (set! pc annotate-cps)))

(define <cont4-2>
  (lambda (src start k)
    (set! k_reg
      (make-cont <cont-8> value2_reg value3_reg value4_reg k))
    (set! info_reg (make-info src start value2_reg))
    (set! x_reg value1_reg)
    (set! pc annotate-cps)))

(define <cont4-3>
  (lambda (src start v k)
    (set! k_reg
      (make-cont <cont-8> value2_reg value3_reg value4_reg k))
    (set! info_reg (make-info src start value2_reg))
    (set! x_reg (list v value1_reg))
    (set! pc annotate-cps)))

(define <cont4-4>
  (lambda (sexp1 k)
    (set! value1_reg (cons sexp1 value1_reg))
    (set! k_reg k)
    (set! pc apply-cont4)))

(define <cont4-5>
  (lambda (src handler k)
    (set! k_reg (make-cont4 <cont4-4> value1_reg k))
    (set! fail_reg value4_reg)
    (set! handler_reg handler)
    (set! src_reg src)
    (set! tokens_reg value3_reg)
    (set! pc read-vector-sequence)))

(define <cont4-6>
  (lambda (expected-terminator sexp1 src handler k)
    (set! k_reg k)
    (set! fail_reg value4_reg)
    (set! handler_reg handler)
    (set! src_reg src)
    (set! expected-terminator_reg expected-terminator)
    (set! tokens_reg value3_reg)
    (set! sexps_reg (cons sexp1 value1_reg))
    (set! pc close-sexp-sequence)))

(define <cont4-7>
  (lambda (expected-terminator src handler k)
    (if (token-type? (first value3_reg) 'dot)
        (begin
          (set! k_reg
            (make-cont4 <cont4-6> expected-terminator value1_reg src
              handler k))
          (set! fail_reg value4_reg)
          (set! handler_reg handler)
          (set! src_reg src)
          (set! tokens_reg (rest-of value3_reg))
          (set! pc read-sexp))
        (begin
          (set! k_reg (make-cont4 <cont4-4> value1_reg k))
          (set! fail_reg value4_reg)
          (set! handler_reg handler)
          (set! src_reg src)
          (set! expected-terminator_reg expected-terminator)
          (set! tokens_reg value3_reg)
          (set! pc read-sexp-sequence)))))

(define <cont4-8>
  (lambda ()
    (set! final_reg value1_reg)
    (set! pc pc-halt-signal)))

(define <cont4-9>
  (lambda (senv src handler k)
    (set! k_reg
      (make-cont2 <cont2-35> senv src value3_reg handler k))
    (set! fail_reg value4_reg)
    (set! handler_reg handler)
    (set! senv_reg senv)
    (set! adatum_reg value1_reg)
    (set! pc aparse)))

(define <cont4-10>
  (lambda ()
    (set! *tokens-left* value3_reg)
    (set! k_reg (make-cont2 <cont2-48>))
    (set! fail_reg value4_reg)
    (set! handler_reg REP-handler)
    (set! senv_reg (initial-contours toplevel-env))
    (set! adatum_reg value1_reg)
    (set! pc aparse)))

(define <cont4-11>
  (lambda (handler k2)
    (if (token-type? (first value3_reg) 'end-marker)
        (begin
          (set! k_reg k2)
          (set! fail_reg value4_reg)
          (set! handler_reg handler)
          (set! senv_reg (initial-contours toplevel-env))
          (set! adatum_reg value1_reg)
          (set! pc aparse))
        (begin
          (set! fail_reg value4_reg)
          (set! handler_reg handler)
          (set! src_reg 'stdin)
          (set! tokens_reg value3_reg)
          (set! msg_reg "tokens left over")
          (set! pc read-error)))))

(define <cont4-12>
  (lambda (handler k2)
    (if (token-type? (first value3_reg) 'end-marker)
        (begin
          (set! value2_reg value4_reg)
          (set! k_reg k2)
          (set! pc apply-cont2))
        (begin
          (set! fail_reg value4_reg)
          (set! handler_reg handler)
          (set! src_reg 'stdin)
          (set! tokens_reg value3_reg)
          (set! msg_reg "tokens left over")
          (set! pc read-error)))))

(define <cont4-13>
  (lambda (src env2 handler k)
    (set! k_reg
      (make-cont2 <cont2-81> src value3_reg env2 handler k))
    (set! fail_reg value4_reg)
    (set! handler_reg handler)
    (set! senv_reg (initial-contours env2))
    (set! adatum_reg value1_reg)
    (set! pc aparse)))

(define make-fail
  (lambda args (return* (cons 'fail-continuation args))))

(define*
  apply-fail
  (lambda () (apply! (cadr fail_reg) (cddr fail_reg))))

(define <fail-1>
  (lambda ()
    (set! final_reg "no more choices")
    (set! pc pc-halt-signal)))

(define <fail-2>
  (lambda (binding old-value fail)
    (set-binding-value! binding old-value)
    (set! fail_reg fail)
    (set! pc apply-fail)))

(define <fail-3>
  (lambda (components dlr-obj old-value fail)
    (set-external-member! dlr-obj components old-value)
    (set! fail_reg fail)
    (set! pc apply-fail)))

(define <fail-4>
  (lambda (old-value var fail)
    (set-global-value! var old-value)
    (set! fail_reg fail)
    (set! pc apply-fail)))

(define <fail-5>
  (lambda (exps env handler fail k)
    (set! k_reg k)
    (set! fail_reg fail)
    (set! handler_reg handler)
    (set! env_reg env)
    (set! exps_reg (cdr exps))
    (set! pc eval-choices)))

(define make-handler
  (lambda args (return* (cons 'handler args))))

(define*
  apply-handler
  (lambda () (apply! (cadr handler_reg) (cddr handler_reg))))

(define <handler-1>
  (lambda ()
    (set! final_reg (list 'exception exception_reg))
    (set! pc pc-halt-signal)))

(define make-handler2
  (lambda args (return* (cons 'handler2 args))))

(define*
  apply-handler2
  (lambda () (apply! (cadr handler_reg) (cddr handler_reg))))

(define <handler2-1>
  (lambda ()
    (set! final_reg (list 'exception exception_reg))
    (set! pc pc-halt-signal)))

(define <handler2-2>
  (lambda ()
    (set! *last-fail* fail_reg)
    (set! final_reg (list 'exception exception_reg))
    (set! pc pc-halt-signal)))

(define <handler2-3>
  (lambda () (set! final_reg #f) (set! pc pc-halt-signal)))

(define <handler2-4>
  (lambda (cexps cvar env handler k)
    (let ((new-env 'undefined))
      (set! new-env
        (extend
          env
          (list cvar)
          (list exception_reg)
          (list "try-catch handler")))
      (set! k_reg k)
      (set! handler_reg handler)
      (set! env_reg new-env)
      (set! exps_reg cexps)
      (set! pc eval-sequence))))

(define <handler2-5>
  (lambda (fexps env handler)
    (set! k_reg (make-cont2 <cont2-72> exception_reg handler))
    (set! handler_reg handler)
    (set! env_reg env)
    (set! exps_reg fexps)
    (set! pc eval-sequence)))

(define <handler2-6>
  (lambda (cexps cvar fexps env handler k)
    (let ((new-env 'undefined))
      (set! new-env
        (extend
          env
          (list cvar)
          (list exception_reg)
          (list "try-catch-finally handler")))
      (let ((catch-handler 'undefined))
        (set! catch-handler (try-finally-handler fexps env handler))
        (set! k_reg (make-cont2 <cont2-57> fexps env handler k))
        (set! handler_reg catch-handler)
        (set! env_reg new-env)
        (set! exps_reg cexps)
        (set! pc eval-sequence)))))

(define make-proc
  (lambda args (return* (cons 'procedure args))))

(define*
  apply-proc
  (lambda () (apply! (cadr proc_reg) (cddr proc_reg))))

(define <proc-1>
  (lambda (bodies formals env)
    (if (= (length args_reg) (length formals))
        (begin
          (set! k_reg k2_reg)
          (set! env_reg
            (extend
              env
              formals
              args_reg
              (make-empty-docstrings (length args_reg))))
          (set! exps_reg bodies)
          (set! pc eval-sequence))
        (begin
          (set! msg_reg
            "incorrect number of arguments in application")
          (set! pc runtime-error)))))

(define <proc-2>
  (lambda (bodies formals runt env)
    (if (>= (length args_reg) (length formals))
        (let ((new-env 'undefined))
          (set! new-env
            (extend
              env
              (cons runt formals)
              (cons
                (list-tail args_reg (length formals))
                (list-head args_reg (length formals)))
              (make-empty-docstrings (+ 1 (length formals)))))
          (set! k_reg k2_reg)
          (set! env_reg new-env)
          (set! exps_reg bodies)
          (set! pc eval-sequence))
        (begin
          (set! msg_reg "not enough arguments in application")
          (set! pc runtime-error)))))

(define <proc-3>
  (lambda (bodies name trace-depth formals env)
    (if (= (length args_reg) (length formals))
        (begin
          (printf
            "~acall: ~s~%"
            (make-trace-depth-string trace-depth)
            (cons name args_reg))
          (set! trace-depth (+ trace-depth 1))
          (set! k_reg (make-cont2 <cont2-73> trace-depth k2_reg))
          (set! env_reg
            (extend
              env
              formals
              args_reg
              (make-empty-docstrings (length formals))))
          (set! exps_reg bodies)
          (set! pc eval-sequence))
        (begin
          (set! msg_reg
            "incorrect number of arguments in application")
          (set! pc runtime-error)))))

(define <proc-4>
  (lambda (bodies name trace-depth formals runt env)
    (if (>= (length args_reg) (length formals))
        (let ((new-env 'undefined))
          (set! new-env
            (extend
              env
              (cons runt formals)
              (cons
                (list-tail args_reg (length formals))
                (list-head args_reg (length formals)))
              (make-empty-docstrings (+ 1 (length formals)))))
          (printf
            "~acall: ~s~%"
            (make-trace-depth-string trace-depth)
            (cons name args_reg))
          (set! trace-depth (+ trace-depth 1))
          (set! k_reg (make-cont2 <cont2-73> trace-depth k2_reg))
          (set! env_reg new-env)
          (set! exps_reg bodies)
          (set! pc eval-sequence))
        (begin
          (set! msg_reg "not enough arguments in application")
          (set! pc runtime-error)))))

(define <proc-5>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg void-value)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-6>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (= (car args_reg) 0))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-7>
  (lambda ()
    (set! final_reg end-of-session)
    (set! pc pc-halt-signal)))

(define <proc-8>
  (lambda ()
    (if (length-one? args_reg)
        (begin
          (set! k_reg
            (make-cont <cont-42> handler_reg fail_reg k2_reg))
          (set! info_reg 'none)
          (set! x_reg (car args_reg))
          (set! pc annotate-cps))
        (if (length-two? args_reg)
            (begin
              (set! k_reg
                (make-cont <cont-41> args_reg handler_reg fail_reg k2_reg))
              (set! info_reg 'none)
              (set! x_reg (car args_reg))
              (set! pc annotate-cps))
            (begin
              (set! msg_reg "incorrect number of arguments to eval")
              (set! pc runtime-error))))))

(define <proc-9>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to eval-ast")
          (set! pc runtime-error))
        (if (not (list? (car args_reg)))
            (begin
              (set! msg_reg
                "eval-ast called on non-abstract syntax tree argument")
              (set! pc runtime-error))
            (begin
              (set! k_reg k2_reg)
              (set! env_reg toplevel-env)
              (set! exp_reg (car args_reg))
              (set! pc m))))))

(define <proc-10>
  (lambda ()
    (set! k_reg
      (make-cont <cont-43> handler_reg fail_reg k2_reg))
    (set! info_reg 'none)
    (set! x_reg (car args_reg))
    (set! pc annotate-cps)))

(define <proc-11>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to string-length")
          (set! pc runtime-error))
        (if (not (string? (car args_reg)))
            (begin
              (set! msg_reg "string-length called on non-string argument")
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply string-length args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-12>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to string-ref")
          (set! pc runtime-error))
        (if (not (string? (car args_reg)))
            (begin
              (set! msg_reg
                "string-ref called with non-string first argument")
              (set! pc runtime-error))
            (if (not (number? (cadr args_reg)))
                (begin
                  (set! msg_reg
                    "string-ref called with non-numberic second argument")
                  (set! pc runtime-error))
                (begin
                  (set! value2_reg fail_reg)
                  (set! value1_reg (apply string-ref args_reg))
                  (set! k_reg k2_reg)
                  (set! pc apply-cont2)))))))

(define <proc-13>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (aunparse (car args_reg)))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-14>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (aunparse (car (caddr (car args_reg)))))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-15>
  (lambda ()
    (set! k_reg (make-cont2 <cont2-76> handler_reg k2_reg))
    (set! src_reg 'stdin)
    (set! input_reg (car args_reg))
    (set! pc scan-input)))

(define <proc-16>
  (lambda ()
    (set! k_reg (make-cont2 <cont2-77> handler_reg k2_reg))
    (set! src_reg 'stdin)
    (set! input_reg (car args_reg))
    (set! pc scan-input)))

(define <proc-17>
  (lambda ()
    (let ((proc 'undefined) (proc-args 'undefined))
      (set! proc-args (cadr args_reg))
      (set! proc (car args_reg))
      (if (dlr-proc? proc)
          (begin
            (set! value2_reg fail_reg)
            (set! value1_reg (dlr-apply proc proc-args))
            (set! k_reg k2_reg)
            (set! pc apply-cont2))
          (begin
            (set! args_reg proc-args)
            (set! proc_reg proc)
            (set! pc apply-proc))))))

(define <proc-18>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to sqrt")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply sqrt args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-19>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to odd?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (odd? (car args_reg)))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-20>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to even?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (even? (car args_reg)))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-21>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to quotient")
          (set! pc runtime-error))
        (if (member 0 (cdr args_reg))
            (begin
              (set! msg_reg "division by zero")
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply quotient args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-22>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to remainder")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply remainder args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-23>
  (lambda ()
    (for-each safe-print args_reg)
    (set! value2_reg fail_reg)
    (set! value1_reg void-value)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-24>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply string args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-25>
  (lambda ()
    (if (= (length args_reg) 3)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg
            (substring (car args_reg) (cadr args_reg) (caddr args_reg)))
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg
            (substring
              (car args_reg)
              (cadr args_reg)
              (string-length (car args_reg))))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-26>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (number->string (car args_reg)))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-27>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (assv (car args_reg) (cadr args_reg)))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-28>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (memv (car args_reg) (cadr args_reg)))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-29>
  (lambda ()
    (let ((s 'undefined))
      (set! s (format "~a" (car args_reg)))
      (set! *need-newline* (true? (not (ends-with-newline? s))))
      (display s)
      (set! value2_reg fail_reg)
      (set! value1_reg void-value)
      (set! k_reg k2_reg)
      (set! pc apply-cont2))))

(define <proc-30>
  (lambda ()
    (set! *need-newline* #f)
    (newline)
    (set! value2_reg fail_reg)
    (set! value1_reg void-value)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-31>
  (lambda ()
    (if (not (length-at-least? 1 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to load")
          (set! pc runtime-error))
        (begin
          (set! k_reg k2_reg)
          (set! env2_reg toplevel-env)
          (set! filenames_reg args_reg)
          (set! pc load-files)))))

(define <proc-32>
  (lambda ()
    (if (length-one? args_reg)
        (begin
          (set! ls_reg (car args_reg))
          (set! sum_reg 0)
          (set! x_reg (car args_reg))
          (set! pc length-loop))
        (begin
          (set! msg_reg "incorrect number of arguments to length")
          (set! pc runtime-error)))))

(define <proc-33>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            (format
              "incorrect number of arguments to symbol?: you gave ~s, should have been 1 argument"
              args_reg))
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply symbol? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-34>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to number?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply number? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-35>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to boolean?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply boolean? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-36>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to string?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply string? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-37>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to char?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply char? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-38>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to char=?")
          (set! pc runtime-error))
        (if (or (not (char? (car args_reg)))
                (not (char? (cadr args_reg))))
            (begin
              (set! msg_reg "char=? requires arguments of type char")
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply char=? args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-39>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to char-whitespace?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply char-whitespace? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-40>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to char->integer")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply char->integer args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-41>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to integer->char")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply integer->char args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-42>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to char-alphabetic?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply char-alphabetic? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-43>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to char-numeric?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply char-numeric? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-44>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to null?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply null? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-45>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to pair?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply pair? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-46>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cons")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply cons args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-47>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to car")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "car called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply car args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-48>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-49>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cadr")
          (set! pc runtime-error))
        (if (not (length-at-least? 2 (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "cadr called on incorrect list structure ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-50>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caddr")
          (set! pc runtime-error))
        (if (not (length-at-least? 3 (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "caddr called on incorrect list structure ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-51>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caaaar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caaaar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caaaar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-52>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caaadr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caaadr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caaadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-53>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caaar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caaar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caaar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-54>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caadar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caadar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caadar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-55>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caaddr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caaddr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caaddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-56>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caadr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caadr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-57>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-58>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cadaar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cadaar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cadaar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-59>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cadadr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cadadr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cadadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-60>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cadar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cadar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cadar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-61>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to caddar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "caddar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply caddar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-62>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cadddr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cadddr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cadddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-63>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdaaar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdaaar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdaaar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-64>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdaadr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdaadr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdaadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-65>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdaar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdaar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdaar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-66>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdadar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdadar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdadar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-67>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdaddr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdaddr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdaddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-68>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdadr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdadr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-69>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-70>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cddaar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cddaar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cddaar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-71>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cddadr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cddadr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cddadr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-72>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cddar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cddar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cddar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-73>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdddar")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdddar called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdddar args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-74>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cddddr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cddddr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cddddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-75>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cdddr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cdddr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cdddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-76>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to cddr")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "cddr called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply cddr args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-77>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg args_reg)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-78>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to set")
          (set! pc runtime-error))
        (begin (set! lst_reg (car args_reg)) (set! pc make-set)))))

(define <proc-79>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply + args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-80>
  (lambda ()
    (if (null? args_reg)
        (begin
          (set! msg_reg "incorrect number of arguments to -")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply - args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-81>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply * args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-82>
  (lambda ()
    (if (and (> (length args_reg) 1) (member 0 (cdr args_reg)))
        (begin
          (set! msg_reg "division by zero")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply / args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-83>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to %")
          (set! pc runtime-error))
        (if (= (cadr args_reg) 0)
            (begin
              (set! msg_reg "modulo by zero")
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply modulo args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-84>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply min args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-85>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply max args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-86>
  (lambda ()
    (if (not (length-at-least? 2 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to <")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply < args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-87>
  (lambda ()
    (if (not (length-at-least? 2 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to >")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply > args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-88>
  (lambda ()
    (if (not (length-at-least? 2 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to <=")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply <= args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-89>
  (lambda ()
    (if (not (length-at-least? 2 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to >=")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply >= args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-90>
  (lambda ()
    (if (not (length-at-least? 2 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to =")
          (set! pc runtime-error))
        (if (not (all-numeric? args_reg))
            (begin
              (set! msg_reg "attempt to apply = on non-numeric argument")
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply = args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-91>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to abs")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply abs args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-92>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to equal?")
          (set! pc runtime-error))
        (begin
          (set! k_reg (make-cont <cont-44> fail_reg k2_reg))
          (set! y_reg (cadr args_reg))
          (set! x_reg (car args_reg))
          (set! pc equal-objects?)))))

(define <proc-93>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to eq?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply eq? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-94>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to memq")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply memq args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-95>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to member")
          (set! pc runtime-error))
        (begin
          (set! k_reg k2_reg)
          (set! ls_reg (cadr args_reg))
          (set! y_reg (cadr args_reg))
          (set! x_reg (car args_reg))
          (set! pc member-loop)))))

(define <proc-96>
  (lambda ()
    (if (or (null? args_reg) (length-at-least? 4 args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to range")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply range args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-97>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply snoc args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-98>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply rac args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-99>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply rdc args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-100>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to set-car!")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "set-car! called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply set-car! args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-101>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to set-cdr!")
          (set! pc runtime-error))
        (if (not (pair? (car args_reg)))
            (begin
              (set! msg_reg
                (format "set-cdr! called on non-pair ~s" (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply set-cdr! args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-102>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to load-as")
          (set! pc runtime-error))
        (let ((filename 'undefined) (module-name 'undefined))
          (set! module-name (cadr args_reg))
          (set! filename (car args_reg))
          (set! k_reg
            (make-cont2 <cont2-84> filename handler_reg k2_reg))
          (set! env_reg env2_reg)
          (set! var_reg module-name)
          (set! pc lookup-binding-in-first-frame)))))

(define <proc-103>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (car *stack-trace*))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-104>
  (lambda ()
    (set! k_reg k2_reg)
    (set! env_reg env2_reg)
    (set! pc get-primitive)))

(define <proc-105>
  (lambda (k)
    (set! value2_reg fail_reg)
    (set! value1_reg (car args_reg))
    (set! k_reg k)
    (set! pc apply-cont2)))

(define <proc-106>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to call/cc")
          (set! pc runtime-error))
        (let ((proc 'undefined))
          (set! proc (car args_reg))
          (if (not (procedure-object? proc))
              (begin
                (set! msg_reg "call/cc called with non-procedure")
                (set! pc runtime-error))
              (let ((fake-k 'undefined))
                (set! fake-k (make-proc <proc-105> k2_reg))
                (if (dlr-proc? proc)
                    (begin
                      (set! value2_reg fail_reg)
                      (set! value1_reg (dlr-apply proc (list fake-k)))
                      (set! k_reg k2_reg)
                      (set! pc apply-cont2))
                    (begin
                      (set! args_reg (list fake-k))
                      (set! proc_reg proc)
                      (set! pc apply-proc)))))))))

(define <proc-107>
  (lambda ()
    (if (null? args_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg void-value)
          (set! k_reg REP-k)
          (set! pc apply-cont2))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (car args_reg))
          (set! k_reg REP-k)
          (set! pc apply-cont2)))))

(define <proc-108>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to require")
          (set! pc runtime-error))
        (if (true? (car args_reg))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg 'ok)
              (set! k_reg k2_reg)
              (set! pc apply-cont2))
            (set! pc apply-fail)))))

(define <proc-109>
  (lambda ()
    (set! value2_reg REP-fail)
    (set! value1_reg args_reg)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-110>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to reverse")
          (set! pc runtime-error))
        (if (not (list? args_reg))
            (begin
              (set! msg_reg
                (format
                  "reverse called on incorrect list structure ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply reverse args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-111>
  (lambda () (set! lists_reg args_reg) (set! pc append-all)))

(define <proc-112>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to string->number")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply string->number args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-113>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to string=?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply string=? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-114>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to list->vector")
          (set! pc runtime-error))
        (if (not (list? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "list->vector called on incorrect list structure ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply list->vector args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-115>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to list->string")
          (set! pc runtime-error))
        (if (not (list? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "list->string called on incorrect list structure ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (if (not (all-char? (car args_reg)))
                (begin
                  (set! msg_reg
                    (format
                      "list->string called on non-char list ~s"
                      (car args_reg)))
                  (set! pc runtime-error))
                (begin
                  (set! value2_reg fail_reg)
                  (set! value1_reg (apply list->string args_reg))
                  (set! k_reg k2_reg)
                  (set! pc apply-cont2)))))))

(define <proc-116>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to char->string")
          (set! pc runtime-error))
        (if (not (char? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "char->string called on non-char item ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply char->string args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-117>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to string->list")
          (set! pc runtime-error))
        (if (not (string? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "string->list called on non-string item ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply string->list args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-118>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to string->symbol")
          (set! pc runtime-error))
        (if (not (string? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "string->symbol called on non-string item ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply string->symbol args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-119>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to symbol->string")
          (set! pc runtime-error))
        (if (not (symbol? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "symbol->string called on non-symbol item ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply symbol->string args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-120>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to vector->list")
          (set! pc runtime-error))
        (if (not (vector? (car args_reg)))
            (begin
              (set! msg_reg
                (format
                  "vector->list called on incorrect vector structure ~s"
                  (car args_reg)))
              (set! pc runtime-error))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (apply vector->list args_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))))))

(define <proc-121>
  (lambda ()
    (set! lst_reg (directory args_reg env2_reg))
    (set! pc make-set)))

(define <proc-122>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (get-current-time))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-123>
  (lambda ()
    (set! k_reg k2_reg)
    (set! env_reg env2_reg)
    (set! proc_reg (car args_reg))
    (set! args_reg (cdr args_reg))
    (set! pc map-primitive)))

(define <proc-124>
  (lambda ()
    (set! k_reg k2_reg)
    (set! env_reg env2_reg)
    (set! lists_reg (cdr args_reg))
    (set! proc_reg (car args_reg))
    (set! pc for-each-primitive)))

(define <proc-125>
  (lambda ()
    (if (< (length args_reg) 1)
        (begin
          (set! msg_reg "incorrect number of arguments to format")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply format args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-126>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg env2_reg)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-127>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (import-native args_reg env2_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-128>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg
      (import-as-native (car args_reg) (cadr args_reg) env2_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-129>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg
      (import-from-native (car args_reg) (cdr args_reg) env2_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-130>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to not")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (not (true? (car args_reg))))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-131>
  (lambda ()
    (apply printf args_reg)
    (set! value2_reg fail_reg)
    (set! value1_reg void-value)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-132>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply vector_native args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-133>
  (lambda ()
    (vector-set!
      (car args_reg)
      (cadr args_reg)
      (caddr args_reg))
    (set! value2_reg fail_reg)
    (set! value1_reg void-value)
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-134>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply vector-ref args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-135>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply make-vector args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-136>
  (lambda ()
    (if (not (length-at-least? 1 args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to 'error' (should at least 1)")
          (set! pc runtime-error))
        (let ((location 'undefined) (message 'undefined))
          (set! location (format "Error in '~a': " (car args_reg)))
          (set! message
            (string-append location (apply format (cdr args_reg))))
          (set! msg_reg message)
          (set! pc runtime-error)))))

(define <proc-137>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to list-ref")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply list-ref args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-138>
  (lambda ()
    (if (null? args_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (current-directory))
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (if (length-one? args_reg)
            (if (string? (car args_reg))
                (begin
                  (set! value2_reg fail_reg)
                  (set! value1_reg (current-directory (car args_reg)))
                  (set! k_reg k2_reg)
                  (set! pc apply-cont2))
                (begin
                  (set! msg_reg "directory must be a string")
                  (set! pc runtime-error)))
            (begin
              (set! msg_reg
                "incorrect number of arguments to current-directory")
              (set! pc runtime-error))))))

(define <proc-139>
  (lambda ()
    (if (and (length-one? args_reg) (number? (car args_reg)))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (round (car args_reg)))
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! msg_reg "round requires exactly one number")
          (set! pc runtime-error)))))

(define <proc-140>
  (lambda ()
    (if (and (length-one? args_reg) (boolean? (car args_reg)))
        (begin
          (set-use-stack-trace! (car args_reg))
          (set! value2_reg fail_reg)
          (set! value1_reg void-value)
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (if (null? args_reg)
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg *use-stack-trace*)
              (set! k_reg k2_reg)
              (set! pc apply-cont2))
            (begin
              (set! msg_reg
                "use-stack-trace requires exactly one boolean or nothing")
              (set! pc runtime-error))))))

(define <proc-141>
  (lambda ()
    (if (and (length-one? args_reg) (boolean? (car args_reg)))
        (begin
          (set! *tracing-on?* (true? (car args_reg)))
          (set! value2_reg fail_reg)
          (set! value1_reg void-value)
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (if (null? args_reg)
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg *tracing-on?*)
              (set! k_reg k2_reg)
              (set! pc apply-cont2))
            (begin
              (set! msg_reg
                "use-tracing requires exactly one boolean or nothing")
              (set! pc runtime-error))))))

(define <proc-142>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to eqv?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply eqv? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-143>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to vector?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply vector? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-144>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to atom?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply atom? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-145>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to iter?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply iter? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-146>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply contains-native args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-147>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply getitem-native args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-148>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply setitem-native args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-149>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to list?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply list? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-150>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to procedure?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply procedure? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-151>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to string<?")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply string<? args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-152>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to float")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply float args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-153>
  (lambda ()
    (if (not (null? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to globals")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply globals args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-154>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to int")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply int args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-155>
  (lambda ()
    (if (not (length-at-least? 1 args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to apply-with-keywords")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply apply-with-keywords args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-156>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to assq")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply assq args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-157>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply dict args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-158>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to property")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply property args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-159>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to rational")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply / args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-160>
  (lambda ()
    (if (not (null? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to reset-toplevel-env")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply reset-toplevel-env args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-161>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to sort")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply sort args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-162>
  (lambda ()
    (if (not (length-at-least? 2 args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to string-append")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply string-append args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-163>
  (lambda ()
    (if (not (length-two? args_reg))
        (begin
          (set! msg_reg
            "incorrect number of arguments to string-split")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply string-split args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-164>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to symbol")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply make-symbol args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-165>
  (lambda ()
    (if (not (length-one? args_reg))
        (begin
          (set! msg_reg "incorrect number of arguments to typeof")
          (set! pc runtime-error))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (apply type args_reg))
          (set! k_reg k2_reg)
          (set! pc apply-cont2)))))

(define <proc-166>
  (lambda ()
    (set! value2_reg fail_reg)
    (set! value1_reg (apply use-lexical-address args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define <proc-167>
  (lambda (external-function-object)
    (set! value2_reg fail_reg)
    (set! value1_reg (apply* external-function-object args_reg))
    (set! k_reg k2_reg)
    (set! pc apply-cont2)))

(define make-macro
  (lambda args (return* (cons 'macro-transformer args))))

(define*
  apply-macro
  (lambda () (apply! (cadr macro_reg) (cddr macro_reg))))

(define <macro-1>
  (lambda ()
    (if (symbol?^ (cadr^ datum_reg))
        (let ((name 'undefined)
              (bindings 'undefined)
              (vars 'undefined)
              (exps 'undefined)
              (bodies 'undefined))
          (set! name (cadr^ datum_reg))
          (set! bindings (caddr^ datum_reg))
          (set! vars (map^ car^ bindings))
          (set! exps (map^ cadr^ bindings))
          (set! bodies (cdddr^ datum_reg))
          (set! value_reg
            (append
              (list 'letrec)
              (append
                (list
                  (list
                    (append
                      (list name)
                      (list
                        (append
                          (list 'lambda)
                          (append (list vars) (at^ bodies)))))))
                (list (append (list name) (at^ exps))))))
          (set! pc apply-cont))
        (let ((bindings 'undefined)
              (vars 'undefined)
              (exps 'undefined)
              (bodies 'undefined))
          (set! bindings (cadr^ datum_reg))
          (set! vars (map^ car^ bindings))
          (set! exps (map^ cadr^ bindings))
          (set! bodies (cddr^ datum_reg))
          (set! value_reg
            (append
              (list
                (append (list 'lambda) (append (list vars) (at^ bodies))))
              (at^ exps)))
          (set! pc apply-cont)))))

(define <macro-2>
  (lambda ()
    (let ((decls 'undefined)
          (vars 'undefined)
          (procs 'undefined)
          (bodies 'undefined))
      (set! decls (cadr^ datum_reg))
      (set! vars (map^ car^ decls))
      (set! procs (map^ cadr^ decls))
      (set! bodies (cddr^ datum_reg))
      (set! k2_reg (make-cont2 <cont2-36> bodies k_reg))
      (set! procs_reg procs)
      (set! vars_reg vars)
      (set! pc create-letrec-assignments^))))

(define <macro-3>
  (lambda ()
    (let ((name 'undefined)
          (formals 'undefined)
          (bodies 'undefined))
      (set! bodies (cddr^ datum_reg))
      (set! formals (cdadr^ datum_reg))
      (set! name (caadr^ datum_reg))
      (set! value_reg
        (append
          (list 'define)
          (append
            (list name)
            (list
              (append
                (list 'lambda)
                (append (list formals) (at^ bodies)))))))
      (set! pc apply-cont))))

(define <macro-4>
  (lambda ()
    (let ((exps 'undefined))
      (set! exps (cdr^ datum_reg))
      (if (null?^ exps)
          (begin (set! value_reg #t) (set! pc apply-cont))
          (if (null?^ (cdr^ exps))
              (begin (set! value_reg (car^ exps)) (set! pc apply-cont))
              (begin
                (set! value_reg
                  (append
                    (list 'if)
                    (append
                      (list (car^ exps))
                      (append
                        (list (append (list 'and) (at^ (cdr^ exps))))
                        (list #f)))))
                (set! pc apply-cont)))))))

(define <macro-5>
  (lambda ()
    (let ((exps 'undefined))
      (set! exps (cdr^ datum_reg))
      (if (null?^ exps)
          (begin (set! value_reg #f) (set! pc apply-cont))
          (if (null?^ (cdr^ exps))
              (begin (set! value_reg (car^ exps)) (set! pc apply-cont))
              (begin
                (set! value_reg
                  (append
                    (list 'let)
                    (append
                      (list
                        (append
                          (list (append (list 'bool) (list (car^ exps))))
                          (list
                            (append
                              (list 'else-code)
                              (list
                                (append
                                  (list 'lambda)
                                  (append
                                    (list '())
                                    (list (append (list 'or) (at^ (cdr^ exps)))))))))))
                      (list
                        (append
                          (list 'if)
                          (append
                            (list 'bool)
                            (append (list 'bool) (list (list 'else-code)))))))))
                (set! pc apply-cont)))))))

(define <macro-6>
  (lambda ()
    (let ((clauses 'undefined))
      (set! clauses (cdr^ datum_reg))
      (if (null?^ clauses)
          (begin
            (set! adatum_reg datum_reg)
            (set! msg_reg "empty (cond) expression")
            (set! pc amacro-error))
          (let ((first-clause 'undefined) (other-clauses 'undefined))
            (set! other-clauses (cdr^ clauses))
            (set! first-clause (car^ clauses))
            (if (or (null?^ first-clause) (not (list?^ first-clause)))
                (begin
                  (set! adatum_reg first-clause)
                  (set! msg_reg "improper cond clause")
                  (set! pc amacro-error))
                (let ((test-exp 'undefined) (then-exps 'undefined))
                  (set! then-exps (cdr^ first-clause))
                  (set! test-exp (car^ first-clause))
                  (if (eq?^ test-exp 'else)
                      (if (null?^ then-exps)
                          (begin
                            (set! adatum_reg first-clause)
                            (set! msg_reg "improper else clause")
                            (set! pc amacro-error))
                          (if (null?^ (cdr^ then-exps))
                              (begin
                                (set! value_reg (car^ then-exps))
                                (set! pc apply-cont))
                              (begin
                                (set! value_reg (append (list 'begin) (at^ then-exps)))
                                (set! pc apply-cont))))
                      (if (null?^ then-exps)
                          (if (null?^ other-clauses)
                              (begin
                                (set! value_reg
                                  (append
                                    (list 'let)
                                    (append
                                      (list (list (append (list 'bool) (list test-exp))))
                                      (list
                                        (append (list 'if) (append (list 'bool) (list 'bool)))))))
                                (set! pc apply-cont))
                              (begin
                                (set! value_reg
                                  (append
                                    (list 'let)
                                    (append
                                      (list
                                        (append
                                          (list (append (list 'bool) (list test-exp)))
                                          (list
                                            (append
                                              (list 'else-code)
                                              (list
                                                (append
                                                  (list 'lambda)
                                                  (append
                                                    (list '())
                                                    (list (append (list 'cond) (at^ other-clauses))))))))))
                                      (list
                                        (append
                                          (list 'if)
                                          (append
                                            (list 'bool)
                                            (append (list 'bool) (list (list 'else-code)))))))))
                                (set! pc apply-cont)))
                          (if (eq?^ (car^ then-exps) '=>)
                              (if (null?^ (cdr^ then-exps))
                                  (begin
                                    (set! adatum_reg first-clause)
                                    (set! msg_reg "improper => clause")
                                    (set! pc amacro-error))
                                  (if (null?^ other-clauses)
                                      (begin
                                        (set! value_reg
                                          (append
                                            (list 'let)
                                            (append
                                              (list
                                                (append
                                                  (list (append (list 'bool) (list test-exp)))
                                                  (list
                                                    (append
                                                      (list 'th)
                                                      (list
                                                        (append
                                                          (list 'lambda)
                                                          (append (list '()) (list (cadr^ then-exps)))))))))
                                              (list
                                                (append
                                                  (list 'if)
                                                  (append
                                                    (list 'bool)
                                                    (list (append (list (list 'th)) (list 'bool)))))))))
                                        (set! pc apply-cont))
                                      (begin
                                        (set! value_reg
                                          (append
                                            (list 'let)
                                            (append
                                              (list
                                                (append
                                                  (list (append (list 'bool) (list test-exp)))
                                                  (append
                                                    (list
                                                      (append
                                                        (list 'th)
                                                        (list
                                                          (append
                                                            (list 'lambda)
                                                            (append (list '()) (list (cadr^ then-exps)))))))
                                                    (list
                                                      (append
                                                        (list 'else-code)
                                                        (list
                                                          (append
                                                            (list 'lambda)
                                                            (append
                                                              (list '())
                                                              (list (append (list 'cond) (at^ other-clauses)))))))))))
                                              (list
                                                (append
                                                  (list 'if)
                                                  (append
                                                    (list 'bool)
                                                    (append
                                                      (list (append (list (list 'th)) (list 'bool)))
                                                      (list (list 'else-code)))))))))
                                        (set! pc apply-cont))))
                              (if (null?^ other-clauses)
                                  (if (null?^ (cdr^ then-exps))
                                      (begin
                                        (set! value_reg
                                          (append
                                            (list 'if)
                                            (append (list test-exp) (list (car^ then-exps)))))
                                        (set! pc apply-cont))
                                      (begin
                                        (set! value_reg
                                          (append
                                            (list 'if)
                                            (append
                                              (list test-exp)
                                              (list (append (list 'begin) (at^ then-exps))))))
                                        (set! pc apply-cont)))
                                  (if (null?^ (cdr^ then-exps))
                                      (begin
                                        (set! value_reg
                                          (append
                                            (list 'if)
                                            (append
                                              (list test-exp)
                                              (append
                                                (list (car^ then-exps))
                                                (list (append (list 'cond) (at^ other-clauses)))))))
                                        (set! pc apply-cont))
                                      (begin
                                        (set! value_reg
                                          (append
                                            (list 'if)
                                            (append
                                              (list test-exp)
                                              (append
                                                (list (append (list 'begin) (at^ then-exps)))
                                                (list (append (list 'cond) (at^ other-clauses)))))))
                                        (set! pc apply-cont))))))))))))))

(define <macro-7>
  (lambda ()
    (let ((bindings 'undefined) (bodies 'undefined))
      (set! bodies (cddr^ datum_reg))
      (set! bindings (cadr^ datum_reg))
      (set! bodies_reg bodies)
      (set! bindings_reg bindings)
      (set! pc nest-let*-bindings^))))

(define <macro-8>
  (lambda ()
    (let ((exp 'undefined) (clauses 'undefined))
      (set! clauses (cddr^ datum_reg))
      (set! exp (cadr^ datum_reg))
      (set! k2_reg (make-cont2 <cont2-38> exp k_reg))
      (set! clauses_reg clauses)
      (set! var_reg 'r)
      (set! pc case-clauses->cond-clauses^))))

(define <macro-9>
  (lambda ()
    (let ((exp 'undefined) (clauses 'undefined))
      (set! clauses (cddr^ datum_reg))
      (set! exp (cadr^ datum_reg))
      (set! k2_reg (make-cont2 <cont2-38> exp k_reg))
      (set! clauses_reg clauses)
      (set! var_reg 'r)
      (set! pc record-case-clauses->cond-clauses^))))

(define <macro-10>
  (lambda ()
    (let ((datatype-name 'undefined)
          (type-tester-name 'undefined))
      (set! datatype-name (cadr^ datum_reg))
      (set! type-tester-name
        (string->symbol
          (string-append (symbol->string^ datatype-name) "?")))
      (if (not (eq?^ (caddr^ datum_reg) type-tester-name))
          (begin
            (set! adatum_reg (caddr^ datum_reg))
            (set! msg_reg
              (format
                "datatype tester predicate not named ~a"
                type-tester-name))
            (set! pc amacro-error))
          (let ((variants 'undefined))
            (set! variants (cdddr^ datum_reg))
            (set! k2_reg (make-cont2 <cont2-41> type-tester-name k_reg))
            (set! variants_reg variants)
            (set! pc make-dd-variant-constructors^))))))

(define <macro-11>
  (lambda ()
    (let ((type-name 'undefined)
          (type-tester-name 'undefined)
          (exp 'undefined)
          (clauses 'undefined))
      (set! type-name (cadr^ datum_reg))
      (set! type-tester-name
        (string->symbol
          (string-append (symbol->string^ type-name) "?")))
      (set! exp (caddr^ datum_reg))
      (set! clauses (cdddr^ datum_reg))
      (set! k2_reg
        (make-cont2 <cont2-44> exp type-name type-tester-name
          k_reg))
      (set! clauses_reg clauses)
      (set! var_reg 'r)
      (set! pc record-case-clauses->cond-clauses^))))

(define next-avail
  (lambda (n) (return* (string-ref chars-to-scan n))))

(define remaining (lambda (n) (return* (+ 1 n))))

(define initialize-scan-counters
  (lambda ()
    (set! scan-line 1)
    (set! scan-char 1)
    (set! scan-position 1)
    (set! last-scan-line scan-line)
    (set! last-scan-char scan-char)
    (set! last-scan-position scan-position)))

(define increment-scan-counters
  (lambda (chars)
    (set! last-scan-line scan-line)
    (set! last-scan-char scan-char)
    (set! last-scan-position scan-position)
    (if (char=? (next-avail chars) #\newline)
        (begin (set! scan-line (+ 1 scan-line)) (set! scan-char 1))
        (set! scan-char (+ 1 scan-char)))
    (set! scan-position (+ 1 scan-position))))

(define mark-token-start
  (lambda ()
    (set! token-start-line scan-line)
    (set! token-start-char scan-char)
    (set! token-start-position scan-position)))

(define*
  scan-input
  (lambda ()
    (initialize-scan-counters)
    (set! chars-to-scan
      (string-append input_reg (string #\nul)))
    (set! chars_reg 0)
    (set! pc scan-input-loop)))

(define*
  scan-input-loop
  (lambda ()
    (set! k_reg
      (make-cont3 <cont3-1> src_reg handler_reg k_reg))
    (set! buffer_reg '())
    (set! action_reg (list 'goto 'start-state))
    (set! pc apply-action)))

(define*
  apply-action
  (lambda ()
    (if (eq? (car action_reg) 'shift)
        (let ((next 'undefined))
          (set! next (list-ref action_reg 1))
          (increment-scan-counters chars_reg)
          (set! buffer_reg (cons (next-avail chars_reg) buffer_reg))
          (set! chars_reg (remaining chars_reg))
          (set! action_reg next)
          (set! pc apply-action))
        (if (eq? (car action_reg) 'replace)
            (let ((new-char 'undefined) (next 'undefined))
              (set! next (list-ref action_reg 2))
              (set! new-char (list-ref action_reg 1))
              (increment-scan-counters chars_reg)
              (set! chars_reg (remaining chars_reg))
              (set! buffer_reg (cons new-char buffer_reg))
              (set! action_reg next)
              (set! pc apply-action))
            (if (eq? (car action_reg) 'drop)
                (let ((next 'undefined))
                  (set! next (list-ref action_reg 1))
                  (increment-scan-counters chars_reg)
                  (set! chars_reg (remaining chars_reg))
                  (set! action_reg next)
                  (set! pc apply-action))
                (if (eq? (car action_reg) 'goto)
                    (let ((state 'undefined))
                      (set! state (list-ref action_reg 1))
                      (if (eq? state 'token-start-state) (mark-token-start))
                      (let ((action 'undefined))
                        (set! action (apply-state state (next-avail chars_reg)))
                        (if (eq? action 'error)
                            (set! pc unexpected-char-error)
                            (begin (set! action_reg action) (set! pc apply-action)))))
                    (if (eq? (car action_reg) 'emit)
                        (let ((token-type 'undefined))
                          (set! token-type (list-ref action_reg 1))
                          (set! k_reg (make-cont <cont-1> chars_reg fail_reg k_reg))
                          (set! token-type_reg token-type)
                          (set! pc convert-buffer-to-token))
                        (error 'apply-action "invalid action: ~a" action_reg))))))))

(define*
  scan-error
  (lambda ()
    (set! exception_reg
      (make-exception "ScanError" msg_reg src_reg line_reg
        char_reg))
    (set! pc apply-handler2)))

(define*
  unexpected-char-error
  (lambda ()
    (let ((c 'undefined))
      (set! c (next-avail chars_reg))
      (if (char=? c #\nul)
          (begin
            (set! char_reg scan-char)
            (set! line_reg scan-line)
            (set! msg_reg "unexpected end of input")
            (set! pc scan-error))
          (begin
            (set! char_reg scan-char)
            (set! line_reg scan-line)
            (set! msg_reg
              (format "unexpected character '~a' encountered" c))
            (set! pc scan-error))))))

(define*
  convert-buffer-to-token
  (lambda ()
    (let ((buffer 'undefined))
      (set! buffer (reverse buffer_reg))
      (if (eq? token-type_reg 'end-marker)
          (begin
            (set! value_reg (make-token1 'end-marker))
            (set! pc apply-cont))
          (if (eq? token-type_reg 'integer)
              (begin
                (set! value_reg
                  (make-token2 'integer (list->string buffer)))
                (set! pc apply-cont))
              (if (eq? token-type_reg 'decimal)
                  (begin
                    (set! value_reg
                      (make-token2 'decimal (list->string buffer)))
                    (set! pc apply-cont))
                  (if (eq? token-type_reg 'rational)
                      (begin
                        (set! value_reg
                          (make-token2 'rational (list->string buffer)))
                        (set! pc apply-cont))
                      (if (eq? token-type_reg 'identifier)
                          (begin
                            (set! value_reg
                              (make-token2
                                'identifier
                                (string->symbol (list->string buffer))))
                            (set! pc apply-cont))
                          (if (eq? token-type_reg 'boolean)
                              (begin
                                (set! value_reg
                                  (make-token2
                                    'boolean
                                    (or (char=? (car buffer) #\t) (char=? (car buffer) #\T))))
                                (set! pc apply-cont))
                              (if (eq? token-type_reg 'character)
                                  (begin
                                    (set! value_reg (make-token2 'character (car buffer)))
                                    (set! pc apply-cont))
                                  (if (eq? token-type_reg 'named-character)
                                      (let ((name 'undefined))
                                        (set! name (list->string buffer))
                                        (if (string=? name "nul")
                                            (begin
                                              (set! value_reg (make-token2 'character #\nul))
                                              (set! pc apply-cont))
                                            (if (string=? name "space")
                                                (begin
                                                  (set! value_reg (make-token2 'character #\space))
                                                  (set! pc apply-cont))
                                                (if (string=? name "tab")
                                                    (begin
                                                      (set! value_reg (make-token2 'character #\tab))
                                                      (set! pc apply-cont))
                                                    (if (string=? name "newline")
                                                        (begin
                                                          (set! value_reg (make-token2 'character #\newline))
                                                          (set! pc apply-cont))
                                                        (if (string=? name "linefeed")
                                                            (begin
                                                              (set! value_reg (make-token2 'character #\newline))
                                                              (set! pc apply-cont))
                                                            (if (string=? name "backspace")
                                                                (begin
                                                                  (set! value_reg (make-token2 'character #\backspace))
                                                                  (set! pc apply-cont))
                                                                (if (string=? name "return")
                                                                    (begin
                                                                      (set! value_reg (make-token2 'character #\return))
                                                                      (set! pc apply-cont))
                                                                    (if (string=? name "page")
                                                                        (begin
                                                                          (set! value_reg (make-token2 'character #\page))
                                                                          (set! pc apply-cont))
                                                                        (begin
                                                                          (set! char_reg token-start-char)
                                                                          (set! line_reg token-start-line)
                                                                          (set! msg_reg (format "invalid character name #\\~a" name))
                                                                          (set! pc scan-error)))))))))))
                                      (if (eq? token-type_reg 'string)
                                          (begin
                                            (set! value_reg (make-token2 'string (list->string buffer)))
                                            (set! pc apply-cont))
                                          (begin
                                            (set! value_reg (make-token1 token-type_reg))
                                            (set! pc apply-cont))))))))))))))

(define make-token1
  (lambda (token-type)
    (let ((start 'undefined) (end 'undefined))
      (set! end
        (list last-scan-line last-scan-char last-scan-position))
      (set! start
        (list
          token-start-line
          token-start-char
          token-start-position))
      (if (eq? token-type 'end-marker)
          (return* (list token-type end end))
          (return* (list token-type start end))))))

(define make-token2
  (lambda (token-type token-info)
    (return*
      (list
        token-type
        token-info
        (list
          token-start-line
          token-start-char
          token-start-position)
        (list last-scan-line last-scan-char last-scan-position)))))

(define token-type?
  (lambda (token class) (return* (eq? (car token) class))))

(define get-token-start
  (lambda (token) (return* (rac (rdc token)))))

(define get-token-end
  (lambda (token) (return* (rac token))))

(define get-token-start-line
  (lambda (token) (return* (car (get-token-start token)))))

(define get-token-start-char
  (lambda (token) (return* (cadr (get-token-start token)))))

(define get-token-start-pos
  (lambda (token) (return* (caddr (get-token-start token)))))

(define rac
  (lambda (ls)
    (if (null? (cdr ls))
        (return* (car ls))
        (let ((current 'undefined))
          (set! current (cdr ls))
          (while (pair? (cdr current)) (set! current (cdr current)))
          (return* (car current))))))

(define rdc
  (lambda (ls)
    (if (null? (cdr ls))
        (return* (list))
        (let ((retval 'undefined)
              (front 'undefined)
              (current 'undefined))
          (set! retval (list (car ls)))
          (set! front retval)
          (set! current (cdr ls))
          (while
            (pair? (cdr current))
            (set-cdr! retval (list (car current)))
            (set! retval (cdr retval))
            (set! current (cdr current)))
          (return* front)))))

(define snoc
  (lambda (x ls)
    (if (null? ls)
        (return* (list x))
        (let ((retval 'undefined)
              (front 'undefined)
              (current 'undefined))
          (set! retval (list (car ls)))
          (set! front retval)
          (set! current (cdr ls))
          (while
            (pair? current)
            (set-cdr! retval (list (car current)))
            (set! retval (cdr retval))
            (set! current (cdr current)))
          (set-cdr! retval (list x))
          (return* front)))))

(define char-delimiter?
  (lambda (c)
    (return*
      (or (char-whitespace? c)
          (char=? c #\')
          (char=? c #\()
          (char=? c #\[)
          (char=? c #\))
          (char=? c #\])
          (char=? c #\")
          (char=? c #\;)
          (char=? c #\#)
          (char=? c #\nul)))))

(define char-initial?
  (lambda (c)
    (return*
      (or (char-alphabetic? c)
          (char=? c #\!)
          (char=? c #\$)
          (char=? c #\%)
          (char=? c #\&)
          (char=? c #\*)
          (char=? c #\/)
          (char=? c #\:)
          (char=? c #\<)
          (char=? c #\=)
          (char=? c #\>)
          (char=? c #\?)
          (char=? c #\^)
          (char=? c #\_)
          (char=? c #\~)))))

(define char-special-subsequent?
  (lambda (c)
    (return*
      (or (char=? c #\+)
          (char=? c #\-)
          (char=? c #\@)
          (char=? c #\.)))))

(define char-subsequent?
  (lambda (c)
    (return*
      (or (char-initial? c)
          (char-numeric? c)
          (char-special-subsequent? c)))))

(define char-sign?
  (lambda (c) (return* (or (char=? c #\+) (char=? c #\-)))))

(define char-boolean?
  (lambda (c)
    (return*
      (or (char=? c #\t)
          (char=? c #\T)
          (char=? c #\f)
          (char=? c #\F)))))

(define apply-state
  (lambda (state c)
    (if (eq? state 'start-state)
        (if (char-whitespace? c)
            (return* (list 'drop (list 'goto 'start-state)))
            (if (char=? c #\;)
                (return* (list 'drop (list 'goto 'comment-state)))
                (if (char=? c #\nul)
                    (return* (list 'drop (list 'emit 'end-marker)))
                    (return* (list 'goto 'token-start-state)))))
        (if (eq? state 'token-start-state)
            (if (char=? c #\()
                (return* (list 'drop (list 'emit 'lparen)))
                (if (char=? c #\[)
                    (return* (list 'drop (list 'emit 'lbracket)))
                    (if (char=? c #\))
                        (return* (list 'drop (list 'emit 'rparen)))
                        (if (char=? c #\])
                            (return* (list 'drop (list 'emit 'rbracket)))
                            (if (char=? c #\')
                                (return* (list 'drop (list 'emit 'apostrophe)))
                                (if (char=? c #\`)
                                    (return* (list 'drop (list 'emit 'backquote)))
                                    (if (char=? c #\,)
                                        (return* (list 'drop (list 'goto 'comma-state)))
                                        (if (char=? c #\#)
                                            (return* (list 'drop (list 'goto 'hash-prefix-state)))
                                            (if (char=? c #\")
                                                (return* (list 'drop (list 'goto 'string-state)))
                                                (if (char-initial? c)
                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                    (if (char-sign? c)
                                                        (return* (list 'shift (list 'goto 'signed-state)))
                                                        (if (char=? c #\.)
                                                            (return* (list 'shift (list 'goto 'decimal-point-state)))
                                                            (if (char-numeric? c)
                                                                (return* (list 'shift (list 'goto 'whole-number-state)))
                                                                (return* 'error))))))))))))))
            (if (eq? state 'comment-state)
                (if (char=? c #\newline)
                    (return* (list 'drop (list 'goto 'start-state)))
                    (if (char=? c #\nul)
                        (return* (list 'drop (list 'emit 'end-marker)))
                        (return* (list 'drop (list 'goto 'comment-state)))))
                (if (eq? state 'comma-state)
                    (if (char=? c #\@)
                        (return* (list 'drop (list 'emit 'comma-at)))
                        (return* (list 'emit 'comma)))
                    (if (eq? state 'hash-prefix-state)
                        (if (char-boolean? c)
                            (return* (list 'shift (list 'emit 'boolean)))
                            (if (char=? c #\\)
                                (return* (list 'drop (list 'goto 'character-state)))
                                (if (char=? c #\()
                                    (return* (list 'drop (list 'emit 'lvector)))
                                    (return* 'error))))
                        (if (eq? state 'character-state)
                            (if (char-alphabetic? c)
                                (return*
                                  (list 'shift (list 'goto 'alphabetic-character-state)))
                                (if (not (char=? c #\nul))
                                    (return* (list 'shift (list 'emit 'character)))
                                    (return* 'error)))
                            (if (eq? state 'alphabetic-character-state)
                                (if (char-alphabetic? c)
                                    (return* (list 'shift (list 'goto 'named-character-state)))
                                    (return* (list 'emit 'character)))
                                (if (eq? state 'named-character-state)
                                    (if (char-delimiter? c)
                                        (return* (list 'emit 'named-character))
                                        (return* (list 'shift (list 'goto 'named-character-state))))
                                    (if (eq? state 'string-state)
                                        (if (char=? c #\")
                                            (return* (list 'drop (list 'emit 'string)))
                                            (if (char=? c #\\)
                                                (return* (list 'drop (list 'goto 'string-escape-state)))
                                                (if (not (char=? c #\nul))
                                                    (return* (list 'shift (list 'goto 'string-state)))
                                                    (return* 'error))))
                                        (if (eq? state 'string-escape-state)
                                            (if (char=? c #\")
                                                (return* (list 'shift (list 'goto 'string-state)))
                                                (if (char=? c #\\)
                                                    (return* (list 'shift (list 'goto 'string-state)))
                                                    (if (char=? c #\b)
                                                        (return*
                                                          (list 'replace #\backspace (list 'goto 'string-state)))
                                                        (if (char=? c #\f)
                                                            (return* (list 'replace #\page (list 'goto 'string-state)))
                                                            (if (char=? c #\n)
                                                                (return*
                                                                  (list 'replace #\newline (list 'goto 'string-state)))
                                                                (if (char=? c #\t)
                                                                    (return* (list 'replace #\tab (list 'goto 'string-state)))
                                                                    (if (char=? c #\r)
                                                                        (return*
                                                                          (list 'replace #\return (list 'goto 'string-state)))
                                                                        (return* 'error))))))))
                                            (if (eq? state 'identifier-state)
                                                (if (char-subsequent? c)
                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                    (if (char-delimiter? c)
                                                        (return* (list 'emit 'identifier))
                                                        (return* 'error)))
                                                (if (eq? state 'signed-state)
                                                    (if (char-numeric? c)
                                                        (return* (list 'shift (list 'goto 'whole-number-state)))
                                                        (if (char=? c #\.)
                                                            (return*
                                                              (list 'shift (list 'goto 'signed-decimal-point-state)))
                                                            (if (char-delimiter? c)
                                                                (return* (list 'emit 'identifier))
                                                                (if (char-subsequent? c)
                                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                                    (return* 'error)))))
                                                    (if (eq? state 'decimal-point-state)
                                                        (if (char-numeric? c)
                                                            (return*
                                                              (list 'shift (list 'goto 'fractional-number-state)))
                                                            (if (char-delimiter? c)
                                                                (return* (list 'emit 'dot))
                                                                (if (char-subsequent? c)
                                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                                    (return* 'error))))
                                                        (if (eq? state 'signed-decimal-point-state)
                                                            (if (char-numeric? c)
                                                                (return*
                                                                  (list 'shift (list 'goto 'fractional-number-state)))
                                                                (if (char-delimiter? c)
                                                                    (return* (list 'emit 'identifier))
                                                                    (if (char-subsequent? c)
                                                                        (return* (list 'shift (list 'goto 'identifier-state)))
                                                                        (return* 'error))))
                                                            (if (eq? state 'whole-number-state)
                                                                (if (char-numeric? c)
                                                                    (return* (list 'shift (list 'goto 'whole-number-state)))
                                                                    (if (char=? c #\.)
                                                                        (return*
                                                                          (list 'shift (list 'goto 'fractional-number-state)))
                                                                        (if (char=? c #\/)
                                                                            (return* (list 'shift (list 'goto 'rational-number-state)))
                                                                            (if (or (char=? c #\e) (char=? c #\E))
                                                                                (return* (list 'shift (list 'goto 'suffix-state)))
                                                                                (if (char-delimiter? c)
                                                                                    (return* (list 'emit 'integer))
                                                                                    (if (char-subsequent? c)
                                                                                        (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                        (return* 'error)))))))
                                                                (if (eq? state 'fractional-number-state)
                                                                    (if (char-numeric? c)
                                                                        (return*
                                                                          (list 'shift (list 'goto 'fractional-number-state)))
                                                                        (if (or (char=? c #\e) (char=? c #\E))
                                                                            (return* (list 'shift (list 'goto 'suffix-state)))
                                                                            (if (char-delimiter? c)
                                                                                (return* (list 'emit 'decimal))
                                                                                (if (char-subsequent? c)
                                                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                    (return* 'error)))))
                                                                    (if (eq? state 'rational-number-state)
                                                                        (if (char-numeric? c)
                                                                            (return* (list 'shift (list 'goto 'rational-number-state*)))
                                                                            (if (char-delimiter? c)
                                                                                (return* (list 'emit 'identifier))
                                                                                (if (char-subsequent? c)
                                                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                    (return* 'error))))
                                                                        (if (eq? state 'rational-number-state*)
                                                                            (if (char-numeric? c)
                                                                                (return* (list 'shift (list 'goto 'rational-number-state*)))
                                                                                (if (char-delimiter? c)
                                                                                    (return* (list 'emit 'rational))
                                                                                    (if (char-subsequent? c)
                                                                                        (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                        (return* 'error))))
                                                                            (if (eq? state 'suffix-state)
                                                                                (if (char-sign? c)
                                                                                    (return* (list 'shift (list 'goto 'signed-exponent-state)))
                                                                                    (if (char-numeric? c)
                                                                                        (return* (list 'shift (list 'goto 'exponent-state)))
                                                                                        (if (char-delimiter? c)
                                                                                            (return* (list 'emit 'identifier))
                                                                                            (if (char-subsequent? c)
                                                                                                (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                                (return* 'error)))))
                                                                                (if (eq? state 'signed-exponent-state)
                                                                                    (if (char-numeric? c)
                                                                                        (return* (list 'shift (list 'goto 'exponent-state)))
                                                                                        (if (char-delimiter? c)
                                                                                            (return* (list 'emit 'identifier))
                                                                                            (if (char-subsequent? c)
                                                                                                (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                                (return* 'error))))
                                                                                    (if (eq? state 'exponent-state)
                                                                                        (if (char-numeric? c)
                                                                                            (return* (list 'shift (list 'goto 'exponent-state)))
                                                                                            (if (char-delimiter? c)
                                                                                                (return* (list 'emit 'decimal))
                                                                                                (if (char-subsequent? c)
                                                                                                    (return* (list 'shift (list 'goto 'identifier-state)))
                                                                                                    (return* 'error))))
                                                                                        (error 'apply-state
                                                                                          "invalid state: ~a"
                                                                                          state))))))))))))))))))))))))

(define aatom?
  (lambda (x)
    (return* (and (pair? x) (eq? (car x) atom-tag)))))

(define apair?
  (lambda (x)
    (return* (and (pair? x) (eq? (car x) pair-tag)))))

(define annotated?
  (lambda (x)
    (return*
      (and (pair? x)
           (or (eq? (car x) atom-tag) (eq? (car x) pair-tag))))))

(define untag-atom^ (lambda (aatom) (return* (cadr aatom))))

(define atom?^
  (lambda (asexp) (return* (eq? (car asexp) atom-tag))))

(define pair?^
  (lambda (asexp) (return* (eq? (car asexp) pair-tag))))

(define null?^
  (lambda (asexp)
    (return* (and (atom?^ asexp) (null? (untag-atom^ asexp))))))

(define symbol?^
  (lambda (asexp)
    (return*
      (and (atom?^ asexp) (symbol? (untag-atom^ asexp))))))

(define string?^
  (lambda (asexp)
    (return*
      (and (atom?^ asexp) (string? (untag-atom^ asexp))))))

(define vector?^
  (lambda (asexp)
    (return*
      (and (atom?^ asexp) (vector? (untag-atom^ asexp))))))

(define car^ (lambda (asexp) (return* (cadr asexp))))

(define cdr^ (lambda (asexp) (return* (caddr asexp))))

(define cadr^
  (lambda (asexp) (return* (car^ (cdr^ asexp)))))

(define cdar^
  (lambda (asexp) (return* (cdr^ (car^ asexp)))))

(define caar^
  (lambda (asexp) (return* (car^ (car^ asexp)))))

(define cddr^
  (lambda (asexp) (return* (cdr^ (cdr^ asexp)))))

(define cdddr^
  (lambda (asexp) (return* (cdr^ (cdr^ (cdr^ asexp))))))

(define caddr^
  (lambda (asexp) (return* (car^ (cdr^ (cdr^ asexp))))))

(define cdadr^
  (lambda (asexp) (return* (cdr^ (car^ (cdr^ asexp))))))

(define cadar^
  (lambda (asexp) (return* (car^ (cdr^ (car^ asexp))))))

(define caadr^
  (lambda (asexp) (return* (car^ (car^ (cdr^ asexp))))))

(define cadddr^
  (lambda (asexp)
    (return* (car^ (cdr^ (cdr^ (cdr^ asexp)))))))

(define eq?^
  (lambda (asexp sym) (return* (eq? (cadr asexp) sym))))

(define vector->list^
  (lambda (asexp) (return* (vector->list (cadr asexp)))))

(define symbol->string^
  (lambda (asexp) (return* (symbol->string (cadr asexp)))))

(define list?^
  (lambda (asexp)
    (return*
      (or (null?^ asexp)
          (and (pair?^ asexp) (list?^ (caddr asexp)))))))

(define at^
  (lambda (alist)
    (if (null?^ alist)
        (return* '())
        (return* (cons (car^ alist) (at^ (cdr^ alist)))))))

(define length^
  (lambda (asexp)
    (if (null?^ asexp)
        (return* 0)
        (return* (+ 1 (length^ (cdr^ asexp)))))))

(define cons^
  (lambda (a b info) (return* (list pair-tag a b info))))

(define map^
  (lambda (f^ asexp)
    (if (null?^ asexp)
        (return* (list atom-tag '() 'none))
        (return*
          (cons^ (f^ (car^ asexp)) (map^ f^ (cdr^ asexp)) 'none)))))

(define*
  annotate-cps
  (lambda ()
    (if (not *reader-generates-annotated-sexps?*)
        (begin (set! value_reg x_reg) (set! pc apply-cont))
        (if (annotated? x_reg)
            (begin (set! value_reg x_reg) (set! pc apply-cont))
            (if (pair? x_reg)
                (begin
                  (set! k_reg (make-cont <cont-3> x_reg info_reg k_reg))
                  (set! info_reg 'none)
                  (set! x_reg (car x_reg))
                  (set! pc annotate-cps))
                (begin
                  (set! value_reg (list atom-tag x_reg info_reg))
                  (set! pc apply-cont)))))))

(define*
  unannotate-cps
  (lambda ()
    (if (aatom? x_reg)
        (begin (set! x_reg (cadr x_reg)) (set! pc unannotate-cps))
        (if (apair? x_reg)
            (begin
              (set! k_reg (make-cont <cont-7> x_reg k_reg))
              (set! x_reg (cadr x_reg))
              (set! pc unannotate-cps))
            (if (pair? x_reg)
                (begin
                  (set! k_reg (make-cont <cont-6> x_reg k_reg))
                  (set! x_reg (car x_reg))
                  (set! pc unannotate-cps))
                (if (vector? x_reg)
                    (begin
                      (set! k_reg (make-cont <cont-4> k_reg))
                      (set! x_reg (vector->list x_reg))
                      (set! pc unannotate-cps))
                    (begin (set! value_reg x_reg) (set! pc apply-cont))))))))

(define make-info
  (lambda (src start end)
    (return* (cons src (append start end)))))

(define replace-info
  (lambda (asexp new-info)
    (if (atom?^ asexp)
        (return* (list atom-tag (cadr asexp) new-info))
        (return*
          (list pair-tag (cadr asexp) (caddr asexp) new-info)))))

(define get-srcfile (lambda (info) (return* (car info))))

(define get-start-line
  (lambda (info) (return* (cadr info))))

(define get-start-char
  (lambda (info) (return* (caddr info))))

(define get-start-pos
  (lambda (info) (return* (cadddr info))))

(define get-end-line
  (lambda (info) (return* (car (cddddr info)))))

(define get-end-char
  (lambda (info) (return* (cadr (cddddr info)))))

(define get-end-pos
  (lambda (info) (return* (caddr (cddddr info)))))

(define get-source-info
  (lambda (asexp) (return* (rac asexp))))

(define source-info?
  (lambda (x) (return* (or (eq? x 'none) (list? x)))))

(define has-source-info?
  (lambda (asexp)
    (return* (not (eq? (get-source-info asexp) 'none)))))

(define original-source-info?
  (lambda (asexp)
    (return*
      (and (has-source-info? asexp)
           (= (length (get-source-info asexp)) 7)))))

(define macro-derived-source-info?
  (lambda (asexp)
    (return*
      (and (has-source-info? asexp)
           (= (length (get-source-info asexp)) 8)))))

(define first (lambda (x) (return* (car x))))

(define rest-of (lambda (x) (return* (cdr x))))

(define string->integer
  (lambda (str) (return* (string->number str))))

(define string->decimal
  (lambda (str) (return* (string->number str))))

(define string->rational
  (lambda (str) (return* (string->number str))))

(define true? (lambda (v) (if v (return* #t) (return* #f))))

(define*
  unexpected-token-error
  (lambda ()
    (let ((token 'undefined))
      (set! token (first tokens_reg))
      (if (token-type? token 'end-marker)
          (begin
            (set! msg_reg "unexpected end of input")
            (set! pc read-error))
          (begin
            (set! msg_reg
              (format "unexpected '~a' encountered" (car token)))
            (set! pc read-error))))))

(define*
  read-error
  (lambda ()
    (let ((token 'undefined))
      (set! token (first tokens_reg))
      (set! exception_reg
        (make-exception "ReadError" msg_reg src_reg
          (get-token-start-line token) (get-token-start-char token)))
      (set! pc apply-handler2))))

(define read-content
  (lambda (filename)
    (return*
      (apply
        string
        (call-with-input-file
          filename
          (lambda (port)
            (let ((loop 'undefined))
              (set! loop
                (lambda (char)
                  (if (eof-object? char)
                      '()
                      (cons char (loop (read-char port))))))
              (loop (read-char port)))))))))

(define*
  read-sexp
  (lambda ()
    (let ((start 'undefined) (end 'undefined))
      (set! end (get-token-end (first tokens_reg)))
      (set! start (get-token-start (first tokens_reg)))
      (let ((temp_1 'undefined))
        (set! temp_1 (first tokens_reg))
        (if (eq? (car temp_1) 'integer)
            (let ((str 'undefined))
              (set! str (list-ref temp_1 1))
              (set! k_reg
                (make-cont <cont-9> end tokens_reg fail_reg k_reg))
              (set! info_reg (make-info src_reg start end))
              (set! x_reg (string->integer str))
              (set! pc annotate-cps))
            (if (eq? (car temp_1) 'decimal)
                (let ((str 'undefined))
                  (set! str (list-ref temp_1 1))
                  (set! k_reg
                    (make-cont <cont-9> end tokens_reg fail_reg k_reg))
                  (set! info_reg (make-info src_reg start end))
                  (set! x_reg (string->decimal str))
                  (set! pc annotate-cps))
                (if (eq? (car temp_1) 'rational)
                    (let ((str 'undefined))
                      (set! str (list-ref temp_1 1))
                      (let ((num 'undefined))
                        (set! num (string->rational str))
                        (if (true? num)
                            (begin
                              (set! k_reg
                                (make-cont <cont-9> end tokens_reg fail_reg k_reg))
                              (set! info_reg (make-info src_reg start end))
                              (set! x_reg num)
                              (set! pc annotate-cps))
                            (begin
                              (set! msg_reg (format "cannot represent ~a" str))
                              (set! pc read-error)))))
                    (if (eq? (car temp_1) 'boolean)
                        (let ((bool 'undefined))
                          (set! bool (list-ref temp_1 1))
                          (set! k_reg
                            (make-cont <cont-9> end tokens_reg fail_reg k_reg))
                          (set! info_reg (make-info src_reg start end))
                          (set! x_reg bool)
                          (set! pc annotate-cps))
                        (if (eq? (car temp_1) 'character)
                            (let ((char 'undefined))
                              (set! char (list-ref temp_1 1))
                              (set! k_reg
                                (make-cont <cont-9> end tokens_reg fail_reg k_reg))
                              (set! info_reg (make-info src_reg start end))
                              (set! x_reg char)
                              (set! pc annotate-cps))
                            (if (eq? (car temp_1) 'string)
                                (let ((str 'undefined))
                                  (set! str (list-ref temp_1 1))
                                  (set! k_reg
                                    (make-cont <cont-9> end tokens_reg fail_reg k_reg))
                                  (set! info_reg (make-info src_reg start end))
                                  (set! x_reg str)
                                  (set! pc annotate-cps))
                                (if (eq? (car temp_1) 'identifier)
                                    (let ((id 'undefined))
                                      (set! id (list-ref temp_1 1))
                                      (set! k_reg
                                        (make-cont <cont-9> end tokens_reg fail_reg k_reg))
                                      (set! info_reg (make-info src_reg start end))
                                      (set! x_reg id)
                                      (set! pc annotate-cps))
                                    (if (eq? (car temp_1) 'apostrophe)
                                        (begin
                                          (set! keyword_reg 'quote)
                                          (set! pc read-abbreviation))
                                        (if (eq? (car temp_1) 'backquote)
                                            (begin
                                              (set! keyword_reg 'quasiquote)
                                              (set! pc read-abbreviation))
                                            (if (eq? (car temp_1) 'comma)
                                                (begin
                                                  (set! keyword_reg 'unquote)
                                                  (set! pc read-abbreviation))
                                                (if (eq? (car temp_1) 'comma-at)
                                                    (begin
                                                      (set! keyword_reg 'unquote-splicing)
                                                      (set! pc read-abbreviation))
                                                    (if (eq? (car temp_1) 'lparen)
                                                        (let ((tokens 'undefined))
                                                          (set! tokens (rest-of tokens_reg))
                                                          (set! k_reg (make-cont4 <cont4-2> src_reg start k_reg))
                                                          (set! expected-terminator_reg 'rparen)
                                                          (set! tokens_reg tokens)
                                                          (set! pc read-sexp-sequence))
                                                        (if (eq? (car temp_1) 'lbracket)
                                                            (let ((tokens 'undefined))
                                                              (set! tokens (rest-of tokens_reg))
                                                              (set! k_reg (make-cont4 <cont4-2> src_reg start k_reg))
                                                              (set! expected-terminator_reg 'rbracket)
                                                              (set! tokens_reg tokens)
                                                              (set! pc read-sexp-sequence))
                                                            (if (eq? (car temp_1) 'lvector)
                                                                (begin
                                                                  (set! k_reg (make-cont4 <cont4-1> src_reg start k_reg))
                                                                  (set! tokens_reg (rest-of tokens_reg))
                                                                  (set! pc read-vector-sequence))
                                                                (set! pc unexpected-token-error)))))))))))))))))))

(define*
  read-abbreviation
  (lambda ()
    (let ((start 'undefined) (keyword-end 'undefined))
      (set! keyword-end (get-token-end (first tokens_reg)))
      (set! start (get-token-start (first tokens_reg)))
      (set! k_reg
        (make-cont <cont-10> src_reg start tokens_reg handler_reg
          fail_reg k_reg))
      (set! info_reg (make-info src_reg start keyword-end))
      (set! x_reg keyword_reg)
      (set! pc annotate-cps))))

(define*
  read-vector-sequence
  (lambda ()
    (let ((temp_1 'undefined))
      (set! temp_1 (first tokens_reg))
      (if (eq? (car temp_1) 'rparen)
          (begin
            (set! expected-terminator_reg 'rparen)
            (set! sexps_reg '())
            (set! pc close-sexp-sequence))
          (if (eq? (car temp_1) 'dot)
              (begin
                (set! msg_reg "unexpected dot (.)")
                (set! pc read-error))
              (begin
                (set! k_reg
                  (make-cont4 <cont4-5> src_reg handler_reg k_reg))
                (set! pc read-sexp)))))))

(define*
  read-sexp-sequence
  (lambda ()
    (let ((temp_1 'undefined))
      (set! temp_1 (first tokens_reg))
      (if (memq (car temp_1) (list 'rparen 'rbracket))
          (begin (set! sexps_reg '()) (set! pc close-sexp-sequence))
          (if (eq? (car temp_1) 'dot)
              (begin
                (set! msg_reg "unexpected dot (.)")
                (set! pc read-error))
              (begin
                (set! k_reg
                  (make-cont4 <cont4-7> expected-terminator_reg src_reg
                    handler_reg k_reg))
                (set! pc read-sexp)))))))

(define*
  close-sexp-sequence
  (lambda ()
    (let ((end 'undefined))
      (set! end (get-token-end (first tokens_reg)))
      (let ((temp_1 'undefined))
        (set! temp_1 (first tokens_reg))
        (if (memq (car temp_1) (list 'rparen 'rbracket))
            (if (token-type? (first tokens_reg) expected-terminator_reg)
                (begin
                  (set! value4_reg fail_reg)
                  (set! value3_reg (rest-of tokens_reg))
                  (set! value2_reg end)
                  (set! value1_reg sexps_reg)
                  (set! pc apply-cont4))
                (if (eq? expected-terminator_reg 'rparen)
                    (begin
                      (set! msg_reg "parenthesized list terminated by bracket")
                      (set! pc read-error))
                    (if (eq? expected-terminator_reg 'rbracket)
                        (begin
                          (set! msg_reg "bracketed list terminated by parenthesis")
                          (set! pc read-error)))))
            (set! pc unexpected-token-error))))))

(define make-binding
  (lambda (value docstring) (return* (cons value docstring))))

(define binding-value
  (lambda (binding) (return* (car binding))))

(define binding-docstring
  (lambda (binding) (return* (cdr binding))))

(define set-binding-value!
  (lambda (binding value) (set-car! binding value)))

(define set-binding-docstring!
  (lambda (binding docstring) (set-cdr! binding docstring)))

(define make-frame
  (lambda (variables values docstrings)
    (return*
      (list
        (list->vector (map make-binding values docstrings))
        variables))))

(define empty-frame?
  (lambda (frame) (return* (null? (cadr frame)))))

(define frame-bindings
  (lambda (frame) (return* (car frame))))

(define environment?
  (lambda (x)
    (return* (and (pair? x) (eq? (car x) 'environment)))))

(define make-empty-environment
  (lambda ()
    (return* (list 'environment (make-frame '() '() '())))))

(define make-initial-environment
  (lambda (vars vals docstrings)
    (return*
      (list 'environment (make-frame vars vals docstrings)))))

(define first-frame (lambda (env) (return* (cadr env))))

(define first-frame-vars
  (lambda (env) (return* (cadr (first-frame env)))))

(define initial-contours
  (lambda (env) (return* (cdr (first-frame env)))))

(define frames (lambda (env) (return* (cdr env))))

(define add-binding
  (lambda (new-var new-binding frame)
    (let ((bindings 'undefined) (vars 'undefined))
      (set! vars (cadr frame))
      (set! bindings (vector->list (car frame)))
      (return*
        (list
          (list->vector (append bindings (list new-binding)))
          (append vars (list new-var)))))))

(define set-first-frame!
  (lambda (env new-frame) (set-car! (cdr env) new-frame)))

(define extend
  (lambda (env variables values docstrings)
    (return*
      (cons
        'environment
        (cons
          (make-frame variables values docstrings)
          (cdr env))))))

(define search-env
  (lambda (env variable)
    (return* (search-frames (cdr env) variable))))

(define search-frames
  (lambda (frames variable)
    (if (null? frames)
        (return* #f)
        (let ((binding 'undefined))
          (set! binding (search-frame (car frames) variable))
          (if binding
              (return* binding)
              (return* (search-frames (cdr frames) variable)))))))

(define in-first-frame?
  (lambda (var env)
    (return* (true? (memq var (first-frame-vars env))))))

(define get-first-frame-value
  (lambda (var env)
    (return*
      (binding-value (search-frame (first-frame env) var)))))

(define*
  lookup-value-by-lexical-address
  (lambda ()
    (let ((bindings 'undefined))
      (set! bindings
        (frame-bindings (list-ref frames_reg depth_reg)))
      (set! value2_reg fail_reg)
      (set! value1_reg
        (binding-value (vector-ref bindings offset_reg)))
      (set! pc apply-cont2))))

(define*
  lookup-binding-by-lexical-address
  (lambda ()
    (let ((bindings 'undefined))
      (set! bindings
        (frame-bindings (list-ref frames_reg depth_reg)))
      (set! value2_reg fail_reg)
      (set! value1_reg (vector-ref bindings offset_reg))
      (set! pc apply-cont2))))

(define*
  lookup-value
  (lambda ()
    (set! sk_reg (make-cont2 <cont2-3> k_reg))
    (set! dk_reg (make-cont3 <cont3-3> k_reg))
    (set! gk_reg (make-cont2 <cont2-4> k_reg))
    (set! pc lookup-variable)))

(define*
  lookup-variable
  (lambda ()
    (let ((binding 'undefined))
      (set! binding (search-env env_reg var_reg))
      (if binding
          (begin
            (set! value2_reg fail_reg)
            (set! value1_reg binding)
            (set! k_reg sk_reg)
            (set! pc apply-cont2))
          (let ((components 'undefined))
            (set! components (split-variable var_reg))
            (if (and (null? (cdr components))
                     (dlr-env-contains (car components)))
                (begin
                  (set! value2_reg fail_reg)
                  (set! value1_reg (car components))
                  (set! k_reg gk_reg)
                  (set! pc apply-cont2))
                (if (and (not (null? (cdr components)))
                         (dlr-env-contains (car components))
                         (dlr-object-contains
                           (dlr-env-lookup (car components))
                           components))
                    (begin
                      (set! value3_reg fail_reg)
                      (set! value2_reg components)
                      (set! value1_reg (dlr-env-lookup (car components)))
                      (set! k_reg dk_reg)
                      (set! pc apply-cont3))
                    (if (null? (cdr components))
                        (begin
                          (set! info_reg var-info_reg)
                          (set! msg_reg (format "unbound variable '~a'" var_reg))
                          (set! pc runtime-error))
                        (begin
                          (set! module_reg env_reg)
                          (set! path_reg "")
                          (set! components_reg components)
                          (set! pc lookup-variable-components))))))))))

(define*
  lookup-variable-components
  (lambda ()
    (let ((var 'undefined) (binding 'undefined))
      (set! var (car components_reg))
      (set! binding (search-env module_reg var))
      (if binding
          (if (null? (cdr components_reg))
              (begin
                (set! value2_reg fail_reg)
                (set! value1_reg binding)
                (set! k_reg sk_reg)
                (set! pc apply-cont2))
              (let ((value 'undefined) (new-path 'undefined))
                (set! new-path
                  (if (string=? path_reg "")
                      (format "~a" var)
                      (format "~a.~a" path_reg var)))
                (set! value (binding-value binding))
                (if (environment? value)
                    (begin
                      (set! module_reg value)
                      (set! path_reg new-path)
                      (set! components_reg (cdr components_reg))
                      (set! pc lookup-variable-components))
                    (if (dlr-object-contains value components_reg)
                        (begin
                          (set! value3_reg fail_reg)
                          (set! value2_reg components_reg)
                          (set! value1_reg value)
                          (set! k_reg dk_reg)
                          (set! pc apply-cont3))
                        (begin
                          (set! info_reg var-info_reg)
                          (set! msg_reg (format "'~a' is not a module" new-path))
                          (set! pc runtime-error))))))
          (if (string=? path_reg "")
              (begin
                (set! info_reg var-info_reg)
                (set! msg_reg (format "unbound module '~a'" var))
                (set! pc runtime-error))
              (begin
                (set! info_reg var-info_reg)
                (set! msg_reg
                  (format
                    "unbound variable '~a' in module '~a'"
                    var
                    path_reg))
                (set! pc runtime-error)))))))

(define*
  lookup-binding-in-first-frame
  (lambda ()
    (let ((frame 'undefined))
      (set! frame (first-frame env_reg))
      (let ((binding 'undefined))
        (set! binding (search-frame frame var_reg))
        (if binding
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg binding)
              (set! pc apply-cont2))
            (let ((new-binding 'undefined))
              (set! new-binding (make-binding 'undefined ""))
              (let ((new-frame 'undefined))
                (set! new-frame (add-binding var_reg new-binding frame))
                (set-first-frame! env_reg new-frame)
                (set! value2_reg fail_reg)
                (set! value1_reg new-binding)
                (set! pc apply-cont2))))))))

(define split-variable
  (lambda (var)
    (let ((strings 'undefined))
      (set! strings (string-split (symbol->string var) #\.))
      (if (member "" strings)
          (return* '())
          (return* (map string->symbol strings))))))

(define string-split
  (lambda (s delimiter-char)
    (let ((position 'undefined) (split 'undefined))
      (set! position
        (lambda (chars)
          (if (char=? (car chars) delimiter-char)
              0
              (+ 1 (position (cdr chars))))))
      (set! split
        (lambda (chars)
          (if (null? chars)
              '()
              (if (not (member delimiter-char chars))
                  (list (apply string chars))
                  (let ((n 'undefined))
                    (set! n (position chars))
                    (cons
                      (apply string (list-head chars n))
                      (split (cdr (list-tail chars n)))))))))
      (return* (split (string->list s))))))

(define head
  (lambda (formals)
    (if (symbol? formals)
        (return* '())
        (if (pair? (cdr formals))
            (return* (cons (car formals) (head (cdr formals))))
            (return* (list (car formals)))))))

(define last
  (lambda (formals)
    (if (symbol? formals)
        (return* formals)
        (if (pair? (cdr formals))
            (return* (last (cdr formals)))
            (return* (cdr formals))))))

(define anything? (lambda (datum) (return* #t)))

(define application?^
  (lambda (asexp)
    (return*
      (and (list?^ asexp)
           (not (null?^ asexp))
           (not (reserved-keyword? (untag-atom^ (car^ asexp))))))))

(define reserved-keyword?
  (lambda (x)
    (return*
      (and (symbol? x)
           (not (eq? (memq x (get-reserved-keywords)) #f))))))

(define get-reserved-keywords
  (lambda ()
    (return*
      (list 'quote 'func 'define! 'quasiquote 'lambda 'if 'set!
       'define 'begin 'cond 'and 'or 'let 'let* 'letrec 'case
       'record-case 'try 'catch 'finally 'raise 'define-syntax
       'choose 'define-datatype 'cases 'trace-lambda))))

(define mit-style-define?^
  (lambda (asexp) (return* (not (symbol?^ (cadr^ asexp))))))

(define literal?
  (lambda (datum)
    (return*
      (or (number? datum)
          (boolean? datum)
          (null? datum)
          (char? datum)
          (string? datum)))))

(define literal?^
  (lambda (asexp)
    (return*
      (and (eq? (car asexp) atom-tag)
           (or (number? (untag-atom^ asexp))
               (boolean? (untag-atom^ asexp))
               (null? (untag-atom^ asexp))
               (char? (untag-atom^ asexp))
               (string? (untag-atom^ asexp)))))))

(define syntactic-sugar?^
  (lambda (asexp)
    (return*
      (and (pair?^ asexp)
           (symbol?^ (car^ asexp))
           (in-first-frame? (untag-atom^ (car^ asexp)) macro-env)))))

(define define-var^
  (lambda (x) (return* (untag-atom^ (cadr^ x)))))

(define define-docstring^
  (lambda (x) (return* (untag-atom^ (caddr^ x)))))

(define try-body^ (lambda (x) (return* (cadr^ x))))

(define catch-var^
  (lambda (x) (return* (untag-atom^ (cadr^ (caddr^ x))))))

(define catch-exps^
  (lambda (x) (return* (cddr^ (caddr^ x)))))

(define try-finally-exps^
  (lambda (x) (return* (cdr^ (caddr^ x)))))

(define try-catch-finally-exps^
  (lambda (x) (return* (cdr^ (cadddr^ x)))))

(define*
  aparse
  (lambda ()
    (let ((info 'undefined))
      (set! info (get-source-info adatum_reg))
      (if (literal?^ adatum_reg)
          (begin
            (set! value2_reg fail_reg)
            (set! value1_reg (lit-aexp (untag-atom^ adatum_reg) info))
            (set! pc apply-cont2))
          (if (symbol?^ adatum_reg)
              (if *use-lexical-address*
                  (begin
                    (set! info_reg info)
                    (set! depth_reg 0)
                    (set! id_reg (untag-atom^ adatum_reg))
                    (set! pc get-lexical-address))
                  (begin
                    (set! value2_reg fail_reg)
                    (set! value1_reg (var-aexp (untag-atom^ adatum_reg) info))
                    (set! pc apply-cont2)))
              (if (vector?^ adatum_reg)
                  (begin
                    (set! k_reg (make-cont <cont-20> info fail_reg k_reg))
                    (set! x_reg adatum_reg)
                    (set! pc unannotate-cps))
                  (if (quote?^ adatum_reg)
                      (begin
                        (set! k_reg (make-cont <cont-19> info fail_reg k_reg))
                        (set! x_reg adatum_reg)
                        (set! pc unannotate-cps))
                      (if (quasiquote?^ adatum_reg)
                          (begin
                            (set! k_reg
                              (make-cont <cont-18> adatum_reg senv_reg info handler_reg
                                fail_reg k_reg))
                            (set! depth_reg 0)
                            (set! ax_reg (cadr^ adatum_reg))
                            (set! pc qq-expand-cps))
                          (if (unquote?^ adatum_reg)
                              (begin (set! msg_reg "misplaced") (set! pc aparse-error))
                              (if (unquote-splicing?^ adatum_reg)
                                  (begin (set! msg_reg "misplaced") (set! pc aparse-error))
                                  (if (syntactic-sugar?^ adatum_reg)
                                      (begin
                                        (set! k_reg
                                          (make-cont2 <cont2-31> senv_reg handler_reg k_reg))
                                        (set! pc expand-once^))
                                      (if (if-then?^ adatum_reg)
                                          (begin
                                            (set! k_reg
                                              (make-cont2 <cont2-30> adatum_reg senv_reg info handler_reg
                                                k_reg))
                                            (set! adatum_reg (cadr^ adatum_reg))
                                            (set! pc aparse))
                                          (if (if-else?^ adatum_reg)
                                              (begin
                                                (set! k_reg
                                                  (make-cont2 <cont2-28> adatum_reg senv_reg info handler_reg
                                                    k_reg))
                                                (set! adatum_reg (cadr^ adatum_reg))
                                                (set! pc aparse))
                                              (if (help?^ adatum_reg)
                                                  (let ((var-info 'undefined))
                                                    (set! var-info (get-source-info (cadr^ adatum_reg)))
                                                    (set! value2_reg fail_reg)
                                                    (set! value1_reg
                                                      (help-aexp (untag-atom^ (cadr^ adatum_reg)) var-info info))
                                                    (set! pc apply-cont2))
                                                  (if (assignment?^ adatum_reg)
                                                      (begin
                                                        (set! k_reg (make-cont2 <cont2-25> adatum_reg info k_reg))
                                                        (set! adatum_reg (caddr^ adatum_reg))
                                                        (set! pc aparse))
                                                      (if (func?^ adatum_reg)
                                                          (begin
                                                            (set! k_reg (make-cont2 <cont2-24> info k_reg))
                                                            (set! adatum_reg (cadr^ adatum_reg))
                                                            (set! pc aparse))
                                                          (if (callback?^ adatum_reg)
                                                              (begin
                                                                (set! k_reg (make-cont2 <cont2-23> info k_reg))
                                                                (set! adatum_reg (cadr^ adatum_reg))
                                                                (set! pc aparse))
                                                              (if (define?^ adatum_reg)
                                                                  (if (mit-style-define?^ adatum_reg)
                                                                      (begin
                                                                        (set! k_reg
                                                                          (make-cont <cont-16> senv_reg info handler_reg fail_reg
                                                                            k_reg))
                                                                        (set! datum_reg adatum_reg)
                                                                        (set! macro_reg mit-define-transformer^)
                                                                        (set! pc apply-macro))
                                                                      (if (= (length^ adatum_reg) 3)
                                                                          (begin
                                                                            (set! k_reg (make-cont2 <cont2-22> adatum_reg info k_reg))
                                                                            (set! adatum_reg (caddr^ adatum_reg))
                                                                            (set! pc aparse))
                                                                          (if (and (= (length^ adatum_reg) 4)
                                                                                   (string?^ (caddr^ adatum_reg)))
                                                                              (begin
                                                                                (set! k_reg (make-cont2 <cont2-21> adatum_reg info k_reg))
                                                                                (set! adatum_reg (cadddr^ adatum_reg))
                                                                                (set! pc aparse))
                                                                              (begin
                                                                                (set! msg_reg "bad concrete syntax:")
                                                                                (set! pc aparse-error)))))
                                                                  (if (define!?^ adatum_reg)
                                                                      (if (mit-style-define?^ adatum_reg)
                                                                          (begin
                                                                            (set! k_reg
                                                                              (make-cont <cont-16> senv_reg info handler_reg fail_reg
                                                                                k_reg))
                                                                            (set! datum_reg adatum_reg)
                                                                            (set! macro_reg mit-define-transformer^)
                                                                            (set! pc apply-macro))
                                                                          (if (= (length^ adatum_reg) 3)
                                                                              (begin
                                                                                (set! k_reg (make-cont2 <cont2-20> adatum_reg info k_reg))
                                                                                (set! adatum_reg (caddr^ adatum_reg))
                                                                                (set! pc aparse))
                                                                              (if (and (= (length^ adatum_reg) 4)
                                                                                       (string?^ (caddr^ adatum_reg)))
                                                                                  (begin
                                                                                    (set! k_reg (make-cont2 <cont2-19> adatum_reg info k_reg))
                                                                                    (set! adatum_reg (cadddr^ adatum_reg))
                                                                                    (set! pc aparse))
                                                                                  (begin
                                                                                    (set! msg_reg "bad concrete syntax:")
                                                                                    (set! pc aparse-error)))))
                                                                      (if (define-syntax?^ adatum_reg)
                                                                          (let ((name 'undefined) (aclauses 'undefined))
                                                                            (set! aclauses (cddr^ adatum_reg))
                                                                            (set! name (define-var^ adatum_reg))
                                                                            (set! k_reg
                                                                              (make-cont <cont-14> aclauses name info fail_reg k_reg))
                                                                            (set! x_reg aclauses)
                                                                            (set! pc unannotate-cps))
                                                                          (if (begin?^ adatum_reg)
                                                                              (if (null?^ (cdr^ adatum_reg))
                                                                                  (begin
                                                                                    (set! msg_reg "bad concrete syntax:")
                                                                                    (set! pc aparse-error))
                                                                                  (if (null?^ (cddr^ adatum_reg))
                                                                                      (begin
                                                                                        (set! adatum_reg (cadr^ adatum_reg))
                                                                                        (set! pc aparse))
                                                                                      (begin
                                                                                        (set! k_reg (make-cont2 <cont2-18> info k_reg))
                                                                                        (set! adatum-list_reg (cdr^ adatum_reg))
                                                                                        (set! pc aparse-all))))
                                                                              (if (lambda?^ adatum_reg)
                                                                                  (begin
                                                                                    (set! k_reg
                                                                                      (make-cont <cont-13> adatum_reg senv_reg info handler_reg
                                                                                        fail_reg k_reg))
                                                                                    (set! x_reg (cadr^ adatum_reg))
                                                                                    (set! pc unannotate-cps))
                                                                                  (if (trace-lambda?^ adatum_reg)
                                                                                      (begin
                                                                                        (set! k_reg
                                                                                          (make-cont <cont-12> adatum_reg senv_reg info handler_reg
                                                                                            fail_reg k_reg))
                                                                                        (set! x_reg (caddr^ adatum_reg))
                                                                                        (set! pc unannotate-cps))
                                                                                      (if (try?^ adatum_reg)
                                                                                          (if (= (length^ adatum_reg) 2)
                                                                                              (begin
                                                                                                (set! adatum_reg (try-body^ adatum_reg))
                                                                                                (set! pc aparse))
                                                                                              (if (and (= (length^ adatum_reg) 3)
                                                                                                       (catch?^ (caddr^ adatum_reg)))
                                                                                                  (begin
                                                                                                    (set! k_reg
                                                                                                      (make-cont2 <cont2-15> adatum_reg senv_reg info handler_reg
                                                                                                        k_reg))
                                                                                                    (set! adatum_reg (try-body^ adatum_reg))
                                                                                                    (set! pc aparse))
                                                                                                  (if (and (= (length^ adatum_reg) 3)
                                                                                                           (finally?^ (caddr^ adatum_reg)))
                                                                                                      (begin
                                                                                                        (set! k_reg
                                                                                                          (make-cont2 <cont2-13> adatum_reg senv_reg info handler_reg
                                                                                                            k_reg))
                                                                                                        (set! adatum_reg (try-body^ adatum_reg))
                                                                                                        (set! pc aparse))
                                                                                                      (if (and (= (length^ adatum_reg) 4)
                                                                                                               (catch?^ (caddr^ adatum_reg))
                                                                                                               (finally?^ (cadddr^ adatum_reg)))
                                                                                                          (begin
                                                                                                            (set! k_reg
                                                                                                              (make-cont2 <cont2-11> adatum_reg senv_reg info handler_reg
                                                                                                                k_reg))
                                                                                                            (set! adatum_reg (try-body^ adatum_reg))
                                                                                                            (set! pc aparse))
                                                                                                          (begin
                                                                                                            (set! msg_reg "bad try syntax:")
                                                                                                            (set! pc aparse-error))))))
                                                                                          (if (raise?^ adatum_reg)
                                                                                              (begin
                                                                                                (set! k_reg (make-cont2 <cont2-8> info k_reg))
                                                                                                (set! adatum_reg (cadr^ adatum_reg))
                                                                                                (set! pc aparse))
                                                                                              (if (choose?^ adatum_reg)
                                                                                                  (begin
                                                                                                    (set! k_reg (make-cont2 <cont2-7> info k_reg))
                                                                                                    (set! adatum-list_reg (cdr^ adatum_reg))
                                                                                                    (set! pc aparse-all))
                                                                                                  (if (application?^ adatum_reg)
                                                                                                      (begin
                                                                                                        (set! k_reg
                                                                                                          (make-cont2 <cont2-6> adatum_reg senv_reg info handler_reg
                                                                                                            k_reg))
                                                                                                        (set! adatum_reg (car^ adatum_reg))
                                                                                                        (set! pc aparse))
                                                                                                      (begin
                                                                                                        (set! msg_reg "bad concrete syntax:")
                                                                                                        (set! pc aparse-error)))))))))))))))))))))))))))))

(define*
  aparse-all
  (lambda ()
    (if (null?^ adatum-list_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! pc apply-cont2))
        (begin
          (set! k_reg
            (make-cont2 <cont2-33> adatum-list_reg senv_reg handler_reg
              k_reg))
          (set! adatum_reg (car^ adatum-list_reg))
          (set! pc aparse)))))

(define*
  aparse-error
  (lambda ()
    (let ((info 'undefined))
      (set! info (get-source-info adatum_reg))
      (set! k_reg
        (make-cont <cont-21> msg_reg info handler_reg fail_reg))
      (set! x_reg adatum_reg)
      (set! pc unannotate-cps))))

(define*
  aparse-sexps
  (lambda ()
    (if (token-type? (first tokens_reg) 'end-marker)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! pc apply-cont2))
        (begin
          (set! k_reg
            (make-cont4 <cont4-9> senv_reg src_reg handler_reg k_reg))
          (set! pc read-sexp)))))

(define*
  get-lexical-address
  (lambda ()
    (if (null? senv_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg (var-aexp id_reg info_reg))
          (set! pc apply-cont2))
        (if (memq id_reg (car senv_reg))
            (begin
              (set! offset_reg 0)
              (set! contours_reg (car senv_reg))
              (set! pc get-lexical-address-offset))
            (begin
              (set! depth_reg (+ depth_reg 1))
              (set! senv_reg (cdr senv_reg))
              (set! pc get-lexical-address))))))

(define*
  get-lexical-address-offset
  (lambda ()
    (if (eq? (car contours_reg) id_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg
            (lexical-address-aexp depth_reg offset_reg id_reg info_reg))
          (set! pc apply-cont2))
        (begin
          (set! offset_reg (+ offset_reg 1))
          (set! contours_reg (cdr contours_reg))
          (set! pc get-lexical-address-offset)))))

(define*
  create-letrec-assignments^
  (lambda ()
    (if (null?^ vars_reg)
        (begin
          (set! value2_reg '())
          (set! value1_reg '())
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! k2_reg
            (make-cont2 <cont2-37> procs_reg vars_reg k2_reg))
          (set! procs_reg (cdr^ procs_reg))
          (set! vars_reg (cdr^ vars_reg))
          (set! pc create-letrec-assignments^)))))

(define*
  amacro-error
  (lambda ()
    (let ((info 'undefined))
      (set! info (get-source-info adatum_reg))
      (set! exception_reg
        (make-exception "MacroError" msg_reg (get-start-line info)
          (get-srcfile info) (get-start-char info)))
      (set! pc apply-handler2))))

(define*
  nest-let*-bindings^
  (lambda ()
    (if (or (null?^ bindings_reg) (null?^ (cdr^ bindings_reg)))
        (begin
          (set! value_reg
            (append
              (list 'let)
              (append (list bindings_reg) (at^ bodies_reg))))
          (set! pc apply-cont))
        (begin
          (set! k_reg (make-cont <cont-22> bindings_reg k_reg))
          (set! bindings_reg (cdr^ bindings_reg))
          (set! pc nest-let*-bindings^)))))

(define*
  case-clauses->simple-cond-clauses^
  (lambda ()
    (if (null?^ clauses_reg)
        (begin (set! value_reg '()) (set! pc apply-cont))
        (begin
          (set! k_reg (make-cont <cont-23> clauses_reg var_reg k_reg))
          (set! clauses_reg (cdr^ clauses_reg))
          (set! pc case-clauses->simple-cond-clauses^)))))

(define*
  case-clauses->cond-clauses^
  (lambda ()
    (if (null?^ clauses_reg)
        (begin
          (set! value2_reg '())
          (set! value1_reg '())
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! k2_reg
            (make-cont2 <cont2-39> clauses_reg var_reg k2_reg))
          (set! clauses_reg (cdr^ clauses_reg))
          (set! pc case-clauses->cond-clauses^)))))

(define*
  record-case-clauses->cond-clauses^
  (lambda ()
    (if (null?^ clauses_reg)
        (begin
          (set! value2_reg '())
          (set! value1_reg '())
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! k2_reg
            (make-cont2 <cont2-40> clauses_reg var_reg k2_reg))
          (set! clauses_reg (cdr^ clauses_reg))
          (set! pc record-case-clauses->cond-clauses^)))))

(define*
  make-dd-variant-constructors^
  (lambda ()
    (if (null?^ variants_reg)
        (begin
          (set! value2_reg '())
          (set! value1_reg '())
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! k2_reg (make-cont2 <cont2-43> variants_reg k2_reg))
          (set! variant_reg (car^ variants_reg))
          (set! pc make-dd-variant-constructor^)))))

(define*
  make-dd-variant-constructor^
  (lambda ()
    (let ((name 'undefined) (fields 'undefined))
      (set! fields (cdr^ variant_reg))
      (set! name (car^ variant_reg))
      (set! k_reg (make-cont <cont-24> fields name k2_reg))
      (set! cdrs_reg 'args)
      (set! fields_reg fields)
      (set! name_reg name)
      (set! pc verify-dd-constructor-fields^))))

(define*
  verify-dd-constructor-fields^
  (lambda ()
    (if (null?^ fields_reg)
        (begin
          (set! value_reg
            (append
              (list 'cons)
              (append
                (list (append (list 'quote) (list name_reg)))
                (list 'args))))
          (set! pc apply-cont))
        (begin
          (set! k_reg
            (make-cont <cont-25> cdrs_reg fields_reg name_reg k_reg))
          (set! cdrs_reg (append (list 'cdr) (list cdrs_reg)))
          (set! fields_reg (cdr^ fields_reg))
          (set! pc verify-dd-constructor-fields^)))))

(define make-macro-env^
  (lambda ()
    (return*
      (make-initial-environment
        (list 'and 'or 'cond 'let 'letrec 'let* 'case 'record-case
          'define-datatype 'cases)
        (list and-transformer^ or-transformer^ cond-transformer^
          let-transformer^ letrec-transformer^ let*-transformer^
          case-transformer^ record-case-transformer^
          define-datatype-transformer^ cases-transformer^)
        (list
          (string-append "(and ...) - short-circuiting `and` macro\n" "\n"
            "Example:\n" "    In  [1]: (and)\n" "    Out [1]: #t\n"
            "    In  [2]: (and #t #f)\n" "    Out [2]: #f\n")
          (string-append "(or ...) - short-circuiting `or` macro" "\n" "Example:\n"
            "    In  [1]: (or)\n" "    Out [1]: #f\n"
            "    In  [2]: (or #t #f)\n" "    Out [2]: #t\n")
          (string-append "(cond (TEST RETURN)...) - conditional evaluation macro"
            "\n" "Example:\n"
            "    In  [1]: (cond ((= 1 2) 3)(else 4))\n"
            "    Out [1]: 4\n")
          (string-append "(let ((VAR VALUE)...)...) - local variable macro" "\n"
            "Example:\n" "    In  [1]: (let ((x 3)) x)\n"
            "    Out [1]: 3\n")
          (string-append
            "(letrec ((VAR VALUE)...)...) - recursive local variable macro"
            "\n"
            "Example:\n"
            "    In  [*]: (letrec ((loop (lambda () (loop)))) (loop))\n")
          (string-append
            "(let* ((VAR VALUE)...)...) - cascading local variable macro"
            "\n" "Example:\n"
            "    In  [1]: (let* ((a 1)(b a)(c b)) c)\n"
            "    Out [1]: 1\n")
          (string-append "(case THING (ITEM RETURN)...)) - case macro" "\n"
            "Example:\n" "    In  [1]: (case 1 (1 2)(3 4))\n"
            "    Out [1]: 2\n")
          (string-append
            "(record-case ) - record-case macro for define-datatype"
            "\n"
            "Example:\n"
            "    In  [1]: (record-case ddtype (subtype (part...) return)...)\n")
          (string-append
            "(define-datatype NAME NAME? (TYPE (PART TEST))...) - defines new datatypes and support functions (macro)"
            "\n" "Example:\n" "    In  [1]: (define-datatype e e?)\n"
            "    In  [1]: (e? 1)\n" "    Out [1]: #f\n")
          (string-append "(cases ...) - cases macro for a more flexible case" "\n"
            "Example:\n" "    In  [1]: (cases 1 ((1 2) 3))\n"
            "    Out [1]: 3\n"))))))

(define make-pattern-macro^
  (lambda (clauses aclauses)
    (return* (list 'pattern-macro clauses aclauses))))

(define pattern-macro?
  (lambda (x)
    (return* (and (pair? x) (eq? (car x) 'pattern-macro)))))

(define macro-clauses
  (lambda (macro) (return* (cadr macro))))

(define macro-aclauses
  (lambda (macro) (return* (caddr macro))))

(define define-syntax-clause?
  (lambda (x)
    (return*
      (and (list? x)
           (= (length x) 2)
           (pattern? (car x))
           (pattern? (cadr x))))))

(define define-syntax-clause?^
  (lambda (x)
    (return*
      (and (list?^ x)
           (= (length^ x) 2)
           (apattern? (car^ x))
           (apattern? (cadr^ x))))))

(define apattern?
  (lambda (x)
    (return*
      (or (aatom? x)
          (and (apair? x)
               (apattern? (cadr x))
               (apattern? (caddr x)))))))

(define list-of-define-syntax-clauses?^
  (lambda (alist)
    (return*
      (or (null?^ alist)
          (and (define-syntax-clause?^ (car^ alist))
               (list-of-define-syntax-clauses?^ (cdr^ alist)))))))

(define*
  expand-once^
  (lambda ()
    (let ((macro-keyword 'undefined))
      (set! macro-keyword (untag-atom^ (car^ adatum_reg)))
      (let ((macro 'undefined))
        (set! macro (get-first-frame-value macro-keyword macro-env))
        (if (pattern-macro? macro)
            (begin
              (set! k_reg (make-cont2 <cont2-45> macro-keyword k_reg))
              (set! aclauses_reg (macro-aclauses macro))
              (set! clauses_reg (macro-clauses macro))
              (set! pc process-macro-clauses^))
            (begin
              (set! k_reg
                (make-cont <cont-27> adatum_reg macro-keyword fail_reg
                  k_reg))
              (set! datum_reg adatum_reg)
              (set! macro_reg macro)
              (set! pc apply-macro)))))))

(define*
  process-macro-clauses^
  (lambda ()
    (if (null? clauses_reg)
        (begin
          (set! msg_reg "no matching clause found for")
          (set! pc aparse-error))
        (let ((left-pattern 'undefined)
              (right-pattern 'undefined)
              (left-apattern 'undefined)
              (right-apattern 'undefined))
          (set! right-apattern (cadar^ aclauses_reg))
          (set! left-apattern (caar^ aclauses_reg))
          (set! right-pattern (cadar clauses_reg))
          (set! left-pattern (caar clauses_reg))
          (set! k_reg
            (make-cont <cont-29> aclauses_reg adatum_reg clauses_reg left-apattern
              left-pattern right-apattern right-pattern handler_reg
              fail_reg k_reg))
          (set! x_reg adatum_reg)
          (set! pc unannotate-cps)))))

(define*
  qq-expand-cps
  (lambda ()
    (if (quasiquote?^ ax_reg)
        (begin
          (set! k_reg (make-cont <cont-35> k_reg))
          (set! depth_reg (+ depth_reg 1))
          (set! ax_reg (cdr^ ax_reg))
          (set! pc qq-expand-cps))
        (if (or (unquote?^ ax_reg) (unquote-splicing?^ ax_reg))
            (if (> depth_reg 0)
                (begin
                  (set! k_reg (make-cont <cont-34> ax_reg k_reg))
                  (set! depth_reg (- depth_reg 1))
                  (set! ax_reg (cdr^ ax_reg))
                  (set! pc qq-expand-cps))
                (if (and (unquote?^ ax_reg)
                         (not (null?^ (cdr^ ax_reg)))
                         (null?^ (cddr^ ax_reg)))
                    (begin (set! value_reg (cadr^ ax_reg)) (set! pc apply-cont))
                    (begin
                      (set! value_reg (append (list 'quote) (list ax_reg)))
                      (set! pc apply-cont))))
            (if (vector?^ ax_reg)
                (begin
                  (set! k_reg (make-cont <cont-33> depth_reg k_reg))
                  (set! info_reg 'none)
                  (set! x_reg (vector->list^ ax_reg))
                  (set! pc annotate-cps))
                (if (not (pair?^ ax_reg))
                    (begin
                      (set! value_reg (append (list 'quote) (list ax_reg)))
                      (set! pc apply-cont))
                    (if (null?^ (cdr^ ax_reg))
                        (begin
                          (set! ax_reg (car^ ax_reg))
                          (set! pc qq-expand-list-cps))
                        (begin
                          (set! k_reg (make-cont <cont-31> ax_reg depth_reg k_reg))
                          (set! ax_reg (car^ ax_reg))
                          (set! pc qq-expand-list-cps)))))))))

(define*
  qq-expand-list-cps
  (lambda ()
    (if (quasiquote?^ ax_reg)
        (begin
          (set! k_reg (make-cont <cont-40> k_reg))
          (set! depth_reg (+ depth_reg 1))
          (set! ax_reg (cdr^ ax_reg))
          (set! pc qq-expand-cps))
        (if (or (unquote?^ ax_reg) (unquote-splicing?^ ax_reg))
            (if (> depth_reg 0)
                (begin
                  (set! k_reg (make-cont <cont-39> ax_reg k_reg))
                  (set! depth_reg (- depth_reg 1))
                  (set! ax_reg (cdr^ ax_reg))
                  (set! pc qq-expand-cps))
                (if (unquote?^ ax_reg)
                    (begin
                      (set! value_reg (append (list 'list) (cdr^ ax_reg)))
                      (set! pc apply-cont))
                    (if (null?^ (cddr^ ax_reg))
                        (begin (set! value_reg (cadr^ ax_reg)) (set! pc apply-cont))
                        (begin
                          (set! value_reg (append (list 'append) (cdr^ ax_reg)))
                          (set! pc apply-cont)))))
            (if (vector?^ ax_reg)
                (begin
                  (set! k_reg (make-cont <cont-38> k_reg))
                  (set! pc qq-expand-cps))
                (if (not (pair?^ ax_reg))
                    (begin
                      (set! value_reg (append (list 'quote) (list (list ax_reg))))
                      (set! pc apply-cont))
                    (if (null?^ (cdr^ ax_reg))
                        (begin
                          (set! k_reg (make-cont <cont-38> k_reg))
                          (set! ax_reg (car^ ax_reg))
                          (set! pc qq-expand-list-cps))
                        (begin
                          (set! k_reg (make-cont <cont-37> ax_reg depth_reg k_reg))
                          (set! ax_reg (car^ ax_reg))
                          (set! pc qq-expand-list-cps)))))))))

(define aunparse
  (lambda (aexp)
    (if (eq? (car aexp) 'lit-aexp)
        (let ((datum 'undefined))
          (set! datum (list-ref aexp 1))
          (if (literal? datum)
              (return* datum)
              (if (vector? datum)
                  (return* datum)
                  (return* (append (list 'quote) (list datum))))))
        (if (eq? (car aexp) 'var-aexp)
            (let ((id 'undefined))
              (set! id (list-ref aexp 1))
              (return* id))
            (if (eq? (car aexp) 'lexical-address-aexp)
                (let ((id 'undefined))
                  (set! id (list-ref aexp 3))
                  (return* id))
                (if (eq? (car aexp) 'if-aexp)
                    (let ((test-aexp 'undefined)
                          (then-aexp 'undefined)
                          (else-aexp 'undefined))
                      (set! else-aexp (list-ref aexp 3))
                      (set! then-aexp (list-ref aexp 2))
                      (set! test-aexp (list-ref aexp 1))
                      (return*
                        (append
                          (list 'if)
                          (append
                            (list (aunparse test-aexp))
                            (append
                              (list (aunparse then-aexp))
                              (list (aunparse else-aexp)))))))
                    (if (eq? (car aexp) 'assign-aexp)
                        (let ((var 'undefined) (rhs-exp 'undefined))
                          (set! rhs-exp (list-ref aexp 2))
                          (set! var (list-ref aexp 1))
                          (return*
                            (append
                              (list 'set!)
                              (append (list var) (list (aunparse rhs-exp))))))
                        (if (eq? (car aexp) 'func-aexp)
                            (let ((exp 'undefined))
                              (set! exp (list-ref aexp 1))
                              (return* (append (list 'func) (list (aunparse exp)))))
                            (if (eq? (car aexp) 'callback-aexp)
                                (let ((exp 'undefined))
                                  (set! exp (list-ref aexp 1))
                                  (return* (append (list 'callback) (list (aunparse exp)))))
                                (if (eq? (car aexp) 'define-aexp)
                                    (let ((id 'undefined)
                                          (docstring 'undefined)
                                          (rhs-exp 'undefined))
                                      (set! rhs-exp (list-ref aexp 3))
                                      (set! docstring (list-ref aexp 2))
                                      (set! id (list-ref aexp 1))
                                      (if (string=? docstring "")
                                          (return*
                                            (append
                                              (list 'define)
                                              (append (list id) (list (aunparse rhs-exp)))))
                                          (return*
                                            (append
                                              (list 'define)
                                              (append
                                                (list id)
                                                (append (list docstring) (list (aunparse rhs-exp))))))))
                                    (if (eq? (car aexp) 'define!-aexp)
                                        (let ((id 'undefined)
                                              (docstring 'undefined)
                                              (rhs-exp 'undefined))
                                          (set! rhs-exp (list-ref aexp 3))
                                          (set! docstring (list-ref aexp 2))
                                          (set! id (list-ref aexp 1))
                                          (if (string=? docstring "")
                                              (return*
                                                (append
                                                  (list 'define!)
                                                  (append (list id) (list (aunparse rhs-exp)))))
                                              (return*
                                                (append
                                                  (list 'define!)
                                                  (append
                                                    (list id)
                                                    (append (list docstring) (list (aunparse rhs-exp))))))))
                                        (if (eq? (car aexp) 'define-syntax-aexp)
                                            (let ((name 'undefined) (clauses 'undefined))
                                              (set! clauses (list-ref aexp 2))
                                              (set! name (list-ref aexp 1))
                                              (return*
                                                (append
                                                  (list 'define-syntax)
                                                  (append (list name) clauses))))
                                            (if (eq? (car aexp) 'begin-aexp)
                                                (let ((exps 'undefined))
                                                  (set! exps (list-ref aexp 1))
                                                  (return* (append (list 'begin) (map aunparse exps))))
                                                (if (eq? (car aexp) 'lambda-aexp)
                                                    (let ((formals 'undefined) (bodies 'undefined))
                                                      (set! bodies (list-ref aexp 2))
                                                      (set! formals (list-ref aexp 1))
                                                      (return*
                                                        (append
                                                          (list 'lambda)
                                                          (append (list formals) (map aunparse bodies)))))
                                                    (if (eq? (car aexp) 'mu-lambda-aexp)
                                                        (let ((formals 'undefined)
                                                              (runt 'undefined)
                                                              (bodies 'undefined))
                                                          (set! bodies (list-ref aexp 3))
                                                          (set! runt (list-ref aexp 2))
                                                          (set! formals (list-ref aexp 1))
                                                          (return*
                                                            (append
                                                              (list 'lambda)
                                                              (append
                                                                (list (append formals runt))
                                                                (map aunparse bodies)))))
                                                        (if (eq? (car aexp) 'app-aexp)
                                                            (let ((operator 'undefined) (operands 'undefined))
                                                              (set! operands (list-ref aexp 2))
                                                              (set! operator (list-ref aexp 1))
                                                              (return*
                                                                (append
                                                                  (list (aunparse operator))
                                                                  (map aunparse operands))))
                                                            (if (eq? (car aexp) 'try-catch-aexp)
                                                                (let ((body 'undefined)
                                                                      (catch-var 'undefined)
                                                                      (catch-exps 'undefined))
                                                                  (set! catch-exps (list-ref aexp 3))
                                                                  (set! catch-var (list-ref aexp 2))
                                                                  (set! body (list-ref aexp 1))
                                                                  (return*
                                                                    (append
                                                                      (list 'try)
                                                                      (append
                                                                        (list (aunparse body))
                                                                        (list
                                                                          (append
                                                                            (list 'catch)
                                                                            (append (list catch-var) (map aunparse catch-exps))))))))
                                                                (if (eq? (car aexp) 'try-finally-aexp)
                                                                    (let ((body 'undefined) (finally-exps 'undefined))
                                                                      (set! finally-exps (list-ref aexp 2))
                                                                      (set! body (list-ref aexp 1))
                                                                      (return*
                                                                        (append
                                                                          (list 'try)
                                                                          (append
                                                                            (list (aunparse body))
                                                                            (list
                                                                              (append (list 'finally) (map aunparse finally-exps)))))))
                                                                    (if (eq? (car aexp) 'try-catch-finally-aexp)
                                                                        (let ((body 'undefined)
                                                                              (catch-var 'undefined)
                                                                              (catch-exps 'undefined)
                                                                              (finally-exps 'undefined))
                                                                          (set! finally-exps (list-ref aexp 4))
                                                                          (set! catch-exps (list-ref aexp 3))
                                                                          (set! catch-var (list-ref aexp 2))
                                                                          (set! body (list-ref aexp 1))
                                                                          (return*
                                                                            (append
                                                                              (list 'try)
                                                                              (append
                                                                                (list (aunparse body))
                                                                                (append
                                                                                  (list
                                                                                    (append
                                                                                      (list 'catch)
                                                                                      (append (list catch-var) (map aunparse catch-exps))))
                                                                                  (list
                                                                                    (append (list 'finally) (map aunparse finally-exps))))))))
                                                                        (if (eq? (car aexp) 'raise-aexp)
                                                                            (let ((exp 'undefined))
                                                                              (set! exp (list-ref aexp 1))
                                                                              (return* (append (list 'raise) (list (aunparse exp)))))
                                                                            (if (eq? (car aexp) 'choose-aexp)
                                                                                (let ((exps 'undefined))
                                                                                  (set! exps (list-ref aexp 1))
                                                                                  (return* (append (list 'choose) (map aunparse exps))))
                                                                                (error 'aunparse
                                                                                  "bad abstract syntax: ~s"
                                                                                  aexp))))))))))))))))))))))

(define exception?
  (lambda (x)
    (return* (and (pair? x) (eq? (car x) 'exception)))))

(define use-lexical-address
  (lambda args
    (if (null? args)
        (return* *use-lexical-address*)
        (begin
          (set! *use-lexical-address* (true? (car args)))
          (return* void-value)))))

(define read-multiline-test
  (lambda (prompt)
    (printf prompt)
    (let ((loop 'undefined))
      (set! loop
        (lambda (input)
          (if (string? input)
              input
              (begin
                (printf
                  "Error: input must be enclosed in quotation marks.\n==> ")
                (loop (read))))))
      (return* (loop (read))))))

(define handle-exception
  (lambda (exc)
    (display (get-traceback-string exc))
    (return* void-value)))

(define get-traceback-string
  (lambda (exc)
    (if (list? (cadr exc))
        (let ((error-type 'undefined)
              (message 'undefined)
              (src-file 'undefined)
              (src-line 'undefined)
              (src-col 'undefined)
              (stack 'undefined)
              (retval 'undefined))
          (set! retval "")
          (set! stack (cadddr (cddr (cadr exc))))
          (set! src-col (cadddr (cdr (cadr exc))))
          (set! src-line (cadddr (cadr exc)))
          (set! src-file (caddr (cadr exc)))
          (set! message (cadr (cadr exc)))
          (set! error-type (car (cadr exc)))
          (set! retval
            (string-append
              retval
              (format "~%Traceback (most recent call last):~%")))
          (while
            (not (null? stack))
            (set! retval
              (string-append retval (format-exception-line (car stack))))
            (set! stack (cdr stack)))
          (if (not (eq? src-file 'none))
              (set! retval
                (string-append
                  retval
                  (format
                    "  File \"~a\", line ~a, col ~a~%"
                    src-file
                    src-line
                    src-col))))
          (return*
            (string-append
              retval
              (format "~a: ~a~%" error-type message))))
        (let ((retval 'undefined))
          (set! retval
            (format "~%Traceback (most recent call last):~%"))
          (return*
            (string-append
              retval
              (format "Raised Exception: ~a~%" (cadr exc))))))))

(define format-exception-line
  (lambda (line)
    (if (list? line)
        (let ((filename 'undefined)
              (line-number 'undefined)
              (column-number 'undefined))
          (set! column-number (caddr line))
          (set! line-number (cadr line))
          (set! filename (car line))
          (if (= (length line) 3)
              (return*
                (format
                  "  File \"~a\", line ~a, col ~a~%"
                  filename
                  line-number
                  column-number))
              (return*
                (format "  File \"~a\", line ~a, col ~a, in '~a'~%" filename
                  line-number column-number (cadddr line)))))
        (return* (format "  Source \"~a\"~%" line)))))

(define start-rm
  (lambda ()
    (set! toplevel-env (make-toplevel-env))
    (set! macro-env (make-macro-env^))
    (return* (read-eval-print-loop-rm))))

(define restart-rm
  (lambda ()
    (printf "Restarting...\n")
    (return* (read-eval-print-loop-rm))))

(define read-eval-print-loop-rm
  (lambda ()
    (let ((input 'undefined))
      (set! input (read-multiline "==> "))
      (let ((result 'undefined))
        (set! result (execute-rm input 'stdin))
        (while
          (not (end-of-session? result))
          (if (exception? result)
              (handle-exception result)
              (if (not (void? result))
                  (begin (if *need-newline* (newline)) (safe-print result))))
          (set! input (read-multiline "==> "))
          (set! result (execute-rm input 'stdin)))
        (return* 'goodbye)))))

(define execute-string-top
  (lambda (input source) (return* (execute-rm input source))))

(define execute-string-rm
  (lambda (input) (return* (execute-rm input 'stdin))))

(define execute-file-rm
  (lambda (filename)
    (return* (execute-rm (read-content filename) filename))))

(define execute-rm
  (lambda (input src)
    (set! load-stack '())
    (initialize-execute!)
    (set! k_reg REP-k)
    (set! fail_reg *last-fail*)
    (set! handler_reg REP-handler)
    (set! src_reg src)
    (set! input_reg input)
    (set! pc scan-input)
    (let ((result 'undefined))
      (set! result (trampoline))
      (if (exception? result)
          (return* result)
          (begin
            (set! *tokens-left* result)
            (if (token-type? (first *tokens-left*) 'end-marker)
                (return* void-value)
                (return* (execute-loop-rm src))))))))

(define execute-loop-rm
  (lambda (src)
    (execute-next-expression-rm src)
    (let ((result 'undefined))
      (set! result (trampoline))
      (if (or (exception? result)
              (end-of-session? result)
              (token-type? (first *tokens-left*) 'end-marker))
          (return* result)
          (return* (execute-loop-rm src))))))

(define execute-next-expression-rm
  (lambda (src)
    (set! k_reg (make-cont4 <cont4-10>))
    (set! fail_reg *last-fail*)
    (set! handler_reg REP-handler)
    (set! src_reg src)
    (set! tokens_reg *tokens-left*)
    (set! pc read-sexp)))

(define try-parse
  (lambda (input)
    (set! load-stack '())
    (set! k_reg (make-cont2 <cont2-50>))
    (set! fail_reg *last-fail*)
    (set! handler_reg try-parse-handler)
    (set! src_reg 'stdin)
    (set! input_reg input)
    (set! pc scan-input)
    (return* (trampoline))))

(define initialize-globals
  (lambda ()
    (set! toplevel-env (make-toplevel-env))
    (set! macro-env (make-macro-env^))
    (set! load-stack '())
    (initialize-execute!)
    (set! *last-fail* REP-fail)))

(define make-debugging-k
  (lambda (exp k) (return* (make-cont2 <cont2-51> exp k))))

(define highlight-expression
  (lambda (exp)
    (printf "call: ~s~%" (aunparse exp))
    (let ((info 'undefined))
      (set! info (rac exp))
      (if (not (eq? info 'none))
          (printf
            "['~a', line ~a, col ~a]~%"
            (get-srcfile info)
            (get-start-line info)
            (get-start-char info))))))

(define handle-debug-info
  (lambda (exp result)
    (printf "~s => ~a~%" (aunparse exp) (make-safe result))))

(define get-use-stack-trace
  (lambda () (return* *use-stack-trace*)))

(define set-use-stack-trace!
  (lambda (value) (set! *use-stack-trace* (true? value))))

(define initialize-stack-trace!
  (lambda () (set-car! *stack-trace* '())))

(define initialize-execute!
  (lambda ()
    (set! _closure_depth 0)
    (set! _trace_pause #f)
    (initialize-stack-trace!)))

(define push-stack-trace!
  (lambda (exp)
    (set-car! *stack-trace* (cons exp (car *stack-trace*)))))

(define pop-stack-trace!
  (lambda (exp)
    (if (not (null? (car *stack-trace*)))
        (set-car! *stack-trace* (cdr (car *stack-trace*))))))

(define*
  m
  (lambda ()
    (if *tracing-on?* (highlight-expression exp_reg))
    (let ((k 'undefined))
      (set! k
        (if *tracing-on?* (make-debugging-k exp_reg k_reg) k_reg))
      (if (eq? (car exp_reg) 'lit-aexp)
          (let ((datum 'undefined))
            (set! datum (list-ref exp_reg 1))
            (set! value2_reg fail_reg)
            (set! value1_reg datum)
            (set! k_reg k)
            (set! pc apply-cont2))
          (if (eq? (car exp_reg) 'var-aexp)
              (let ((id 'undefined) (info 'undefined))
                (set! info (list-ref exp_reg 2))
                (set! id (list-ref exp_reg 1))
                (set! k_reg k)
                (set! var-info_reg info)
                (set! var_reg id)
                (set! pc lookup-value))
              (if (eq? (car exp_reg) 'lexical-address-aexp)
                  (let ((depth 'undefined) (offset 'undefined))
                    (set! offset (list-ref exp_reg 2))
                    (set! depth (list-ref exp_reg 1))
                    (set! k_reg k)
                    (set! frames_reg (frames env_reg))
                    (set! offset_reg offset)
                    (set! depth_reg depth)
                    (set! pc lookup-value-by-lexical-address))
                  (if (eq? (car exp_reg) 'func-aexp)
                      (let ((exp 'undefined))
                        (set! exp (list-ref exp_reg 1))
                        (set! k_reg (make-cont2 <cont2-69> k))
                        (set! exp_reg exp)
                        (set! pc m))
                      (if (eq? (car exp_reg) 'callback-aexp)
                          (let ((exp 'undefined))
                            (set! exp (list-ref exp_reg 1))
                            (set! k_reg (make-cont2 <cont2-68> k))
                            (set! exp_reg exp)
                            (set! pc m))
                          (if (eq? (car exp_reg) 'if-aexp)
                              (let ((test-exp 'undefined)
                                    (then-exp 'undefined)
                                    (else-exp 'undefined))
                                (set! else-exp (list-ref exp_reg 3))
                                (set! then-exp (list-ref exp_reg 2))
                                (set! test-exp (list-ref exp_reg 1))
                                (set! k_reg
                                  (make-cont2 <cont2-67> else-exp then-exp env_reg handler_reg
                                    k))
                                (set! exp_reg test-exp)
                                (set! pc m))
                              (if (eq? (car exp_reg) 'help-aexp)
                                  (let ((var 'undefined) (var-info 'undefined))
                                    (set! var-info (list-ref exp_reg 2))
                                    (set! var (list-ref exp_reg 1))
                                    (set! sk_reg (make-cont2 <cont2-65> k))
                                    (set! dk_reg (make-cont3 <cont3-5> k))
                                    (set! gk_reg (make-cont2 <cont2-66> k))
                                    (set! var-info_reg var-info)
                                    (set! var_reg var)
                                    (set! pc lookup-variable))
                                  (if (eq? (car exp_reg) 'assign-aexp)
                                      (let ((var 'undefined)
                                            (rhs-exp 'undefined)
                                            (var-info 'undefined))
                                        (set! var-info (list-ref exp_reg 3))
                                        (set! rhs-exp (list-ref exp_reg 2))
                                        (set! var (list-ref exp_reg 1))
                                        (set! k_reg
                                          (make-cont2 <cont2-64> var var-info env_reg handler_reg k))
                                        (set! exp_reg rhs-exp)
                                        (set! pc m))
                                      (if (eq? (car exp_reg) 'define-aexp)
                                          (let ((var 'undefined)
                                                (docstring 'undefined)
                                                (rhs-exp 'undefined))
                                            (set! rhs-exp (list-ref exp_reg 3))
                                            (set! docstring (list-ref exp_reg 2))
                                            (set! var (list-ref exp_reg 1))
                                            (set! k_reg
                                              (make-cont2 <cont2-61> docstring var env_reg handler_reg k))
                                            (set! exp_reg rhs-exp)
                                            (set! pc m))
                                          (if (eq? (car exp_reg) 'define!-aexp)
                                              (let ((var 'undefined)
                                                    (docstring 'undefined)
                                                    (rhs-exp 'undefined))
                                                (set! rhs-exp (list-ref exp_reg 3))
                                                (set! docstring (list-ref exp_reg 2))
                                                (set! var (list-ref exp_reg 1))
                                                (set! k_reg (make-cont2 <cont2-59> docstring var k))
                                                (set! exp_reg rhs-exp)
                                                (set! pc m))
                                              (if (eq? (car exp_reg) 'define-syntax-aexp)
                                                  (let ((name 'undefined)
                                                        (clauses 'undefined)
                                                        (aclauses 'undefined))
                                                    (set! aclauses (list-ref exp_reg 3))
                                                    (set! clauses (list-ref exp_reg 2))
                                                    (set! name (list-ref exp_reg 1))
                                                    (set! k_reg (make-cont2 <cont2-58> aclauses clauses k))
                                                    (set! env_reg macro-env)
                                                    (set! var_reg name)
                                                    (set! pc lookup-binding-in-first-frame))
                                                  (if (eq? (car exp_reg) 'begin-aexp)
                                                      (let ((exps 'undefined))
                                                        (set! exps (list-ref exp_reg 1))
                                                        (set! k_reg k)
                                                        (set! exps_reg exps)
                                                        (set! pc eval-sequence))
                                                      (if (eq? (car exp_reg) 'lambda-aexp)
                                                          (let ((formals 'undefined) (bodies 'undefined))
                                                            (set! bodies (list-ref exp_reg 2))
                                                            (set! formals (list-ref exp_reg 1))
                                                            (set! value2_reg fail_reg)
                                                            (set! value1_reg (closure formals bodies env_reg))
                                                            (set! k_reg k)
                                                            (set! pc apply-cont2))
                                                          (if (eq? (car exp_reg) 'mu-lambda-aexp)
                                                              (let ((formals 'undefined)
                                                                    (runt 'undefined)
                                                                    (bodies 'undefined))
                                                                (set! bodies (list-ref exp_reg 3))
                                                                (set! runt (list-ref exp_reg 2))
                                                                (set! formals (list-ref exp_reg 1))
                                                                (set! value2_reg fail_reg)
                                                                (set! value1_reg (mu-closure formals runt bodies env_reg))
                                                                (set! k_reg k)
                                                                (set! pc apply-cont2))
                                                              (if (eq? (car exp_reg) 'trace-lambda-aexp)
                                                                  (let ((name 'undefined)
                                                                        (formals 'undefined)
                                                                        (bodies 'undefined))
                                                                    (set! bodies (list-ref exp_reg 3))
                                                                    (set! formals (list-ref exp_reg 2))
                                                                    (set! name (list-ref exp_reg 1))
                                                                    (set! value2_reg fail_reg)
                                                                    (set! value1_reg
                                                                      (trace-closure name formals bodies env_reg))
                                                                    (set! k_reg k)
                                                                    (set! pc apply-cont2))
                                                                  (if (eq? (car exp_reg) 'mu-trace-lambda-aexp)
                                                                      (let ((name 'undefined)
                                                                            (formals 'undefined)
                                                                            (runt 'undefined)
                                                                            (bodies 'undefined))
                                                                        (set! bodies (list-ref exp_reg 4))
                                                                        (set! runt (list-ref exp_reg 3))
                                                                        (set! formals (list-ref exp_reg 2))
                                                                        (set! name (list-ref exp_reg 1))
                                                                        (set! value2_reg fail_reg)
                                                                        (set! value1_reg
                                                                          (mu-trace-closure name formals runt bodies env_reg))
                                                                        (set! k_reg k)
                                                                        (set! pc apply-cont2))
                                                                      (if (eq? (car exp_reg) 'try-catch-aexp)
                                                                          (let ((body 'undefined)
                                                                                (cvar 'undefined)
                                                                                (cexps 'undefined))
                                                                            (set! cexps (list-ref exp_reg 3))
                                                                            (set! cvar (list-ref exp_reg 2))
                                                                            (set! body (list-ref exp_reg 1))
                                                                            (let ((new-handler 'undefined))
                                                                              (set! new-handler
                                                                                (try-catch-handler cvar cexps env_reg handler_reg k))
                                                                              (set! k_reg k)
                                                                              (set! handler_reg new-handler)
                                                                              (set! exp_reg body)
                                                                              (set! pc m)))
                                                                          (if (eq? (car exp_reg) 'try-finally-aexp)
                                                                              (let ((body 'undefined) (fexps 'undefined))
                                                                                (set! fexps (list-ref exp_reg 2))
                                                                                (set! body (list-ref exp_reg 1))
                                                                                (let ((new-handler 'undefined))
                                                                                  (set! new-handler
                                                                                    (try-finally-handler fexps env_reg handler_reg))
                                                                                  (set! k_reg
                                                                                    (make-cont2 <cont2-57> fexps env_reg handler_reg k))
                                                                                  (set! handler_reg new-handler)
                                                                                  (set! exp_reg body)
                                                                                  (set! pc m)))
                                                                              (if (eq? (car exp_reg) 'try-catch-finally-aexp)
                                                                                  (let ((body 'undefined)
                                                                                        (cvar 'undefined)
                                                                                        (cexps 'undefined)
                                                                                        (fexps 'undefined))
                                                                                    (set! fexps (list-ref exp_reg 4))
                                                                                    (set! cexps (list-ref exp_reg 3))
                                                                                    (set! cvar (list-ref exp_reg 2))
                                                                                    (set! body (list-ref exp_reg 1))
                                                                                    (let ((new-handler 'undefined))
                                                                                      (set! new-handler
                                                                                        (try-catch-finally-handler cvar cexps fexps env_reg
                                                                                          handler_reg k))
                                                                                      (set! k_reg
                                                                                        (make-cont2 <cont2-57> fexps env_reg handler_reg k))
                                                                                      (set! handler_reg new-handler)
                                                                                      (set! exp_reg body)
                                                                                      (set! pc m)))
                                                                                  (if (eq? (car exp_reg) 'raise-aexp)
                                                                                      (let ((exp 'undefined))
                                                                                        (set! exp (list-ref exp_reg 1))
                                                                                        (set! k_reg (make-cont2 <cont2-55> handler_reg))
                                                                                        (set! exp_reg exp)
                                                                                        (set! pc m))
                                                                                      (if (eq? (car exp_reg) 'choose-aexp)
                                                                                          (let ((exps 'undefined))
                                                                                            (set! exps (list-ref exp_reg 1))
                                                                                            (set! k_reg k)
                                                                                            (set! exps_reg exps)
                                                                                            (set! pc eval-choices))
                                                                                          (if (eq? (car exp_reg) 'app-aexp)
                                                                                              (let ((operator 'undefined)
                                                                                                    (operands 'undefined)
                                                                                                    (info 'undefined))
                                                                                                (set! info (list-ref exp_reg 3))
                                                                                                (set! operands (list-ref exp_reg 2))
                                                                                                (set! operator (list-ref exp_reg 1))
                                                                                                (set! k_reg
                                                                                                  (make-cont2 <cont2-54> exp_reg operator env_reg info
                                                                                                    handler_reg k))
                                                                                                (set! exps_reg operands)
                                                                                                (set! pc m*))
                                                                                              (error 'm
                                                                                                "bad abstract syntax: '~s'"
                                                                                                exp_reg))))))))))))))))))))))))))

(define make-exception
  (lambda (exception message source line column)
    (return*
      (list exception message source line column
        (make-stack-trace)))))

(define make-stack-trace
  (lambda ()
    (let ((trace 'undefined))
      (set! trace (car *stack-trace*))
      (return* (reverse (map format-stack-trace trace))))))

(define get-procedure-name
  (lambda (aexp)
    (if (macro-derived-source-info? aexp)
        (return* (rac (get-source-info aexp)))
        (if (eq? (car aexp) 'app-aexp)
            (let ((operator 'undefined))
              (set! operator (list-ref aexp 1))
              (if (eq? (car operator) 'lexical-address-aexp)
                  (let ((id 'undefined))
                    (set! id (list-ref operator 3))
                    (return* id))
                  (if (eq? (car operator) 'var-aexp)
                      (let ((id 'undefined))
                        (set! id (list-ref operator 1))
                        (return* id))
                      (if (eq? (car operator) 'lambda-aexp)
                          (let ((formals 'undefined))
                            (set! formals (list-ref operator 1))
                            (return*
                              (append
                                (list 'lambda)
                                (append (list formals) (list '...)))))
                          (if (eq? (car operator) 'mu-lambda-aexp)
                              (let ((formals 'undefined) (runt 'undefined))
                                (set! runt (list-ref operator 2))
                                (set! formals (list-ref operator 1))
                                (return*
                                  (append
                                    (list 'lambda)
                                    (append (list (append formals runt)) (list '...)))))
                              (if (eq? (car operator) 'trace-lambda-aexp)
                                  (let ((name 'undefined))
                                    (set! name (list-ref operator 1))
                                    (return* name))
                                  (if (eq? (car operator) 'mu-trace-lambda-aexp)
                                      (let ((name 'undefined))
                                        (set! name (list-ref operator 1))
                                        (return* name))
                                      (return* 'application))))))))
            (return* 'unknown)))))

(define format-stack-trace
  (lambda (exp)
    (let ((info 'undefined))
      (set! info (rac exp))
      (if (eq? info 'none)
          (return* 'macro-generated-exp)
          (return*
            (list
              (get-srcfile info)
              (get-start-line info)
              (get-start-char info)
              (get-procedure-name exp)))))))

(define*
  runtime-error
  (lambda ()
    (if (eq? info_reg 'none)
        (begin
          (set! exception_reg
            (make-exception "RunTimeError" msg_reg 'none 'none 'none))
          (set! pc apply-handler2))
        (let ((src 'undefined)
              (line_number 'undefined)
              (char_number 'undefined))
          (set! char_number (get-start-char info_reg))
          (set! line_number (get-start-line info_reg))
          (set! src (get-srcfile info_reg))
          (set! exception_reg
            (make-exception "RunTimeError" msg_reg src line_number
              char_number))
          (set! pc apply-handler2)))))

(define*
  m*
  (lambda ()
    (if (null? exps_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! pc apply-cont2))
        (begin
          (set! k_reg
            (make-cont2 <cont2-70> exps_reg env_reg handler_reg k_reg))
          (set! exp_reg (car exps_reg))
          (set! pc m)))))

(define*
  eval-sequence
  (lambda ()
    (if (null? (cdr exps_reg))
        (begin (set! exp_reg (car exps_reg)) (set! pc m))
        (begin
          (set! k_reg
            (make-cont2 <cont2-71> exps_reg env_reg handler_reg k_reg))
          (set! exp_reg (car exps_reg))
          (set! pc m)))))

(define try-catch-handler
  (lambda (cvar cexps env handler k)
    (return*
      (make-handler2 <handler2-4> cexps cvar env handler k))))

(define try-finally-handler
  (lambda (fexps env handler)
    (return* (make-handler2 <handler2-5> fexps env handler))))

(define try-catch-finally-handler
  (lambda (cvar cexps fexps env handler k)
    (return*
      (make-handler2 <handler2-6> cexps cvar fexps env handler
        k))))

(define*
  eval-choices
  (lambda ()
    (if (null? exps_reg)
        (set! pc apply-fail)
        (let ((new-fail 'undefined))
          (set! new-fail
            (make-fail <fail-5> exps_reg env_reg handler_reg fail_reg
              k_reg))
          (set! fail_reg new-fail)
          (set! exp_reg (car exps_reg))
          (set! pc m)))))

(define make-empty-docstrings
  (lambda (n)
    (if (= n 0)
        (return* '())
        (return* (cons "" (make-empty-docstrings (- n 1)))))))

(define closure
  (lambda (formals bodies env)
    (return* (make-proc <proc-1> bodies formals env))))

(define mu-closure
  (lambda (formals runt bodies env)
    (return* (make-proc <proc-2> bodies formals runt env))))

(define make-trace-depth-string
  (lambda (level)
    (if (= level 0)
        (return* "")
        (return*
          (string-append
            " |"
            (make-trace-depth-string (- level 1)))))))

(define trace-closure
  (lambda (name formals bodies env)
    (let ((trace-depth 'undefined))
      (set! trace-depth 0)
      (return*
        (make-proc <proc-3> bodies name trace-depth formals env)))))

(define continuation-object?
  (lambda (x)
    (return*
      (and (pair? x)
           (memq
             (car x)
             (list
               'continuation
               'continuation2
               'continuation3
               'continuation4))))))

(define mu-trace-closure
  (lambda (name formals runt bodies env)
    (let ((trace-depth 'undefined))
      (set! trace-depth 0)
      (return*
        (make-proc <proc-4> bodies name trace-depth formals runt
          env)))))

(define length-one?
  (lambda (ls)
    (return* (and (not (null? ls)) (null? (cdr ls))))))

(define length-two?
  (lambda (ls)
    (return*
      (and (not (null? ls))
           (not (null? (cdr ls)))
           (null? (cddr ls))))))

(define length-at-least?
  (lambda (n ls)
    (if (< n 1)
        (return* #t)
        (if (or (null? ls) (not (pair? ls)))
            (return* #f)
            (return* (length-at-least? (- n 1) (cdr ls)))))))

(define all-numeric?
  (lambda (ls)
    (return*
      (or (null? ls)
          (and (number? (car ls)) (all-numeric? (cdr ls)))))))

(define all-char?
  (lambda (ls)
    (return*
      (or (null? ls)
          (and (char? (car ls)) (all-char? (cdr ls)))))))

(define void? (lambda (x) (return* (eq? x void-value))))

(define end-of-session?
  (lambda (x) (return* (eq? x end-of-session))))

(define safe-print
  (lambda (arg)
    (set! *need-newline* #f)
    (pretty-print (make-safe arg))))

(define make-safe
  (lambda (x)
    (if (procedure-object? x)
        (return* '<procedure>)
        (if (environment-object? x)
            (return* '<environment>)
            (if (pair? x)
                (return* (cons (make-safe (car x)) (make-safe (cdr x))))
                (if (vector? x)
                    (return* (list->vector (make-safe (vector->list x))))
                    (return* x)))))))

(define procedure-object?
  (lambda (x)
    (return*
      (or (procedure? x)
          (and (pair? x) (eq? (car x) 'procedure))))))

(define environment-object?
  (lambda (x)
    (return* (and (pair? x) (eq? (car x) 'environment)))))

(define ends-with-newline?
  (lambda (s)
    (let ((len 'undefined))
      (set! len (string-length s))
      (return* (equal? (substring s (- len 1) len) "\n")))))

(define*
  load-file
  (lambda ()
    (if (member filename_reg load-stack)
        (begin
          (printf "skipping recursive load of ~a~%" filename_reg)
          (set! value2_reg fail_reg)
          (set! value1_reg void-value)
          (set! pc apply-cont2))
        (if (not (string? filename_reg))
            (begin
              (set! msg_reg
                (format "filename '~a' is not a string" filename_reg))
              (set! pc runtime-error))
            (if (not (file-exists? filename_reg))
                (begin
                  (set! msg_reg
                    (format
                      "attempted to load nonexistent file '~a'"
                      filename_reg))
                  (set! pc runtime-error))
                (begin
                  (set! load-stack (cons filename_reg load-stack))
                  (set! k_reg
                    (make-cont2 <cont2-79> filename_reg env2_reg handler_reg
                      k_reg))
                  (set! src_reg filename_reg)
                  (set! input_reg (read-content filename_reg))
                  (set! pc scan-input)))))))

(define*
  read-and-eval-asexps
  (lambda ()
    (if (token-type? (first tokens_reg) 'end-marker)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg void-value)
          (set! pc apply-cont2))
        (begin
          (set! k_reg
            (make-cont4 <cont4-13> src_reg env2_reg handler_reg k_reg))
          (set! pc read-sexp)))))

(define*
  load-files
  (lambda ()
    (if (null? filenames_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg void-value)
          (set! pc apply-cont2))
        (begin
          (set! k_reg
            (make-cont2 <cont2-82> filenames_reg env2_reg info_reg
              handler_reg k_reg))
          (set! filename_reg (car filenames_reg))
          (set! pc load-file)))))

(define*
  length-loop
  (lambda ()
    (if (null? x_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg sum_reg)
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (if (not (pair? x_reg))
            (begin
              (set! msg_reg
                (format "length called on improper list ~s" ls_reg))
              (set! pc runtime-error))
            (begin
              (set! sum_reg (+ sum_reg 1))
              (set! x_reg (cdr x_reg))
              (set! pc length-loop))))))

(define*
  make-set
  (lambda ()
    (if (null? lst_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg lst_reg)
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! k2_reg (make-cont2 <cont2-83> lst_reg k2_reg))
          (set! lst_reg (cdr lst_reg))
          (set! pc make-set)))))

(define*
  equal-objects?
  (lambda ()
    (if (or (and (null? x_reg) (null? y_reg))
            (and (boolean? x_reg)
                 (boolean? y_reg)
                 (or (and x_reg y_reg) (and (not x_reg) (not y_reg))))
            (and (symbol? x_reg) (symbol? y_reg) (eq? x_reg y_reg))
            (and (number? x_reg) (number? y_reg) (= x_reg y_reg))
            (and (char? x_reg) (char? y_reg) (char=? x_reg y_reg))
            (and (eq? x_reg void-value) (eq? y_reg void-value))
            (and (string? x_reg)
                 (string? y_reg)
                 (string=? x_reg y_reg)))
        (begin (set! value_reg #t) (set! pc apply-cont))
        (if (and (pair? x_reg) (pair? y_reg))
            (begin
              (set! k_reg (make-cont <cont-45> x_reg y_reg k_reg))
              (set! y_reg (car y_reg))
              (set! x_reg (car x_reg))
              (set! pc equal-objects?))
            (if (and (vector? x_reg)
                     (vector? y_reg)
                     (= (vector-length x_reg) (vector-length y_reg)))
                (begin
                  (set! i_reg (- (vector-length x_reg) 1))
                  (set! v2_reg y_reg)
                  (set! v1_reg x_reg)
                  (set! pc equal-vectors?))
                (begin (set! value_reg #f) (set! pc apply-cont)))))))

(define*
  equal-vectors?
  (lambda ()
    (if (< i_reg 0)
        (begin (set! value_reg #t) (set! pc apply-cont))
        (begin
          (set! k_reg (make-cont <cont-46> i_reg v1_reg v2_reg k_reg))
          (set! y_reg (vector-ref v2_reg i_reg))
          (set! x_reg (vector-ref v1_reg i_reg))
          (set! pc equal-objects?)))))

(define*
  member-loop
  (lambda ()
    (if (null? y_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg #f)
          (set! pc apply-cont2))
        (if (not (pair? y_reg))
            (begin
              (set! msg_reg
                (format "member called on improper list ~s" ls_reg))
              (set! pc runtime-error))
            (begin
              (set! k_reg
                (make-cont <cont-47> ls_reg x_reg y_reg info_reg handler_reg
                  fail_reg k_reg))
              (set! y_reg (car y_reg))
              (set! pc equal-objects?))))))

(define*
  get-primitive
  (lambda ()
    (let ((sym 'undefined))
      (set! sym (car args_reg))
      (set! k_reg
        (make-cont2 <cont2-85> args_reg sym info_reg handler_reg
          k_reg))
      (set! var-info_reg 'none)
      (set! var_reg sym)
      (set! pc lookup-value))))

(define*
  append2
  (lambda ()
    (if (null? ls1_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg ls2_reg)
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (begin
          (set! k2_reg (make-cont2 <cont2-86> ls1_reg k2_reg))
          (set! ls1_reg (cdr ls1_reg))
          (set! pc append2)))))

(define*
  append-all
  (lambda ()
    (if (null? lists_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (if (null? (cdr lists_reg))
            (begin
              (set! value2_reg fail_reg)
              (set! value1_reg (car lists_reg))
              (set! k_reg k2_reg)
              (set! pc apply-cont2))
            (if (not (list? (car lists_reg)))
                (begin
                  (set! msg_reg
                    (format
                      "append called on incorrect list structure ~s"
                      (car lists_reg)))
                  (set! pc runtime-error))
                (begin
                  (set! k2_reg (make-cont2 <cont2-87> lists_reg k2_reg))
                  (set! lists_reg (cdr lists_reg))
                  (set! pc append-all)))))))

(define directory
  (lambda (args env)
    (if (or (null? args) (environment? (car args)))
        (return*
          (sort
            symbol<?
            (if (null? args)
                (append
                  (get-variables-from-frames (frames macro-env))
                  (get-variables-from-frames (frames env)))
                (get-variables-from-frames (frames (car args))))))
        (return* (get-external-members (car args))))))

(define get-variables-from-frame
  (lambda (frame) (return* (cadr frame))))

(define get-variables-from-frames
  (lambda (frames)
    (return* (flatten (map get-variables-from-frame frames)))))

(define symbol<?
  (lambda (a b)
    (let ((a_string 'undefined) (b_string 'undefined))
      (set! b_string (symbol->string b))
      (set! a_string (symbol->string a))
      (return* (string<? a_string b_string)))))

(define flatten
  (lambda (lists)
    (if (null? lists)
        (return* '())
        (if (list? (car lists))
            (return*
              (append (flatten (car lists)) (flatten (cdr lists))))
            (return* (cons (car lists) (flatten (cdr lists))))))))

(define get-current-time
  (lambda ()
    (let ((now 'undefined))
      (set! now (current-time))
      (return*
        (+ (time-second now)
           (inexact (/ (time-nanosecond now) 1000000000)))))))

(define*
  map-primitive
  (lambda ()
    (if (iterator? (car args_reg))
        (begin
          (set! generator_reg (car args_reg))
          (set! pc iterate-collect))
        (let ((len 'undefined) (list-args 'undefined))
          (set! list-args (listify args_reg))
          (set! len (length args_reg))
          (if (= len 1)
              (begin (set! list1_reg (car list-args)) (set! pc map1))
              (if (= len 2)
                  (begin
                    (set! list2_reg (cadr list-args))
                    (set! list1_reg (car list-args))
                    (set! pc map2))
                  (begin (set! lists_reg list-args) (set! pc mapN))))))))

(define listify
  (lambda (arg-list)
    (if (null? arg-list)
        (return* '())
        (if (list? (car arg-list))
            (return* (cons (car arg-list) (listify (cdr arg-list))))
            (if (vector? (car arg-list))
                (return*
                  (cons
                    (vector->list (car arg-list))
                    (listify (cdr arg-list))))
                (if (string? (car arg-list))
                    (return*
                      (cons
                        (string->list (car arg-list))
                        (listify (cdr arg-list))))
                    (error 'map
                      "cannot use object type '~a' in map"
                      (get_type (car arg-list)))))))))

(define*
  iterate
  (lambda ()
    (let ((iterator 'undefined))
      (set! iterator (get-iterator generator_reg))
      (set! iterator_reg iterator)
      (set! pc iterate-continue))))

(define*
  iterate-continue
  (lambda ()
    (let ((item 'undefined))
      (set! item (next-item iterator_reg))
      (if (null? item)
          (begin
            (set! value2_reg fail_reg)
            (set! value1_reg '())
            (set! pc apply-cont2))
          (begin
            (set! k2_reg
              (make-cont2 <cont2-88> iterator_reg proc_reg env_reg
                handler_reg k_reg))
            (set! info_reg 'none)
            (set! env2_reg env_reg)
            (set! args_reg (list item))
            (set! pc apply-proc))))))

(define*
  iterate-collect
  (lambda ()
    (let ((iterator 'undefined))
      (set! iterator (get-iterator generator_reg))
      (set! iterator_reg iterator)
      (set! pc iterate-collect-continue))))

(define*
  iterate-collect-continue
  (lambda ()
    (let ((item 'undefined))
      (set! item (next-item iterator_reg))
      (if (null? item)
          (begin
            (set! value2_reg fail_reg)
            (set! value1_reg '())
            (set! pc apply-cont2))
          (begin
            (set! k2_reg
              (make-cont2 <cont2-89> iterator_reg proc_reg env_reg
                handler_reg k_reg))
            (set! info_reg 'none)
            (set! env2_reg env_reg)
            (set! args_reg (list item))
            (set! pc apply-proc))))))

(define*
  map1
  (lambda ()
    (if (null? list1_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! pc apply-cont2))
        (if (dlr-proc? proc_reg)
            (begin
              (set! k_reg
                (make-cont2 <cont2-91> list1_reg proc_reg k_reg))
              (set! list1_reg (cdr list1_reg))
              (set! pc map1))
            (begin
              (set! k2_reg
                (make-cont2 <cont2-90> list1_reg proc_reg env_reg
                  handler_reg k_reg))
              (set! info_reg 'none)
              (set! env2_reg env_reg)
              (set! args_reg (list (car list1_reg)))
              (set! pc apply-proc))))))

(define*
  map2
  (lambda ()
    (if (null? list1_reg)
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! pc apply-cont2))
        (if (dlr-proc? proc_reg)
            (begin
              (set! k_reg
                (make-cont2 <cont2-93> list1_reg list2_reg proc_reg k_reg))
              (set! list2_reg (cdr list2_reg))
              (set! list1_reg (cdr list1_reg))
              (set! pc map2))
            (begin
              (set! k2_reg
                (make-cont2 <cont2-92> list1_reg list2_reg proc_reg env_reg
                  handler_reg k_reg))
              (set! info_reg 'none)
              (set! env2_reg env_reg)
              (set! args_reg (list (car list1_reg) (car list2_reg)))
              (set! pc apply-proc))))))

(define*
  mapN
  (lambda ()
    (if (null? (car lists_reg))
        (begin
          (set! value2_reg fail_reg)
          (set! value1_reg '())
          (set! pc apply-cont2))
        (if (dlr-proc? proc_reg)
            (begin
              (set! k_reg
                (make-cont2 <cont2-95> lists_reg proc_reg k_reg))
              (set! lists_reg (map cdr lists_reg))
              (set! pc mapN))
            (begin
              (set! k2_reg
                (make-cont2 <cont2-94> lists_reg proc_reg env_reg
                  handler_reg k_reg))
              (set! info_reg 'none)
              (set! env2_reg env_reg)
              (set! args_reg (map car lists_reg))
              (set! pc apply-proc))))))

(define*
  for-each-primitive
  (lambda ()
    (if (iterator? (car lists_reg))
        (begin
          (set! generator_reg (car lists_reg))
          (set! pc iterate))
        (let ((arg-list 'undefined))
          (set! arg-list (listify lists_reg))
          (if (null? (car arg-list))
              (begin
                (set! value2_reg fail_reg)
                (set! value1_reg void-value)
                (set! pc apply-cont2))
              (if (dlr-proc? proc_reg)
                  (begin
                    (dlr-apply proc_reg (map car arg-list))
                    (set! lists_reg (map cdr arg-list))
                    (set! pc for-each-primitive))
                  (begin
                    (set! k2_reg
                      (make-cont2 <cont2-96> arg-list proc_reg env_reg handler_reg
                        k_reg))
                    (set! info_reg 'none)
                    (set! env2_reg env_reg)
                    (set! args_reg (map car arg-list))
                    (set! pc apply-proc))))))))

(define make-toplevel-env
  (lambda ()
    (let ((primitives 'undefined))
      (set! primitives
        (list
         (list
           '*
           times-prim
           "(* ...): multiplication procedure; multiplies all arguments")
         (list
           '+
           plus-prim
           "(+ ...): addition procedure; adds all arguments")
         (list
           '-
           minus-prim
           "(- ...): subtraction procedure; subtracts all arguments")
         (list
           '/
           divide-prim
           "(/ ...): division procedure; divides all arguments")
         (list
           'div
           quotient-prim
           "(div arg0 arg1): quotient procedure for rationals/ints; divides arg0 by arg1 (aliases // and quotient)")
         (list
           '%
           modulo-prim
           "(% arg0 arg1): modulo procedure for two arguments (aliases mod and modulo)")
         (list
           'mod
           modulo-prim
           "(mod arg0 arg1): modulo procedure for two arguments (aliases % and modulo)")
         (list
           'modulo
           modulo-prim
           "(modulo arg0 arg1): modulo procedure for two arguments (aliases mod and %)")
         (list
           '//
           quotient-prim
           "(// arg0 arg1): quotient procedure for rationals/ints; divides arg0 by arg1 (aliases div and quotient)")
         (list
           'quotient
           quotient-prim
           "(quotient arg0 arg1): quotient procedure for rationals/ints; divides arg0 by arg1 (aliases // and div)")
         (list
           '<
           lt-prim
           "(< arg0 arg1): less-than procedure for two arguments")
         (list
           '<=
           lt-or-eq-prim
           "(<= arg0 arg1): less-than or equal procedure for two arguments")
         (list
           '=
           equal-sign-prim
           "(= arg0 arg1): numeric equality procedure for two arguments")
         (list
           '>
           gt-prim
           "(> arg0 arg1): greater-than procedure for two arguments")
         (list
           '>=
           gt-or-eq-prim
           "(>= arg0 arg1): greater-than or equal procedure for two arguments")
         (list
           'abort
           abort-prim
           "(abort) : aborts processing and returns to top level")
         (list 'abs abs-prim "(abs value): absolute value procedure")
         (list
           'append
           append-prim
           "(append ...): append lists together into a single list")
         (list
           'apply
           apply-prim
           "(apply PROCEDURE '(args...)): apply the PROCEDURE to the args")
         (list
           'assv
           assv-prim
           "(assv KEY ((ITEM VALUE) ...)): look for KEY in ITEMs; return matching (ITEM VALUE) or #f if not found")
         (list
           'boolean?
           boolean?-prim
           "(boolean? ITEM): return #t if ITEM is a boolean value")
         (list
           'caddr
           caddr-prim
           "(caddr ITEM): return the (car (cdr (cdr ITEM)))")
         (list
           'cadr
           cadr-prim
           "(cadr ITEM): return the (car (cdr ITEM))")
         (list
           'call-with-current-continuation
           call/cc-prim
           "(call-with-current-continuation ...): ")
         (list 'call/cc call/cc-prim "(call/cc ...): ")
         (list
           'car
           car-prim
           "(car LIST) returns the first element of LIST")
         (list
           'cdr
           cdr-prim
           "(cdr LIST) returns rest of LIST after (car LIST)")
         (list 'caaaar caaaar-prim "caaaar ...): ")
         (list 'caaadr caaadr-prim "(caaadr ...): ")
         (list 'caaar caaar-prim "(caaar ...): ")
         (list 'caadar caadar-prim "(caadar ...): ")
         (list 'caaddr caaddr-prim "(caaddr ...): ")
         (list 'caadr caadr-prim "(caadr ...): ")
         (list 'caar caar-prim "(caar ...): ")
         (list 'cadaar cadaar-prim "(cadaar ...): ")
         (list 'cadadr cadadr-prim "(cadadr ...): ")
         (list 'cadar cadar-prim "(cadar ...): ")
         (list 'caddar caddar-prim "(caddar ...): ")
         (list 'cadddr cadddr-prim "(cadddr ...): ")
         (list 'cdaaar cdaaar-prim "(cdaaar ...): ")
         (list 'cdaadr cdaadr-prim "(cdaadr ...): ")
         (list 'cdaar cdaar-prim "(cdaar ...): ")
         (list 'cdadar cdadar-prim "(cdadar ...): ")
         (list 'cdaddr cdaddr-prim "(cdaddr ...): ")
         (list 'cdadr cdadr-prim "(cdadr ...): ")
         (list 'cdar cdar-prim "(cdar ...): ")
         (list 'cddaar cddaar-prim "(cddaar ...): ")
         (list 'cddadr cddadr-prim "(cddadr ...): ")
         (list 'cddar cddar-prim "(cddar ...): ")
         (list 'cdddar cdddar-prim "(cdddar ...): ")
         (list 'cddddr cddddr-prim "(cddddr ...): ")
         (list 'cdddr cdddr-prim "(cdddr ...): ")
         (list 'cddr cddr-prim "(cddr ...): ")
         (list
           'char?
           char?-prim
           "(char? ITEM): return #t if ITEM is a character, #f otherwise")
         (list
           'char=?
           char=?-prim
           "(char=? CHAR1 CHAR2): return #t if CHAR1 has the same values as CHAR2, #f otherwise")
         (list
           'char-whitespace?
           char-whitespace?-prim
           "(char-whitespace? CHAR): return #t if CHAR is a whitespace character, #f otherwise")
         (list
           'char-alphabetic?
           char-alphabetic?-prim
           "(char-alphabetic? CHAR): return #t if CHAR is an alphabetic character, #f otherwise")
         (list
           'char-numeric?
           char-numeric?-prim
           "(char-numeric? CHAR): return #t if CHAR is a whitespace character, #f otherwise")
         (list
           'char->integer
           char->integer-prim
           "(char->integer CHAR): return associated number of CHAR ")
         (list
           'cons
           cons-prim
           "(cons ITEM1 ITEM2): return a list with ITEM1 as car and ITEM2 as cdr (ITEM2 is typically a list)")
         (list
           'current-time
           current-time-prim
           "(current-time): returns the current time as number of seconds since 1970-1-1")
         (list
           'cut
           cut-prim
           "(cut ARGS...): return to toplevel with ARGS")
         (list
           'dir
           dir-prim
           "(dir [ITEM]): return items in environment, or, if ITEM is given, the items in module")
         (list
           'display
           display-prim
           "(display ITEM): display the ITEM as output")
         (list
           'current-environment
           current-environment-prim
           "(current-environment): returns the current environment")
         (list
           'eq?
           eq?-prim
           "(eq? ITEM1 ITEM2): return #t if ITEM1 is eq to ITEM2, #f otherwise")
         (list
           'equal?
           equal?-prim
           "(equal? ITEM1 ITEM2): return #t if ITEM1 is equal to ITEM2, #f otherwise")
         (list
           'error
           error-prim
           "(error NAME MESSAGE): create an exception in NAME with MESSAGE")
         (list
           'eval
           eval-prim
           "(eval LIST): evaluates the LIST as a Scheme expression")
         (list
           'eval-ast
           eval-ast-prim
           "(eval-ast AST): evaluates the Abstract Syntax Tree as a Scheme expression (see parse and parse-string)")
         (list 'exit exit-prim "(exit): ")
         (list
           'for-each
           for-each-prim
           "(for-each PROCEDURE LIST): apply PROCEDURE to each item in LIST, but don't return results")
         (list
           'format
           format-prim
           "(format STRING ITEM ...): format the string with ITEMS as arguments")
         (list 'get get-prim "(get ...): ")
         (list
           'get-stack-trace
           get-stack-trace-prim
           "(get-stack-trace): return the current stack trace")
         (list
           'load-as
           load-as-prim
           "(load-as FILENAME MODULE-NAME): load the filename, putting items in MODULE-NAME namespace")
         (list
           'integer->char
           integer->char-prim
           "(integer->char INTEGER): return the assocated character of INTEGER")
         (list
           'length
           length-prim
           "(length LIST): returns the number of elements in top level of LIST")
         (list
           'list
           list-prim
           "(list ITEM ...): returns a list composed of all of the items")
         (list
           'list->vector
           list->vector-prim
           "(list->vector LIST): returns the LIST as a vector")
         (list
           'list->string
           list->string-prim
           "(list->string LIST): returns the LIST as a string")
         (list
           'list-ref
           list-ref-prim
           "(list-ref LIST INDEX): returns the item in LIST at INDEX (zero-based)")
         (list
           'load
           load-prim
           "(load FILENAME...): loads the given FILENAMEs")
         (list
           'min
           min-prim
           "(min ...): returns the minimum value from the list of values")
         (list
           'max
           max-prim
           "(max ...): returns the maximum value from the list of values")
         (list
           'make-set
           make-set-prim
           "(make-set LIST): returns a list of unique items from LIST")
         (list
           'make-vector
           make-vector-prim
           "(make-vector LIST): returns a vector from LIST")
         (list
           'map
           map-prim
           "(map PROCEDURE LIST...): apply PROCEDURE to each element of LIST, and return return results")
         (list
           'member
           member-prim
           "(member ITEM LIST): return #t if MEMBER in top level of LIST")
         (list 'memq memq-prim "(memq ...): ")
         (list 'memv memv-prim "(memv ...): ")
         (list
           'newline
           newline-prim
           "(newline): displays a new line in output")
         (list
           'not
           not-prim
           "(not ITEM): returns the boolean not of ITEM; ITEM is only #t when #t, otherwise #f")
         (list
           'null?
           null?-prim
           "(null? ITEM): return #t if ITEM is empty list, #f otherwise")
         (list
           'number->string
           number->string-prim
           "(number->string NUMBER): return NUMBER as a string")
         (list
           'number?
           number?-prim
           "(number? ITEM): return #t if ITEM is a number, #f otherwise")
         (list 'pair? pair?-prim "(pair? ITEM): ")
         (list
           'parse
           parse-prim
           "(parse LIST): parse a list; returns Abstract Syntax Tree (AST)")
         (list
           'parse-string
           parse-string-prim
           "(parse-string STRING): parse a string; returns Abstract Syntax Tree (AST)")
         (list 'print print-prim "(print ITEM): ")
         (list 'printf printf-prim "(printf FORMAT ARGS...): ")
         (list
           'range
           range-prim
           "(range END), (range START END), or (RANGE START END STEP): (all integers)")
         (list 'read-string read-string-prim "(read-string ...): ")
         (list 'require require-prim "(require ...): ")
         (list 'reverse reverse-prim "(reverse LIST): ")
         (list
           'set-car!
           set-car!-prim
           "(set-car! LIST ITEM): set the car of LIST to be ITEM")
         (list
           'set-cdr!
           set-cdr!-prim
           "(set-cdr! LIST ITEM): set the car of LIST to be ITEM (which is typically a list)")
         (list
           'snoc
           snoc-prim
           "(snoc ITEM LIST): cons the ITEM onto the end of LIST")
         (list
           'rac
           rac-prim
           "(rac LIST): return the last item of LIST")
         (list
           'rdc
           rdc-prim
           "(rdc LIST): return everything but last item in LIST")
         (list
           'sqrt
           sqrt-prim
           "(sqrt NUMBER): return the square root of NUMBER")
         (list
           'odd?
           odd?-prim
           "(odd? NUMBER): returns #t if NUMBER is even, #f otherwise")
         (list
           'even?
           even?-prim
           "(even? NUMBER): returns #t if NUMBER is odd, #f otherwise")
         (list
           'remainder
           remainder-prim
           "(remainder NUMBER1 NUMBER2): returns the remainder after dividing NUMBER1 by NUMBER2")
         (list
           'string
           string-prim
           "(string ITEM): returns ITEM as a string")
         (list
           'string-length
           string-length-prim
           "(string-length STRING): returns the length of a string")
         (list
           'string-ref
           string-ref-prim
           "(string-ref STRING INDEX): return the character of STRING at position INDEX")
         (list
           'string?
           string?-prim
           "(string? ITEM): return #t if ITEM is a string, #f otherwise")
         (list
           'string->number
           string->number-prim
           "(string->number STRING): return STRING as a number")
         (list
           'string=?
           string=?-prim
           "(string=? STRING1 STRING2): return #t if STRING1 is the same as STRING2, #f otherwise")
         (list
           'substring
           substring-prim
           "(substring STRING START [END]): return the substring of STRING starting with position START and ending before END. If END is not provided, it defaults to the length of the STRING")
         (list
           'symbol?
           symbol?-prim
           "(symbol? ITEM): return #t if ITEM is a symbol, #f otherwise")
         (list 'unparse unparse-prim "(unparse AST): ")
         (list
           'unparse-procedure
           unparse-procedure-prim
           "(unparse-procedure ...): ")
         (list
           'import
           import-prim
           "(import MODULE...): import host-system modules; MODULEs are strings")
         (list
           'import-as
           import-as-prim
           "(import-as MODULE NAME): import a host-system module; MODULE is a string, and NAME is a symbol or string. Use * for NAME to import into toplevel environment")
         (list
           'import-from
           import-from-prim
           "(import-from MODULE NAME...): import from host-system module; MODULE is a string, and NAME is a symbol or string")
         (list
           'use-stack-trace
           use-stack-trace-prim
           "(use-stack-trace BOOLEAN): set stack-trace usage on/off")
         (list
           'vector
           vector-prim
           "(vector [ITEMS]...): return ITEMs as a vector")
         (list
           'vector-ref
           vector-ref-prim
           "(vector-ref VECTOR INDEX): ")
         (list
           'vector-set!
           vector-set!-prim
           "(vector-set! VECTOR INDEX VALUE): ")
         (list 'void void-prim "(void): The null value symbol")
         (list
           'zero?
           zero?-prim
           "(zero? NUMBER): return #t if NUMBER is equal to zero, #f otherwise")
         (list
           'current-directory
           current-directory-prim
           "(current-directory [PATH]): get the current directory, or set it if PATH is given (alias cd)")
         (list
           'cd
           current-directory-prim
           "(cd [PATH]): get the current directory, or set it if PATH is given (alias current-directory)")
         (list
           'round
           round-prim
           "(round NUMBER): round NUMBER to the nearest integer (may return float)")
         (list
           'char->string
           char->string-prim
           "(char->string CHAR): ")
         (list
           'string->list
           string->list-prim
           "(string->list STRING): string STRING as a list of characters")
         (list
           'string->symbol
           string->symbol-prim
           "(string->symbol STRING): return STRING as a symbol")
         (list
           'symbol->string
           symbol->string-prim
           "(symbol->string SYMBOL): return SYMBOL as a string")
         (list
           'vector->list
           vector->list-prim
           "(vector->list VECTOR): return VECTOR as a list")
         (list
           'eqv?
           eqv?-prim
           "(eqv? ITEM1 ITEM2): return #t if ITEM1 and ITEM2 have the same value")
         (list
           'vector?
           vector?-prim
           "(vector? ITEM): return #t if ITEM is a vector, #f otherwise")
         (list
           'atom?
           atom?-prim
           "(atom? ITEM): return #t if ITEM is a atom, #f otherwise")
         (list
           'iter?
           iter?-prim
           "(iter? ITEM): return #t if ITEM is a iterator, #f otherwise")
         (list
           'list?
           list?-prim
           "(list? ITEM): return #t if ITEM is a list, #f otherwise")
         (list
           'procedure?
           procedure?-prim
           "(procedure? ITEM): return #t if ITEM is a procedure, #f otherwise")
         (list
           'string<?
           string<?-prim
           "(string<? STRING1 STRING2): compare two strings to see if STRING1 is less than STRING2")
         (list
           'float
           float-prim
           "(float NUMBER): return NUMBER as a floating point value")
         (list
           'globals
           globals-prim
           "(globals): get global environment")
         (list
           'int
           int-prim
           "(int NUMBER): return NUMBER as an integer")
         (list
           'apply-with-keywords
           apply-with-keywords-prim
           "(apply-with-keywords PROCEDURE ...): ")
         (list 'assq assq-prim "(assq ...): ")
         (list 'dict dict-prim "(dict ...): ")
         (list
           'contains
           contains-prim
           "(contains DICTIONARY ITEM): returns #t if DICTIONARY contains ITEM")
         (list
           'getitem
           getitem-prim
           "(getitem DICTIONARY ITEM): returns the VALUE of DICTIONARY[ITEM]")
         (list
           'setitem
           setitem-prim
           "(setitem DICTIONARY ITEM VALUE): sets and returns DICTIONARY[ITEM] with VALUE")
         (list 'property property-prim "(property ...): ")
         (list
           'rational
           rational-prim
           "(rational NUMERATOR DENOMINTAOR): return a rational number")
         (list
           'reset-toplevel-env
           reset-toplevel-env-prim
           "(reset-toplevel-env): reset the toplevel environment")
         (list
           'sort
           sort-prim
           "(sort PROCEDURE LIST): sort the list using PROCEDURE to compare items")
         (list
           'string-append
           string-append-prim
           "(string-append STRING1 STRING2): append two strings together")
         (list
           'string-split
           string-split-prim
           "(string-split STRING CHAR): return a list with substrings of STRING where split by CHAR")
         (list
           'symbol
           symbol-prim
           "(symbol STRING): turn STRING into a symbol")
         (list
           'typeof
           typeof-prim
           "(typeof ITEM): returns type of ITEM")
         (list
           'use-lexical-address
           use-lexical-address-prim
           "(use-lexical-address [BOOLEAN]): get lexical-address setting, or set it on/off if BOOLEAN is given")
         (list
           'use-tracing
           use-tracing-prim
           "(use-tracing [BOOLEAN]): get tracing setting, or set it on/off if BOOLEAN is given")))
      (return*
        (make-initial-env-extended
          (map car primitives)
          (map cadr primitives)
          (map caddr primitives))))))

(define reset-toplevel-env
  (lambda ()
    (set! toplevel-env (make-toplevel-env))
    (return* void-value)))

(define make-external-proc
  (lambda (external-function-object)
    (return* (make-proc <proc-167> external-function-object))))

(define pattern?
  (lambda (x)
    (return*
      (or (null? x)
          (number? x)
          (boolean? x)
          (symbol? x)
          (and (pair? x) (pattern? (car x)) (pattern? (cdr x)))))))

(define pattern-variable?
  (lambda (x)
    (return*
      (and (symbol? x)
           (equal? "?" (substring (symbol->string x) 0 1))))))

(define constant?
  (lambda (x)
    (return*
      (and (not (pattern-variable? x)) (not (pair? x))))))

(define*
  occurs?
  (lambda ()
    (if (constant? pattern_reg)
        (begin (set! value_reg #f) (set! pc apply-cont))
        (if (pattern-variable? pattern_reg)
            (begin
              (set! value_reg (equal? var_reg pattern_reg))
              (set! pc apply-cont))
            (begin
              (set! k_reg (make-cont <cont-48> pattern_reg var_reg k_reg))
              (set! pattern_reg (car pattern_reg))
              (set! pc occurs?))))))

(define*
  unify-patterns^
  (lambda ()
    (if (pattern-variable? p1_reg)
        (if (pattern-variable? p2_reg)
            (begin
              (set! value_reg (make-sub 'unit p1_reg p2_reg ap2_reg))
              (set! pc apply-cont))
            (begin
              (set! k_reg
                (make-cont <cont-49> ap2_reg p1_reg p2_reg k_reg))
              (set! pattern_reg p2_reg)
              (set! var_reg p1_reg)
              (set! pc occurs?)))
        (if (pattern-variable? p2_reg)
            (begin
              (set! temp_1 p2_reg)
              (set! temp_2 p1_reg)
              (set! temp_3 ap2_reg)
              (set! temp_4 ap1_reg)
              (set! p1_reg temp_1)
              (set! p2_reg temp_2)
              (set! ap1_reg temp_3)
              (set! ap2_reg temp_4)
              (set! pc unify-patterns^))
            (if (and (constant? p1_reg)
                     (constant? p2_reg)
                     (equal? p1_reg p2_reg))
                (begin
                  (set! value_reg (make-sub 'empty))
                  (set! pc apply-cont))
                (if (and (pair? p1_reg) (pair? p2_reg))
                    (begin
                      (set! apair2_reg ap2_reg)
                      (set! apair1_reg ap1_reg)
                      (set! pair2_reg p2_reg)
                      (set! pair1_reg p1_reg)
                      (set! pc unify-pairs^))
                    (begin (set! value_reg #f) (set! pc apply-cont))))))))

(define*
  unify-pairs^
  (lambda ()
    (set! k_reg
      (make-cont <cont-51> apair1_reg apair2_reg pair1_reg
        pair2_reg k_reg))
    (set! ap2_reg (car^ apair2_reg))
    (set! ap1_reg (car^ apair1_reg))
    (set! p2_reg (car pair2_reg))
    (set! p1_reg (car pair1_reg))
    (set! pc unify-patterns^)))

(define*
  instantiate^
  (lambda ()
    (if (constant? pattern_reg)
        (begin
          (set! value2_reg ap_reg)
          (set! value1_reg pattern_reg)
          (set! k_reg k2_reg)
          (set! pc apply-cont2))
        (if (pattern-variable? pattern_reg)
            (begin
              (set! avar_reg ap_reg)
              (set! var_reg pattern_reg)
              (set! pc apply-sub^))
            (if (pair? pattern_reg)
                (begin
                  (set! k2_reg
                    (make-cont2 <cont2-100> ap_reg pattern_reg s_reg k2_reg))
                  (set! ap_reg (car^ ap_reg))
                  (set! pattern_reg (car pattern_reg))
                  (set! pc instantiate^))
                (error 'instantiate^ "bad pattern: ~a" pattern_reg))))))

(define make-sub
  (lambda args (return* (cons 'substitution args))))

(define*
  apply-sub^
  (lambda ()
    (let ((temp_1 'undefined))
      (set! temp_1 (cdr s_reg))
      (if (eq? (car temp_1) 'empty)
          (begin
            (set! value2_reg avar_reg)
            (set! value1_reg var_reg)
            (set! k_reg k2_reg)
            (set! pc apply-cont2))
          (if (eq? (car temp_1) 'unit)
              (let ((new-var 'undefined)
                    (new-pattern 'undefined)
                    (new-apattern 'undefined))
                (set! new-apattern (list-ref temp_1 3))
                (set! new-pattern (list-ref temp_1 2))
                (set! new-var (list-ref temp_1 1))
                (if (equal? var_reg new-var)
                    (begin
                      (set! value2_reg new-apattern)
                      (set! value1_reg new-pattern)
                      (set! k_reg k2_reg)
                      (set! pc apply-cont2))
                    (begin
                      (set! value2_reg avar_reg)
                      (set! value1_reg var_reg)
                      (set! k_reg k2_reg)
                      (set! pc apply-cont2))))
              (if (eq? (car temp_1) 'composite)
                  (let ((s1 'undefined) (s2 'undefined))
                    (set! s2 (list-ref temp_1 2))
                    (set! s1 (list-ref temp_1 1))
                    (set! k2_reg (make-cont2 <cont2-101> s2 k2_reg))
                    (set! s_reg s1)
                    (set! pc apply-sub^))
                  (error 'apply-sub^ "bad substitution: ~a" s_reg)))))))

(define chars-to-scan 'undefined)

(define scan-line 'undefined)

(define scan-char 'undefined)

(define scan-position 'undefined)

(define last-scan-line 'undefined)

(define last-scan-char 'undefined)

(define last-scan-position 'undefined)

(define token-start-line 'undefined)

(define token-start-char 'undefined)

(define token-start-position 'undefined)

(define atom-tag (box 'atom))

(define pair-tag (box 'pair))

(define *reader-generates-annotated-sexps?* #t)

(define init-cont (make-cont <cont-11>))

(define init-cont2 (make-cont2 <cont2-2>))

(define init-cont3 (make-cont3 <cont3-2>))

(define init-cont4 (make-cont4 <cont4-8>))

(define init-handler (make-handler <handler-1>))

(define init-handler2 (make-handler2 <handler2-1>))

(define init-fail (make-fail <fail-1>))

(define-native
  search-frame
  (lambda (frame var)
    (search-for-binding var (car frame) (cadr frame) 0)))

(define-native
  search-for-binding
  (lambda (var bindings variables i)
    (if (null? variables)
        #f
        (if (eq? (car variables) var)
            (vector-ref bindings i)
            (search-for-binding
              var
              bindings
              (cdr variables)
              (+ i 1))))))

(define *use-lexical-address* #t)

(define-native dlr-proc? (lambda (x) #f))

(define-native dlr-apply apply)

(define-native dlr-func (lambda (x) x))

(define-native callback (lambda args #f))

(define-native dlr-env-contains (lambda (x) #f))

(define-native dlr-env-lookup (lambda (x) #f))

(define-native dlr-object? (lambda (x) #f))

(define-native dlr-lookup-components (lambda (x y) #f))

(define-native set-global-value! (lambda (var x) #f))

(define-native set-global-docstring! (lambda (var x) #f))

(define-native printf-prim printf)

(define-native import-native (lambda ignore #f))

(define-native iterator? (lambda ignore #f))

(define-native get_type (lambda (x) 'unknown))

(define-native
  tagged-list^
  (lambda (keyword op len)
    (lambda (asexp)
      (and (list?^ asexp)
           (op (length^ asexp) len)
           (symbol?^ (car^ asexp))
           (eq?^ (car^ asexp) keyword)))))

(define quote?^ (tagged-list^ 'quote = 2))

(define quasiquote?^ (tagged-list^ 'quasiquote = 2))

(define unquote?^ (tagged-list^ 'unquote >= 2))

(define unquote-splicing?^
  (tagged-list^ 'unquote-splicing >= 2))

(define if-then?^ (tagged-list^ 'if = 3))

(define if-else?^ (tagged-list^ 'if = 4))

(define help?^ (tagged-list^ 'help = 2))

(define assignment?^ (tagged-list^ 'set! = 3))

(define func?^ (tagged-list^ 'func = 2))

(define callback?^ (tagged-list^ 'callback = 2))

(define define?^ (tagged-list^ 'define >= 3))

(define define!?^ (tagged-list^ 'define! >= 3))

(define define-syntax?^ (tagged-list^ 'define-syntax >= 3))

(define begin?^ (tagged-list^ 'begin >= 2))

(define lambda?^ (tagged-list^ 'lambda >= 3))

(define trace-lambda?^ (tagged-list^ 'trace-lambda >= 4))

(define raise?^ (tagged-list^ 'raise = 2))

(define choose?^ (tagged-list^ 'choose >= 1))

(define try?^ (tagged-list^ 'try >= 2))

(define catch?^ (tagged-list^ 'catch >= 3))

(define finally?^ (tagged-list^ 'finally >= 2))

(define let-transformer^ (make-macro <macro-1>))

(define letrec-transformer^ (make-macro <macro-2>))

(define mit-define-transformer^ (make-macro <macro-3>))

(define and-transformer^ (make-macro <macro-4>))

(define or-transformer^ (make-macro <macro-5>))

(define cond-transformer^ (make-macro <macro-6>))

(define let*-transformer^ (make-macro <macro-7>))

(define case-transformer^ (make-macro <macro-8>))

(define record-case-transformer^ (make-macro <macro-9>))

(define define-datatype-transformer^
  (make-macro <macro-10>))

(define cases-transformer^ (make-macro <macro-11>))

(define-native
  dd1
  "(define-datatype thing thing?\n     (thing0)\n     (thing1\n       (f1 thing1-field1?))\n     (thing2\n       (f1 thing2-field1?)\n       (f2 thing2-field2?))\n     (thing3\n       (f1 thing3-field1?)\n       (f2 (list-of thing3-field2?))\n       (f3 thing3-field3?)))")

(define-native
  cases1
  "(cases thing (cons x y)\n     (thing0 () b1)\n     (thing1 (f1) b1 b2 b3)\n     (thing2 (f1 f2 . f3) b1 b2 b3)\n     (thing3 args b1 b2 b3)\n     (else d1 d2 d3))")

(define-native
  dd2
  "(define-datatype expression expression?\n     (var-exp\n       (id symbol?))\n     (if-exp\n       (test-exp expression?)\n       (then-exp expression?)\n       (else-exp expression?))\n     (lambda-exp\n       (formals (list-of symbol?))\n       (bodies (list-of expression?)))\n     (app-exp\n       (operator expression?)\n       (operands (list-of expression?))))")

(define-native
  cases2
  "(cases expression exp\n     (var-exp (id info)\n       (lookup-value id env info handler fail k))\n     (if-exp (test-exp then-exp else-exp info)\n       (m test-exp env handler fail\n\t  (lambda (bool fail)\n\t    (if bool\n\t      (m then-exp env handler fail k)\n\t      (m else-exp env handler fail k)))))\n      (lambda-exp (formals bodies info)\n\t(k (closure formals bodies env) fail))\n      (app-exp (operator operands info)\n\t(m* operands env handler fail\n\t  (lambda (args fail)\n\t    (m operator env handler fail\n\t      (lambda (proc fail)\n\t\t(proc args env info handler fail k))))))\n      (else (error 'm \"bad abstract syntax: ~s\" exp)))")

(define macro-env 'undefined)

(define REP-k (make-cont2 <cont2-47>))

(define REP-handler (make-handler2 <handler2-2>))

(define REP-fail (make-fail <fail-1>))

(define *last-fail* REP-fail)

(define *tokens-left* 'undefined)

(define-native dlr-proc? (lambda (x) #f))

(define-native dlr-apply apply)

(define-native dlr-func (lambda (x) x))

(define-native callback (lambda args #f))

(define-native dlr-env-contains (lambda (x) #f))

(define-native dlr-env-lookup (lambda (x) #f))

(define-native dlr-object? (lambda (x) #f))

(define-native dlr-lookup-components (lambda (x y) #f))

(define-native set-global-value! (lambda (var x) #f))

(define-native set-global-docstring! (lambda (var x) #f))

(define-native import-native (lambda ignore #f))

(define-native import-as-native (lambda ignore #f))

(define-native import-from-native (lambda ignore #f))

(define-native iterator? (lambda ignore #f))

(define-native get_type (lambda (x) 'unknown))

(define-native char->string (lambda (c) (string c)))

(define-native dict (lambda (assoc) assoc))

(define-native float (lambda (n) (exact->inexact n)))

(define-native int (lambda (n) (inexact->exact n)))

(define-native iter? (lambda (x) #f))

(define-native contains-native (lambda (dict x) #f))

(define-native getitem-native (lambda (dict x) 'unknown))

(define-native
  setitem-native
  (lambda (dict x value) 'unknown))

(define-native
  read-multiline
  (lambda (prompt) (printf prompt) (format "~s" (read))))

(define try-parse-handler (make-handler2 <handler2-3>))

(define *tracing-on?* #f)

(define *stack-trace* (list '()))

(define *use-stack-trace* #t)

(define-native
  make-safe-continuation
  (lambda (k)
    (if (not (pair? k))
        '<???>
        (if (eq? (car k) 'fail-continuation)
            '<fail>
            (if (memq (car k) (list 'handler 'handler2))
                '<handler>
                (if (memq
                      (car k)
                      (list
                        'continuation
                        'continuation2
                        'continuation3
                        'continuation4))
                    (cons
                      (cadr k)
                      (map make-safe-continuation
                           (filter continuation-object? (cddr k))))
                    '<???>))))))

(define void-prim (make-proc <proc-5>))

(define void-value '<void>)

(define zero?-prim (make-proc <proc-6>))

(define exit-prim (make-proc <proc-7>))

(define end-of-session (list 'exiting 'the 'interpreter))

(define eval-prim (make-proc <proc-8>))

(define eval-ast-prim (make-proc <proc-9>))

(define parse-prim (make-proc <proc-10>))

(define string-length-prim (make-proc <proc-11>))

(define string-ref-prim (make-proc <proc-12>))

(define unparse-prim (make-proc <proc-13>))

(define unparse-procedure-prim (make-proc <proc-14>))

(define parse-string-prim (make-proc <proc-15>))

(define read-string-prim (make-proc <proc-16>))

(define apply-prim (make-proc <proc-17>))

(define sqrt-prim (make-proc <proc-18>))

(define odd?-prim (make-proc <proc-19>))

(define even?-prim (make-proc <proc-20>))

(define quotient-prim (make-proc <proc-21>))

(define remainder-prim (make-proc <proc-22>))

(define print-prim (make-proc <proc-23>))

(define string-prim (make-proc <proc-24>))

(define substring-prim (make-proc <proc-25>))

(define number->string-prim (make-proc <proc-26>))

(define assv-prim (make-proc <proc-27>))

(define memv-prim (make-proc <proc-28>))

(define display-prim (make-proc <proc-29>))

(define newline-prim (make-proc <proc-30>))

(define *need-newline* #f)

(define load-prim (make-proc <proc-31>))

(define load-stack '())

(define length-prim (make-proc <proc-32>))

(define symbol?-prim (make-proc <proc-33>))

(define number?-prim (make-proc <proc-34>))

(define boolean?-prim (make-proc <proc-35>))

(define string?-prim (make-proc <proc-36>))

(define char?-prim (make-proc <proc-37>))

(define char=?-prim (make-proc <proc-38>))

(define char-whitespace?-prim (make-proc <proc-39>))

(define char->integer-prim (make-proc <proc-40>))

(define integer->char-prim (make-proc <proc-41>))

(define char-alphabetic?-prim (make-proc <proc-42>))

(define char-numeric?-prim (make-proc <proc-43>))

(define null?-prim (make-proc <proc-44>))

(define pair?-prim (make-proc <proc-45>))

(define cons-prim (make-proc <proc-46>))

(define car-prim (make-proc <proc-47>))

(define cdr-prim (make-proc <proc-48>))

(define cadr-prim (make-proc <proc-49>))

(define caddr-prim (make-proc <proc-50>))

(define caaaar-prim (make-proc <proc-51>))

(define caaadr-prim (make-proc <proc-52>))

(define caaar-prim (make-proc <proc-53>))

(define caadar-prim (make-proc <proc-54>))

(define caaddr-prim (make-proc <proc-55>))

(define caadr-prim (make-proc <proc-56>))

(define caar-prim (make-proc <proc-57>))

(define cadaar-prim (make-proc <proc-58>))

(define cadadr-prim (make-proc <proc-59>))

(define cadar-prim (make-proc <proc-60>))

(define caddar-prim (make-proc <proc-61>))

(define cadddr-prim (make-proc <proc-62>))

(define cdaaar-prim (make-proc <proc-63>))

(define cdaadr-prim (make-proc <proc-64>))

(define cdaar-prim (make-proc <proc-65>))

(define cdadar-prim (make-proc <proc-66>))

(define cdaddr-prim (make-proc <proc-67>))

(define cdadr-prim (make-proc <proc-68>))

(define cdar-prim (make-proc <proc-69>))

(define cddaar-prim (make-proc <proc-70>))

(define cddadr-prim (make-proc <proc-71>))

(define cddar-prim (make-proc <proc-72>))

(define cdddar-prim (make-proc <proc-73>))

(define cddddr-prim (make-proc <proc-74>))

(define cdddr-prim (make-proc <proc-75>))

(define cddr-prim (make-proc <proc-76>))

(define list-prim (make-proc <proc-77>))

(define make-set-prim (make-proc <proc-78>))

(define plus-prim (make-proc <proc-79>))

(define minus-prim (make-proc <proc-80>))

(define times-prim (make-proc <proc-81>))

(define divide-prim (make-proc <proc-82>))

(define modulo-prim (make-proc <proc-83>))

(define min-prim (make-proc <proc-84>))

(define max-prim (make-proc <proc-85>))

(define lt-prim (make-proc <proc-86>))

(define gt-prim (make-proc <proc-87>))

(define lt-or-eq-prim (make-proc <proc-88>))

(define gt-or-eq-prim (make-proc <proc-89>))

(define equal-sign-prim (make-proc <proc-90>))

(define abs-prim (make-proc <proc-91>))

(define equal?-prim (make-proc <proc-92>))

(define eq?-prim (make-proc <proc-93>))

(define memq-prim (make-proc <proc-94>))

(define member-prim (make-proc <proc-95>))

(define range-prim (make-proc <proc-96>))

(define snoc-prim (make-proc <proc-97>))

(define rac-prim (make-proc <proc-98>))

(define rdc-prim (make-proc <proc-99>))

(define-native
  range
  (lambda args
    (let ((range 'undefined))
      (set! range
        (lambda (n end step acc)
          (if (>= n end)
              (reverse acc)
              (range (+ n step) end step (cons n acc)))))
      (if (null? (cdr args))
          (range 0 (car args) 1 '())
          (if (null? (cddr args))
              (range (car args) (cadr args) 1 '())
              (range (car args) (cadr args) (caddr args) '()))))))

(define set-car!-prim (make-proc <proc-100>))

(define set-cdr!-prim (make-proc <proc-101>))

(define load-as-prim (make-proc <proc-102>))

(define get-stack-trace-prim (make-proc <proc-103>))

(define get-prim (make-proc <proc-104>))

(define call/cc-prim (make-proc <proc-106>))

(define abort-prim (make-proc <proc-107>))

(define require-prim (make-proc <proc-108>))

(define cut-prim (make-proc <proc-109>))

(define reverse-prim (make-proc <proc-110>))

(define append-prim (make-proc <proc-111>))

(define string->number-prim (make-proc <proc-112>))

(define string=?-prim (make-proc <proc-113>))

(define list->vector-prim (make-proc <proc-114>))

(define list->string-prim (make-proc <proc-115>))

(define char->string-prim (make-proc <proc-116>))

(define string->list-prim (make-proc <proc-117>))

(define string->symbol-prim (make-proc <proc-118>))

(define symbol->string-prim (make-proc <proc-119>))

(define vector->list-prim (make-proc <proc-120>))

(define dir-prim (make-proc <proc-121>))

(define current-time-prim (make-proc <proc-122>))

(define map-prim (make-proc <proc-123>))

(define for-each-prim (make-proc <proc-124>))

(define format-prim (make-proc <proc-125>))

(define current-environment-prim (make-proc <proc-126>))

(define import-prim (make-proc <proc-127>))

(define import-as-prim (make-proc <proc-128>))

(define import-from-prim (make-proc <proc-129>))

(define not-prim (make-proc <proc-130>))

(define printf-prim (make-proc <proc-131>))

(define vector-prim (make-proc <proc-132>))

(define-native
  vector_native
  (lambda args (apply vector args)))

(define vector-set!-prim (make-proc <proc-133>))

(define vector-ref-prim (make-proc <proc-134>))

(define make-vector-prim (make-proc <proc-135>))

(define error-prim (make-proc <proc-136>))

(define list-ref-prim (make-proc <proc-137>))

(define current-directory-prim (make-proc <proc-138>))

(define round-prim (make-proc <proc-139>))

(define use-stack-trace-prim (make-proc <proc-140>))

(define use-tracing-prim (make-proc <proc-141>))

(define eqv?-prim (make-proc <proc-142>))

(define vector?-prim (make-proc <proc-143>))

(define atom?-prim (make-proc <proc-144>))

(define iter?-prim (make-proc <proc-145>))

(define contains-prim (make-proc <proc-146>))

(define getitem-prim (make-proc <proc-147>))

(define setitem-prim (make-proc <proc-148>))

(define list?-prim (make-proc <proc-149>))

(define procedure?-prim (make-proc <proc-150>))

(define string<?-prim (make-proc <proc-151>))

(define float-prim (make-proc <proc-152>))

(define globals-prim (make-proc <proc-153>))

(define int-prim (make-proc <proc-154>))

(define apply-with-keywords-prim (make-proc <proc-155>))

(define assq-prim (make-proc <proc-156>))

(define dict-prim (make-proc <proc-157>))

(define property-prim (make-proc <proc-158>))

(define rational-prim (make-proc <proc-159>))

(define reset-toplevel-env-prim (make-proc <proc-160>))

(define sort-prim (make-proc <proc-161>))

(define string-append-prim (make-proc <proc-162>))

(define string-split-prim (make-proc <proc-163>))

(define symbol-prim (make-proc <proc-164>))

(define typeof-prim (make-proc <proc-165>))

(define use-lexical-address-prim (make-proc <proc-166>))

(define-native
  make-initial-env-extended
  (lambda (names procs docstrings)
    (make-initial-environment names procs docstrings)))

(define toplevel-env 'undefined)

;; the trampoline
(define trampoline
  (lambda () (if pc (begin (pc) (trampoline)) final_reg)))
(define pc-halt-signal #f)

(define run
  (lambda (setup . args)
    (apply setup args)
    (return* (trampoline))))

