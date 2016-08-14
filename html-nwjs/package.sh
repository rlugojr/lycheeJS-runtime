#!/bin/bash

lowercase() {
	echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/";
}

OS=`lowercase \`uname\``;

LYCHEEJS_ROOT=$(cd "$(dirname "$0")/../../../"; pwd);
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);
PROJECT_NAME="$2";
PROJECT_ROOT="$LYCHEEJS_ROOT$1";
BUILD_ID=`basename $PROJECT_ROOT`;


if [ "$OS" == "darwin" ]; then

	OS="osx";

elif [ "$OS" == "linux" ]; then

	OS="linux";

elif [ "$OS" == "windows_nt" ]; then

	OS="windows";

fi;


LINUX_STATUS=1;
OSX_STATUS=1;
WINDOWS_STATUS=1;


_package_linux () {

	if [ -d "./$BUILD_ID-linux" ]; then
		rm -rf "./$BUILD_ID-linux";
	fi;

	mkdir "$BUILD_ID-linux";


	mkdir "$BUILD_ID-linux/x86";
	cat "$RUNTIME_ROOT/linux/x86/nw" "$BUILD_ID.nw" > "$BUILD_ID-linux/x86/$PROJECT_NAME.bin";
	chmod +x "$BUILD_ID-linux/x86/$PROJECT_NAME.bin";

	cp -R $RUNTIME_ROOT/linux/x86/* $BUILD_ID-linux/x86/;
	rm $BUILD_ID-linux/x86/nw;


	mkdir "$BUILD_ID-linux/x86_64";
	cat "$RUNTIME_ROOT/linux/x86_64/nw" "$BUILD_ID.nw" > "$BUILD_ID-linux/x86_64/$PROJECT_NAME.bin";
	chmod +x "$BUILD_ID-linux/x86_64/$PROJECT_NAME.bin";

	cp -R $RUNTIME_ROOT/linux/x86_64/* $BUILD_ID-linux/x86_64/;
	rm $BUILD_ID-linux/x86_64/nw;

	if [ -x "$BUILD_ID-linux/x86/$PROJECT_NAME.bin" ] && [ -x "$BUILD_ID-linux/x86_64/$PROJECT_NAME.bin" ]; then
		LINUX_STATUS=0;
	fi;

}

_package_osx () {

	if [ -d "./$BUILD_ID-osx" ]; then
		rm -rf "./$BUILD_ID-osx";
	fi;

	mkdir "$BUILD_ID-osx";

	mkdir "$BUILD_ID-osx/x86_64";
	mkdir "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app";
	cp -r "$RUNTIME_ROOT/osx/x86_64/nwjs.app/Contents" "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app/Contents";
	cp "$BUILD_ID.nw" "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app/Contents/Resources/app.nw";

	# Well, fuck you, Apple.
	if [ "$OS" == "osx" ]; then
		sed -i '' "s/__NAME__/$PROJECT_NAME/g" "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app/Contents/Info.plist";
	else
		sed -i "s/__NAME__/$PROJECT_NAME/g" "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app/Contents/Info.plist";
		png2icns "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app/Contents/Resources/nw.icns" "$BUILD_ID/icon.png";
	fi;


	if [ -e "$BUILD_ID-osx/x86_64/$PROJECT_NAME.app/Contents/Resources/app.nw" ]; then
		OSX_STATUS=0;
	fi;

}

_package_windows () {

	if [ -d "./$BUILD_ID-windows" ]; then
		rm -rf "./$BUILD_ID-windows";
	fi;

	mkdir "$BUILD_ID-windows";

	mkdir "$BUILD_ID-windows/x86";
	cat "$RUNTIME_ROOT/windows/x86/nw.exe" "$BUILD_ID.nw" > "$BUILD_ID-windows/x86/$PROJECT_NAME.exe";
	chmod +x "$BUILD_ID-windows/x86/$PROJECT_NAME.exe";

	cp -R $RUNTIME_ROOT/windows/x86/* $BUILD_ID-windows/x86/;
	rm $BUILD_ID-windows/x86/nw.exe;


	mkdir "$BUILD_ID-windows/x86_64";
	cat "$RUNTIME_ROOT/windows/x86_64/nw.exe" "$BUILD_ID.nw" > "$BUILD_ID-windows/x86_64/$PROJECT_NAME.exe";
	chmod +x "$BUILD_ID-windows/x86_64/$PROJECT_NAME.exe";

	cp -R $RUNTIME_ROOT/windows/x86_64/* $BUILD_ID-windows/x86_64/;
	rm $BUILD_ID-windows/x86_64/nw.exe;


	if [ -x "$BUILD_ID-windows/x86/$PROJECT_NAME.exe" ] && [ -x "$BUILD_ID-windows/x86_64/$PROJECT_NAME.exe" ]; then
		WINDOWS_STATUS=0;
	fi;

}



if [ -f "$PROJECT_ROOT/package.json" ]; then

	# Preparations (.nw file)

	cd "$PROJECT_ROOT/../";
	if [ -f "./$BUILD_ID.nw" ]; then
		rm "./$BUILD_ID.nw";
	fi;

	cd $PROJECT_ROOT;
	zip -r -q "../$BUILD_ID.nw" ./*;



	# Package process

	cd "$PROJECT_ROOT/../";
	_package_linux;

	if [ "$LINUX_STATUS" != "0" ]; then
		echo "FAILURE (Linux build)";
	fi;


	cd "$PROJECT_ROOT/../";
	_package_osx;

	if [ "$OSX_STATUS" != "0" ]; then
		echo "FAILURE (OSX build)";
	fi;


	cd "$PROJECT_ROOT/../";
	_package_windows;

	if [ "$WINDOWS_STATUS" != "0" ]; then
		echo "FAILURE (Windows build)";
	fi;


	if [ "$LINUX_STATUS" != "0" ] || [ "$OSX_STATUS" != "0" ] || [ "$WINDOWS_STATUS" != "0" ]; then
		exit 1;
	fi;



	echo "SUCCESS";
	exit 0;

else

	echo "FAILURE";
	exit 1;

fi;

