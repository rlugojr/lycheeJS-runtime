#!/bin/bash

NODE_DOWNLOAD="https://nodejs.org/dist/latest";
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);


_download_archive () {

	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NODE_DOWNLOAD/$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$(dirname $3)";
	target="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$target'";

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.tar.gz;
		tar -zxf ./download.tar.gz;

		mv $RUNTIME_ROOT/.tmp/node-*/bin/node $target;
		echo "$new_hash" > $folder/.download_hash;

	fi;

}

_download_file () {

	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NODE_DOWNLOAD/$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$(dirname $3)";
	target="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$target'";

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.bin;

		mv download.bin $target;
		echo "$new_hash" > $folder/.download_hash;

	fi;

}


echo "UPDATE node ...";
cd $RUNTIME_ROOT;

if [ ! -d ./.tmp ]; then
	mkdir .tmp;
fi;


if [ -f ./SHA256SUMS.txt ]; then
	rm ./SHA256SUMS.txt;
fi;


cd $RUNTIME_ROOT;
curl -s "$NODE_DOWNLOAD/SHASUMS256.txt" > ./SHASUMS256.txt;

FILE_LINUX_ARM=$(  cat ./SHASUMS256.txt | grep linux-armv7l | grep gz  | cut -d" " -f3);
HASH_LINUX_ARM=$(  cat ./SHASUMS256.txt | grep linux-armv7l | grep gz  | cut -d" " -f1);

FILE_LINUX_X86=$(  cat ./SHASUMS256.txt | grep linux-x86    | grep gz  | cut -d" " -f3);
HASH_LINUX_X86=$(  cat ./SHASUMS256.txt | grep linux-x86    | grep gz  | cut -d" " -f1);

FILE_LINUX_X64=$(  cat ./SHASUMS256.txt | grep linux-x64    | grep gz  | cut -d" " -f3);
HASH_LINUX_X64=$(  cat ./SHASUMS256.txt | grep linux-x64    | grep gz  | cut -d" " -f1);

FILE_OSX_X64=$(    cat ./SHASUMS256.txt | grep darwin-x64   | grep gz  | cut -d" " -f3);
HASH_OSX_X64=$(    cat ./SHASUMS256.txt | grep darwin-x64   | grep gz  | cut -d" " -f1);

FILE_WINDOWS_X86=$(cat ./SHASUMS256.txt | grep win-x86      | grep exe | cut -d" " -f3);
HASH_WINDOWS_X86=$(cat ./SHASUMS256.txt | grep win-x86      | grep exe | cut -d" " -f1);

FILE_WINDOWS_X64=$(cat ./SHASUMS256.txt | grep win-x64      | grep exe | cut -d" " -f3);
HASH_WINDOWS_X64=$(cat ./SHASUMS256.txt | grep win-x64      | grep exe | cut -d" " -f1);


cd $RUNTIME_ROOT;

_download_archive "$FILE_LINUX_ARM" "$HASH_LINUX_ARM" "linux/arm/node";
_download_archive "$FILE_LINUX_X86" "$HASH_LINUX_X86" "linux/x86/node";
_download_archive "$FILE_LINUX_X64" "$HASH_LINUX_X64" "linux/x86_64/node";
_download_archive "$FILE_OSX_X64"   "$HASH_OSX_X64"   "osx/x86_64/node";

_download_file "$FILE_WINDOWS_X86" "$HASH_WINDOWS_X86" "windows/x86/node.exe";
_download_file "$FILE_WINDOWS_X64" "$HASH_WINDOWS_X64" "windows/x86_64/node.exe";


rm -rf $RUNTIME_ROOT/.tmp;


echo "SUCCESS";
exit 0;

