#!/bin/bash
set -e

FILENAME="pgdump-aws-lambda.zip"

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists zip ; then
    echo "zip command not found, try: sudo apt-get install zip"
    exit 0
fi

echo "creating bundle.."
# create a temp directory for our bundle
mkdir bundle
# copy entire app into BUNDLE_DIR
cp -r `ls -A | grep -v "bundle"` bundle

# prune things from BUNDLE_DIR
echo "running npm prune.."
cd bundle
# prune dev-dependancies from node_modules
npm prune --production >> /dev/null

rm -rf dist coverage test

# create and empty the dist directory
if [ ! -d ../dist ]; then
    mkdir ../dist
fi
rm -rf ../dist/*

# create zip of bundle/
echo "creating zip.."
zip -q -r $FILENAME *
echo "zip -q -r $FILENAME *"
mv $FILENAME ../dist/$FILENAME

echo "successfully created dist/$FILENAME"

cd ..
# remove bundle/
rm -rf bundle/
