;;; pass-it-on-tests.el --- Tests for pass-it-on.el -*- lexical-binding: t; -*-

(require 'ert)
(require 'pass-it-on)
(require 'cl-lib)

(ert-deftest pass-it-on-initial-state ()
  "Test the initial state of the package."
  (should (not pass-it-on-mode))
  (should (null pass-it-on-target-window-id)))

(ert-deftest pass-it-on-mode-activation-without-window ()
  "Test that activating the mode without a window ID fails gracefully."
  (let ((pass-it-on-target-window-id nil)
        (pass-it-on-mode nil)) ; Localize the mode variable for the test
    ;; The mode logic calls `pass-it-on-select-window`, which is a stub.
    ;; So `pass-it-on-target-window-id` remains nil.
    (pass-it-on-mode 1)
    ;; The mode should see that no window is set and disable itself.
    (should (not pass-it-on-mode))))

(ert-deftest pass-it-on-mode-activation-with-window ()
  "Test that activating the mode with a window ID succeeds."
  (let ((pass-it-on-target-window-id "0x12345")
        (pass-it-on-mode nil))
    (pass-it-on-mode 1)
    (should pass-it-on-mode)))

(ert-deftest pass-it-on-mode-deactivation ()
  "Test that deactivating the mode works."
  (let ((pass-it-on-mode t)) ; Start with mode enabled
    (pass-it-on-mode -1)
    (should (not pass-it-on-mode))))

(ert-deftest pass-it-on-select-window-sets-id ()
  "Test that `pass-it-on-select-window` correctly parses `xwininfo` output."
  (let ((pass-it-on-target-window-id nil)
        (fake-xwininfo-output "\n\nxwininfo: Window id: 0x1a00007 \"My Test Window\"\n  Absolute upper-left X:  10\n"))
    ;; Mock the shell command function to avoid running external processes.
    (cl-letf (((symbol-function 'shell-command-to-string)
               (lambda (command)
                 (should (string= command "xwininfo"))
                 fake-xwininfo-output)))
      (pass-it-on-select-window)
      ;; This test will fail until the function is implemented.
      (should (string= pass-it-on-target-window-id "0x1a00007")))))

(ert-deftest pass-it-on-select-window-handles-failure ()
  "Test `pass-it-on-select-window` on `xwininfo` failure."
  (let ((pass-it-on-target-window-id "pre-existing-id")
        (fake-xwininfo-output "xwininfo: Aborted.\n"))
    (cl-letf (((symbol-function 'shell-command-to-string)
               (lambda (_) fake-xwininfo-output)))
      (pass-it-on-select-window)
      ;; The ID should not be changed if parsing fails.
      (should (string= pass-it-on-target-window-id "pre-existing-id")))))

;; TODO: Add tests for `pass-it-on-forward-input` once it's implemented.
;; The tests should mock `start-process` or `call-process` and verify that
;; `xdotool` is called with the correct arguments. For example, it should
;; check that the command includes the correct window ID from
;; `pass-it-on-target-window-id` and the correct key representation.


;;; pass-it-on-tests.el ends here
