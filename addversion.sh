#!/bin/bash
set -x
set -e

if [ "$1" = "" ]; then
	echo "usage: $0 <php version> [docker host:port]"
	exit -1
fi

DOCKER_HOST=""
if [ "$2" != "" ]; then
	DOCKER_HOST="-H $2"
fi

read -p "Will attempt to build new container from PHP version $1, is this correct? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit -1
fi

if [ -f ".lock" ]; then
	echo
	echo "Already building elsewhere, exiting"
	echo "If this is not the case, something went wrong in a previous build. Remove .lock file and try again"
	exit -1
fi

touch .lock
echo
echo
echo >build.log # nuke the log
echo "Okay! Let's go! You can watch the debug progress with: \$ tail -f build.log"
echo "Creating $1 folder ..."

MAINVER=${1%.*}
if [ ! -f ".ext-$MAINVER" ]; then
	BUILDCONF=$(cat .ext-default)
else
	BUILDCONF=$(cat .ext-$MAINVER)
fi

mkdir -p $1
pushd $1
cat > Dockerfile <<EOF
FROM php:$1
$BUILDCONF
RUN ln -s /usr/local/bin/php /php

ADD common/run.sh /run.sh
ADD common/content /content
RUN useradd -d /render -m -s /bin/false -U render
USER render
WORKDIR /render
ENTRYPOINT ["/run.sh"]
EOF

! git submodule status common
if [ $? -eq 0 ]; then
	git submodule add --force git@github.com:tehplayground/common.git common >>build.log 2>&1
fi
cd ..

echo "Building tehplayground/$1 ..."
echo "This will take a LONG time, go grab a cuppa ..."
sudo docker $DOCKER_HOST build -t tehplayground/$1 $1 >>build.log 2>&1

echo "Build completed successfully!"
echo "Testing tehplayground/$1 container ..."

NEWVER=$(echo "<?php echo phpversion();" | sudo docker $DOCKER_HOST run -i tehplayground/$1)
if [ "$1" != "$NEWVER" ]; then
	echo "New container returned \"${NEWVER}\" when queried via phpversion() - please verify!"
	exit -1
fi

echo "Container returned version number $NEWVER, which matches requested $1"
echo "Yay!"

PUSHCMD="sudo docker $DOCKER_HOST push tehplayground/$1"
read -p "Would you like to push this to Docker Hub? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo
	echo "Okay, feel free to push to Docker Hub when you're ready with the following command:"
	echo "\$ ${PUSHCMD}"
	exit
fi

echo
echo "Pushing now"
echo "Depending on your internet speed, this could take a really long time, go grab another cuppa ... "

$PUSHCMD >>build.log 2>&1

echo
echo "All done! Don't forget to push these changes into git!"
rm -f .lock
