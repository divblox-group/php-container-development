FROM ghcr.io/divblox-group/php-apache-base-docker-image:latest

COPY ./xdebug.ini "$PHP_INI_DIR/conf.d"