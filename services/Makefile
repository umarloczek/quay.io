include .env
# todo add commands for deploying proxy and logs, automate this process
DEV				=docker-compose -f docker-compose.yaml -f docker-compose.override.yaml
DEPLOY			=docker-compose -f docker-compose.yaml -f docker-compose.deploy.yaml
PROXY			=docker-compose -f docker-compose.proxy.yaml

WAITCMD			=timeout -s TERM 120 sh -c 'while [[ "$$(curl -s -o /dev/null -L -w ''%{http_code}'' ${URL})" != "200" ]]; do echo ${URL} not ready && sleep 2; done'

clear: rm proxy-rm deploy-rm

dev:
	@${DEV} up --detach --build
	${DEV} logs -f

up:
	@${DEV} up --detach --build

proxy:
	@${PROXY} up --detach
	${PROXY} logs

deploy: rm proxy
	@${DEPLOY} up --detach --build

rm:
	-@${DEV} down -v

deploy-rm:
	-@${DEPLOY} down -v

proxy-rm:
	-@${PROXY} down -v

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
