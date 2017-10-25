#!/bin/bash
source ~/.rvm/scripts/rvm

comment="$1"
push_commit="git commit -a -m '$comment'"
GREEN='\033[0;32'

# change ruby version
eval 'rvm use 2.2.5'

# assume in local branch
eval 'bundle exec jekyll build'
echo
eval 'git add .'
echo
eval $push_commit
echo
eval 'git push --all origin local'
echo -e "${GREEN}Pushed to local branch"
echo

# copy _site
eval 'rm -rf ~/git/local_backup/*'
eval 'cp -r ./_site/* ~/git/local_backup/'
echo -e "${GREEN}Copied to local_backup"
echo

# add changes to master branch
eval 'git checkout master'
eval 'cp ./README.md ~/git/local_backup/'
eval 'rm -rf ./*'
eval 'cp -r ~/git/local_backup/* ./'
eval 'touch .nojekyll'
#echo 'find ~/git/ -name ".DS_Store" -depth -exec rm {} \'
echo -e "${GREEN}Copied to master branch"
echo

# commit and push changes
eval 'git add .'
echo
eval $push_commit
echo
eval 'git push --all origin master'
echo
eval 'git checkout local'
echo -e "${GREEN}Pushed to master branch"
echo
