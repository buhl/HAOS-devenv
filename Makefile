IMAGE=devenv:latest
NAME=devenv

PORT=$(shell for p in $$(seq 8123 -1000 1123); do if netcat -z 127.0.0.1 $$p; then continue; else echo $$p; break; fi; done)

help:
	cat README.md

build:
	docker build -t $(IMAGE) devenv

check_workdir: $(WD)
ifndef WD
	$(error WD is undefined)
endif

.PHONY: $(WD)
$(WD):
	@if !  test -d $(WD); then \
		echo "$(WD) is not a dir or does not exist"; \
		exit 1; \
	fi

test: check_workdir

run: volume start-devenv

volume:
	docker volume inspect $(NAME)-docker-volume >/dev/null 2>&1 \
		|| docker volume create $(NAME)-docker-volume >/dev/null 2>&1

start-devenv: check_workdir
	docker run --rm -d --name $(NAME)-running \
		-p 127.0.0.1:$(PORT):8123 \
		--mount source=$(WD),target=/workspaces/hassio/addons/local/myaddon,type=bind,consistency=delegated \
		--mount source=$(NAME)-docker-volume,target=/var/lib/docker,type=volume \
		--privileged \
		--entrypoint=/bin/sh \
		devenv:latest \
		-c 'echo Container started ; trap "exit 0" 15; while sleep 1 & wait $!; do :; done'

shell:
	docker exec -it $(NAME)-running /bin/bash

shell-supervisor:
	docker exec -it $(NAME)-running docker exec -it hassio_supervisor /bin/bash 

start-hassio:
	docker exec -it $(NAME)-running /usr/local/bin/start_ha.sh

observe:
	docker exec -it $(NAME)-running curl http://0.0.0.0:4357/

stop-devenv:
	@docker stop $(NAME)-running >/dev/null 2>&1 || exit 0

clean-volume:
	@docker volume rm $(NAME)-docker-volume >/dev/null 2>&1 || exit 0

clean-container:
	@docker rm $(NAME)-running >/dev/null 2>&1 || exit 0

clean: stop-devenv clean-container clean-volume

.PHONY: help build run volume start-devenv clean-volume clean-container clean
