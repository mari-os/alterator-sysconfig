(document:surround "/std/base")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-syskbd")


(define keyboard-names `(("caps_toggle" . ,(_ "CapsLock key"))
                         ("ctrl_shift_toggle" . ,(_ "Control+Shift keys"))
                         ("ctrl_toggle" . ,(_ "Control key"))
                         ("toggle" . ,(_ "Alt key"))
                         ("default" . ,(_ "Default"))
                         ("nodeadkeys" . ,(_ "Without dead keys"))))


(define main-language (let ()
                        (define-operation get-lang)
                        (car (get-lang (fluid-ref generic-session)))))

(define keyboards (woo-catch
                   (lambda()
                     (woo-list-names "/syskbd" 'lang main-language))
                   (lambda(reason) '())))

(define (get-name item)
  (cond-assoc item keyboard-names item))

(define (apply-keyboard)
  (woo-catch
   (thunk
    (let ((current (keyboard-type current)))
      (and (>= current 0)
           (woo-write (string-append "/syskbd/"
                                     main-language
                                     "/"
                                     (list-ref keyboards current)))))
        #t)
   (lambda(reason) #f)))

;;;;;;;;;;;;
children-align center
margin 50
(label (_ "Please select keyboard variant or switch type for your system language"))

(document:id keyboard-type (listbox
                            layout-policy 100 -2
                            rows (map get-name keyboards)
			    (and (> (length keyboards) 0) (current 0))))

;;will be replaced with frame:on-next
(button "Apply" (when clicked
                  (apply-keyboard)))
