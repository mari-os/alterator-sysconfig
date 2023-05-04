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

  (label)
  (label text (_ "<strong>Attention!</strong> Account and password work only for curl and wget. If you use proxy for apt-get or any graphical web-browser, leave these fields empty.") text-wrap #t colspan 3)

  (label colspan 4)

  (label text (_ "No Proxy for:") align "right" name "noproxy")
  (edit colspan 3 name "noproxy")
  (label) (label text (small (_ "(multiple values should be comma separated)")))

  (label colspan 4)

  (label)
  (hbox
    colspan 3
    align "left"
    (button text (_ "Apply") name "apply")
    (button text (_ "Reset") name "reset")))

