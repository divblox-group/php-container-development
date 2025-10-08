#!/bin/bash
colour='\033[38;5;208m'
success='\033[1;32m'
error='\033[1;31m'
normal='\033[0m' 

output=false
banner=false
maintenancePassword="123"
moduleUrls=( 
    https://appname.dxgroup.local/
)

if $banner; then
    echo ""
    FILE=banner.txt
    if test -f "$FILE"; then
        cat banner.txt
    else
        echo "Banner file not found"
    fi    
    echo ""
fi    

if $output; then
    date=$(date '+%Y-%m-%d--%H-%M-%S')
    folder="KylieRun--${date}"
    mkdir $folder
    date > ${folder}/date.txt
fi    


function sanitize_file_name {
    echo -n $1 | perl -pe 's/[\?\[\]\/\\=<>:;,''"&\$#*()|~`!{}%+]//g;' -pe 's/[\r\n\t -]+/-/g;'
}

# options: REMOTESYNCONLY REMOTEGENONLY REMOTEAUTOSYNCGEN
operations=( "$@" )
for operation in "${operations[@]}"
do
    if $output; then
        mkdir "${folder}/${operation}"
    fi
    successCount=0
    failCount=0
    echo "=================================="
    echo -e -n "${colour}PERFORMING ${success}${operation}${colour} ON ALL MODULES${normal}\n"
    echo "----------------------------------"
    for moduleUrl in "${moduleUrls[@]}"
    do
        echo -e "${colour}${moduleUrl}${normal}"
        result=$(curl --location --request POST "${moduleUrl}sDevORM/sDev_CodeGenerator/Remote/DatabaseORMRemoteHelper.php" \
            --insecure \
            --header 'Content-Type: application/x-www-form-urlencoded' \
            --data-urlencode "Password=${maintenancePassword}" \
            --data-urlencode "Function=${operation}")
        echo "${result}" | grep -Eo '"[^"]*" *(: *([0-9]*|"[^"]*")[^{}\["]*|,)?|[^"\]\[\}\{]*|\{|\},?|\[|\],?|[0-9 ]*,?' | awk '{if ($0 ~ /^[}\]]/ ) offset-=4; printf "%*c%s\n", offset, " ", $0; if ($0 ~ /^[{\[]/) offset+=4}'
        if [[ "$result" == *"\"Result\":\"Success\""* ]]; then
            echo -e -n "${success}SUCCESS${normal}\n"
            successCount=$((successCount+1))
        else
            echo -e -n "${error}FAIL!${normal}\n"
            failCount=$((failCount+1))
        fi
        cleaned=$(sanitize_file_name "$moduleUrl")
        if $output; then
            echo $result > "${folder}/${operation}/${cleaned}.json" || echo -e -n "${error}**Logging Failed**${normal}\n"
        fi
        echo "----------------------------------"
    done
    echo -e -n "SUMMARY FOR ${colour}${operation}${normal}\n"
    echo -e -n "${success}SUCCEEDED: ${successCount}${normal}\n"
    if [ "$failCount" -ne 0 ]; then
        echo -e -n "${error}FAILED: ${failCount}${normal}\n"
        echo -e -n "${error}FAILURES WERE DETECTED DURING ${colour}${operation}${error}, EXITING...${normal}\n"
        break
    else
        echo -e -n "${success}NO FAILURES DETECTED DURING ${colour}${operation}${success}, CONTINUING...${normal}\n"
    fi
    echo "=================================="
done
echo "=================================="
if $output; then
    echo -e -n "${colour}ZIPPING LOGS..${normal}\n"
    zip  -r "${folder}".zip ${folder} || echo -e -n "${error}**Zipping Failed - Please check if you have the Zip package installed**${normal}\n"
    echo -e -n "${colour}ZIPPING DONE!${normal}\n"
    echo "=================================="
fi

echo -e -n "${colour}JOB'S DONE!${normal}\n"
echo "=================================="
