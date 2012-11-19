#!/bin/bash
#
# @file bzr2git.sh
#
# Shell script to convert bzr repo to git. Requires the bzr fastimport module.
#
# Note: New to git. This works, but probably could be done in a step or two less.
#
# Usage: bz2git.sh "$client" "$project"
#
# @author programming@dbswebsite.com 2012-11-13
#
###############################################################################

repo_master=repos.dbswebsite.com

clear

# sanity checks
[ ! -d .bzr ] && echo is this a bzr repo or not? && exit 1

# For our purposes, we need to know the CLIENT and the PROJECT!
[ ! "$1" ] && echo Need client name on command line && exit 1
[ ! "$2" ] && echo Need project name on command line && exit 1

# normalize $client. TODO
client=$(echo "$1" |  sed  -e 's/ /-/g' |tolower.sh)
project=$(echo "$2" |  sed  -e 's/ /-/g' |tolower.sh)

echo starting git conversion, making sure bzr is up to date ....
# make sure all the bzr stuff is up to date & committed
bzr update
bzr add
bzr commit -m 'Final bzr commit, if needed ...'

# git does not handle empty directories (bzr does)
find -type d -empty -exec touch {}/.ignore \;

# starting git import
git init
cp .bzrignore .gitignore
bzr fast-export `pwd` | git fast-import
rm -rfv .bzr*
git add .
git commit -m "Converting to git"  
# 
echo
echo Look OK? Is $repo_master ready for new repo? Are we good to go for a push? ctrl-c to cancel
read

echo creating repo on $repo_master and pushing code ...
# create-git-repo.sh is custom script to create file $client/$project file structure and initialize a --bare git repo
ssh git@$repo_master create-git-repo.sh \"$client\" \"$project\"
git remote add origin "git@$repo_master:/repos/git/$client/$project"
git push origin master
git config branch.master.remote origin
git config branch.master.merge refs/heads/master

echo;echo Done. Test it now.

# yea
