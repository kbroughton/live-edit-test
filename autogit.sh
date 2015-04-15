git pull
echo q >> testfile
git add testfile
git commit -am "kbroughton"
git push origin/live-edit
git push origin/$USER-edits
