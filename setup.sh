#!/bin/bash
# init

# --------------------------------------------------------------------------------------
# Script to Setup the Project and it's content
# --------------------------------------------------------------------------------------

printf "**************************\nProject Setup : Started\n**************************\n"

function pause()
{
    printf '\n'
    read -p 'Press [Enter] key to continue...'
}

# --------------------------------------------------------------------------------------
# Part 1 : Check the required applications are installed
# --------------------------------------------------------------------------------------
hash go 2>/dev/null || { echo >&2 "The project require's go but it's not installed."; echo "Download: https://code.google.com/p/go/"; echo "Aborting."; pause; exit 1; }
hash git 2>/dev/null || { echo >&2 "The project require's git but it's not installed."; echo "http://git-scm.com/downloads"; echo "Aborting."; pause; exit 1; }
# --------------------------------------------------------------------------------------

printf "\n**************************\n"
# --------------------------------------------------------------------------------------
# Part 2 : Setup the GOPATH workspace directory to the current path
# --------------------------------------------------------------------------------------
# Get the current path as this will be set as the projects workspace
SCRIPT_PATH=`pwd -P`
printf "Script path is '$SCRIPT_PATH'.\n"

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    printf "Setting up for Mac\n";
    # Store the bash profile file in a variable
    BASH_PROFILE=$HOME/.bash_profile
    # Fixup the go path
    GOPATH_FROM_HOME="${SCRIPT_PATH/$HOME/~}"
    # Grep the file to see if the GOPATH exists already
    if grep -Fq "export GOPATH=" $BASH_PROFILE
    then
        # GOPATH was found replace it using sed
        printf "GOATH found replacing it with '$GOPATH_FROM_HOME'.\n"
        sed -i -r 's|^export GOPATH=.*|export GOPATH='$GOPATH_FROM_HOME'|' $BASH_PROFILE
    else
        # GOPATH not found so add it
        printf "GOATH was not found setting it to '$GOPATH_FROM_HOME'.\n"
        echo "export GOPATH=$GOPATH_FROM_HOME" >> $BASH_PROFILE
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under Linux platform
    printf "Setup Failed : Linux has not been supported yet.\n";
    pause
    exit 1;
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under Windows NT platform
    printf "Setting up for Windows\n";
    printf "Current GOPATH Path is '$GOPATH'.\n";
    printf "Setting GOPATH to '$SCRIPT_PATH'.\n";
    # Perminatly set the GOPATH
    setx GOPATH $SCRIPT_PATH
else
	printf "Setup Failed : Unkown Platform.\n";
    pause;
    exit 1;
fi
# --------------------------------------------------------------------------------------
printf "**************************\n"

printf "\n**************************\n"
# --------------------------------------------------------------------------------------
# Part 2 : Setup the git part of the project
# --------------------------------------------------------------------------------------
# See if the project has submodules
if [ -f ".gitmodules" ]; then
	printf "Setting up the project submodules.\n"
	git submodule init
	git submodule update
fi
# --------------------------------------------------------------------------------------
printf "**************************\n"

printf "\n**************************\nProject Setup : Finished\n**************************\n"
printf "\nPlease restart the terminal and open editor applications for the GOPATH to take effect.\n"
pause