#lang racket
(require srfi/42ref)
(require (planet wmfarr/plt-linalg:1:13/matrix))
(require math/array)

(provide eigensystem)

(define m
  (array #[#[1.00671141 -0.11010327 0.87760486 0.82344326]
          #[-0.11010327  1.00671141 -0.42333835 -0.358937]
           #[0.87760486 -0.42333835  1.00671141  0.96921855]
           #[0.82344326 -0.358937    0.96921855  1.00671141]]))



(eigensystem m)