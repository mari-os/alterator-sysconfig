(document:surround "/std/base")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-proxy")

;; DISPLAY =============================================================

;;**********************************************************************
(gridbox columns "10;80;10"
	;;--------------------------------
	(spacer)
	(document:id proxy_enabled
		(checkbox
			(_ "Enabled")
			state #t
			tooltip (_ "Enable or disable this proxy")
			(when toggled
				(toggle-control-activity (proxy_enabled state) (widgets server port login password))
			)
		)
	)
	(spacer)
	;;--------------------------------
	(spacer)
	(groupbox (_ "Proxy")
		(gridbox columns "10;30;50;10"
			;;--------------------------------
			(spacer)
			(label (_ "Server"))
			(document:id server
				(edit
					""
					widget-name "server"
					tooltip (_ "Might be as simple as \"proxy\"")
					(when changed (clean-edit server "[^a-zA-Z0-9.-]\+"))
				)
			)
			(spacer)
			;;--------------------------------
			(spacer)
			(label (_ "Port"))
			(document:id port
				(edit
					""
					widget-name "port"
					tooltip (_ "Usual values are 3128 or 8080")
					(when changed (clean-edit port "[^0-9]\+"))
				)
			)
			(spacer)))
	(spacer)
	;;--------------------------------
	(spacer)
	(groupbox (_ "Authentication")
		(gridbox columns "10;30;50;10"
			;;--------------------------------
			(spacer)
			(label (_ "Login"))
			(document:id login
				(edit
					""
					widget-name "login"
					tooltip (_ "Only needed for authenticated proxy")
					(when changed (clean-edit login "[^a-z0-9_-]\+"))
				)
			)
			(spacer)
			;;--------------------------------
			(spacer)
			(label (_ "Password"))
			(document:id password
				(edit
					""
					echo stars
					widget-name "password"
					tooltip (_ "Makes sense with login")
					;;FIXME user may enter one of sepchars
	 				;;(when changed (clean-edit password ????))
				)
			)
			(spacer)))
	(spacer)
	;;--------------------------------
	(spacer)
	(gridbox columns "30;30;30"
		align "center"
		(document:id apply-button (button (_ "Save")))
		(document:id reset-button (button (_ "Reload")))
		(document:id quit-button (button (_ "Quit") ))
	)
	(spacer)
)

;; BEHAVIOUR ===========================================================

;;**********************************************************************
(apply-button (when clicked (write-proxy)))

;;**********************************************************************
(reset-button (when clicked (read-proxy)))

;;**********************************************************************
(quit-button (when clicked (document:end)))

;;**********************************************************************
(define (clean-edit edt rx-string)
	(define s (edt text))
	(define z (make-cell ""))
	(cond
		((not-empty-string? rx-string)
			(cell-set! z (regexp-substitute/global #f rx-string s 'pre 'post))
			(if (not (string=? (cell-ref z) s))
				(edt text (cell-ref z))
			)
		)
	)
)

;;**********************************************************************
(define (toggle-control-activity what controls)
	(controls alterability what activity what)

;; 	(if what
;; 		(proxy_enabled text (_ "Enabled"))
;; 		(proxy_enabled text (_ "Disabled"))
;; 	)
)

;;**********************************************************************
(define (read-proxy)
	(let
		(
			(data (woo-read-first "/proxy" ))
		)

		(server text (woo-get-option data 'server))
		(port text (woo-get-option data 'port))
		(login text (woo-get-option data 'login))
		(password text (woo-get-option data 'password))
		(proxy_enabled state (woo-get-option data 'enabled))
	)
)

;;**********************************************************************
(define (write-proxy)
	(woo-catch/message
		(thunk
			(woo-write/constraints "/proxy"
				'server (server text)
				'port (port text)
				'login (login text)
				'password (password text)
				'enabled (proxy_enabled state)
			)
		)
	)
)

;; MAIN ================================================================

;;**********************************************************************
(document:root
	(when loaded
		(read-proxy)
		(update-constraints "read" "/proxy" 'enabled (proxy_enabled state))
		(toggle-control-activity (proxy_enabled state) (widgets server port login password))
	)
)
