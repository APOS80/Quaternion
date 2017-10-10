#lang typed/racket

(require math/flonum)

(provide (all-defined-out))

(struct qvector ([x : Flonum] [y : Flonum] [z : Flonum]) #:transparent #:mutable)
(struct quaternion ([w : Flonum] [v : qvector]) #:transparent #:mutable)

;quaternion length.
(: q-norm (-> quaternion Flonum))
(define (q-norm q)
     (flsqrt (flsum (list
                     (fl* (quaternion-w q) (quaternion-w q))
                     (fl* (qvector-x (quaternion-v q)) (qvector-x (quaternion-v q)))
                     (fl* (qvector-y (quaternion-v q)) (qvector-y (quaternion-v q)))
                     (fl* (qvector-z (quaternion-v q)) (qvector-z (quaternion-v q)))
                     )))
  )

;Normalizes a quternion, a normalized quaternion is also called a unit quaternion.
(: q-normalize (-> quaternion quaternion))
(define (q-normalize q)
  (let ([l (q-norm q)])
    (quaternion (fl/ (quaternion-w q) l)
                (qvector
                (fl/ (qvector-x (quaternion-v q)) l)
                (fl/ (qvector-y (quaternion-v q)) l)
                (fl/ (qvector-z (quaternion-v q)) l))))
  )

(: q-add (-> quaternion quaternion quaternion))
(define (q-add q1 q2)
  (quaternion (fl+ (quaternion-w q1) (quaternion-w q2))
              (qvector
              (fl+ (qvector-x (quaternion-v q1)) (qvector-x (quaternion-v q2)))
              (fl+ (qvector-y (quaternion-v q1)) (qvector-y (quaternion-v q2)))
              (fl+ (qvector-z (quaternion-v q1)) (qvector-z (quaternion-v q2)))))
  )

(: q-sub (-> quaternion quaternion quaternion))
(define (q-sub q1 q2)
  (quaternion (fl- (quaternion-w q1) (quaternion-w q2))
              (qvector
              (fl- (qvector-x (quaternion-v q1)) (qvector-x (quaternion-v q2)))
              (fl- (qvector-y (quaternion-v q1)) (qvector-y (quaternion-v q2)))
              (fl- (qvector-z (quaternion-v q1)) (qvector-z (quaternion-v q2)))))
  )

;Multiply two quaternions.
(: q-multiply-qq (-> quaternion quaternion quaternion))
(define (q-multiply-qq q1 q2)
  (let ([a1 (quaternion-w q1)]
        [b1 (qvector-x (quaternion-v q1))]
        [c1 (qvector-y (quaternion-v q1))]
        [d1 (qvector-z (quaternion-v q1))]
        [a2 (quaternion-w q2)]
        [b2 (qvector-x (quaternion-v q2))]
        [c2 (qvector-y (quaternion-v q2))]
        [d2 (qvector-z (quaternion-v q2))])
    (quaternion (- (fl* a1 a2) (fl* b1 b2) (fl* c1 c2) (fl* d1 d2))
                (qvector
                (+ (fl* a1 b2) (fl* b1 a2) (fl* c1 d2) (fl* -1.0 (fl* d1 c2)))
                (+ (fl* a1 c2) (fl* -1.0 (fl* b1 d2)) (fl* c1 a2) (fl* d1 b2))
                (+ (fl* a1 d2) (fl* b1 c2) (fl* -1.0 (fl* c1 b2)) (fl* d1 a2)))))
  )

;Divide quatrenion with scalar.
(: q-divide-qs (-> quaternion Float quaternion))
(define (q-divide-qs q s)
  (quaternion (fl/ (quaternion-w q) s)
              (qvector
              (fl/ (qvector-x (quaternion-v q)) s)
              (fl/ (qvector-y (quaternion-v q)) s)
              (fl/ (qvector-z (quaternion-v q)) s)))
  )

(: q-negate (-> quaternion quaternion))
(define (q-negate q)
     (quaternion (fl* -1.0 (quaternion-w q))
                 (qvector
                 (fl* -1.0 (qvector-x (quaternion-v q)))
                 (fl* -1.0 (qvector-y (quaternion-v q)))
                 (fl* -1.0 (qvector-z (quaternion-v q)))))
  )

(: q-conjugate (-> quaternion quaternion))
(define (q-conjugate q)
     (quaternion (quaternion-w q)
                 (qvector
                 (fl* -1.0 (qvector-x (quaternion-v q)))
                 (fl* -1.0 (qvector-y (quaternion-v q)))
                 (fl* -1.0 (qvector-z (quaternion-v q)))))
  )

(: q-inverse (-> quaternion quaternion))
(define (q-inverse q)
  (q-divide-qs
   (q-conjugate q)
   (fl* (q-norm q) (q-norm q)))
  )

;define rotation about an arbitrary axis
;Positive rotation is anticlockwise! 
(: q-rotation (-> Flonum qvector quaternion))
(define (q-rotation angl qv)
  (let* ([v (flsin (fl/ angl 2.0))]
         [x (fl* (qvector-x qv) v)]
         [y (fl* (qvector-y qv) v)]
         [z (fl* (qvector-z qv) v)]
         )
    (quaternion (flcos (fl/ angl 2.0)) (qvector x y z))
    )
  )

;rotate object
;object w => 0!
;Apply rotation on object
(: q-rotate (-> quaternion quaternion quaternion))
(define (q-rotate rotation object)
  (q-multiply-qq
   (q-multiply-qq
    rotation
    object)
   (q-conjugate rotation))
  )

