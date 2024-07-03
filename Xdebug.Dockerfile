FROM johanmarx/stratusolve_php_apache:php802015-240214

COPY ./xdebug.ini "$PHP_INI_DIR/conf.d"