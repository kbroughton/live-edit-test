BRANCH=`git branch | grep '*' | cut -f2 -d' '`
if [[ "$BRANCH" == 'live-edit' ]];then
    echo "On branch live-edit"
    git pull
    echo q >> testfile
    git add testfile
    git commit -am "kbroughton"
    git push origin live-edit
    git push origin $USER-edits
else
    echo "Not on branch live-edit.  Doing nothing."
fi