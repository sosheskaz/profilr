VERSION=1.0.1

# CGO has problems for me.
GOENV=CGO_ENABLED=0
# Strip out debug info
DISTFLAGS=-ldflags="-s -w"

GOBUILDDIST=${GOENV} go build ${DISTFLAGS}
GOBUILD=${GOENV} go build

# Basic Commands
clean:
	rm -rf dist/
	rm -rf bin/

test:
	go test

build:
	${GOBUILD} -o bin/profilr .

# Publish Commands

publish: docker-push github-release

docker-image: clean build-linux-amd64
	docker build -t ericmiller/profilr:${VERSION}-scratch -f docker/scratch/Dockerfile .
	docker build -t ericmiller/profilr:${VERSION}-alpine -f docker/alpine/Dockerfile .

docker-push: test docker-image
	docker push ericmiller/profilr:${VERSION}-scratch
	docker push ericmiller/profilr:${VERSION}-alpine

github-release: clean test build-all
	./git-release.sh

# Dist Commands

build-all: clean build-linux build-bsd build-macos build-solaris

build-linux: build-linux-amd64 \
	build-linux-arm64 \
	build-linux-ppc64 \
	build-linux-ppc64le \
	build-linux-mips64 \
	build-linux-mips64le \
	build-linux-386 \
	build-linux-arm \
	build-linux-mips \
	build-linux-mipsle

build-bsd: \
	build-freebsd-amd64 \
	build-freebsd-arm \
	build-freebsd-386 \
	build-netbsd-amd64 \
	build-netbsd-arm \
	build-netbsd-386 \
	build-openbsd-amd64 \
	build-openbsd-arm \
	build-openbsd-386 \
	build-dragonfly-amd64

build-macos:
	GOOS=darwin GOARCH=amd64 ${GOBUILDDIST} -o dist/macos/amd64/profilr

build-solaris:
	GOOS=solaris GOARCH=amd64 ${GOBUILDDIST} -o dist/solaris/amd64/profilr

# Linux Builds

build-linux-amd64:
	GOOS=linux GOARCH=amd64 ${GOBUILDDIST} -o dist/linux/amd64/profilr

build-linux-arm64:
	GOOS=linux GOARCH=arm64 ${GOBUILDDIST} -o dist/linux/arm64/profilr

build-linux-ppc64:
	GOOS=linux GOARCH=ppc64 ${GOBUILDDIST} -o dist/linux/ppc64/profilr

build-linux-ppc64le:
	GOOS=linux GOARCH=ppc64le ${GOBUILDDIST} -o dist/linux/ppc64le/profilr

build-linux-mips64:
	GOOS=linux GOARCH=mips64 ${GOBUILDDIST} -o dist/linux/mips64/profilr

build-linux-mips64le:
	GOOS=linux GOARCH=mips64le ${GOBUILDDIST} -o dist/linux/mips64le/profilr

build-linux-386:
	GOOS=linux GOARCH=386 ${GOBUILDDIST} -o dist/linux/386/profilr

build-linux-arm:
	GOOS=linux GOARCH=arm ${GOBUILDDIST} -o dist/linux/arm/profilr

build-linux-mips:
	GOOS=linux GOARCH=mips ${GOBUILDDIST} -o dist/linux/mips/profilr

build-linux-mipsle:
	GOOS=linux GOARCH=mipsle ${GOBUILDDIST} -o dist/linux/mipsle/profilr

# BSD Builds

build-freebsd-amd64:
	GOOS=freebsd GOARCH=amd64 ${GOBUILDDIST} -o dist/freebsd/amd64/profilr

build-freebsd-arm:
	GOOS=freebsd GOARCH=arm ${GOBUILDDIST} -o dist/freebsd/arm/profilr

build-freebsd-386:
	GOOS=freebsd GOARCH=386 ${GOBUILDDIST} -o dist/freebsd/386/profilr

build-netbsd-amd64:
	GOOS=netbsd GOARCH=amd64 ${GOBUILDDIST} -o dist/netbsd/amd64/profilr

build-netbsd-arm:
	GOOS=netbsd GOARCH=arm ${GOBUILDDIST} -o dist/netbsd/arm/profilr

build-netbsd-386:
	GOOS=netbsd GOARCH=386 ${GOBUILDDIST} -o dist/netbsd/386/profilr

build-openbsd-amd64:
	GOOS=openbsd GOARCH=amd64 ${GOBUILDDIST} -o dist/openbsd/amd64/profilr

build-openbsd-arm:
	GOOS=openbsd GOARCH=arm ${GOBUILDDIST} -o dist/openbsd/arm/profilr

build-openbsd-386:
	GOOS=openbsd GOARCH=386 ${GOBUILDDIST} -o dist/openbsd/386/profilr

build-dragonfly-amd64:
	GOOS=dragonfly GOARCH=amd64 ${GOBUILDDIST} -o dist/dragonfly/amd64/profilr
