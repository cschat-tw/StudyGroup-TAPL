;; Interpreter: GNU Guile 2.0.11
;; 我無法確定這個實作完全遵守一樣的邏輯！

;; *更新*: 想了一想，cons 一個 'end 在 term 前面像是亂來的做法因為這樣把
;; type 的定義變得混雜了，或許使用和書裡面類似的定義才是正確的做法……
;; (即是所有 term 的 ctor 都有一個 `info' 參數，可以用來記憶 term 是否
;; 已經 eval 過)

(use-modules (ice-9 match)
             (rnrs base)
             (ice-9 format))

(define (is-numeric-val? t)
  (match t
    (('tm-zero) '(tm-true))
    (('tm-succ _) '(tm-true))
    (_ '(tm-false))))

(define (eval* t)
  (match t
    (('tm-if ('tm-true) t2 t3) (eval* t2))
    (('tm-if ('tm-false) t2 t3) (eval* t3))
    (('tm-if t1 t2 t3)
     (let ((t1' (eval* t1)))
       (if (eq? (car t1') 'end)
           (cons 'end t)
           (eval* `(tm-if ,t1' ,t2 ,t3)))))
    (('tm-succ t1)
     (let ((t1' (eval* t1)))
       (if (eq? (car t1') 'end)
           (cons 'end t)
           (eval* `(tm-succ ,t1')))))
    (('tm-pred ('tm-zero)) '(tm-zero))
    (('tm-pred ('tm-succ t1))
     (let ((t1' (eval* t1)))
       (let ((t1'' (if (eq? (car t1') 'end) (cdr t1') t1')))
         (match (is-numeric-val? t1'')
           (('tm-true) t1'')
           (('tm-false) `(end ,t))))))
    (('tm-pred t1)
     (let ((t1' (eval* t1)))
       (if (eq? (car t1') 'end)
           (cons 'end t)
           (eval* `(tm-pred ,t1')))))
    (('tm-is-zero ('tm-zero)) '(tm-true))
    (('tm-is-zero ('tm-succ t1))
     (let ((t1' (eval* t1)))
       (let ((t1'' (if (eq? (car t1') 'end) (cdr t1') t1')))
         (match (is-numeric-val? t1')
           (('tm-true) '(tm-false))
           (('tm-false) (cons 'end t))))))
    (('tm-is-zero t1)
     (let ((t1' (eval* t1)))
       (if (eq? (car t1') 'end)
           (cons 'end t)
           (eval* `(tm-is-zero ,t1')))))
    (_ (cons 'end t))))

(define (eval t)
  (let ((t' (eval* t)))
    (match t'
      (('end t1 ...) t1)
      (_ t'))))

(define (eval-print t)
  (format #t "~a => ~a\n" t (eval t)))

(eval-print '(tm-is-zero (tm-zero)))
(eval-print '(tm-is-zero (tm-pred (tm-pred (tm-succ (tm-zero))))))
(eval-print '(tm-pred (tm-zero)))

(eval-print '(tm-pred (tm-succ
                       (tm-pred (tm-succ
                                 (tm-pred (tm-succ (tm-zero))))))))

(eval-print '(tm-if (tm-true)
                    (tm-is-zero (tm-succ (tm-true)))
                    (tm-false)))

(eval-print '(tm-if (tm-false)
                    (tm-zero)
                    (tm-pred (tm-succ (tm-zero)))))
