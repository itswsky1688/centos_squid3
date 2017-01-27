NAME=$(shell pwd | awk -F/ '{print $$(NF-1)}')
VERSION=$(shell pwd | awk -F/ '{print $$(NF-0)}')
REGISTRY=vb-registry-01:5000
PORT=3128

check:
	@echo ======== $(NAME):$(VERSION) ========

build: check
	docker build -t $(NAME):$(VERSION) .

run: check
	docker run     --rm --name $(NAME)_$(VERSION)_$(PORT) -p $(PORT):3128 `cat env` $(NAME):$(VERSION)

run-bash: check
	docker run -it --rm --name $(NAME)_$(VERSION)_$(PORT) -p $(PORT):3128 `cat env` $(NAME):$(VERSION) bash

debug: check
	docker run -it --rm --name $(NAME)_$(VERSION)_$(PORT) -p $(PORT):3128 -v `pwd`/squid.conf:/etc/squid/squid.conf `cat env` $(NAME):$(VERSION) bash

stop: check
	-docker stop $(NAME)_$(VERSION)_$(PORT)
	-docker rm   $(NAME)_$(VERSION)_$(PORT)

save: check
	docker save $(NAME):$(VERSION) | gzip > $(NAME).$(VERSION).tar.gz

load: check
	docker load -i $(NAME).$(VERSION).tar.gz

push: check
	-docker rmi $(REGISTRY)/$(NAME):$(VERSION) ; \
	docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	docker push $(REGISTRY)/$(NAME):$(VERSION)

