(document:surround "/std/frame")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-sysconfig")

(define (write-keyboard)
  (woo-catch/message
    (thunk
      (woo-write "/sysfont");;save console font
      (and-let* ((kbd (keyboard-type value)));;save console and X11 keyboard layout
	(woo-write "/syskbd/" 'layout kbd))
      #t)))

;;;;;;;;;;;;

(gridbox
  columns "30;40;30"
  ;;
  (spacer)
  (label (_ "Please select keyboard switch type:"))
  (spacer)
  ;;
  (spacer)
  (document:id keyboard-type (listbox
			       (when double-clicked (frame:next))))
  (spacer))

(frame:on-next (thunk (or (write-keyboard) 'cancel)))

(document:root (when loaded
                 (keyboard-type enumref "/syskbd")
                 (let ((len (keyboard-type count)))
                   (and (positive? len) (keyboard-type current 0))
                   (and (= len 1) (write-keyboard))
                   (and (<= len 1) (frame:skip)))))
