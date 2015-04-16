PROJECTS_HOME=$HOME/PROJECTS
GIT_PROJECT="live-edit-test"
GIT_URL="git@github.com:kbroughton/$GIT_PROJECT.git"

if [[ ! -f ${PROJECTS_HOME} ]];then
    mkdir -p $PROJECTS_HOME
fi

###############################
# Git
###############################

pushd "$PROJECTS_HOME" > /dev/null
echo "***** Cloning $GIT_PROJECT *****"
git clone $GIT_URL
pushd $PROJECT_HOME 
git fetch --all

echo "***** Creating live-edit and my-edits git branches *****"
LIVE_EDIT_BRANCH=live-edit
MY_EDITS_BRANCH=my-edits

#git branch ${LIVE_EDIT_BRANCH}  # already exists
git branch --set-upstream-to=origin/live-edit live-edit
git branch ${MY_EDITS_BRANCH}
git branch --set-upstream-to=origin/$USER-edits $USER-edits


# Check if ~/.bash_profile already sources sublimerc.sh
source_git_prompt=`grep git_prompt ${HOME}/.bash_profile`
echo "***** Adding 'source $HOME/.git_prompt.sh' to bash_profile *****"
if [[ $source_git_prompt == '' ]];then
    echo "***** Adding source ~/.git_prompt.sh to .bash_profile *****"
    cp ".git_prompt.sh" "$HOME/"
    echo "source $HOME/.git_prompt.sh" >> ${HOME}/.bash_profile
fi

############################
# Sublime
############################
PLAT=`uname` 2 > &1

ST_PATH=`which subl`
if [[ ${ST_PATH} != "" ]];then
    if [[ $PLAT == "Darwin" ]];then
        ST_CONF_DIR="${HOME}/.config/sublime"
        echo "***** Creating $ST_CONF_DIR config dir *****"
    
        if [[ ! -f ${ST_CONF_DIR} ]];then
            mkdir -p ${ST_CONF_DIR}
        fi
        if [[ ! -f ${ST_CONF_DIR}/sublimerc.sh ]];then
            echo "***** Copying sublimerc.sh to $ST_CONF_DIR *****"
            cp sublimerc.sh ${ST_CONF_DIR}
        fi
        # Check if ~/.bash_profile already sources sublimerc.sh
        source_sublimerc=`grep sublimerc ${HOME}/.bash_profile`
        echo "***** Adding 'source $ST_CONF_DIR/sublimerc.sh' to bash_profile *****"
        if [[ $source_sublimerc == '' ]];then
            echo "source sublimerc.sh" >> ${HOME}/.bash_profile
        fi

        echo "***** Installing sublime plugins *****"
        if [[ -f "${ST2_PACKAGES_DIR}" ]];then
            pushd "${ST2_PACKAGES_DIR}"
        
            echo "***** Installing sublime autosave plugin *****"
            git clone https://github.com/jamesfzhang/auto-save.git
            # Check if line exists in User/Default (OSX).sublime-keymap
            KEYMAP_LINE="{ "keys": ["ctrl+shift+s"], "command": "auto_save" }"
            popd
        elif [[ -f "${ST3_PACKAGES_DIR}" ]];then
            pushd ${ST3_PACKAGES_DIR}
            echo "***** Installing sublime autosave plugin *****"
            git clone https://github.com/jamesfzhang/auto-save.git
            # Check if line exists in User/Default (OSX).sublime-keymap
            KEYMAP_LINE="{ "keys": ["ctrl+shift+s"], "command": "auto_save" }"
            popd
        else 
            echo "***** Did not find sublimetext 2 or 3 at $ST2_PACKAGES_DIR or $ST3_PACKAGES_DIR *****"
            exit 1
        fi

    elif [[ $PLAT == "Linux" ]];then
        echo "***** Linux not yet supported *****"
    fi

fi



