REVISION := $(shell git describe --always)
DATE := $(shell date +%Y-%m-%dT%H:%M:%S%z)
LDFLAGS	:= -ldflags="-X \"main.Revision=$(REVISION)\" -X \"main.BuildDate=${DATE}\""

.PHONY: build-cross dist build clean run help

name		:= sample-go-app
linux_name	:= $(name)-linux-amd64
darwin_name	:= $(name)-darwin-amd64

help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-22s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)

dist: build-docker ## create .tar.gz linux & darwin to /bin
	cd bin && tar zcvf $(linux_name).tar.gz $(linux_name) && rm -f $(linux_name)
	cd bin && tar zcvf $(darwin_name).tar.gz $(darwin_name) && rm -f $(darwin_name)

build-cross: ## create to build for linux & darwin to bin/
	GOOS=linux GOARCH=amd64 go build -o bin/$(linux_name) $(LDFLAGS) main.go
	GOOS=darwin GOARCH=amd64 go build -o bin/$(darwin_name) $(LDFLAGS) main.go

build: ## go build
	go build -o bin/$(name) $(LDFLAGS) main.go

build-docker: ## go build on Docker
	@docker run --rm -v "$(PWD)":/go/src/github.com/sioncojp/$(name) -w /go/src/github.com/sioncojp/$(name) golang:latest bash build.sh

test: ## go test
	go test -v $$(go list ./... | grep -v /vendor/)

clean: ## remove bin/*
	rm -f bin/*

run: ## go run
	go run main.go

lint: ## go lint ignore vendor
	golint $(go list ./... | grep -v /vendor/)

docker: ## docker build & run
	docker build -t $(name):latest .
	docker run --rm --name $(name) -p 8000:8000 $(name):latest
