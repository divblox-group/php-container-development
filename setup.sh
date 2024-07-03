#!/bin/bash
colour='\033[35m'
normal='\033[0m'
error='\033[1;31m'

function checkout ()
{
    echo "=========================="
    echo -e "Repo is ${colour}${repository}${normal}"
    echo "Branch(es):"
    for module in "${modules[@]}"
    do
        folder=$(echo $module | cut -d',' -f1)
        branch=$(echo $module | cut -d',' -f2)
        echo -e "--------- Branch ${colour}${branch}${normal} into ${colour}./${folder}${normal} ---------"
        if cd ${folder}; 
        then
            currentBranch=$(git branch --show-current);
            git config core.filemode false
            if [ $currentBranch != $branch ]; then
                echo -e "${error}Current branch: ${colour}${currentBranch}${error} is not the expected branch: ${colour}${branch}${error}"
                echo -e "${error}SKIPPING! Manual intervention required${normal}"
            else
                # sDev custom log file reset
                LOG_PATH=./assets/_core/php/DeveloperMode/CustomLog.txt
                if test -f "$LOG_PATH";
                then
                    git restore ./assets/_core/php/DeveloperMode/CustomLog.txt
                fi
                git fetch origin +refs/heads/${branch}*:refs/remotes/origin/${branch}*
                git remote set-branches origin "${branch}" "${branch}*"
                git pull --rebase
            fi
            cd ..
        else
            git clone --branch ${branch} --single-branch ${repository} ./${folder}
        fi
    done
}

# Application 1
repository="https://github.com/divblox-group/reponamehere.git"
modules=(
    foldernamehere,main
)
checkout

# Add more applications as needed