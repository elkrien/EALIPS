#!/bin/sh
#
# GIT setup script
# by MM <elkrien@gmail.com>
# based & inspired on Eric Dubois (thanx)
# License: GNU GPLv3
#
#https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-config

git config --global pull.rebase false
git config --global push.default simple
git config --global user.name "elkrien"
git config --global user.email "elkrien@gmail.com"
sudo git config --system core.editor micro
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=32000'
      
echo "###########################################################"
echo "	Github credentials have been set"
echo "	Delete folder ~/.cache/git if You made an error"
echo "	or want to switch to another GitHub credentials"
echo "###########################################################"
