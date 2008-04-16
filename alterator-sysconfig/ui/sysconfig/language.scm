(document:surround "/std/frame")
(document:insert "/std/functions")

;;; Helpers

(define (name+description x)
  (cons (woo-get-option x 'name)
        (woo-get-option x 'description)))

(define *languages* (make-cell '()))

(define (current-language)
  (string-cut (car (list-ref (cell-ref *languages*) (langlist current))) #\:))

(define (write-language)
  (woo-catch/message
   (thunk
    (let ((lang (current-language)))
      (woo-write "/syslang" 'lang lang)
      (woo-write "/autoinstall/syslang" 'lang lang)
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
                      (wizard-id steps-clear)
                      (wizard-id steps (map label+icon (woo-list "/step-list")))
                      (wizard-id current-step 0)
                      (wizard-id action-text 'forward (_ "Next"))))

  ;;common hacks
  (with-translation _ "alterator-sysconfig"
                    (label-choose text (_ "Select your language"))))

(define (default-language)
  (define-operation get-lang)
  (car (get-lang (fluid-ref generic-session))))

;;; UI

(gridbox
  columns "30;40;30"
  ;;
  (spacer)
  (document:id label-choose (label "Select your language"))
  (spacer)

  ;;
  (spacer)
  (document:id langlist
	       (listbox (when selected
			  (change-translations))
			(when double-clicked
			  (frame:next))))
  (spacer))

;;; Logic

(frame:on-next (thunk (or (write-language) 'cancel)))

(document:root
 (when loaded
   (woo-catch/message
    (thunk
     (let ((languages (map name+description (woo-list "/syslang")))
           (default (default-language)))
       (cell-set! *languages* languages)
       (langlist rows (map cdr languages)
                 current (or (string-list-index default (map car languages))
                             0))
       (langlist selected))))))
