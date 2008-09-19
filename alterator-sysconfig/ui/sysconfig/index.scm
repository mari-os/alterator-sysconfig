(document:surround "/std/frame")
(document:insert "/std/functions")

;;; language stuff

(define (current-language)
  (and-let* ((l (langlist value)))
    (string-cut l #\:)))

(define (write-language)
  (catch/message
    (lambda()
      (and-let* ((lang (current-language)))
		(woo-write "/sysconfig/language" 'lang lang)
		(simple-notify document:root 'action "language" 'value lang)
		#t))))

(define (label+icon x)
  (cons (woo-get-option x 'label)
        (woo-get-option x 'icon)))

(define (change-translations)
  (define-operation set-lang)
  (set-lang (fluid-ref generic-session) (current-language))

  ;;wizardface specific hacks
  (let ((wizard-id (global 'frame:wizard)))
    (if wizard-id
      (begin
	(wizard-id steps-clear)
	(wizard-id steps (map label+icon (woo-list "/step-list")))
	(wizard-id current-step 0)
	(wizard-id action-text 'help (_ "Help" "alterator-wizard"))
	(wizard-id action-text 'forward (_ "Next" "alterator-wizard")))))

  ;;common hacks
  (label1 text (_ "Select your language:" "alterator-sysconfig"))
  (label2 text (_ "Please select keyboard switch type:" "alterator-sysconfig"))
  (keyboard-type enumref "/sysconfig/kbd"))

(define (default-language)
  (define-operation get-lang)
  (string-join (get-lang (fluid-ref generic-session)) ":"))

(define (update-lang)
  (change-translations)
  (let ((len (keyboard-type count)))
      (and (positive? len) (default-keyboard))
      (and (= len 1) (write-keyboard))))

;;; keyboard stuff

(define (write-keyboard)
  (catch/message
    (lambda()
      (and-let* ((kbd (keyboard-type value)));;save console and X11 keyboard layout
		(woo-write "/sysconfig/kbd/" 'layout kbd))
      #t)))

(define (default-keyboard)
  (keyboard-type value (woo-get-option (woo-read-first "/sysconfig/kbd") 'layout))
  (or (positive? (keyboard-type current))
      (keyboard-type current 0)))

;;;;;;;;;;;;

(gridbox
  columns "30;40;30"

  (spacer)
  (document:id label1 (label text "Select your language:"))
  (spacer)

  (spacer)
  (document:id langlist (listbox (when selected (update-lang))))
  (spacer)

  (label colspan 3)

  (spacer)
  (document:id label2 (label text "Please select keyboard switch type:"))
  (spacer)

  (spacer)
  (document:id keyboard-type (listbox))
  (spacer))

(frame:on-next (thunk (or (write-keyboard) (write-language) 'cancel)))

(document:root
  (when loaded
    (catch/message
      (lambda()
	(langlist enumref "/sysconfig/language"
		  value (default-language)
		  selected)
	(keyboard-type enumref "/sysconfig/kbd")))))

