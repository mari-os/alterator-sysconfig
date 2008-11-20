(document:surround "/std/frame")

(gridbox
  columns "0;80;0;20"
  margin 40

  (label (_ "Proxy server:") align "right" name "server")
  (edit name "server")
  (label (_ "Port:") name "port")
  (edit name "port")

  (label colspan 4)

  (label (_ "Account:") align "right" name "login")
  (edit colspan 3 name "login")

  (label (_ "Password:") align "right" name "passwd")
  (edit colspan 3 name "passwd" echo "stars")

  (label colspan 4)

  (label)
  (hbox
    colspan 3
    align "left"
    (button (_ "Apply")
	    (when clicked (form-write/message "/sysproxy")
	                  (form-read/message "/sysproxy")))
    (button (_ "Reset")
	    (when clicked (form-read/message "/sysproxy")))))

(document:root
  (when loaded
    (form-read/message "/sysproxy")))
