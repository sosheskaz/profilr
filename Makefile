VERSION=1.0

clean:
	rm -rf bin/

test:
	go test

build: clean
	go build -o bin/profilr .

build-linux: clean
	GOOS=linux CGO_ENABLED=0 go build -o bin/profilr .

docker-image: build-linux
	docker build -t ericmiller/profilr:${VERSION}-scratch -f docker/scratch/Dockerfile .
	docker build -t ericmiller/profilr:${VERSION}-alpine -f docker/alpine/Dockerfile .

docker-push: test docker-image
	docker push ericmiller/profilr:${VERSION}-scratch
	docker push ericmiller/profilr:${VERSION}-alpine
