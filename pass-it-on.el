;;; pass-it-on.el --- Forward input to another X window. -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Raj Patil

;; Author: Raj Patil <raj@cognware.com>
;; Version: 0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: convenience, window-management, x11, control

;;; Commentary:

;; This package provides a minor mode to forward keyboard and mouse
;; input from Emacs to another X window without changing focus. This
;; allows controlling other applications while remaining within Emacs.

;; To use, run `M-x pass-it-on-select-window` and click on the target
;; window. Then, enable the mode with `M-x pass-it-on-mode`.

;;; Code:

(require 'cl-lib)

(defgroup pass-it-on nil
  "Forward input to another X window."
  :group 'applications)

(defvar pass-it-on-target-window-id nil
  "The X Window ID of the window to control.")

;;;###autoload
(defun pass-it-on-select-window ()
  "Select a target window for pass-it-on-mode using `xwininfo`."
  (interactive)
  (let ((output (shell-command-to-string "xwininfo")))
    (if (string-match "Window id: \\(0x[0-9a-fA-F]+\\)" output)
        (let ((window-id (match-string 1 output)))
          (setq pass-it-on-target-window-id window-id)
          (message "Pass-It-On target window set to: %s" window-id))
      (message "Could not get window ID from xwininfo."))))

(defun pass-it-on--char-to-keysym (char)
  "Convert CHAR to an X11 keysym name string."
  (pcase char
    (?\s "space")
    (?\t "Tab")
    (?\r "Return")
    (?\e "Escape")
    (?\b "BackSpace")
    (?\+ "plus")
    (?- "minus")
    (?_ "underscore")
    (?= "equal")
    (?` "grave")
    (?. "period")
    (?, "comma")
    (?: "colon")
    (?\; "semicolon")
    (?< "less")
    (?> "greater")
    (?/ "slash")
    (?\\ "backslash")
    (?| "bar")
    (?\' "apostrophe")
    (?\" "quotedbl")
    (_ (char-to-string char))))

(defun pass-it-on--event-to-xdotool-key-string (event)
  "Convert an Emacs input EVENT to a string for `xdotool key`."
  (let* ((base-key (event-basic-type event))
         (modifiers (event-modifiers event)))
    (let ((key-name (if (characterp base-key)
                        (pass-it-on--char-to-keysym base-key)
                      (downcase (format "%s" base-key))))
          (xdotool-mods (cl-loop for mod in modifiers
                                 collect (pcase mod
                                           ('shift "shift")
                                           ('control "control")
                                           ('meta "alt")
                                           ('alt "alt")
                                           ('super "super")
                                           ('hyper "hyper")))))
      (string-join (append xdotool-mods (list key-name)) "+"))))

(defun pass-it-on-forward-input ()
  "Forward the last keypress to the target window using xdotool."
  (interactive)
  (when pass-it-on-target-window-id
    (let ((key-string (pass-it-on--event-to-xdotool-key-string last-command-event)))
      (call-process "xdotool" nil 0 nil "key" "--window"
                    pass-it-on-target-window-id key-string))))

;;;###autoload
(define-minor-mode pass-it-on-mode
  "A minor mode to forward input to another X window."
  :init-value nil
  :lighter " PassItOn"
  :keymap (make-sparse-keymap)
  (if pass-it-on-mode
      (if pass-it-on-target-window-id
          (progn
            (message "Pass-It-On mode enabled for window %s." pass-it-on-target-window-id)
            ;; TODO: Set up keymap to forward input.
            )
        (progn
          (message "No target window selected. Disabling mode.")
          (setq pass-it-on-mode nil)))
    (message "Pass-It-On mode disabled.")))

(provide 'pass-it-on)

;;; pass-it-on.el ends here
