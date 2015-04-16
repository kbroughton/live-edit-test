#!/bin/bash
BRANCH=`git branch | grep '*' | cut -f2 -d' '`
if [[ "$BRANCH" == 'live-edit' ]];then
    echo "On branch live-edit"
    echo "**** git pull ***"
    git pull
    PLAT=`uname`
    if [[ $PLAT == 'Linux' ]];then
	echo b >> testfile
    else
	echo q >> testfile
    fi
    echo "**** git add and git commit ****"
    git add testfile
    git commit -am "`hostname`"
    echo "***** git push origin live-edit ******"
    git push origin live-edit
    echo "**** git push origin $USER-edits ****"
    git push origin $USER-edits
else
    echo "Not on branch live-edit.  Doing nothing."
fi
