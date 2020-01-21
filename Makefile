include .env

BASE			=docker-compose -f docker-compose.yml
DEV				=docker-compose -f docker-compose.yml -f docker-compose.dev.yaml
UP				=up --detach --build

URL				=http://localhost:${WORDPRESS_PORT}
BENCH			=-c 5 -t 5 -d 10 --timeout 1s --latency

WAIT			=docker run --rm --network=host alpine apk add curl && ${WAITCMD}
WAITCMD			=timeout -s TERM 60 sh -c 'while [[ "$$(curl -s -o /dev/null -L -w ''%{http_code}'' ${URL})" != "200" ]]; do echo ${URL} not ready && sleep 2; done'
VISIT			=echo "Visit ${URL}"


# BASE
base-up:	## run BASE environment
	@${BASE} ${UP} && \
	${WAIT} && \
	${VISIT}

base-down:	## docker-compose down
	${BASE} down

base-rm:	## docker-compose down -v
	${BASE} down -v

base-log:	## docker-compose logs
	${BASE} logs

base-logs:	## docker-compose logs -f
	${BASE} logs -f

base-restart: base-rm base-up	## base-rm base-up

# DEV
dev-up:	## run DEV environment
	@${DEV} ${UP} && \
	${WAIT} && \
	${VISIT}

dev-down:	## docker-compose down
	${DEV} down

dev-rm:	## docker-compose down -v
	${DEV} down -v

dev-log:	## docker-compose logs
	${DEV} logs

dev-logs:	## docker-compose logs -f
	${DEV} logs -f

dev-restart: dev-rm dev-up	## base-rm base-up

wait:	## wait for wordpress to be ready
	${WAIT} && \
	${VISIT}

clear: base-rm dev-rm	## remove all deployments with volumes

bench:		## benchmark wordpress using wrk https://github.com/wg/wrk
	docker run --rm --network=host \
	quay.io/dim/wrk:stable \
	${BENCH} ${URL}

# HELP
.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
