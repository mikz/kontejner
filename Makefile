REPO=mikz/kontejner

all: build

build:
	docker build -t $(REPO) --rm .
push:
	docker push $(REPO)
