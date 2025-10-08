#!/bin/bash
colour='\033[38;5;208m'
normal='\033[0m'
error='\033[1;31m'

# module/folder/app same name as in docker compose servuce
module=app

parentFolder=$(basename "$PWD")

echo
echo -e ${colour}================ $module ================${normal}
container=$(docker ps | grep "$parentFolder-$module")
echo $container
containerid=$(echo $container | cut -d ' ' -f1)
if [ -z "${containerid}" ];
then 
    echo -e "${error}No running container found for $module ($parentFolder-$module)${normal}"
    exit
fi
echo "container id for $module is $containerid"
docker exec -it $containerid /bin/sh -c "php /var/www/html/index.php" #customise what you want to run, like a cron or test file