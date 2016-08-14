#!/usr/bin/env bash

set -u;
set -e;


RUNTIME_ROOT=$(cd "$(dirname "$0")/../"; pwd);


for runtime in $RUNTIME_ROOT/* ; do

	if [[ -f ./$runtime/update.sh ]]; then
		./$runtime/update.sh;
	fi;

done;

