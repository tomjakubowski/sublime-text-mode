;;; sublime-text-mode.el --- care package for erstwhile Sublime Text users

;; Copyright (C) 2017 Tom Jakubowski

;; Author: Tom Jakubowski <tom@crystae.net>
;; Version: 0.1
;; Keywords: games
;; URL: https://github.com/tomjakubowski/sublime-text-mode

;; This file is not part of GNU Emacs.

;; This file is in the public domain. Do whatever you want with it!

;;; Commentary:

;; This package provides a global minor mode to help former Sublime Text users
;; feel more comfortable (by presenting nag screens).
;;
;; To enable, run the `sublime-text-mode' command.  Run again to disable the
;; minor mode.

;;; Code:

(require 'package)

(defvar sublime-text--save-count 0)
(defconst sublime-text--nag-period 7)

(defconst sublime-text--nag-message
  "Emacs is free software. You don't have to pay for Emacs or
register it to stop these popups; just uninstall the
sublime-text-mode package.")

(defun sublime-text--nag ()
  "Nag nag nag."
  (let ((choice (x-popup-dialog
                 (selected-frame)
                 `(,sublime-text--nag-message
                   ("Uninstall sublime-text-mode" . uninstall)
                   ("Cancel" . cancel)))))
    (when (eq choice 'uninstall)
      (sublime-text-mode -1)            ; disabling the mode removes the hook.
      (let ((pkg (assq 'sublime-text-mode package-alist)))
        (when pkg
          (package-delete (cadr pkg))))
      (message-box "Thanks for supporting Emacs, you rock!"))))

(defun sublime-text--maybe-nag ()
  "Bump save count, and nag if enough buffers have been saved.

This function resets `sublime-text-save-count' if the nag is
shown."
  (setq sublime-text--save-count (+ 1 sublime-text--save-count))
  (when (>= sublime-text--save-count sublime-text--nag-period)
    (setq sublime-text--save-count 0)
    (sublime-text--nag)))

;;;###autoload
(define-minor-mode sublime-text-mode
  "Toggle Sublime Text mode globally.

Interactively with no argument, this command toggles the mode.
A positive prefix argument enables the mode, any other prefix
argument disables it.  From Lisp, argument omitted or nil enables
the mode, `toggle' toggles the state.

When Sublime Text mode is enabled, upon saving a buffer you will,
every so often, be presented with a nag screen."
  :lighter " ST3"
  :global t
  (if sublime-text-mode
      (add-hook 'after-save-hook #'sublime-text--maybe-nag)
    (remove-hook 'after-save-hook #'sublime-text--maybe-nag)))

(provide 'sublime-text-mode)

;;; sublime-text-mode.el ends here
