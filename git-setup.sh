#!/bin/bash
#
#################################################################################
#										#
#										#
# Opis		:	Skrypt do ustawiania git'a 				#
#		:								#
# Author	:	Maciej Młocek (thx to Eric Dubois from Arcolinux)	#
#										#
#										#
#################################################################################


#setting up git
#https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-config


git config --global pull.rebase false
git config --global push.default simple
git config --global user.name "elkrien"
git config --global user.email "elkrien@gmail.com"
sudo git config --system core.editor micro
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=32000'
      

echo "###########################################################"
echo "	Github credentials zostały ustawione"
echo "	Wykasuj folder ~/.cache/git jeśli się pomyliłeś"
echo "	lub chcesz się przełączyć na inny github"
echo "###########################################################"
echo
echo "################################################################"
echo "####################    K O N I E C    #########################"
echo "################################################################"
