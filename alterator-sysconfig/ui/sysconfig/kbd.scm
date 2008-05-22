(document:surround "/std/frame")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-sysconfig")


(define keyboard-names `(("alt_sh_toggle" . ,(_ "Alt+Shift key"))
			 ("caps_toggle" . ,(_ "CapsLock key"))
                         ("ctrl_shift_toggle" . ,(_ "Control+Shift keys"))
                         ("ctrl_toggle" . ,(_ "Control key"))
                         ("toggle" . ,(_ "Alt key"))
			 ("ctrl_shift_toggle_ru_ua" . ,(_ "Control+Shift keys, UK,RU,EN"))
                         ("default" . ,(_ "Default"))
                         ("nodeadkeys" . ,(_ "Without dead keys"))))


(define keyboards (woo-catch
                   (lambda()
                     (woo-list-names "/syskbd"))
                   (lambda(reason) '())))

(define (get-name item)
  (cond-assoc item keyboard-names item))

(define (write-keyboard)
  (woo-catch/message
    (thunk
      ;;save console font
      (woo-write "/sysfont")
      ;;save console and X11 keyboard layout
      (let ((current (keyboard-type current)))
	(and (>= current 0)
	     (begin
	       (woo-write (string-append "/syskbd/" (list-ref keyboards current))))))
      #t)))

;;;;;;;;;;;;

(gridbox
  columns "30;40;30"
  ;;
  (spacer)
  (label (_ "Please select keyboard switch type"))
  (spacer)
  ;;
  (spacer)
  (document:id keyboard-type (listbox
			       rows (map get-name keyboards)
			       (and (> (length keyboards) 0) (current 0))
			       (when double-clicked (frame:next))))
  (spacer))

(frame:on-next (thunk (or (write-keyboard) 'cancel)))


(document:root (when loaded
                 (let ((len (length keyboards)))
                   (and (= len 1) (write-keyboard))
                   (and (<= len 1) (frame:skip)))))

