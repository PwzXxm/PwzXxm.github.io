#!/bin/bash
source ~/.rvm/scripts/rvm

comment="$1"
push_commit="git commit -a -m '$comment'"

# green color
GREEN='\033[0;32m'
# no color
NC='\033[0m'

# change ruby version
eval 'rvm use 2.2.5'

# assume in local branch
eval 'bundle exec jekyll build'
printf "\n"
eval 'git add .'
eval $push_commit
printf "\n"
eval 'git push origin local'
printf "${GREEN}Pushed to local branch${NC}\n\n"

# copy _site
eval 'rm -rf ~/git/local_backup/*'
eval 'cp -r ./_site/* ~/git/local_backup/'
printf "${GREEN}Copied to local_backup${NC}\n\n"

# add changes to master branch
eval 'git checkout master'
printf "\n"
eval 'cp ./README.md ~/git/local_backup/'
eval 'rm -rf ./*'
eval 'cp -r ~/git/local_backup/* ./'
eval 'touch .nojekyll'
printf "${GREEN}Copied to master branch${NC}\n\n"

# commit and push changes
eval 'git add .'
printf "\n"
eval $push_commit
eval 'git push origin master'
printf "\n"
eval 'git checkout local'
printf "${GREEN}Pushed to master branch${NC}\n"
