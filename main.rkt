#lang racket

;;    Copyright 2021 W. Teal

;;    This program is free software: you can redistribute it and/or modify
;;    it under the terms of the GNU General Public License as published by
;;    the Free Software Foundation, either version 3 of the License, or
;;    (at your option) any later version.

;;    This program is distributed in the hope that it will be useful,
;;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;    GNU General Public License for more details.

;;    You should have received a copy of the GNU General Public License
;;    along with this program.  If not, see <https://www.gnu.org/licenses/>.

(module+ test
  (require rackunit))

(require racket/date)
(require racket/cmdline)
(date-display-format 'iso-8601)

(define/contract (slice-at-char in-list slice-here max-length)
  (-> list? char? exact-positive-integer? list?)
  (if (< (length in-list) max-length)
      (list in-list)
      (let ([split-index
             (last (filter
                    (lambda (i) (<= i max-length))
                    (indexes-of in-list slice-here)))])
        (cons
         (take in-list split-index)    
         (slice-at-char (drop in-list (+ split-index 1)) slice-here max-length)))))

(define/contract (iota-wrap iota)
  (-> string? string?)
  (let ([max-length 56]
        [date-prefix (string-join (list (date->string (current-date) #t) "-- "))]
        [indent (make-string 23 #\space)])
    (string-append
     date-prefix
     (string-join
      (map list->string
           (add-between
            (slice-at-char (string->list iota) #\space 56)
            '(#\newline)))
      indent))))

(define/contract (load-jottery-path)
  (-> path?)
  (let ([config-file
          (build-path
           (find-system-path 'home-dir)
           ".config"
           "jot"
           "location.txt")])
    (if (and (file-exists? config-file)
             (not (= 0 (file-size config-file))))
        (with-input-from-file config-file
          (lambda ()
            (string->path (read-line))))
        (let ([jottery  (build-path (find-system-path 'home-dir)
                          "jottery.txt")])
          (make-parent-directory* config-file)
          (with-output-to-file config-file #:exists 'truncate
                (lambda ()
                  (displayln (path->string jottery))))
          jottery))))

(module+ test
  (let ([test-string
         "I am a long test string that is long enough to need to be wrapped for this test."]
        [answer-string
         "I am a long test string\nthat is long enough to\nneed to be wrapped for\nthis test."])

  (check-equal?
   (string-join
      (map list->string
           (add-between
            (slice-at-char (string->list test-string) #\space 25)
            '(#\newline))) "")
   answer-string)))

(module+ main
  (command-line
   #:args (iota)
  (let ([jottery (load-jottery-path)])
     (with-output-to-file jottery #:exists 'append
       (lambda ()
         (displayln
          (iota-wrap iota))
         (displayln ""))))))
