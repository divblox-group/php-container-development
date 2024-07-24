FROM johanmarx/stratusolve_php_apache:php802018-240422

COPY ./xdebug.ini "$PHP_INI_DIR/conf.d"