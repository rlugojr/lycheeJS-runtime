#!/usr/bin/env bash

set -u;
set -e;


for runtime in * ; do

	if [[ -f ./$runtime/update.sh ]]; then
		./$runtime/update.sh;
	fi;

done;

