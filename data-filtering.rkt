#lang racket

(provide total count average standard-deviation min max filter make-linear-regression)
(provide petal-width sepal-length sepal-width petal-length class)
(provide same-class)
(provide remove-last)
(provide filter-last-csv)
(provide str-to-num-lst strlst-to-numlsts)
(provide merge-lists)

;;used for data abstractions

;;Data abstractions of iris dataset

(define petal-width
  (lambda (x)
    (if (eqv? x 'name)
    "Petal Width"
    (car x))))

(define sepal-length
  (lambda (x)
    (if (eqv? x 'name)
        "Sepal Length"
        (car (cdr x)))))

(define sepal-width
  (lambda (x)
    (if (eqv? x 'name)
        "Sepal Width"
        (car (cdr (cdr x))))))

(define petal-length
  (lambda (x)
    (if (eqv? x 'name)
         "Petal Length"
         (car (cdr (cdr (cdr x)))))))

(define class
  (lambda (x)
    (if (eqv? x 'name)
        "Class"
        (car (cdr (cdr (cdr (cdr x))))))))

;; data helper functions
(define (same-class class1 class2)
  (string=? class1 class2))

;; function to remove last element from list, needed to remove class from iris csv to form an array
;; and to remove the last element
(define (remove-last lst)
  (reverse (cdr (reverse lst))))

;; function that takes a list of lists created from a csv file, will remove the last list in the
;; first level and final element of all other lists 
(define (filter-last-csv lst-of-lsts)
  (define remove-last-lst (remove-last lst-of-lsts))
  (map (lambda (x) (remove-last x)) remove-last-lst))

;; converts a list of strings to numbers recursively 
(define (str-to-num-lst items)
  (if (null? items)
      '() 
      (cons (string->number (car items))
            (str-to-num-lst (cdr items)))))

;; converts a list of lists of strings to numbers using a mapping of the str-to-num-lst function 
(define (strlst-to-numlsts lst-of-str)
  (map (lambda (x) (str-to-num-lst x)) lst-of-str))

;; Data manipulation functions

;; (total param data class) → number?
;; data: list
;; param: procedure (should be one of the data abstractions
;; class: string

;; usage:
;; > (total (remove-last iris-raw) petal-width)
;; > (total (remove-last iris-raw) petal-width "Iris-virginica")

(define total 
  ;; create a lambda to have an optional argument
  (lambda (data parm [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (+ (string->number (parm x)) y)) 0 data)
        ;; filter then get the average
        (foldr (lambda (x y) (+ (string->number (parm x)) y)) 0
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))

;; (total param data class) → number?
;; data: list
;; class: string

;; usage:
;; > (count (remove-last iris-raw))
;; > (count (remove-last iris-raw) "Iris-virginica")

(define count
  ;; create a lambda to have an optional argument
  (lambda (data [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (+ 1 y)) 0 data)
        ;; filter then get the average
        (foldr (lambda (x y) (+ 1 y)) 0
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))

;; (average param data class) → number?
;; data: list
;; param: procedure (should be one of the data abstractions
;; class: string

;; usage:
;; > (average (remove-last iris-raw) petal-width)
;; > (average (remove-last iris-raw) petal-width "Iris-virginica")

(define average 
  ;; create a lambda to have an optional argument
  (lambda (data parm [class-t "none"])
        (/ (total data parm class-t) (count data class-t))))
  

;; (average param data class) → number?
;; data: list
;; param: procedure (should be one of the data abstractions)
;; class: string

;; usage:
;; > (standard-deviation (remove-last iris-raw) petal-width)
;; > (standard-deviation(remove-last iris-raw) petal-width "Iris-virginica")
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

  
(define (calc-linear-regression x-points y-points)
  (define (mergelist x y)
    (if (or (null? x) (null? y))
    '()
    (cons (list (car x) (car y))
          (mergelist (cdr x) (cdr y)))))         
  (let* ([x-mean (/ (foldr + 0 x-points) (length x-points))]
         [y-mean (/ (foldr + 0 y-points) (length y-points))]
         [numerator (foldr
                     (lambda(x y) (+ (* (- (car x) x-mean) (- (car (cdr x)) y-mean))))
                     0
                     (mergelist x-points y-points))]
         [denominator (foldr (lambda(x y) (+ (expt (- x y-mean) 2)))  0 x-points)]
         [slope (/ numerator denominator)]
         [intercept (- y-mean (* slope x-mean))])
    (list slope intercept)))

(define (make-linear-regression data-set col1 col2)
  (calc-linear-regression (foldr
                           (lambda(x y) (cons (string->number (col1 x)) y))
                           '() data-set)
                          (foldr
                           (lambda(x y) (cons (string->number (col2 x)) y))
                           '()
                           data-set)
                          ))
  ;(foldr (lambda(x y) (cons (col1 x) y)) '() data-set))
  ;data-set)

;; function that flattens a list of lists into a single lists
(define (merge-lists list-of-lists)
  (if (null? list-of-lists)
      '()
      (append (car list-of-lists) (merge-lists (cdr list-of-lists)))))
