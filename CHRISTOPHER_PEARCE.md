# Data Visualizations from UCI Machine Learning Repository

## Christopher Pearce
### April 26, 2017

# Overview
We plan to make a few data visualizations from the UCI Machine Learning Repository. Data visualization is interesting 
because it enables us to understand and communicate complex data easily. By performing data visualizations in racket, 
we hope to utilize several key concepts learned in class and explore racket plot, csv, array and matrix libraries.

For this project I focused specifically on creating a Principal Component Analysis of the iris dataset. To approach this 
problem, I decided to download a dataset from online, cast it to an array structure to process the data. 

# Libraries Used
The code uses four libraries:

```lisp
(require net/url)
(require csv-reading)
(require math/array)
(require math/matrix)
(require plot)
(require math/statistics)
```

* The ```net/url``` library provides the ability to make REST-style https requests to get data sets from UCI
* The ```csv-reading``` library is used to parse the csv file ```net/url``` collects and parse it into a racket list of 
lists
* The ```math/array``` library and ```math/matrix``` was used to perform the data calculations from the csv as an array
* The ```plot``` library is used to make 2d and 3d plots of the results
* The ```math/statistics``` library was used to help calculate the standard deviation of a 2d list

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Four examples are shown and they are individually numbered. 

## 1. removing the last column in a 2d list of lists with a map

The ```remove-last``` procedure removes the last element in a list by reversing the cdr of the reversed list argument


```lisp
;; function to remove last element from list, needed to remove class from iris csv to form an array
;; and to remove the last element
(define (remove-last lst)
  (reverse (cdr (reverse lst))))
```

When the ```net/url``` function is used to convert the csv to a list, it is originally a list of string lists, including
string fields such as iris class and an empty list for the last newline at the end of the file. Therefore, that 
```remove-last``` abstraction is used in ```filter-last-csv``` to drop that newline list and the final string column 
from the iris dataset.

```lisp
;; function that takes a list of lists created from a csv file, will remove the last list in the
;; first level and final element of all other lists 
(define (filter-last-csv lst-of-lsts)
  (define remove-last-lst (remove-last lst-of-lsts))
  (map (lambda (x) (remove-last x)) remove-last-lst))
```
## 2. Using Recursion and mapping to change the items in a list

This ```str-to-num-lst``` procedure recursively casts a string as a number on an entire list. This procedure is used 
as a helper function in ```strlst-to-numlsts``` a procedure that takes our now number string list of lists and
converts them to just regular numbers. Once I had a list of lists with just numbers I converted it to an array in so I 
could do the matrix multiplication required for a PCA.

```lisp
;; converts a list of strings to numbers recursively 
(define (str-to-num-lst items)
  (if (null? items)
      '() 
      (cons (string->number (car items))
            (str-to-num-lst (cdr items)))))
```

## 3. using maps to calculate the mean and standard deviation of an array

These procedures are used together in order to standardize the iris dataset using various array maps and folds such as
```array/```, ```array-axis-sum```, ```array-map```, ect. are used calculate the mean and standard deviation of every 
column, then perform array subtraction and division to calculate the standardized matrix (zero mean and unit variance)

```lisp
;; function that takes one argument, a 2d array (matrix) and returns the mean of every column
(define (matrix-mean matrix)
  (array/ (array-axis-sum matrix 0) (array (vector-ref (array-shape matrix) 0))))


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
```

I also used ```matrix*```, a procedure from math/matrix that can multiply matrices of different dimensions (the 
covariance matrix is 4X4 instead of 4X150)
 
```lisp 
;; create N X N matrix of containing covariance of all properties, need to figure out how to
;; multiply matrices of different dimensions in racket, hardcoded covariance matrix to define it for
;; now, should be cov[x, y] = ∑i (xi – E[x]) (yi – E[y])  / (n-1) or
;; (array z - mean vector transposed) multiplied by (z - mean vector) all divided by
;; N - 1 (149 in this case)

(define iris-co-variance-matrix
 (array/
 (matrix* (array-axis-swap (array- z mean-vector) 1 0) (array- z mean-vector))
 (array (- (vector-ref (array-shape z) 0) 1))))
```

## 4. using expression evaluation to create the Principal Component Analysis

In this example, filter-3c (adapted from filter in data-filtering.rkt written by @rfarinel) is using expression 
evaluation to take a string containing the class name and return just the rows in iris-pca-classes the correct class 
argument. 
```lisp
(define pca1 (remove-last-col (filter-3c iris-pca-classes petal-width identity "Iris-setosa")))
(define pca2 (remove-last-col (filter-3c iris-pca-classes petal-width identity "Iris-versicolor")))
(define pca3 (remove-last-col (filter-3c iris-pca-classes petal-width identity "Iris-virginica")))

;; pca of iris dataset
(plot3d (list (points3d pca1 #:sym 'dot #:size 20 #:color 1 #:label "Iris-setosa")
              (points3d pca2 #:sym 'dot #:size 20 #:color 2 #:label "Iris-versicolor")
              (points3d pca3 #:sym 'dot #:size 20 #:color 3 #:label "Iris-virginica"))
        #:altitude 25
        #:title "3D PCA of iris dataset")
```

