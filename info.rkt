#lang info
(define collection "jot")
(define deps '("base" "date" "command-line"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/jot.scrbl" ())))
(define pkg-desc "A minimal notetaking application.")
(define version "2021-12-26")
(define pkg-authors '(wtee))
(define license '(GPL-3.0-or-later))
