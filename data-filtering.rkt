#lang racket


(provide total count average standard-deviation min max filter)
(provide petal-width sepal-length sepal-width petal-length class)
(provide same-class)
(provide remove-last)
(provide filter-last-csv)
(provide str-to-num-lst strlst-to-numlsts)
(provide annotated-proc)


;;used for data abstractions
(struct annotated-proc (base note)
   #:property prop:procedure
              (struct-field-index base))

;;Data abstractions


(define petal-width (annotated-proc (lambda (x)  (car x)) "Petal Width"))
(define sepal-length (annotated-proc (lambda (x)  (car (cdr x))) "Sepal Length"))
(define sepal-width (annotated-proc  (lambda (x)  (car (cdr (cdr x)))) "Sepal Width"))
(define petal-length (annotated-proc  (lambda (x)  (car (cdr (cdr (cdr x))))) "Petal Length"))
(define class  (annotated-proc  (lambda (x)  (car (cdr (cdr (cdr (cdr x)))))) "Class"))

;;data helper functions
(define (same-class class1 class2)
  (string=? class1 class2))

; function to remve last element from list, needed to remove class from iris csv to form a array
; and to remove the last element
(define (remove-last lst)
  (reverse (cdr (reverse lst))))

; function that takes a list of lists, will remove the last list in the first level and final element
; of all other lists 
(define (filter-last-csv lst-of-lsts)
  (define remove-last-lst (remove-last lst-of-lsts))
  (map (lambda (x) (remove-last x)) remove-last-lst))

; converts a list of strings to numbers recursivly 
(define (str-to-num-lst items)
  (if (null? items)
      '() 
      (cons (string->number (car items))
            (str-to-num-lst (cdr items)))))

; converts a list of lists of strings to numbers using a mapping of the str-to-num-lst function 
(define (strlst-to-numlsts lst-of-str)
  (map (lambda (x) (str-to-num-lst x)) lst-of-str))

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
    (sqrt (/ (foldr
              (lambda (x y)
                (+ (expt (- (string->number (parm x)) (average data parm class-t)) 2) y)) 0 data)
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


(define filter 
  (lambda (data parm expr [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (if (expr (string->number (parm x))) (cons x y) y)) '() data)
        ;;filter then get the average
        (foldr (lambda (x y) (if (expr (string->number (parm x))) (cons x y) y)) '()
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))