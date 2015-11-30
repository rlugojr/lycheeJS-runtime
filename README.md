
# lycheeJS-runtime

This project aims to deliver lycheeJS in an easier way
to other platforms via its fertilizer adapters.

These runtimes are integrated in the lycheeJS bundles
and don't require additional software as they are
shipped in this repository as binaries.


# Build Setup

The build server setup requires a Ubuntu 16.04 LTS or
Ubuntu 15.10 machine with at least 4GB of free hard drive
space. Optional third-party SDKs are only `openjdk-8-jdk`
for the Android platform at the moment. Automatic updates
with the `./update.sh` script work only if you have `curl`
and `git` installed. 

The runtime toolchain also works somehow on OSX, but OSX
is not well integrated with its faked GNU toolchain from
UNIX systems - so there may occur many bugs.

However, you are free to contribute patches or file issues
for OSX if you like.

```bash
sudo apt-get install bash binutils coreutils icnsutils sed zip unzip tar curl git wget openjdk-8-jdk -y;
```


# Build Process

These runtime toolchain is usable via the `./bin/fertilizer.sh`
which automatically ports the project as a serialized
environment. This serialized environment is then passed
to the `./$runtime/package.sh` and then ported to all
platforms each runtime is available for.

For example, this fertilizer call will fertilize the
boilerplate application for the `html-nwjs` runtime,
to 6 different targets: Linux, OSX and Windows; each
both x86 and x86_64.

```bash
cd /opt/lycheejs; # path to lycheeJS root
./bin/fertilizer.sh boilerplate "html-nwjs/main";
```


# Contributor Release Process

The runtime toolchain is released as forced push commits due
to their heavy oversized binaries. We don't track history of
the runtimes, so each release they are shipped with the
latest stable up-to-date variant.

```bash
cd /opt/lycheejs/bin/runtime;

./update.sh;


git status; # Fix OSX builds and their Info.plist (__NAME__ placeholder)


rm -rf .git/;
git init;
git remote add origin git@github.com:Artificial-Engineering/lycheeJS-runtime.git;
git add ./;
git commit -m ":sparkles: :boom: :sparkles:"
git push origin master -f;
```

