NS ?= xymox
VERSION ?= 0.1.1
REPOSITORY ?= quay.io

IMAGE_NAME ?= vue-todos
DOCKER = docker

DOCKERFILE = Dockerfile

.PHONY: build push shell release

build-nocache: Dockerfile
	$(DOCKER) build --rm --no-cache -t $(NS)/$(IMAGE_NAME):$(VERSION) -f $(DOCKERFILE) .

build: Dockerfile
	$(DOCKER) build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f $(DOCKERFILE) .

build-ubi8: Dockerfile
	$(DOCKER) build -t $(NS)/$(IMAGE_NAME)-ubi8:$(VERSION) -f $(DOCKERFILE).ubi8 .

tag:
	$(DOCKER) tag $(NS)/$(IMAGE_NAME):$(VERSION) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(VERSION)

push: build
	$(DOCKER) push $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(VERSION)

shell:
	$(DOCKER) run --rm --name $(IMAGE_NAME) -ti $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

tag-latest: tag
	$(DOCKER) tag $(NS)/$(IMAGE_NAME):$(VERSION) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):latest
  
push-latest: tag-latest
  make push -e VERSION=latest

release: push-latest push tag build

default: build
