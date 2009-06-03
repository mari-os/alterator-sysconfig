(define-module (ui sysconfig proxy ajax)
	       :use-module (alterator ajax)
	       :use-module (alterator woo)
	       :export (on-load))

(define (ui-read)
  (catch/message
    (lambda()
      (form-update-value "passwd" "")
      (form-update-value-list
        '("server" "port" "login")
        (woo-read-first "/sysconfig-proxy")))))

(define (ui-write)
  (catch/message
    (lambda()
      (apply woo-write "/sysconfig-proxy"
                       (form-value-list '("server" "port" "login" "passwd" "language")))
      (ui-read))))

(define (on-load)
  (ui-read)
  (form-bind "apply" "click" ui-write)
  (form-bind "reset" "click" ui-read))

