#lang racket

(require net/url)
(require csv-reading)
(require math/array)
(require plot)

;; define list of iris data directly from url
(define iris-url "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data")
(define iris-raw ((compose csv->list get-pure-port string->url) iris-url))

; function to remve last element from list, needed to remove class from iris csv to form a array
; and to remove the last element
(define (remove-last lst)
  (reverse (cdr (reverse lst))))

; function that takes a list of lists, will remove the last list in the first level and final element
; of all other lists 
(define (filter-last-csv lst-of-lsts)
  (define remove-last-lst (remove-last lst-of-lsts))
  (map (lambda (x) (remove-last x)) remove-last-lst))

; converts iris csv to a list with just numbers (stored as string)
(define iris-raw-num-str (filter-last-csv iris-raw))

; converts a list of strings to numbers recursivly 
(define (str-to-num-lst items)
  (if (null? items)
      '()
      (cons (string->number (car items))
            (str-to-num-lst (cdr items)))))

; converts a list of lists of strings to numbers using a mapping of the str-to-num-lst function 
(define (strlst-to-numlsts lst-of-str)
  (map (lambda (x) (str-to-num-lst x)) lst-of-str))

; finally create a mutable NxM array of the iris dataset 
(define iris-array (list*->array (strlst-to-numlsts iris-raw-num-str) number?))

; quick test of 3d plot
;(plot3d (points3d (array->list* iris-array))
;          #:altitude 25)

;;Data abstractions
(define (petal-width x) (car x))
(define (sepal-length x) (car (cdr x)))
(define (sepal-width x) (car (cdr (cdr x))))
(define (petal-length x) (car (cdr (cdr (cdr x)))))
(define (class x) (car (cdr (cdr (cdr (cdr x))))))

;;data helper functions
(define (same-class class1 class2)
  (string=? class1 class2))

;;lambdas for filter
(define less-than 
  (lambda (y)
    (lambda (x)
      (< x y))))

(define greater-than
  (lambda (y)
    (lambda (x)
      (> x y))))
      

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
        (foldr (lambda (x y) (if (expr (string->number (expr x))) x y)) '()
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))

;;(define where
;;  (lambda (data parm list-of-expr [class-t "none"])
;;    (if (null? list-of-expr)
;;    data
;;    (where (filter
      
           
    
    
  




