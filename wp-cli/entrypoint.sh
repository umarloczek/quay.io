#!/bin/sh
# todo pass url as env
wait-for-it wordpress:9000 -t 90 --strict -- \
    wp core install \
        --url=http://localhost:${WORDPRESS_PORT} \
        --title=${WORDPRESS_TITLE} \
        --admin_user=${WORDPRESS_LOGIN} \
        --admin_password=${WORDPRESS_PASSWORD} \
        --admin_email=${WORDPRESS_EMAIL} \
        --skip-email

# todo replace for deploy
wp search-replace --regex \
    "localhost:[0-9]*" \
    "localhost:${WORDPRESS_PORT}"
