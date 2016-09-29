#!/usr/bin/env bash

set -u;
set -e;


TMP_STATUS="/tmp/lycheejs-runtime.json";
GITHUB_TOKEN=$(cat "/opt/lycheejs/.github/TOKEN");
RELEASE_USER="Artificial-Engineering";
RELEASE_REPO="lycheejs-runtime";
RELEASE_NAME=$(date +"%Y.%m.%d");
RUNTIME_ROOT=$(cd "$(dirname "$0")/../"; pwd);


if [ -f "$RUNTIME_ROOT/lycheejs-runtime.zip" ]; then
	rm "$RUNTIME_ROOT/lycheejs-runtime.zip";
fi;


cd $RUNTIME_ROOT;
zip -r lycheejs-runtime.zip README.md ./bin ./html-nwjs ./html-webview ./node;


if [ "$GITHUB_TOKEN" != "" ]; then

	echo "RELEASE lycheejs-runtime";

	cd $RUNTIME_ROOT;

	curl --silent -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" --data "{\"tag_name\":\"$RELEASE_NAME\",\"name\":\"$RELEASE_NAME\",\"prerelease\":true}" "https://api.github.com/repos/$RELEASE_USER/$RELEASE_REPO/releases" -o "$TMP_STATUS";


	release_id=$(cat "$TMP_STATUS" | grep id | cut -d"," -f1 | cut -d":" -f2 | head -1 | tr -d '[[:space:]]');

	if [ "$release_id" != "ValidationFailed" ]; then

		echo "> uploading zip for $release_id ...";

		cd $RUNTIME_ROOT;
		curl --silent -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/zip" --data-binary "@$RUNTIME_ROOT/lycheejs-runtime.zip" "https://uploads.github.com/repos/$RELEASE_USER/$RELEASE_REPO/releases/$release_id/assets?name=lycheejs-runtime.zip" &> /dev/null;

		echo "SUCCESS";
		exit 0;

	else

		echo "FAILURE";
		exit 1;

	fi;

fi;


rm "$RUNTIME_ROOT/lycheejs-runtime.zip";

