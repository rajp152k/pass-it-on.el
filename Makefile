EMACS ?= emacs

ELFILES := $(wildcard *.el)
ELCFILES := $(ELFILES:.el=.elc)

.PHONY: all clean lint test

all: $(ELCFILES)

%.elc: %.el
	$(EMACS) -Q --batch -L . -f batch-byte-compile $<

clean:
	rm -f $(ELCFILES)

lint:
	$(EMACS) -Q --batch --eval "(progn (require 'checkdoc) (checkdoc-file \"pass-it-on.el\"))"

test: all
	$(EMACS) -Q --batch -l ert -l pass-it-on.el -l pass-it-on-tests.el -f ert-run-tests-batch-and-exit
