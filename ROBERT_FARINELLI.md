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
Part of this functions purpose is to be a wrapper for 'car' as the petal-width is the first column in the dataset the car
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
## 2. Using Recursion and mapping to create a plot
