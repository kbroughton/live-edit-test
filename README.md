README.md

autogit_cron is installed by coping it into the editor after running 
> env EDITOR=nano crontab -e

Then install the sublime plugins: autosave
./setup_autogit.sh

By default the letter 'q' is appended to the file by the cron job every minute for testing.

The user must be working on the live-edits branch for autogit.sh to run

The cron job also runs autogit.sh every minute to do the following:

> git pull live-edits                # pull from live-edits branch gathering new edits from other users
> git commit -am "$USER-<timestamp>" # commit the file 
> git push origin live-edit          # push to live-edits 
> git push origin $USER-edits        # push to user-tagged branch to track this user's commits

On a regular inteval, the live-edits head will be staged to a new branch live-edits-candidate
and parse-tested.  If it passes it will be pushed to dev branch.

It would be reasonable to git squash multiple commits before promoting to stable branches.

