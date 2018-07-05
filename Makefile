
GO     ?= GO15VENDOREXPERIMENT=1 go
GOARCH := $(shell $(GO) env GOARCH)
GOHOSTARCH := $(shell $(GO) env GOHOSTARCH)
USER = monkey
BRANCH = $(shell git branch | sed -n -e 's/^\* \(.*\)/\1/p')
VERSION = $(shell head -n 1 VERSION)
GIT_COMMIT = `git rev-parse HEAD | cut -c1-7`
BUILDDATE = `date +%FT%T`
PREFIX  = github.com/kikiyou/ats_exporter
BUILD_OPTIONS = -ldflags "-X main.Version=$(VERSION) -X main.Revision=$(GIT_COMMIT) \
				 -X main.Branch=$(BRANCH) \
                 -X main.BuildUser=$(USER) -X main.BuildDate=${BUILDDATE}"
agent:
	GOOS=linux GOARCH=${GOARCH} ${GO} build  ${BUILD_OPTIONS} -o fsv_agent ./cmd/fsv_agent.go

build:
	GOOS=linux GOARCH=${GOARCH} ${GO} build  ${BUILD_OPTIONS} -o ats_exporter 
run:
	export ATS_URL=http://172.16.6.38/_stats
	./ats_exporter
