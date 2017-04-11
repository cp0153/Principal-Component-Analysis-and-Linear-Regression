#lang racket

(require net/url)
(require csv-reading)
(require math/array)
 (require math/matrix)
(require plot)

; require custom functions 
(require "graphs.rkt")
(require "data-filtering.rkt")

;; define list of iris data directly from url
(define iris-url "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data")
(define iris-raw ((compose csv->list get-pure-port string->url) iris-url))

; converts iris csv to a list with just numbers (stored as string), drops the last cololmn in a list
; of lists 
(define iris-raw-num-str (filter-last-csv iris-raw))

; create a mutable NxM array of the iris dataset 
(define iris-array (list*->array (strlst-to-numlsts iris-raw-num-str) number?))

; calculate mean and standard diviation
(define iris-mean 0)

(define iris-std 0)

; function that takes a NXM array and standardizes the values (z = (x - mean) / std)
(define (standardize-matrix n) 0)

; calculate mean vector (mean of z)
(define mean-vector 0)

; create N X N matrix of containing covariance of all properties
(define co-variance-matrix 0)

; calculate eigenvectors and eigenvalues
(define eigenvalues 0)
(define eigenvectors 0)

; use eigenvectors with the 2 or 3 highest eigenvalues to create projection matrix

; take dot product of z and projection matrix

; plot with result of dot product


; quick test of 3d plot
;(plot3d (points3d (array->list* iris-array))
;          #:altitude 25)


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
(define Iris-virginica (filter (remove-last iris-raw) petal-width identity "Iris-virginica"))
(define Iris-versicolor (filter (remove-last iris-raw) petal-width identity "Iris-versicolor"))
(define Iris-setosa (filter (remove-last iris-raw) petal-width identity "Iris-setosa"))


