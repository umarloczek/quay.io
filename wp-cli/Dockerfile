FROM quay.io/dim/wfi as builder

FROM wordpress:cli-php7.4
COPY --from=builder \
    /usr/bin/wait-for-it \
    /usr/local/bin/

USER root
RUN chown www-data:www-data \
    /usr/local/bin/wait-for-it

WORKDIR /app
COPY entrypoint.sh .
RUN chown www-data:www-data entrypoint.sh

WORKDIR /var/www/html
USER www-data

ENTRYPOINT ["/app/entrypoint.sh"]
