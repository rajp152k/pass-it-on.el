;;; pass-it-on-tests.el --- Tests for pass-it-on.el -*- lexical-binding: t; -*-

(require 'ert)
(require 'pass-it-on)

(ert-deftest pass-it-on-initial-state ()
  "Test the initial state of the package."
  (should (not pass-it-on-mode))
  (should (null pass-it-on-target-window-id)))

(ert-deftest pass-it-on-mode-activation-without-window ()
  "Test that activating the mode without a window ID fails gracefully."
  ;; Ensure the target window is nil before the test
  (let ((pass-it-on-target-window-id nil))
    ;; Interactively, this would prompt the user, but programmatically
    ;; calling the mode function like this allows us to test the logic.
    (pass-it-on-mode 1)
    ;; The mode should see that no window is set and disable itself.
    (should (not pass-it-on-mode))))

;;; pass-it-on-tests.el ends here
