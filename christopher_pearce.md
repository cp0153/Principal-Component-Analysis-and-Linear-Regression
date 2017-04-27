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

```
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

Five examples are shown and they are individually numbered. 

## 1. Initialization using a Global Object

The following code creates a list of string lists containing all of the data in a csv from 
https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data

```
(require "graphs.rkt")
(require "data-filtering.rkt")

;; define list of iris data directly from url
(define iris-url "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data")
(define iris-raw ((compose csv->list get-pure-port string->url) iris-url))
 ```
 
 While using global objects is not a central theme in the course, it's necessary to show this code to understand
 the later examples.

## 2. removing the last column in a 2d list of lists with a map

The ```remove-last``` procedure removes the last element in a list by reversing the cdr of the reversed list argument


```Racket
;; function to remove last element from list, needed to remove class from iris csv to form an array
;; and to remove the last element
(define (remove-last lst)
  (reverse (cdr (reverse lst))))
```

When the ```net/url``` function is used to convert the csv to a list, it is originally a list of string lists, including
string fields such as iris class and an empty list for the last newline at the end of the file. Therefore, that 
```remove-last``` abstraction is used in ```filter-last-csv``` to drop that newline list and the final string column 
from the iris dataset.

```Racket
;; function that takes a list of lists created from a csv file, will remove the last list in the
;; first level and final element of all other lists 
(define (filter-last-csv lst-of-lsts)
  (define remove-last-lst (remove-last lst-of-lsts))
  (map (lambda (x) (remove-last x)) remove-last-lst))
```
## 3. Using Recursion and mapping to change the items in a list

This ```str-to-num-lst``` procedure recursively casts a string as a number on an entire list. This procedure is used 
as a helper function in ```strlst-to-numlsts``` a procedure that takes our now purley number string list of lists and
converts them to just regular numbers

```
;; converts a list of strings to numbers recursively 
(define (str-to-num-lst items)
  (if (null? items)
      '() 
      (cons (string->number (car items))
            (str-to-num-lst (cdr items)))))
```

## 4. using maps to calculate the mean and standard deviation of an array

These procedures are used together in order to standardize the iris dataset using various array maps and folds such as
```array/```, ```array-axis-sum```, ```array-map```, ect. are used calculate the mean and standard deviation of every 
column, then perform array subtraction and division to calculate the standardized matrix (zero mean and unit variance)

```Racket
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

## 5. using maps to multiply matrices

```
(define iris-co-variance-matrix
 (array/
 (matrix* (array-axis-swap (array- z mean-vector) 1 0) (array- z mean-vector))
 (array (- (vector-ref (array-shape z) 0) 1)))
  )
  
;; plot with result of dot product
;; z multiplied by the projection-matrix
(define iris-pca
  (matrix* z iris-projection-matrix))
```

