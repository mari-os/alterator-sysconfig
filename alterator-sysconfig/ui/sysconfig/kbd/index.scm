(document:surround "/std/frame")
(document:insert "/std/functions")

(po-domain "alterator-sysconfig")

(define (write-keyboard)
  (woo-catch/message
    (thunk
      (woo-write "/sysfont");;save console font
      (and-let* ((kbd (keyboard-type value)));;save console and X11 keyboard layout
	(woo-write "/syskbd/" 'layout kbd))
      #t)))

(define (default-keyboard)
  (keyboard-type value (woo-get-option (woo-read-first "/syskbd")
                                       'layout))
  (or (positive? (keyboard-type current))
      (keyboard-type current 0)))

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
		 (woo-catch/message
		   (lambda()
		       (keyboard-type enumref "/syskbd")
		     (let ((len (keyboard-type count)))
		       (and (positive? len) (default-keyboard))
		       (and (= len 1) (write-keyboard))
		       (and (<= len 1) (frame:skip)))))))

