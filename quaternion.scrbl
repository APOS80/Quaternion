#lang scribble/manual

@require[
         @for-label[;quaternion
                    racket
                    racket/base
                    racket/flonum
                    ]]

@title{Quaternion}
@author{APOS80}

@defmodule[quaternion]

@section{Intro}
Quaternions are used for rotation of koordinates and vectors.

@section{Structures}

@defstruct*[qvector ([x flonum?][y flonum?][z flonum?]) #:mutable #:transparent]

@defstruct*[quaternion ([w flonum?] [v qvector?]) #:mutable #:transparent]

@section{Basic procedures}

@defproc[(q-add [q1 (quaternion?)]
                [q2 (quaternion?)])
         quaternion?]

@defproc[(q-sub [q1 (quaternion?)]
                [q2 (quaternion?)])
         quaternion?]

@defproc[(q-norm [q (quaternion?)])
          quaternion?]

@defproc[(q-normalize [q (quaternion?)])
          quaternion?]

@defproc[(q-multiply-qq [q1 (quaternion?)]
                     [q2 (quaternion?)])
          quaternion?]

@defproc[(q-divide-qs [q (quaternion?)]
                      [s (flonum?)])
          quaternion?]

@defproc[(q-negate [q (quaternion?)])
          quaternion?]

@defproc[(q-conjugate [q (quaternion?)])
          quaternion?]

@defproc[(q-inverse [q (quaternion?)])
          quaternion?]

@section{Rotation}

@defproc[(q-rotation [angl (flonum?)]
                     [qv (qvector?)])
          quaternion?]
Rotation in radians about an arbitrary axis.
Positive rotation is anticlockwise! 

@defproc[(q-rotate [rotation (quaternion?)]
                   [object (quaternion?)])
          quaternion?]
Applyes the rotation on an object.
Object quaternion's w has to be 0!

@section{Examples}


@racketblock[
             (code:comment "Rotation about one axis:")
  (let*
    ([A (q-rotation (fl/ pi 2.0) (qvector 0.0 1.0 0.0))](code:comment "Rotation 90degrees about Y-axis.")
     [B (q-rotate A (quaternion 0.0 (qvector 0.0 0.0 1.0)))])(code:comment "Apply rotation on quaternion with A.")
  (begin
  (printf "X: ~a\n" (~r(qvector-x (quaternion-v B))))(code:comment "Print results.")
  (printf "Y: ~a\n" (~r(qvector-y (quaternion-v B))))
  (printf "Z: ~a\n" (~r(qvector-z (quaternion-v B))))
  ))
 ]


@racketblock[
             (code:comment "Rotation about two axis:")
  (let*
    ([A1 (q-rotation (fl/ pi 4.0) (qvector 0.0 1.0 0.0))](code:comment "Rotation 90degrees about Y-axis.")
     [A2 (q-rotation (fl/ pi 4.0) (qvector 1.0 0.0 0.0))](code:comment "Rotation 90degrees about X-axis.")
     [AS (q-multiply-qq A1 A2)](code:comment "Combine rotations.")
     [B (q-rotate AS (quaternion 0.0 (qvector 0.0 0.0 1.0)))])(code:comment "Apply rotation on quaternion with A.")
  (begin
  (printf "X: ~a\n" (~r(qvector-x (quaternion-v B))))(code:comment "Print results.")
  (printf "Y: ~a\n" (~r(qvector-y (quaternion-v B))))
  (printf "Z: ~a\n" (~r(qvector-z (quaternion-v B))))
  ))
 ]
