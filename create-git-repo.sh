#!/bin/bash
#
# @file create-git-repo.sh
#
# This script initializes an empty git repo and creates the proper directory
# structure, which starts with the client name. If client or project names have
# spaces, they MUST be quoted. Please check to see if the client exists first
# before running this script.
#
# Script should be run on $repo_master_host.
#
#  EXAMPLE USAGE:
#	create-git-repo.sh "Example Client Inc" "example.com"
#
# @author programming@dbswebsite.com 2012-11-02
#
###########################################################################

owner=git
group=development
permissions=775
repos=repos.dbswebsite.com
repo_home=$repos:/repos/git
tmp=/tmp/repos/git
home=$(pwd)

! [ "$1" ] && echo You need a client name on the command line, friend && exit 1
! [ "$2" ] && echo You need a client name and a project name on the command line, doh && exit 1
[ "$3" ] && echo "Too many command line args. Did you quote the client name? ass_hat" && exit 1

if [ $(hostname) != $repos ];then
	echo Wrong host ... should be run from $repos, sir
	exit
fi

# normalize
client=$(echo "$1" |  sed  -e 's/ /-/g' |tolower.sh)
project=$(echo "$2" |  sed  -e 's/ /-/g' |tolower.sh)

clear

[ -d $tmp ] && rm -fr $tmp/* || mkdir -p $tmp

# 2009-01-11, just in case ... 
cd $tmp || exit 1

echo "Creating git master repository ..."
echo "Creating git $client directory ..."
mkdir $client || exit 1
cd $client || exit 1

# Abort if the project already exists
if [ -d $project ];then
	echo "The $project project already exists! Exiting now."
	exit 1
fi

# Create the directory
echo "Creating git $project directory ..."
mkdir $project || exit 1

# Move into the new directory
cd $project || exit 1
pwd

# create an empty, "bare" git repo
git init --bare

# FIXME, path is hardcoded
mkdir -p /repos/git/$client/$project
cp -av . /repos/git/$client/$project

if [ $UID == 0 ];then
	# fix ownership if run by root
	chown -R $owner:$group /repos/git/$client/
	chmod -R 775 /repos/git/$client/
fi

echo Done creating $repo_home/$client/$project

# eof
