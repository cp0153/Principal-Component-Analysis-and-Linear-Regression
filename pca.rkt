#lang racket

(require net/url)
(require csv-reading)
(require math/array)
(require plot)
(require "graphs.rkt")
(require "data-filitering.rkt")

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


;;lambdas for filter
(define less-than 
  (lambda (y)
    (lambda (x)
      (< x y))))

(define greater-than
  (lambda (y)
    (lambda (x)
      (> x y))))

(define equal-to
  (lambda (y)
    (lambda (x)
      (= x y))))

(define identity
    (lambda (x)
      x))


;;TODO
;;Plot a 3d graph plot graph
;;Make a linear regression
;;make bar graphs
;;make the graphs have better labels

;;testing plot
(define thing
  (plot3d (list (points3d (strlst-to-numlsts iris-raw-num-str) #:sym 'dot #:size 20 #:color 1))))

;;TODO


;;Some test data set for ploting
(define Iris-virginica (filiter (remove-last iris-raw) petal-width identity "Iris-virginica"))
(define Iris-versicolor (filiter (remove-last iris-raw) petal-width identity "Iris-versicolor"))
(define Iris-setosa (filiter (remove-last iris-raw) petal-width identity "Iris-setosa"))

             
     
           
    
    
  




