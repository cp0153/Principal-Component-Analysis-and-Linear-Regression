# Data Visualizations from UCI Machine Learning Repository

### Statement
We have made a few data visualizations from the UCI Machine Learning Repository. Data visualization is interesting
because it enables us to understand and communicate complex data easily. By performing data visualizations in racket, we
utilized several key concepts learned in class and explore racket plot, csv, array and matrix 
libraries.

### Analysis

We implemented the project using several approaches from the class.

We used some data abstractions by taking a dataset from a CSV file and storing in memory as either a list of lists 
(cons cells) or 2d arrays(a rectangular grid of homogeneous independent elements). We also used selectors to select the 
various columns in the data (petal width and length, sepal width and length).

We used recursion throughout the project since several different list operations involve recursing through the 
list by using car and cdr. For example, since CSV stores everything in a string format, to perform operations on the 
numbers in a data set, they must first casted to numbers and the non-number fields need to be removed. Recursion has 
also been used to making the plots. When plotting, the plot function will recursively build a list of points to plot.

We used mapping, filtering, and reductions to perform various data manipulations on the dataset. For example, a map for 
operations such as removing a certain column from a table. Folds to to sum all of the numbers in a column, calculate the 
standard deviation, mean, total, min, max and count of a dataset. 

Also, we used higher order functions to perform operations on several elements in a 2d list or array. All the statics 
functions use varying foldr functions. Linear regression used many higher order functions to for summations in the 
formula or mapping equations to every elements of the list. The math/matrix library was used to perform matrix multiplications.

Our project used some state modification. Linear regression used a let* to create a bunch of closures. This
is so I can calculate intermediate steps of calculating linear regression. 

The array library in racket supports a lot of list manipulation similar to what we did in Haskell like 
array slicing and mapping. Almost all of the array functions involved a map function.

There is a bit of expression evaluation going on in our project. The selectors hold 2 parts a lambda expersion that will uses cars and cdrs
to get a the column number that corepsonds with the name of the column and a string that is the acutal name of the column.
If the symbol 'name is passed to the procedure, the name of the column is returned, Otherwise the lambda expersion is returned.
Also in the plot2D function, the last argument decides if a linear regression should be plotted or not. If the symbol 'none is
passed then it wont, otherwise it will. Although this doesn't make logical sense it was made as an intention to be expanded upon
in the future.



### External Technologies

Our project connected to data sets from UCI (for example https://archive.ics.uci.edu/ml/datasets/Iris) or by
reading/writing from a CSV file.

### Data Sets or other Source Materials

We will be using the iris dataset from UCI (https://archive.ics.uci.edu/ml).

### Deliverable and Demonstration

we made some different data visualizations, a plot of a principal component analysis like the sample image 
below, a linear regression plot[ADD IMAGE AND INFO ON OTHER PLOTS], 

![pca image](/pca.png?raw=true "pca image")

The functions we implemented are fairly general and it should be possible to apply to other datasets. 
For example the code casting numbers in a 2 dimensional list can be applied to any list of lists. 

### Evaluation of Results
We were successful in producing a Principal Component Analysis of the iris dataset, and a linear
regression plot. 

## Architecture Diagram

![OPL_FP_image](/OPL_FP.png?raw=true "OPLFP image")

Data was obtained from the UCI Machine Learning Repository in CSV format. We can then use the Racket CSV library to
move it into memory as a list of lists of strings. From there we were able to  process the data using Racket 
(cons cells and arrays)until it was ready to plot using the plot library.

## Schedule


### First Milestone (Sun Apr 9)

Writing code required to do initial manipulations from the raw csv data to a usable data abstraction.

### Second Milestone (Sun Apr 16)
completing the plots

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28 [your date to be determined later])
additional data visualizations time permitting 

## Group Responsibilities

### Robert Farinelli @rfarinel
Data filtering and statically analysis of data (total, count, average, standard deviation, min, max)
Data visualization of data from UCI repository (2D point plots of 2 different features with linear regression, 
3D point plots of 3 different features, and bar charts for statistical analysis).

### Christopher Pearce @cp0153
Principal Component Analysis of Iris on the UCI repository.
