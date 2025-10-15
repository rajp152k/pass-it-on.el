# pass-it-on.el

`pass-it-on.el` is an Emacs extension that allows you to forward keyboard input to another X window without changing focus. This lets you control other applications while remaining within Emacs.

## Prerequisites

This package relies on external command-line tools to interact with the X Window System. Please ensure they are installed.

- `xdotool`
- `xwininfo` (often part of a package like `x11-utils`)

On Debian/Ubuntu-based systems, you can install them with:
```sh
sudo apt-get install xdotool x11-utils
```

## Installation

At present, installation is manual. Place `pass-it-on.el` in a directory on your Emacs `load-path`.

Example:
```emacs-lisp
;; In your init.el or .emacs
(add-to-list 'load-path "/path/to/your/pass-it-on/clone")
(require 'pass-it-on)
```

## Usage

1.  **Select a Target Window**: Run `M-x pass-it-on-select-window`. Your cursor will change, allowing you to click on the window you wish to control. A message in the echo area will confirm that the window ID has been captured.
2.  **Enable the Mode**: Run `M-x pass-it-on-mode` to enable input forwarding. The " PassItOn" indicator will appear in your mode line.
3.  **Forward Input**: While the mode is active, keyboard input is sent to the target window.
4.  **Disable the Mode**: To stop forwarding and return to normal Emacs operation, run `M-x pass-it-on-mode` again.

## Development

The included `Makefile` provides helpers for common development tasks.

- **Byte-compile Elisp files**:
  ```sh
  make all
  ```
- **Run the test suite**:
  ```sh
  make test
  ```
- **Clean compiled files**:
  ```sh
  make clean
  ```
- **Check for documentation style issues**:
  ```sh
  make lint
  ```
