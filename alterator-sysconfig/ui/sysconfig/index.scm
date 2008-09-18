(document:surround "/std/frame")
(document:insert "/std/functions")

;;; language stuff

(define (current-language)
  (and-let* ((l (langlist value)))
    (string-cut l #\:)))

(define (write-language)
  (woo-catch/message
   (thunk
    (and-let* ((lang (current-language)))
      (woo-write "/syslang" 'lang lang)
      (simple-notify document:root 'action "language" 'value lang)
      #t))))

(define (label+icon x)
  (cons (woo-get-option x 'label)
        (woo-get-option x 'icon)))

(define (change-translations)
  (define-operation set-lang)
  (set-lang (fluid-ref generic-session) (current-language))

  ;;wizardface specific hacks
  (with-translation _ "alterator-wizard"
    (let ((wizard-id (global 'frame:wizard)))
      (if wizard-id
        (begin
          (wizard-id steps-clear)
          (wizard-id steps (map label+icon (woo-list "/step-list")))
          (wizard-id current-step 0)
          (wizard-id action-text 'help (_ "Help"))
          (wizard-id action-text 'forward (_ "Next"))))))

  ;;common hacks
  (with-translation _ "alterator-sysconfig"
    (label1 text (_ "Select your language:"))
    (label2 text (_ "Please select keyboard switch type:"))
    (keyboard-type enumref "/syskbd")
  ))

(define (default-language)
  (define-operation get-lang)
  (string-join (get-lang (fluid-ref generic-session)) ":"))


;;; keyboard stuff

(define (write-keyboard)
  (woo-catch/message
    (thunk
      (woo-write "/sysfont");;save console font
      (and-let* ((kbd (keyboard-type value)));;save console and X11 keyboard layout
        (woo-write "/syskbd/" 'layout kbd))
      #t)))

(define (default-keyboard)
  (keyboard-type value (woo-get-option (woo-read-first "/syskbd") 'layout))
  (or (positive? (keyboard-type current))
      (keyboard-type current 0)))

;;;;;;;;;;;;

(gridbox
  columns "30;40;30"

  (spacer)
  (document:id label1 (label "Select your language:"))
  (spacer)

  (spacer)
  (document:id langlist (listbox (when selected (change-translations))))
  (spacer)

  (spacer)
  (label "")
  (spacer)

  (spacer)
  (document:id label2 (label "Please select keyboard switch type:"))
  (spacer)

  (spacer)
  (document:id keyboard-type (listbox))
  (spacer))

(frame:on-next (thunk (or (write-keyboard) (write-language) 'cancel)))

(document:root (when loaded (woo-catch/message
  (thunk
    (langlist enumref "/syslang"
              value (default-language)
              selected)
    (keyboard-type enumref "/syskbd")
    (let ((len (keyboard-type count)))
      (and (positive? len) (default-keyboard))
      (and (= len 1) (write-keyboard)))
  ))))
