(document:surround "/std/frame")
(document:insert "/std/functions")

;;; language stuff

(define (current-language)
  (and-let* ((l (langlist value)))
    (string-cut l #\:)))

(define (label+icon x)
  (cons (woo-get-option x 'label)
        (woo-get-option x 'icon)))

(define (change-translations)
  (define-operation set-lang)
  (set-lang (fluid-ref generic-session) (current-language))

  ;;wizardface specific hacks
  (and-let* ((wizard-id (global 'frame:wizard))
	     (_ (make-translator "alterator-wizard" (session-language))))
    (wizard-id steps-clear)
    (wizard-id steps (map label+icon (woo-list "/step-list")))
    (wizard-id current-step 0)
    (wizard-id action-text 'help (_ "Help"))
    (wizard-id action-text 'forward (_ "Next")))

  ;;common hacks
  (let ((_ (make-translator "alterator-sysconfig" (session-language))))
    (label1 text (_ "Select your language:"))
    (label2 text (_ "Please select keyboard switch type:"))
    (keyboard-type enumref "/sysconfig/kbd")))

(define (default-language)
  (define-operation get-lang)
  (string-join (get-lang (fluid-ref generic-session)) ":"))

(define (update-lang)
  (change-translations)
  (let ((len (keyboard-type count)))
      (and (positive? len) (default-keyboard))
      (and (= len 1) (write-keyboard))))

;;; keyboard stuff

(define (default-keyboard)
  (keyboard-type value (woo-get-option (woo-read-first "/sysconfig/kbd") 'layout))
  (or (positive? (keyboard-type current))
      (keyboard-type current 0)))

(define (write-sysconfig)
  (catch/message
    (lambda()
      (let ((lang (current-language))
	    (kbd (keyboard-type value)))
	(woo-write "/sysconfig/language" 'lang lang)
	(woo-write "/sysconfig/kbd" 'layout kbd)
	(simple-notify document:root 'action "language" 'value lang)
	#t))))

;;;;;;;;;;;;

(gridbox
  columns "100"
  margin 50

  (document:id label1 (label text "Select your language:"))

  (document:id langlist (listbox (when selected (update-lang))))

  (label)

  (document:id label2 (label text "Please select keyboard switch type:"))

  (document:id keyboard-type (listbox)))

(frame:on-next (thunk (or (write-sysconfig) 'cancel)))

(document:root
  (when loaded
    (catch/message
      (lambda()
	(langlist enumref "/sysconfig/language"
		  value (default-language)
		  selected)
	(keyboard-type enumref "/sysconfig/kbd")))))
