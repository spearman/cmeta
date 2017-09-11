#lang racket

;;
;;  module main
;;
(module+ main
  (require (prefix-in c:           c))
  (require (prefix-in rkt:logging: racket/logging))
  (require (prefix-in parse:       "./parse.rkt"))

  ;; parameters
  (define log-level        (make-parameter 'error))
  ;; command-line parameters
  (define input-file-path  (make-parameter #f))  ; required
  (define output-file-path (make-parameter #f))  ; optional
  (define debug-flag       (make-parameter #f))  ; optional
  (define quiet-flag       (make-parameter #f))  ; optional

  ;; parse command line arguments: provides implicit -h and --help flags;
  ;; requires an <input-file> argument to be provided or else a message will
  ;; be printed and program returns with exit code '1'
  (input-file-path (command-line
    #:once-each
    [("-o" "--output") output "Path to the output file"
      (output-file-path output)]
    #:once-any
    [("-g" "--debug") "Enable debug logging to stderr"
      (debug-flag #t) (log-level 'debug)]
    [("-q" "--quiet") "Suppress all logging to stderr"
      (quiet-flag #t) (log-level 'none)]
    #:args ([input #f]) input))

  ;;
  ;;  proc main
  ;;
  (define main (lambda ()
    (displayln "main...")

    (define source-lines (make-parameter #f))
    (define (read-lines strings)
      (let ([maybe-string (read-line)])
        (if (string? maybe-string)
          (read-lines (cons maybe-string strings))
          strings
        )
      )
    )

    (if (input-file-path)
      (source-lines (file->lines (input-file-path) #:mode 'text))
      (source-lines (read-lines null))
    )

    (printf "debug: source raw line count: ~a\n"
      (length (source-lines))
    )

#|
    (pretty-display (c:parse-program "\
int foo() { return 5; }
int main() { printf (\"foo: %i\\n\", foo()); }"))
|#

    (displayln "...main"))
  ) ;; end proc main

  ;;
  ;; run proc main with the specified log level
  ;;
  (rkt:logging:with-logging-to-port (current-error-port) main (log-level))


) ;; end module main
