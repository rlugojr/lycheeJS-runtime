
# lychee.js Runtimes

brought to you as libre software with joy and pride by [Artificial Engineering](http://artificial.engineering).

Support our libre Bot Cloud via BTC [1CamMuvrFU1QAMebPoDsL3JrioVDoxezY2](bitcoin:1CamMuvrFU1QAMebPoDsL3JrioVDoxezY2?amount=0.5&label=lychee.js%20Support).



## Overview

This project aims to deliver the lychee.js Engine in
an easier way to other platforms via its fertilizer adapters.

These runtimes are the equivalent for each fertilizer adapter
and offer an identical way of packaging to multiple platforms.

This repository tries to ship binaries whereever possible.



## Usage

The `do-update.sh` script allows to update all third-party
dependencies and download all runtimes for all platforms
and all architectures automatically.

```bash
cd /opt/lycheejs/bin/runtime;

# Updates all runtimes
./bin/do-update.sh;
```



## Releases

The `do-release.sh` script allows to create a release for
github. It will package everything into a `zip` file that
is uploaded to the [releases](./releases) section of this
repository.

In order to make this work, you have to be a contributor
inside the [Artificial-Engineering](https://github.com/Artificial-Engineering)
organization and you must have configured your
[Personal Access Token](https://github.com/settings/tokens)
with `repo` rights.

```bash
# Dump the Token into the TOKEN file
echo MY-PERSONAL-ACCESS-TOKEN > /opt/lycheejs/.github/TOKEN;


cd /opt/lycheejs/bin/runtime;

# Creates a release and uploads it to github
./bin/do-release.sh;
```



# Work-in-Progress

- `html-nwjs` Linux ARM build [#1151](https://github.com/nwjs/nw.js/issues/1151)
- `html-webview` needs Android Nougat Toolchain update (and automatic download, so it's not tracked in this repository anymore)

