EMACS ?= emacs

ELFILES := $(wildcard *.el)
ELCFILES := $(ELFILES:.el=.elc)

.PHONY: all clean lint

all: $(ELCFILES)

%.elc: %.el
	$(EMACS) -Q --batch -f batch-byte-compile $<

clean:
	rm -f $(ELCFILES)

lint:
	$(EMACS) -Q --batch --eval "(progn (require 'checkdoc) (checkdoc-file \"pass-it-on.el\"))"
