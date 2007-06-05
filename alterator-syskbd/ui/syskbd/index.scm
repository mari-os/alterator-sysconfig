(document:surround "/std/frame")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-syskbd")


(define keyboard-names `(("alt_sh_toggle" . ,(_ "Alt+Shift key"))
			 ("caps_toggle" . ,(_ "CapsLock key"))
                         ("ctrl_shift_toggle" . ,(_ "Control+Shift keys"))
                         ("ctrl_toggle" . ,(_ "Control key"))
                         ("toggle" . ,(_ "Alt key"))
                         ("default" . ,(_ "Default"))
                         ("nodeadkeys" . ,(_ "Without dead keys"))))


(define keyboards (woo-catch
                   (lambda()
                     (woo-list-names "/syskbd"))
                   (lambda(reason) '())))

(define (get-name item)
  (cond-assoc item keyboard-names item))

(define (apply-keyboard)
  (woo-catch
   (thunk
    (let ((current (keyboard-type current)))
      (and (>= current 0)
           (begin
             (woo-write (string-append "/syskbd/" (list-ref keyboards current)))
             (woo-write (string-append "/autoinstall/syskbd/" (list-ref keyboards current))))))
    #t)
   (lambda(reason) #f)))

;;;;;;;;;;;;

(hbox
 (spacer)
 (vbox
  max-height 200
  (label (_ "Please select keyboard switch type"))
  (document:id keyboard-type (listbox
                              layout-policy 100 -2
                              max-width 300
                              rows (map get-name keyboards)
                              (and (> (length keyboards) 0) (current 0)))))
 (spacer))

(frame:on-next apply-keyboard)

(define (skip-step)
  (if (eq? (global 'frame:direction) 'next)
      (frame:next)
      (frame:back)))

(document:root (when loaded
                 (let ((len (length keyboards)))
                   (and (= len 1) (apply-keyboard))
                   (and (<= len 1) (skip-step)))))

