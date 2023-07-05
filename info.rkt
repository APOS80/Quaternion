#lang info
(define collection "quaternion")
(define deps '("base"
               "scribble-lib"
               "typed-racket-lib"
               "typed-racket-more"
               "math-lib"))
(define build-deps '("typed-racket-doc"
                     "racket-doc"
                     "math-doc"))
(define scribblings '(["quaternion.scrbl" () ("Math and Science")]))
(define pkg-desc "Quaternions")
(define version "1.0")
(define pkg-authors '(APOS80))

