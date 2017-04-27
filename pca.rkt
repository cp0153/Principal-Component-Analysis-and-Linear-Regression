#lang racket

(require net/url)
(require csv-reading)
(require math/array)
(require math/matrix)
(require plot)

;; require custom functions 
(require "graphs.rkt")
(require "data-filtering.rkt")

;; define list of iris data directly from url
(define iris-url "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data")
(define iris-raw ((compose csv->list get-pure-port string->url) iris-url))

;; converts iris csv to a list with just numbers (stored as string), drops the last column in a list
;; of lists 
(define iris-raw-num-str (filter-last-csv iris-raw))

;; create a mutable NxM array of the iris dataset 
(define iris-array (list*->array (strlst-to-numlsts iris-raw-num-str) number?))

;; calculate mean and standard deviation or iris

;; define an array with the sum of each column 
(define iris-sum (array-axis-sum iris-array 0))

;; function that takes one argument, a 2d array (matrix) and returns the mean of every column
(define (matrix-mean matrix)
  (array/ (array-axis-sum matrix 0) (array (vector-ref (array-shape matrix) 0))))

(define iris-mean (matrix-mean iris-array))

;; function that takes one argument, a 2d array (matrix) and returns the std of every column
(define (matrix-std matrix)
  (array-map sqrt (array/
                   (array-axis-sum (array-map sqr (array- matrix (matrix-mean matrix))) 0)
                   (array (vector-ref (array-shape matrix) 0))
                   )))

(define iris-std (matrix-std iris-array))

;; function that takes a NXM array and standardizes the values (z = (x - mean) / std)
(define (standardize-matrix matrix)
  (array/ (array- matrix (matrix-mean matrix)) (matrix-std matrix)))

;; define standardized iris
(define z (standardize-matrix iris-array))

;; calculate mean vector (mean of z)
(define mean-vector (matrix-mean z))

;; create N X N matrix of containing covariance of all properties, need to figure out how to
;; multiply matrices of different dimensions in racket, hardcoded covariance matrix to define it for
;; now, should be cov[x, y] = ∑i (xi – E[x]) (yi – E[y])  / (n-1) or
;; (array z - mean vector transposed) multiplied by (z - mean vector) all divided by
;; N - 1 (149 in this case)

(define iris-co-variance-matrix
 (array/
 (matrix* (array-axis-swap (array- z mean-vector) 1 0) (array- z mean-vector))
 (array (- (vector-ref (array-shape z) 0) 1))))
           
;; calculate eigenvectors and eigenvalues from the covariance matrix 
(define iris-eigenvalues
  (array #[2.93035378  0.92740362  0.14834223  0.02074601]))
           
(define iris-eigenvectors
  (array #[#[0.52237162 -0.37231836 -0.72101681  0.26199559]
           #[-0.26335492 -0.92555649  0.24203288 -0.12413481]
           #[0.58125401 -0.02109478  0.14089226 -0.80115427]
           #[0.56561105 -0.06541577  0.6338014   0.52354627]]))

;; use eigenvectors with the 2 or 3 highest eigenvalues to create projection matrix
;; this function takes two arguments, the first is an array of eigenvectors, the second is the number
;; number of dimensions for the new array
;; want to define a function here that takes an array and only keeps the n first number of columns
;; like 3x3 array and 2 will remove the last column from it
(define (projection-matrix eigenvectors dim) 0)
;;  (define (iter dim count)
;;    (if (> count dim)
;;        eigenvectors
;;        ((map (lambda (x) (remove-last  x)) eigenvectors))))
;; (iter dim 1))

;; take the first 2 or 3 columns from the corresponding eigenvector/value pairs 
(define iris-projection-matrix
  (list*->array (map (lambda (x) (remove-last x)) (array->list* iris-eigenvectors)) number?))
;  (array #[#[0.52237162 -0.37231836 -0.72101681]
;           #[-0.26335492 -0.92555649  0.24203288]
;           #[0.58125401 -0.02109478  0.14089226]
;           #[0.56561105 -0.06541577  0.6338014]]))

;; plot with result of dot product
;; z multiplied by the projection-matrix
(define iris-pca
  (array->list* (matrix* z iris-projection-matrix)))

(define iris-pca-classes
  (map (lambda (x y) (append-last x y)) iris-pca
       (map (lambda (x) (class x)) (remove-last iris-raw))))

(define identity
    (lambda (x)
      x))

(define pca-class
  (lambda (x)
    (if (eqv? x 'name)
         "Class"
         (car (cdr (cdr (cdr x)))))))

(define filter-3c 
  (lambda (data parm expr [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (if (expr (string-to-number (parm x))) (cons x y) y)) '() data)
        ;;filter then get the average
        (foldr (lambda (x y) (if (expr (string-to-number (parm x))) (cons x y) y)) '()
               (foldr (lambda (x y) (if (same-class (pca-class x) class-t) (cons x y) y))
                      '() data)))))


(define pca1 (remove-last-col (filter-3c iris-pca-classes petal-width identity "Iris-setosa")))
(define pca2 (remove-last-col (filter-3c iris-pca-classes petal-width identity "Iris-versicolor")))
(define pca3 (remove-last-col (filter-3c iris-pca-classes petal-width identity "Iris-virginica")))

;; pca of iris dataset
(plot3d (list (points3d pca1 #:sym 'dot #:size 20 #:color 1 #:label "Iris-setosa")
              (points3d pca2 #:sym 'dot #:size 20 #:color 2 #:label "Iris-versicolor")
              (points3d pca3 #:sym 'dot #:size 20 #:color 3 #:label "Iris-virginica"))
        #:altitude 25
        #:title "3D PCA of iris dataset")

;(plot3d (points3d iris-pca #:sym 'dot #:size 20 #:color 1)
;        #:altitude 25
;        #:title "3D PCA of iris dataset")

;; quick test of 3d plot
;; (plot3d (points3d (array->list* iris-array))
;;          #:altitude 25)


;; lambdas for filter
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


;; TODO
;; Plot a 3d graph plot graph
;; Make a linear regression
;; make bar graphs
;; make the graphs have better labels

;; testing plot
(define thing
  (plot3d (list (points3d (strlst-to-numlsts iris-raw-num-str) #:sym 'dot #:size 20 #:color 1))))

;; TODO


;; Some test data set for plotting
(define Iris-virginica (filter (remove-last iris-raw) petal-width identity "Iris-virginica"))
(define Iris-versicolor (filter (remove-last iris-raw) petal-width identity "Iris-versicolor"))
(define Iris-setosa (filter (remove-last iris-raw) petal-width identity "Iris-setosa"))


