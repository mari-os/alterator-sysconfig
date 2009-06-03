(document:surround "/std/frame")

(gridbox
  columns "0;80;0;20"
  margin 40

  (label text (_ "Proxy server:") align "right" name "server")
  (edit name "server")
  (label text (_ "Port:") name "port")
  (edit name "port")

  (label colspan 4)

  (label text (_ "Account:") align "right" name "login")
  (edit colspan 3 name "login")

  (label text (_ "Password:") align "right" name "passwd")
  (edit colspan 3 name "passwd" echo "stars")

  (label colspan 4)

  (label)
  (hbox
    colspan 3
    align "left"
    (button text (_ "Apply") name "apply")
    (button text (_ "Reset") name "reset")))

