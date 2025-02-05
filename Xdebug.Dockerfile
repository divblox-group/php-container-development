FROM johanmarx/stratusolve_php_apache:latest

COPY ./xdebug.ini "$PHP_INI_DIR/conf.d"