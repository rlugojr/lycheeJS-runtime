#!/usr/bin/env bash

set -u;
set -e;


lowercase() {
	echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/";
}

OS=`lowercase \`uname\``;
ARCH=`lowercase \`uname -m\``;

GITHUB_RELEASE="";
GITHUB_TOKEN=$(cat "/opt/lycheejs/.github/TOKEN");
RELEASE_USER="Artificial-Engineering";
RELEASE_REPO="lycheejs-runtime";
RELEASE_NAME=$(date +"%Y.%m.%d");
RUNTIME_ROOT=$(cd "$(dirname "$0")/../"; pwd);


if [ "$ARCH" == "x86_64" -o "$ARCH" == "amd64" ]; then
	ARCH="x86_64";
fi;

if [ "$ARCH" == "i386" -o "$ARCH" == "i686" -o "$ARCH" == "i686-64" ]; then
	ARCH="x86";
fi;

if [ "$ARCH" == "armv7l" -o "$ARCH" == "armv8" ]; then
	ARCH="arm";
fi;


if [ "$OS" == "darwin" ]; then

	OS="osx";
	GITHUB_RELEASE="$RUNTIME_ROOT/bin/helper/osx/$ARCH/github-release";

elif [ "$OS" == "linux" ]; then

	OS="linux";
	GITHUB_RELEASE="$RUNTIME_ROOT/bin/helper/linux/$ARCH/github-release";

fi;

if [ ! -f $GITHUB_RELEASE ]; then
	echo "Sorry, your computer is not supported. ($OS / $ARCH)";
	exit 1;
fi;



if [ -f "$RUNTIME_ROOT/lycheejs-runtime.zip" ]; then
	rm "$RUNTIME_ROOT/lycheejs-runtime.zip";
fi;


cd $RUNTIME_ROOT;
zip -r lycheejs-runtime.zip README.md ./bin ./html-nwjs ./html-webview ./node;


if [ -f $GITHUB_RELEASE ] && [ "$GITHUB_TOKEN" != "" ]; then

	cd $RUNTIME_ROOT;

	$GITHUB_RELEASE release --user $RELEASE_USER --repo $RELEASE_REPO --tag $RELEASE_NAME --name $RELEASE_NAME --pre-release --security-token $GITHUB_TOKEN;
	$GITHUB_RELEASE upload --user $RELEASE_USER --repo $RELEASE_REPO --tag $RELEASE_NAME --name lycheejs-runtime.zip --file $RUNTIME_ROOT/lycheejs-runtime.zip --security-token $GITHUB_TOKEN;

fi;


# TODO: Do this again
# rm "$RUNTIME_ROOT/lycheejs-runtime.zip";

