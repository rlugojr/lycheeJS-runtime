#!/bin/bash

# XXX: NWJS guys have no symlink at /latest (it's outdated)
# NWJS_DOWNLOAD="http://dl.nwjs.io/v0.15.1";

NWJS_VERSION="v0.16.1";
NWJS_DOWNLOAD="http://nwjs.s3-us-west-2.amazonaws.com";
NWJS_AWSXML="$NWJS_DOWNLOAD/?delimiter=/&prefix=$NWJS_VERSION%2F";
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);


_download_linux () {

	if [ "$1" == "" ]; then
		return;
	fi;

	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NWJS_DOWNLOAD/$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$folder'";

		if [ ! -d "$folder" ]; then
			mkdir -p "$folder";
		fi;

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.tar.gz;

		if [ -f ./download.tar.gz ]; then

			tar -zxf ./download.tar.gz;

			if [ ! -d "$folder/lib" ]; then
				mkdir "$folder/lib";
			fi;

			if [ ! -d "$folder/locales" ]; then
				mkdir "$folder/locales";
			fi;

			mv $RUNTIME_ROOT/.tmp/nwjs-*/icudtl.dat                  $folder/icudtl.dat;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/lib/libffmpeg.so            $folder/lib/libffmpeg.so;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/lib/libnode.so              $folder/lib/libnode.so;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/lib/libnw.so                $folder/lib/libnw.so;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/locales/en-US.pak           $folder/locales/en-US.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/resources.pak               $folder/resources.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw                          $folder/nw;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_100_percent.pak          $folder/nw_100_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_200_percent.pak          $folder/nw_200_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_material_100_percent.pak $folder/nw_material_100_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_material_200_percent.pak $folder/nw_material_200_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/natives_blob.bin            $folder/natives_blob.bin;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/snapshot_blob.bin           $folder/snapshot_blob.bin;

			echo "$new_hash" > $folder/.download_hash;

		fi;

	fi;

}

_download_osx () {

	if [ "$1" == "" ]; then
		return;
	fi;


	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NWJS_DOWNLOAD/$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$folder'";

		if [ ! -d "$folder" ]; then
			mkdir -p "$folder";
		fi;

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.zip;

		if [ -f ./download.zip ]; then

			unzip -q ./download.zip;

			rm -rf $folder/nwjs.app;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nwjs.app $folder/nwjs.app;

			echo "$new_hash" > $folder/.download_hash;


			if [ -f "$folder/nwjs.app/Contents/Info.plist" ]; then

				sed -i '10s|nwjs|__NAME__|'   "$folder/nwjs.app/Contents/Info.plist";
				sed -i 's|Chromium|__NAME__|' "$folder/nwjs.app/Contents/Info.plist";

			fi;

		fi;

	fi;

}

_download_windows () {

	if [ "$1" == "" ]; then
		return;
	fi;

	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NWJS_DOWNLOAD/$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$folder'";

		if [ ! -d "$folder" ]; then
			mkdir -p "$folder";
		fi;

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.zip;

		if [ -f ./download.zip ]; then

			unzip -q ./download.zip;

			if [ ! -d "$folder/locales" ]; then
				mkdir "$folder/locales";
			fi;

			mv $RUNTIME_ROOT/.tmp/nwjs-*/d3dcompiler_47.dll          $folder/d3dcompiler_47.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/ffmpeg.dll                  $folder/ffmpeg.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/icudtl.dat                  $folder/icudtl.dat;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/libEGL.dll                  $folder/libEGL.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/libGLESv2.dll               $folder/libGLESv2.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/locales/en-US.pak           $folder/locales/en-US.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/node.dll                    $folder/node.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw.dll                      $folder/nw.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw.exe                      $folder/nw.exe;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_100_percent.pak          $folder/nw_100_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_200_percent.pak          $folder/nw_200_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_elf.dll                  $folder/nw_elf.dll;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_material_100_percent.pak $folder/nw_material_100_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/nw_material_200_percent.pak $folder/nw_material_200_percent.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/resources.pak               $folder/resources.pak;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/natives_blob.bin            $folder/natives_blob.bin;
			mv $RUNTIME_ROOT/.tmp/nwjs-*/snapshot_blob.bin           $folder/snapshot_blob.bin;

			echo "$new_hash" > $folder/.download_hash;

		fi;

	fi;

}



echo "UPDATE html-nwjs ...";
cd $RUNTIME_ROOT;

if [ ! -d ./.tmp ]; then
	mkdir .tmp;
fi;


if [ -f ./SHASUMS256.txt ]; then
	rm ./SHASUMS256.txt;
fi;


cd $RUNTIME_ROOT;
curl -s "$NWJS_AWSXML" > ./aws.xml;
cat ./aws.xml | grep -oPm1 "(?<=<Key>)[^<]+"  | sed -e "s/\s/\n/g"   > ./files.txt;
cat ./aws.xml | grep -oPm1 "(?<=<ETag>)[^<]+" | sed -e "s/&quot;//g" > ./hashes.txt;

LINUX_X86=$(cat ./files.txt | grep -n nwjs-v | grep linux-ia32 | grep gz | cut -d":" -f1);
FILE_LINUX_X86=$(sed -n "${LINUX_X86}p" ./files.txt);
HASH_LINUX_X86=$(sed -n "${LINUX_X86}p" ./hashes.txt);

LINUX_X64=$(cat ./files.txt | grep -n nwjs-v | grep linux-x64 | grep gz | cut -d":" -f1);
FILE_LINUX_X64=$(sed -n "${LINUX_X64}p" ./files.txt);
HASH_LINUX_X64=$(sed -n "${LINUX_X64}p" ./hashes.txt);

OSX_X64=$(cat ./files.txt | grep -n nwjs-v | grep osx-x64 | grep zip | cut -d":" -f1);
FILE_OSX_X64=$(sed -n "${OSX_X64}p" ./files.txt);
HASH_OSX_X64=$(sed -n "${OSX_X64}p" ./hashes.txt);

WINDOWS_X86=$(cat ./files.txt | grep -n nwjs-v | grep win-ia32 | grep zip | cut -d":" -f1);
FILE_WINDOWS_X86=$(sed -n "${WINDOWS_X86}p" ./files.txt);
HASH_WINDOWS_X86=$(sed -n "${WINDOWS_X86}p" ./hashes.txt);

WINDOWS_X64=$(cat ./files.txt | grep -n nwjs-v | grep win-x64 | grep zip | cut -d":" -f1);
FILE_WINDOWS_X64=$(sed -n "${WINDOWS_X64}p" ./files.txt);
HASH_WINDOWS_X64=$(sed -n "${WINDOWS_X64}p" ./hashes.txt);



# XXX: Issue https://github.com/nwjs/nw.js/issues/4930

# cd $RUNTIME_ROOT;
# curl -s "$NWJS_DOWNLOAD/SHASUMS256.txt" > ./SHASUMS256.txt;
#
# FILE_LINUX_X86=$(  cat ./SHASUMS256.txt | grep nwjs-v | grep linux-ia32 | grep gz  | cut -d" " -f3);
# HASH_LINUX_X86=$(  cat ./SHASUMS256.txt | grep nwjs-v | grep linux-ia32 | grep gz  | cut -d" " -f1);
#
# FILE_LINUX_X64=$(  cat ./SHASUMS256.txt | grep nwjs-v | grep linux-x64  | grep gz  | cut -d" " -f3);
# HASH_LINUX_X64=$(  cat ./SHASUMS256.txt | grep nwjs-v | grep linux-x64  | grep gz  | cut -d" " -f1);
#
# FILE_OSX_X64=$(    cat ./SHASUMS256.txt | grep nwjs-v | grep osx-x64    | grep zip | cut -d" " -f3);
# HASH_OSX_X64=$(    cat ./SHASUMS256.txt | grep nwjs-v | grep osx-x64    | grep zip | cut -d" " -f1);
#
# FILE_WINDOWS_X86=$(cat ./SHASUMS256.txt | grep nwjs-v | grep win-ia32   | grep zip | cut -d" " -f3);
# HASH_WINDOWS_X86=$(cat ./SHASUMS256.txt | grep nwjs-v | grep win-ia32   | grep zip | cut -d" " -f1);
#
# FILE_WINDOWS_X64=$(cat ./SHASUMS256.txt | grep nwjs-v | grep win-x64    | grep zip | cut -d" " -f3);
# HASH_WINDOWS_X64=$(cat ./SHASUMS256.txt | grep nwjs-v | grep win-x64    | grep zip | cut -d" " -f1);
#


cd $RUNTIME_ROOT;

_download_linux "$FILE_LINUX_X86" "$HASH_LINUX_X86" "linux/x86";
_download_linux "$FILE_LINUX_X64" "$HASH_LINUX_X86" "linux/x86_64";
_download_osx "$FILE_OSX_X64" "$HASH_OSX_X64" "osx/x86_64";
_download_windows "$FILE_WINDOWS_X86" "$HASH_WINDOWS_X86" "windows/x86";
_download_windows "$FILE_WINDOWS_X64" "$HASH_WINDOWS_X64" "windows/x86_64";

rm -rf $RUNTIME_ROOT/.tmp;


echo "SUCCESS";
exit 0;

