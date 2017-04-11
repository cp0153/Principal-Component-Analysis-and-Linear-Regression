#lang racket

(require plot)
(provide plot-2D plot-3D)


;;(plot-2D list-of-datasets col1 col2) -> plot?
;; list-of-datasets: list of datasets that are lists of lists
;; col1: colmun of the data set to plot on the x-axis
;; col2: colmun of the data set to plot on the y-axis

;;useage: (plot-2D (list Iris-virginica Iris-versicolor) petal-width petal-length)

(define (plot-2D list-of-datasets col1 col2)
  ;;count is used to make sure each dataset ploted has a different color
  (let ([count 0])
    (define (points-ceator list-of-datasets col1 col2 list-of-points)
       (if (null? list-of-datasets)
           list-of-points
           (begin
             (set! count (+ count 1))
             (points-ceator (cdr list-of-datasets) col1 col2
                            (cons  (points
                                    (foldr (lambda(x y)
                                             (cons
                                              (vector
                                               (string->number (col1 x))
                                               (string->number (col2 x))) y))
                                           '()  (car list-of-datasets))
                                          #:color count) list-of-points)))))
   (plot (points-ceator list-of-datasets col1 col2 '()))))



 (define (plot-3D list-of-datasets col1 col2 col3)
   (let ([count 0])
     (define (3D-points-ceator list-of-datasets col1 col2 col3 list-of-points)
       (if (null? list-of-datasets)
           list-of-points
           (begin
             (set! count (+ count 1))
             (3D-points-ceator (cdr list-of-datasets) col1 col2 col3
                               (cons (points3d
                                      (foldr (lambda(x y)
                                               (cons
                                                (list
                                                 (string->number (col1 x))
                                                 (string->number (col2 x))
                                                 (string->number (col3 x))) y))
                                              '() (car list-of-datasets))
                                             #:sym 'dot #:size 20 #:color count) list-of-points)))))
     (plot3d (3D-points-ceator list-of-datasets col1 col2 col3 '()))))