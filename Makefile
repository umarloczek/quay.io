
run: down drun browser-win logs

drun:
	docker-compose up -d --build --scale wrk=0

bench:
	docker-compose up wrk

logs:
	docker-compose logs -f

browser-win:
	-C:\Program Files\Mozilla Firefox\firefox.exe http://wordpress.local:9333

down:
	-docker-compose down -v

install-wordpress:
	docker-compose run wp-cli wait-for-it mysql:3306 --strict -- wp core install \
	--url=http://localhost:9333 \
	--title=test \
	--admin_user=test \
	--admin_password=test \
	--admin_email=example@example.com \
	--skip-email
