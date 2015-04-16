

############################
# Sublime
############################
PLAT=`uname` 2 > &1

ST_PATH=`which subl`
if [[ ${ST_PATH} != "" ]];then
    if [[ $PLAT == "Darwin" ]];then
        ST_CONF_DIR="${HOME}/.config/sublime"
        echo "Creating $ST_CONF_DIR config dir"
if [[ ! -f ${ST_CONF_DIR} ]];then
    mkdir -p ${ST_CONF_DIR}
fi

if [[ ! -f ${ST_CONF_DIR}/sublimerc.sh ]];then
    echo "Copying sublimerc.sh to $ST_CONF_DIR"
    cp sublimerc.sh ${ST_CONF_DIR}
fi


# Check if ~/.bash_profile already sources sublimerc.sh
source_sublimerc=`grep sublimerc ${HOME}/.bash_profile`
echo "Adding 'source $ST_CONF_DIR/sublimerc.sh' to bash_profile"
if [[ $source_sublimerc == '' ]];then
    echo "source sublimerc.sh" >> ${HOME}/.bash_profile
fi

###############################
# Git
###############################

echo "Creating live-edit and my-edits git branches"
LIVE_EDITS_BRANCH=live-edit
MY_EDITS_BRANCH=my-edits

git branch ${LIVE_EDITS_BRANCH}
git branch ${MY_EDITS_BRANCH}

echo "Installing sublime plugins"
if [[ -f "${ST2_PACKAGES_DIR}" ]];then
	pushd "${ST2_PACKAGES_DIR}"

    echo "Installing sublime autosave plugin"
	git clone https://github.com/jamesfzhang/auto-save.git
    # Check if line exists in User/Default (OSX).sublime-keymap
    KEYMAP_LINE="{ "keys": ["ctrl+shift+s"], "command": "auto_save" }"

elif [[ -f "${ST3_PACKAGES_DIR}" ]];then
    pushd ${ST3_PACKAGES_DIR}
    echo "Installing sublime autosave plugin"
    git clone https://github.com/jamesfzhang/auto-save.git
    # Check if line exists in User/Default (OSX).sublime-keymap
    KEYMAP_LINE="{ "keys": ["ctrl+shift+s"], "command": "auto_save" }"

else 
    echo "Did not find sublimetext 2 or 3 at $ST2_PACKAGES_DIR or $ST3_PACKAGES_DIR"
    exit 1
fi

