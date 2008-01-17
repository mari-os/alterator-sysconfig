(document:surround "/std/base")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-proxy")

(gridbox columns "20;40;60;20"
	 ;;
	 (spacer)
	 (label (_ "Proxy server"))
	 (document:id server (edit "" widget-name "server"))
	 (spacer)
	 ;;
	 (spacer)
	 (label (_ "Proxy port"))
	 (document:id port (edit "" widget-name "port"))
	 (spacer)
	 )

(hbox
  align "center"
  (document:id apply-button (button (_ "Apply")))
  (document:id reset-button (button (_ "Reset")))
  (document:id quit-button (button (_ "Quit") )))

;;;;;;;;;;;;;;;;;;;;;;
(define (read-proxy)
  (let ((data (woo-read-first "/proxy" )))
    (server text (woo-get-option data 'server))
    (port text (woo-get-option data 'port))
    ))

(define (write-proxy server port)
  (woo-catch/message
    (thunk
      (woo-write/constraints "/proxy"
	     'server server
	     'port port
	     ))))

;;;;;;;;;;;;;;;;;;;;;;
(apply-button (when clicked
		(let ((apply-server (server text))
		      (apply-port (port text)))
		  (if (and
			(not-empty-string? apply-server)
			(not-empty-string? apply-port))
		    (write-proxy apply-server apply-port)))))

(reset-button (when clicked
		(read-proxy)))

(quit-button (when clicked
	       (document:end)))

;;;;;;;;;;;;;;;;;;;;;;
(document:root
  (when loaded
    (read-proxy)
    (update-constraints "write" "/net-pptp")))

