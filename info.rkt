#lang info
(define collection "quaternion")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "math-doc"))
(define scribblings '(["quaternion.scrbl" () ("3D")]))
(define pkg-desc "Quaternions")
(define version "1.0")
(define pkg-authors '(APOS80))
