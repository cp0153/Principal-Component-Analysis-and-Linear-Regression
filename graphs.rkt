#lang racket

(require plot)
(require "data-filtering.rkt")
(provide plot-2D plot-3D plot-statics)

(struct annotated-proc (base note)
   #:property prop:procedure
              (struct-field-index base))

;;(plot-2D list-of-datasets col1 col2) -> plot?
;; list-of-datasets: list of datasets that are lists of lists
;; col1: colmun of the data set to plot on the x-axis
;; col2: colmun of the data set to plot on the y-axis

;;usage: (plot-2D (list Iris-virginica Iris-versicolor) petal-width petal-length 'none)

(define (plot-2D list-of-datasets col1 col2 regression)
  ;;count is used to make sure each dataset plotted has a different color
 (let ([count 0]
       [regression-vals (make-linear-regression (merge-lists list-of-datasets) col1 col2)])
     (define (points-creator list-of-datasets col1 col2 list-of-points)
        (if (null? list-of-datasets)
            (if (eqv? regession 'none)
                list-of-points
                (cons (function
                       (lambda (x) (+ (* (car regression-vals) x) (car (cdr regression-vals)))))
                      list-of-points))
            (begin
              (set! count (+ count 1))
              (points-creator (cdr list-of-datasets) col1 col2
                             (cons  (points
                                     (foldr (lambda(x y)
                                              (cons
                                               (vector
                                                (string->number (col1 x))
                                                (string->number (col2 x))) y))
                                            '()  (car list-of-datasets))
                                           #:color count) list-of-points)))))
   (plot (points-ceator list-of-datasets col1 col2 '()))))




 ;;(define (plot-3D list-of-datasets col1 col2 col3)
   ;;(let ([count 0])
     ;;(define (3D-points-ceator list-of-datasets col1 col2 col3 list-of-points)
      ;; (if (null? list-of-datasets)
      ;;     list-of-points
     ;;      (begin
     ;;        (set! count (+ count 1))
     ;;        (3D-points-creator (cdr list-of-datasets) col1 col2 col3
     ;;                          (cons (points3d
      ;;                                (foldr (lambda(x y)
     ;;                                          (cons
      ;;                                          (list
      ;;                                           (string->number (col1 x))
      ;;                                           (string->number (col2 x))
      ;;                                           (string->number (col3 x))) y))
       ;;                                       '() (car list-of-datasets))
       ;;                                      #:sym 'dot #:size 20 #:color count) list-of-points)))))
    ;; (plot3d (3D-points-creator list-of-datasets col1 col2 col3 '()))))

(define (plot-3D list-of-datasets col1 col2 col3)
   (let ([count 0])
     (define (3D-points-creator list-of-datasets col1 col2 col3 list-of-points)
       (if (null? list-of-datasets)
           list-of-points
           (begin
             (set! count (+ count 1))
             (3D-points-creator (cdr list-of-datasets) col1 col2 col3
                               (cons (points3d
                                      (foldr (lambda(x y)
                                               (cons
                                                (list
                                                 (string->number (col1 x))
                                                 (string->number (col2 x))
                                                 (string->number (col3 x))) y))
                                              '() (car list-of-datasets))
                                             #:sym 'dot #:size 20 #:color count) list-of-points)))))
     (plot3d (3D-points-creator list-of-datasets col1 col2 col3 '()))))


;; usage (plot-statics
(define (plot-statics data-set function param list-of-classes)
  (let ([count 0]
       [min -1])
    (define (histogram-creator dataset function param list-of-classes list-of-histograms)
      (if (null? list-of-classes)
          list-of-histograms
          (begin
            (set! count (+ count 1))
            (set! min (+ min 1))
            (histogram-creator dataset function param (cdr list-of-classes)
                              (cons (discrete-histogram
                                      (list
                                        (vector
                                         (class (car
                                                 (filter dataset param identity
                                                         (car list-of-classes))))
                                         (function dataset param (car list-of-classes))))
                                      #:x-min min #:color count) list-of-histograms)))))
  (plot
   (histogram-creator data-set function param list-of-classes '())
   #:x-label "Class"
   #:y-label (param 'name))))