#!/bin/bash
set -eu

declare -p WORDPRESS_TITLE
declare -p WORDPRESS_LOGIN
declare -p WORDPRESS_PASSWORD
declare -p WORDPRESS_EMAIL
declare -p WORDPRESS_HOST

wait-for-it ${WORDPRESS_HOST} -t 120

if [[ $1 == "deploy" ]]
then
    echo "Deploying...";
    declare -p DOMAIN_NAME
    # Always happens on `https` and port `80`, we don't care.
    URL="http://${DOMAIN_NAME}"
else
    echo "Developing...";
    declare -p WORDPRESS_PORT
    [[ "${WORDPRESS_PORT}" == 80 ]] && \
    URL="http://localhost" || \
    URL="http://localhost:${WORDPRESS_PORT}"
fi


if $(wp core is-installed);
then
    echo "Wordpress is already installed..."
else
    echo "Installing wordpress..."
    wp core install \
        --url=${URL} \
        --title=${WORDPRESS_TITLE} \
        --admin_user=${WORDPRESS_LOGIN} \
        --admin_password=${WORDPRESS_PASSWORD} \
        --admin_email=${WORDPRESS_EMAIL} \
        --skip-email
fi

declare -r CURRENT_DOMAIN=$(wp option get siteurl)

if ! [[ ${CURRENT_DOMAIN} == ${URL} ]]; then
    echo "Replacing ${CURRENT_DOMAIN} with ${URL} in database..."
    wp search-replace ${CURRENT_DOMAIN} ${URL}
fi

echo "Visit $(wp option get siteurl)"
