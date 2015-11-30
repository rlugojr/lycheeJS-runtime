#!/bin/bash

NWJS_DOWNLOAD="http://dl.nwjs.io/latest";
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);


echo "UPDATE html-nwjs ...";
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


curl -s "$NWJS_DOWNLOAD/MD5SUMS" > ./MD5SUMS;
DL_LINUX_X64=$(cat ./MD5SUMS | cut -c 35- | grep linux-x64 | grep nwjs-v | grep gz);

curl -s "$NWJS_DOWNLOAD/$DL_LINUX_X64" > ./$DL_LINUX_X64;
tar -zxf ./$DL_LINUX_X64;
mv ./nwjs-*-linux-x64/icudtl.dat $RUNTIME_ROOT/linux/x86_64/icudtl.dat;
mv ./nwjs-*-linux-x64/libffmpegsumo.so $RUNTIME_ROOT/linux/x86_64/libffmpegsumo.so;
mv ./nwjs-*-linux-x64/nw $RUNTIME_ROOT/linux/x86_64/nw;
mv ./nwjs-*-linux-x64/nw.pak $RUNTIME_ROOT/linux/x86_64/nw.pak;



#
# OSX
#


_cleanup_tmp;
cd $RUNTIME_ROOT/.tmp;


curl -s "$NWJS_DOWNLOAD/MD5SUMS" > ./MD5SUMS;
DL_OSX_X64=$(cat ./MD5SUMS | cut -c 35- | grep osx-x64 | grep nwjs-v | grep zip);

curl -s "$NWJS_DOWNLOAD/$DL_OSX_X64" > ./$DL_OSX_X64;
unzip -q ./$DL_OSX_X64;
rm -rf $RUNTIME_ROOT/osx/x86_64/nwjs.app;
mv ./nwjs-*-osx-x64/nwjs.app $RUNTIME_ROOT/osx/x86_64/nwjs.app;



#
# WINDOWS
#


_cleanup_tmp;
cd $RUNTIME_ROOT/.tmp;


curl -s "$NWJS_DOWNLOAD/MD5SUMS" > ./MD5SUMS;
DL_WIN_X64=$(cat ./MD5SUMS | cut -c 35- | grep win-x64 | grep nwjs-v | grep zip);

curl -s "$NWJS_DOWNLOAD/$DL_WIN_X64" > ./$DL_WIN_X64;
unzip -q ./$DL_WIN_X64;
mv ./nwjs-*-win-x64/d3dcompiler_47.dll $RUNTIME_ROOT/windows/x86_64/d3dcompiler_47.dll;
mv ./nwjs-*-win-x64/ffmpegsumo.dll $RUNTIME_ROOT/windows/x86_64/ffmpegsumo.dll;
mv ./nwjs-*-win-x64/icudtl.dat $RUNTIME_ROOT/windows/x86_64/icudtl.dat;
mv ./nwjs-*-win-x64/libEGL.dll $RUNTIME_ROOT/windows/x86_64/libEGL.dll;
mv ./nwjs-*-win-x64/libGLESv2.dll $RUNTIME_ROOT/windows/x86_64/libGLESv2.dll;
mv ./nwjs-*-win-x64/nw.exe $RUNTIME_ROOT/windows/x86_64/nw.exe;
mv ./nwjs-*-win-x64/nw.pak $RUNTIME_ROOT/windows/x86_64/nw.pak;



rm -rf $RUNTIME_ROOT/.tmp;

echo "SUCCESS";
exit 0;

