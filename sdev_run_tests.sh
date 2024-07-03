#!/bin/bash
colour='\033[0;33m'
normal='\033[0m'
error='\033[1;31m'

# modules/folders with unit tests
modules=(

)

parentFolder=$(basename "$PWD")

for module in "${modules[@]}"
do
    echo
    echo -e ${colour}================ $module ================${normal}
    container=$(docker ps | grep "$parentFolder-$module")
    echo $container
    containerid=$(echo $container | cut -d ' ' -f1)
    if [ -z "${containerid}" ];
    then 
        echo -e "${error}No running container found for $module ($parentFolder-$module)${normal}"
        continue
    fi
    echo "container id for $module is $containerid"
    docker exec -it $containerid /bin/sh -c "cd /var/www/html/phpunit && ./vendor/bin/phpunit"
done
