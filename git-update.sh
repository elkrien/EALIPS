#!/bin/sh
#
# GIT update script
# by MM <elkrien@gmail.com>
# based & inspired on Eric Dubois (thanx)
# License: GNU GPLv3
#
#https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-config



# Github (pull)

tput setaf 3
echo
echo "Verification if everything is actual..."
tput sgr0
git pull

# Mark all for update

git add --all .

# Add commit

tput setaf 3
echo
echo
echo "####################################"
echo
echo "Add commit:"

read input
tput sgr0

# Set commit with above comment and date

git commit -m "$input"

# Github (push)

git push -u origin main

# Final information

tput setaf 3
echo
echo
echo "################################################################"
echo
echo "                      Git updated"
echo
echo "################################################################"
echo
tput sgr0
