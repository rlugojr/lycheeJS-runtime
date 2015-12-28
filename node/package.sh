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

	mkdir "$BUILD_ID-linux/arm";
	cp "$RUNTIME_ROOT/linux/arm/node" "$BUILD_ID-linux/arm/node";
	cp "$RUNTIME_ROOT/linux/arm/init.sh" "$BUILD_ID-linux/arm/$PROJECT_NAME.sh";
	cp "$BUILD_ID/index.js" "$BUILD_ID-linux/arm/index.js";
	chmod +x "$BUILD_ID-linux/arm/node";
	chmod +x "$BUILD_ID-linux/arm/$PROJECT_NAME.sh";

	mkdir "$BUILD_ID-linux/x86_64";
	cp "$RUNTIME_ROOT/linux/x86_64/node" "$BUILD_ID-linux/x86_64/node";
	cp "$RUNTIME_ROOT/linux/x86_64/init.sh" "$BUILD_ID-linux/x86_64/$PROJECT_NAME.sh";
	cp "$BUILD_ID/index.js" "$BUILD_ID-linux/x86_64/index.js";
	chmod +x "$BUILD_ID-linux/x86_64/node";
	chmod +x "$BUILD_ID-linux/x86_64/$PROJECT_NAME.sh";


	if [ -x "$BUILD_ID-linux/arm/$PROJECT_NAME.sh" ] && [ -x "$BUILD_ID-linux/x86_64/$PROJECT_NAME.sh" ]; then
		LINUX_STATUS=0;
	fi;

}

_package_osx () {

	if [ -d "./$BUILD_ID-osx" ]; then
		rm -rf "./$BUILD_ID-osx";
	fi;

	mkdir "$BUILD_ID-osx";

	mkdir "$BUILD_ID-osx/x86_64";
	cp "$RUNTIME_ROOT/osx/x86_64/node" "$BUILD_ID-osx/x86_64/node";
	cp "$RUNTIME_ROOT/osx/x86_64/init.sh" "$BUILD_ID-osx/x86_64/$PROJECT_NAME.sh";
	cp "$BUILD_ID/index.js" "$BUILD_ID-osx/x86_64/index.js";
	chmod +x "$BUILD_ID-osx/x86_64/node";
	chmod +x "$BUILD_ID-osx/x86_64/$PROJECT_NAME.sh";


	if [ -x "$BUILD_ID-osx/x86_64/$PROJECT_NAME.sh" ]; then
		OSX_STATUS=0;
	fi;

}

_package_windows () {

	if [ -d "./$BUILD_ID-windows" ]; then
		rm -rf "./$BUILD_ID-windows";
	fi;

	mkdir "$BUILD_ID-windows";

	mkdir "$BUILD_ID-windows/x86_64";
	cp "$RUNTIME_ROOT/windows/x86_64/node.exe" "$BUILD_ID-windows/x86_64/node.exe";
	cp "$RUNTIME_ROOT/windows/x86_64/node.lib" "$BUILD_ID-windows/x86_64/node.lib";
	cp "$RUNTIME_ROOT/windows/x86_64/init.cmd" "$BUILD_ID-windows/x86_64/$PROJECT_NAME.cmd";
	cp "$BUILD_ID/index.js" "$BUILD_ID-windows/x86_64/index.js";
	chmod +x "$BUILD_ID-windows/x86_64/node.exe";
	chmod +x "$BUILD_ID-windows/x86_64/$PROJECT_NAME.cmd";


	if [ -x "$BUILD_ID-windows/x86_64/$PROJECT_NAME.cmd" ]; then
		WINDOWS_STATUS=0;
	fi;

}



if [ -f "$PROJECT_ROOT/index.js" ]; then

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

