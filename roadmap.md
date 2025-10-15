# Roadmap for `pass-it-on.el`

This document outlines the development plan for `pass-it-on.el`, following a test-driven development (TDD) approach.

## ~~Phase 1: Implement Window Selection~~ (DONE)

~~The immediate goal is to make the existing test suite pass. This involves implementing the `pass-it-on-select-window` function.~~

1.  ~~**Implement `pass-it-on-select-window`**~~:
    -   ~~In `pass-it-on.el`, modify the function to call the external `xwininfo` command using `shell-command-to-string`.~~
    -   ~~Use a regular expression to parse the output and extract the window ID (e.g., `0x...`).~~
    -   ~~If a window ID is found, set the `pass-it-on-target-window-id` variable.~~
    -   ~~If `xwininfo` fails or the output is not as expected, ensure the variable is not changed and optionally inform the user.~~

2.  ~~**Verify Implementation**~~:
    -   ~~Run `make test`.~~
    -   ~~All tests, including `pass-it-on-select-window-sets-id`, should now pass.~~

## Phase 2: Implement Core Input Forwarding

With window selection working, the next step is to implement the main feature: forwarding keyboard input. The core forwarding function and its helpers have been implemented.

1.  **Add Tests for Input Forwarding**:
    -   In `pass-it-on-tests.el`, create new `ert-deftest`s for `pass-it-on-forward-input`.
    -   The tests should mock `call-process` or `start-process` to avoid executing `xdotool`.
    -   Test cases should verify that `xdotool` is called with the correct arguments:
        - The correct window ID from `pass-it-on-target-window-id`.
        - The correct key string translation for various Emacs key events (e.g., `a`, `A`, `C-c`).

2.  **~~Implement `pass-it-on-forward-input`~~** (DONE):
    -   ~~This function will be triggered by user input when `pass-it-on-mode` is active.~~
    -   ~~It needs to take the last key event (`last-command-event`) and convert it into a string that `xdotool` can understand. This is the most complex part. Start with simple characters and then add support for modifiers (Control, Meta, Shift).~~
    -   ~~Use `call-process` to execute `xdotool key --window <window_id> '<key_string>'`.~~

3.  **Activate the Keymap**:
    -   In the `define-minor-mode` block for `pass-it-on-mode`, replace the `;; TODO` with code that sets up a keymap.
    -   This keymap should be "overriding" and bind all (or most) printable character keys to `pass-it-on-forward-input`. A special key should be reserved to exit the mode.

## Phase 3: Refinement and Features

Once the core functionality is in place and tested, we can add features and improve usability.

1.  **Mouse Event Forwarding**:
    -   Extend the keymap and forwarding logic to capture and forward mouse clicks using `xdotool click`.

2.  **User Feedback**:
    -   Provide better visual feedback when the mode is active. For example, change the cursor color or display information in the mode line.

3.  **Configuration**:
    -   Add `defcustom` variables for the paths to `xwininfo` and `xdotool`.
    -   Allow customization of the keymap.

4.  **Documentation**:
    -   Write a comprehensive `README.md` with installation instructions, dependencies, and a usage guide (with a GIF).
    -   Ensure all functions and variables have clear docstrings that follow Emacs conventions (`checkdoc`).

## Phase 4: Packaging

Prepare the package for distribution on MELPA.

1.  **Review MELPA Guidelines**: Ensure the package structure, headers, and code style meet the requirements.
2.  **Finalize `Makefile`**: Add any necessary targets for packaging or final checks.
3.  **Submit to MELPA**: Create a pull request to add the package recipe.
