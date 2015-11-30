#!/bin/bash

NODE_DOWNLOAD="https://nodejs.org/dist/latest";
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);


echo "UPDATE node ...";
cd $RUNTIME_ROOT;



_cleanup_tmp () {

	cd $RUNTIME_ROOT;

	if [ -d .tmp ]; then
		rm -rf .tmp;
	fi;

	mkdir .tmp;

}



#
# LINUX
#


_cleanup_tmp;
cd $RUNTIME_ROOT/.tmp;


curl -s "$NODE_DOWNLOAD/SHASUMS256.txt" > ./SHASUMS256.txt;
DL_LINUX_ARM=$(cat ./SHASUMS256.txt | cut -c 67- | grep linux-armv7l | grep gz);
DL_LINUX_X64=$(cat ./SHASUMS256.txt | cut -c 67- | grep linux-x64 | grep gz);

curl -s "$NODE_DOWNLOAD/$DL_LINUX_ARM" > ./$DL_LINUX_ARM;
curl -s "$NODE_DOWNLOAD/$DL_LINUX_X64" > ./$DL_LINUX_X64;
tar -zxf ./$DL_LINUX_ARM;
tar -zxf ./$DL_LINUX_X64;
mv ./node-*-linux-armv7l/bin/node $RUNTIME_ROOT/linux/arm/node;
mv ./node-*-linux-x64/bin/node $RUNTIME_ROOT/linux/x86_64/node;



#
# OSX
#


_cleanup_tmp;
cd $RUNTIME_ROOT/.tmp;


curl -s "$NODE_DOWNLOAD/SHASUMS256.txt" > ./SHASUMS256.txt;
DL_OSX_X64=$(cat ./SHASUMS256.txt | cut -c 67- | grep darwin-x64 | grep gz);

curl -s "$NODE_DOWNLOAD/$DL_OSX_X64" > ./$DL_OSX_X64;
tar -zxf ./$DL_OSX_X64;
mv ./node-*-darwin-x64/bin/node $RUNTIME_ROOT/osx/x86_64/node;



#
# WINDOWS
#


_cleanup_tmp;
cd $RUNTIME_ROOT/.tmp;


curl -s "$NODE_DOWNLOAD/win-x64/node.exe" > $RUNTIME_ROOT/windows/x86_64/node.exe;
curl -s "$NODE_DOWNLOAD/win-x64/node.lib" > $RUNTIME_ROOT/windows/x86_64/node.lib;



rm -rf $RUNTIME_ROOT/.tmp;

echo "SUCCESS";
exit 0;

