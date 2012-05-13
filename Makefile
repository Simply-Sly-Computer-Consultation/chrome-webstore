EXTNAME := chrome-webstore
KEYFILE := $(EXTNAME).pem
SHELL   := /usr/bin/env bash
CHROME  := chromium -n --args
CWD     := $(shell pwd)
TMPDIR  := $(shell mktemp -d)
VERSION := $(shell python -c "import json,sys;print json.loads(sys.stdin.read()).get('version','')" < manifest.json)
ITEMS   := img/ manifest.json

all: pack

moveout: $(ITEMS)
	mkdir $(TMPDIR)/$(EXTNAME)
	cp -R $(ITEMS) $(TMPDIR)/$(EXTNAME)

crx: moveout
	$(CHROME) --pack-extension=$(TMPDIR)/$(EXTNAME) \
	    --pack-extension-key=$(KEYFILE) --no-message-box
	mv $(TMPDIR)/$(EXTNAME).crx $(CWD)/build/$(EXTNAME)-latest.crx

zip: moveout
	cd $(TMPDIR)/$(EXTNAME)/ && zip $(EXTNAME)-$(VERSION).zip -r ./*
	cp $(TMPDIR)/$(EXTNAME)/$(EXTNAME)-$(VERSION).zip $(CWD)

clean:
	rm $(CWD)/*.zip
