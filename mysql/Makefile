
IMG = "mysqltest"

run: rm r logs

build:
	docker build --tag=${IMG} .

rm:
	-docker rm -f ${IMG}

r: build rm
	docker run -d -e MYSQL_ROOT_PASSWORD=test --name=${IMG} ${IMG}

exec:
	docker exec -it ${IMG} /bin/bash

logs:
	docker logs -f ${IMG}
