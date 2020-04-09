(document:surround "/std/frame")

;;; language stuff

(define (current-language)
  (and-let* ((l (form-value "langlist")))
    (string-cut l #\:)))

(define (current-keyboard)
  (form-value "keyboard_type"))

(define (label+icon x)
  (cons (woo-get-option x 'label)
        (woo-get-option x 'icon)))

(define (change-translations)
  (define-operation set-lang)
  (set-lang (fluid-ref generic-session) (current-language))

  (simple-notify document:root 'action "language"
                               'value (current-language))

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
    (form-update-value "label1" (_ "Select your language:"))
    (form-update-value "label2" (_ "Please select keyboard switch type:"))))

(define (default-language)
  (define-operation get-lang)
  (let ((lang (string-join (get-lang (fluid-ref generic-session)) ":")))
    (if (and (not-empty-string? lang)
             (string<> "C" lang))
      lang
      "en_US")))

(define (default-keyboard lst)
  (let ((current (woo-get-option (woo-read-first "/sysconfig-base/kbd") 'layout)))
    (cond
      ((not-empty-string? current) current)
      ((pair? lst) (woo-get-option (car lst) 'name))
      (else ""))))

(define (update-language)
  (change-translations)
  (let ((keyboard-list (woo-list "/sysconfig-base/kbd" 'language (form-value "language"))))
    (form-update-enum "keyboard_type" keyboard-list)
    (form-update-value "keyboard_type" (default-keyboard keyboard-list))))

(define (write-sysconfig)
  (catch/message
    (lambda()
      (let ((lang (current-language))
	    (kbd (current-keyboard)))
	(woo-write "/sysconfig-base/language" 'lang lang)
	(woo-write "/sysconfig-base/kbd" 'layout kbd)
	(simple-notify document:root 'action "language" 'value lang)
	#t))))

;;;;;;;;;;;;

(gridbox
  columns "100"
  margin 50

  (label name "label1" value "Select your language:")
  (listbox name "langlist")
  (label)
  (label name "label2" value "Please select keyboard switch type:")
  (listbox name "keyboard_type"))

(frame:on-next (thunk (or (write-sysconfig) 'cancel)))

(document:root
  (when loaded
    (catch/message
      (lambda()
	(form-update-enum "langlist" (woo-list "/sysconfig-base/language" 'language (form-value "language")))
	(form-update-value "langlist" (default-language))
	(form-bind "langlist" "change" update-language)
	(update-language)))))

