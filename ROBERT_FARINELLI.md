# Data Visualizations from UCI Machine Learning Repository

## Robert Farinelii
### April 29, 2017

# Overview
In our project, we made data visualizations from the UCI Machine Learning Repository. 
Data visualization is important because it helps people visualize and understand complex data easily. 

For my part I focused on creating filtering and statistics functions. The filtering functions allow the user to filter the 
data based on the given parameters. The statistics functions took the whole dataset or any filtered data and gave the 
requested statistical analysis of the data. I also made plots to for all this functionality to show the manipulated data. 

# Libraries Used
My code uses four libraries:

```lisp
(require net/url)
(require csv-reading)
(require plot)
(require math/statistics)
```

* The ```net/url``` Used to make https requests to get data our data from the UCI Repository
* The ```csv-reading``` Used to parse the csv file  to create list of lists of the data in Racket
* The ```plot``` library is used to make 2d,3d, and bar chart plots of the results
* The ```math/statistics``` Used to calculate the standard deviation of a parameter from the dataset

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Five examples are shown and they are individually numbered.

## 1. Using Selectors for the to get at the columns 

The following code is how data Abstraction was used to get a a column of data (it also show symbolic differentiation):


```lisp
;;Data abstractions of iris dataset
(define petal-width
  (lambda (x)
    (if (eqv? x 'name)
    "Petal Width"
    (car x))))
```
Part of this functions purpose is to be a wrapper for ```car``` as the petal-width is the first column in the dataset the car
acts a getter for the first column on an entry. Symbolic differentiation is also used in this function. If the symbol ```'name```
is passed then it will return a string with the name of the column (or selector). Otherwise it will return a lambda that will
act as the selector.

another example is shown here for petal-length (the fouth column):

```lisp
(define petal-length
  (lambda (x)
    (if (eqv? x 'name)
         "Petal Length"
         (car (cdr (cdr (cdr x)))))))

```

## 2. accumulation (foldr) to create an average
 
```lisp
(define min
  (lambda (data parm [class-t "none"])
    (if (same-class class-t "none")
        (foldr (lambda (x y) (if (< (string->number (parm x)) y)
                                 (string->number (parm x))
                                 y)) 9999999999 data)
        ;;filter then get the average
        (foldr (lambda (x y) (if (< (string->number (parm x)) y)
                                 (string->number (parm x))
                                 y)) 9999999999
               (foldr (lambda (x y) (if (same-class (class x) class-t) (cons x y) y)) '() data)))))
```

This function uses foldr to find the min of the given column of the data set given by the ```param```
argument which is one of the selectors mentioned in #1. if an optional argument 'class-t is passed
then it will filter by out the non matching class names (the 5th parameter of the data-set as a string)
then it will use foldr to find the min. I uses a lambda to see if the current element is smaller than
the accumulation (base case is 9999999999). If it is smaller than that it will return the current element
overwise it will return the accumulation. This is just one example of a statics function I created, I made
many others such as max, total, count, average, and stand-dev.


## 3. Using Recursion and Mapping to create a hsitogram

```lisp
(define (plot-statics data-set function param list-of-classes)
  (define (histogram-creator dataset function param list-of-classes list-of-histograms count min)
    (if (null? list-of-classes)
         list-of-histograms
         (histogram-creator dataset function param (cdr list-of-classes)
                            (cons (discrete-histogram
                                   (list
                                    (vector
                                     (class (car
                                             (filter dataset param identity ;;filitering to get the class name happens here
                                                     (car list-of-classes))))
                                         (function dataset param (car list-of-classes)))) ;; getting the statisic happens here
                                      #:x-min min #:color count) list-of-histograms)
         (+ count 1)(+ min 1)))) ;;used to change the color of each histogram
  (plot(histogram-creator data-set function param list-of-classes '() 1 0)
   #:title (string-append (param 'name) " Comparison")
   #:x-label "Class"
   #:y-label (param 'name))) ;;symboloic differenation as discribed in #1 in use
```
The function uses a helper function ```histogram-creator``` as a helper function to recurse through the ```list-of-histograms``` that
specify the number of ```discrete-histogram``` to be created. When a single histogram is created, it uses a vector to store the
data to be plotted. The first part of the vector is the the name of the histogram (x-axis). To do this it uses my filter function
to get only the entries that contain the that from the ```car``` of the ```list-of-class```. Then it gets the class name from the first
entry. For the y-axis, it uses the ```function``` parameter to get the requested statistic (min, max, average...) on from the requested
parameter on the data set passed by the 'param to get that static on that parameter and also filtering out the class that is the
```(car list-of-classes)```.


## 4. Using state modification (let*) and more accumulating to calculate a linear regression


```lisp
(define (calc-linear-regression x-points y-points)
  ;;takes two list an create a new list with each element being
  ;; a pair of the nth element of that list
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
```

This function takes two lists the x-points and the y-points. The reason let* is used is to define terms
that will later be used to calculate intermediate steps in the formula and final slope (alpha) and the
final intercept (Beta). first the x and then y mean is calculated in in the context of an new environment
using foldr.Then, the numerator is calculated in a new environment by looking up the previously defined
x and y means also using foldr. the slope and the intercept are calculated which are the two numeric values
we need to plot a linear regression.

## 5. Using mapping, acumulation, recursion, and symbolic diferenation to create a 2D plot with linear regresion 

```lisp
(define (plot-2D list-of-datasets col1 col2 regression)
  ;;count is used to make sure each dataset plotted has a different color
 (let ([regression-vals (make-linear-regression (merge-lists list-of-datasets) col1 col2)])
     (define (points-creator list-of-datasets col1 col2 list-of-points count)
        (if (null? list-of-datasets)
            (if (eqv? regression 'none) ;;symbolic d
                list-of-points
                (cons (function
                       (lambda (x) (+ (* (car regression-vals) x) (car (cdr regression-vals)))))
                      list-of-points))
            (points-creator (cdr list-of-datasets) col1 col2
                            (cons (points
                                   (foldr (lambda(x y)
                                            (cons
                                             (vector
                                              (string->number (col1 x))
                                              (string->number (col2 x))) y))
                                          '()  (car list-of-datasets))
                                   #:label (string-append "Dataset " (number->string count))
                                   #:color count) list-of-points) (+ count 1))))
   (plot (points-creator list-of-datasets col1 col2 '())
         #:title (string-append (col1 'name) " vs " (col2 'name))
         #:x-label (col1 'name)
         #:y-label (col2 'name))))
```
This function works nearly the same as in #2. The difference here is we are using recursion to create a list of points
and not a list of Histograms. The main difference is after the accumulation finishes. Instead of just returning the
accumulation. If check the to see if the symbol ```'none``` was passed. if that symbol was passed then just the accumulation
will be returned. Otherwise we will cons a function object to the end of our list of points that will be the linear
regression plot. A lambda is used to create that object dynamically using the function in #4.


Closing remarks: This is just a small bit of what I did. Most of the other functions I created follow a similar structure
as these ones but vary in what function foldr is using or the end result of the accumulation.