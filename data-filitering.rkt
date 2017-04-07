#lang racket


(provide total count average standard-deviation min max filiter)

;;data helper functions
(define (same-class class1 class2)
  (string=? class1 class2))


;;Data manipluation functions

;; (total param data class) → number?
;; data: list
;; param: procedure (should be one of the data abstractions
;; class: srting

;;ueasge:
;;> (total (remove-last iris-raw) petal-width)
;;> (total (remove-last iris-raw) petal-width "Iris-virginica")

(define total 
  ;;create a lambda to have an optional arugement
  (lambda (data parm [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (+ (string->number (parm x)) y)) 0 data)
        ;;filter then get the average
        (foldr (lambda (x y) (+ (string->number (parm x)) y)) 0
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))

;; (total param data class) → number?
;; data: list
;; class: srting

;;ueasge:
;;> (count (remove-last iris-raw))
;;> (count (remove-last iris-raw) "Iris-virginica")

(define count
  ;;create a lambda to have an optional arugement
  (lambda (data [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (+ 1 y)) 0 data)
        ;;filter then get the average
        (foldr (lambda (x y) (+ 1 y)) 0
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))

;; (average param data class) → number?
;; data: list
;; param: procedure (should be one of the data abstractions
;; class: srting

;;ueasge:
;;> (average (remove-last iris-raw) petal-width)
;;> (average (remove-last iris-raw) petal-width "Iris-virginica")

(define average 
  ;;create a lambda to have an optional arugement
  (lambda (data parm [class-t "none"])
        (/ (total data parm class-t) (count data class-t))))
  

;; (average param data class) → number?
;; data: list
;; param: procedure (should be one of the data abstractions)
;; class: srting

;;ueasge:
;;> (standard-deviation (remove-last iris-raw) petal-width)
;;> (standard-deviation(remove-last iris-raw) petal-width "Iris-virginica")
(define standard-deviation
  (lambda (data parm [class-t "none"])
    (sqrt (/ (foldr (lambda (x y) (+ (expt (- (string->number (parm x)) (average data parm class-t)) 2) y)) 0 data)
             (total data parm class-t)))))

(define min
  (lambda (data parm [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (if (< (string->number (parm x)) y) x y)) 9999999999 data)
        ;;filter then get the average
        (foldr (lambda (x y) (if (< (string->number (parm x)) y) x y)) 9999999999
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))


(define max
  (lambda (data parm [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (if (> (string->number (parm x)) y) x y)) 0 data)
        ;;filter then get the average
        (foldr (lambda (x y) (if (> (string->number (parm x)) y) x y)) 0
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))


(define filiter 
  (lambda (data parm expr [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (if (expr (string->number (parm x))) (cons x y) y)) '() data)
        ;;filter then get the average
        (foldr (lambda (x y) (if (expr (string->number (parm x))) (cons x y) y)) '()
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))