GOCMD=go
GOFILES=$(shell find . -type f -name '*.go' -not -path "./vendor/*")

GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean

APP_NAME=main
BINARY_WIN=.exe

BUILDDIR=ezphp

RELEASE_NAME=ezphp
RELEASEDIR=$(BUILDDIR)
RELEASEFILE=$(RELEASE_NAME).zip

all: release
	
setup:
	mkdir -p $(RELEASEDIR)

clean:
	$(GOCLEAN)
	rm -rf $(RELEASE_NAME) $(BUILDDIR)
	rm -rf public_html
	rm -rf php

format:
	goimports -w -d $(GOFILES)

run-interactive: 
	GTK_DEBUG=interactive go run main.go -gui

build-linux: format clean
	$(GOBUILD) -o $(APP_NAME).go -o $(RELEASEDIR)/$(RELEASE_NAME)
	
build-win: format clean setup
	rsrc -manifest main.exe.manifest -ico logo/512px.ico -o rsrc.syso
	GOOS=windows GOARCH=386 $(GOBUILD) -o $(APP_NAME).go -o $(RELEASEDIR)/$(RELEASE_NAME)$(BINARY_WIN)
	zip -r $(RELEASEDIR)/$(RELEASEFILE) $(BUILDDIR)
	
release: build-win