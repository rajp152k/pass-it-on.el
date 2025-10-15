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

(defgroup pass-it-on nil
  "Forward input to another X window."
  :group 'applications)

(defvar pass-it-on-target-window-id nil
  "The X Window ID of the window to control.")

;;;###autoload
(defun pass-it-on-select-window ()
  "Select a target window for pass-it-on-mode using `xwininfo`."
  (interactive)
  ;; Implementation to follow
  (message "pass-it-on-select-window not implemented yet."))

(defun pass-it-on-forward-input ()
  "Forward the last keypress to the target window using xdotool."
  (interactive)
  ;; Implementation to follow
  (message "pass-it-on-forward-input not implemented yet."))

;;;###autoload
(define-minor-mode pass-it-on-mode
  "A minor mode to forward input to another X window."
  :init-value nil
  :lighter " PassItOn"
  :keymap (make-sparse-keymap)
  (if pass-it-on-mode
      (progn
        (when (not pass-it-on-target-window-id)
          (call-interactively #'pass-it-on-select-window))
        (if pass-it-on-target-window-id
            (message "Pass-It-On mode enabled for window %s." pass-it-on-target-window-id)
          (progn
            (message "No target window selected. Disabling mode.")
            (setq pass-it-on-mode nil))))
    (message "Pass-It-On mode disabled.")))

(provide 'pass-it-on)

;;; pass-it-on.el ends here
