#!/bin/bash

PROJECT_ROOT=$(cd "$(dirname "$0")/"; pwd);

cd $PROJECT_ROOT;
./node ./index.js;

