; ***** BEGIN LICENSE BLOCK *****
; * Copyright (C) 2006  Stanislav Ievlev <inger@altlinux.org>
; * Copyright (C) 2007  Alexey Gladkov <legion@altlinux.org>
; *
; * This program is free software; you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation; either version 2 of the License, or
; * (at your option) any later version.
; *
; * This program is distributed in the hope that it will be useful,
; * but WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; * GNU General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program; if not, write to the Free Software
; * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
; ***** END LICENSE BLOCK *****

;;this is a demo of simple authentication dialog
(document:surround "/std/base")
(document:insert "/std/functions")

(define languages (woo-list "/syslang"))

(define (get-description x)
	(woo-get-option x 'description))

(define (get-name x) 
	(woo-get-option x 'name))

(define (get-current-language)
	(get-name (list-ref languages (langlist current))))

(define (set-language)
	(woo-catch/message
	  (thunk (woo-write "/syslang" 'lang (get-current-language))
	         (woo-write "/autoinstall/syslang" 'lang (get-current-language))))
	(simple-notify document:root 'action "language" 'value (get-current-language)))

(define (change-translations)
	(let ()
		(define-operation set-lang)
		(set-lang (fluid-ref generic-session) (list (get-current-language)))
		(with-translation _ "alterator-install2" (apply-button text (_ "OK")))
		(with-translation _ "alterator-install2" (label-choose text (_ "Select your language")))))

(define (set-default-language)
	(and-let* ((l (global 'language))
			((not-empty-string? l))
			(ll (string-cut l #\;)))
			(langlist current (or (string-list-index (car ll) (map get-name languages)) 0))
			(change-translations)
			#f))

(gridbox columns "30;40;30"

	(spacer)
	(document:id label-choose (label "Select your language"))
	(spacer)

	;; line
	(spacer)
	(document:id langlist
		(listbox rows (map get-description languages)
			current 0
			(when selected (change-translations))))
	(spacer)

	;; line
	(spacer)
	(document:id apply-button
		(button "OK"
			(when clicked (and (setenv "INSTALLER_LANGUAGE" (get-current-language)) (set-language) (document:replace '/)))))
	(spacer))

(langlist selected)
(document:root (when loaded (set-default-language)))
