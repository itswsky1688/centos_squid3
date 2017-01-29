NAME=$(shell pwd | awk -F/ '{print $$(NF-1)}')
VERSION=$(shell pwd | awk -F/ '{print $$(NF-0)}')
REGISTRY=vb-registry-01:5000
TARGET=basic

check:
	@echo ======== $(NAME):$(VERSION) ========

build: check
	docker build -t $(NAME):$(VERSION) .

run: check
	docker run -it --rm --name $(NAME)_$(VERSION)_$(TARGET) `cat env/env-$(TARGET)` $(NAME):$(VERSION)

run-bash: check
	docker run -it --rm --name $(NAME)_$(VERSION)_$(TARGET) `cat env/env-$(TARGET)` $(NAME):$(VERSION) bash

stop: check
	-docker stop $(NAME)_$(VERSION)_$(TARGET)
	-docker rm   $(NAME)_$(VERSION)_$(TARGET)

save: check
	docker save $(NAME):$(VERSION) | gzip > $(NAME).$(VERSION).tar.gz

load: check
	docker load -i $(NAME).$(VERSION).tar.gz

push: check
	-docker rmi $(REGISTRY)/$(NAME):$(VERSION) ; \
	docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	docker push $(REGISTRY)/$(NAME):$(VERSION)

