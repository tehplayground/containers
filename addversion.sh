#!/bin/bash
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

echo
echo "Creating $1 folder ..."
echo

mkdir $1
cd $1
cat > Dockerfile <<EOF
FROM php:$1
RUN ln -s /usr/local/bin/php /php

ADD common/run.sh /run.sh
ADD common/content /content
RUN useradd -d /render -m -s /bin/false -U render
USER render
WORKDIR /render
ENTRYPOINT ["/run.sh"]
EOF

git submodule add --force git@github.com:tehplayground/common.git common
cd ..

echo
echo "Building tehplayground/$1 ..."
echo
sudo docker $DOCKER_HOST build -t tehplayground/$1 $1

echo
echo "Testing tehplayground/$1 container ..."
echo

NEWVER=$(echo "<?php echo phpversion();" | sudo docker $DOCKER_HOST run -i tehplayground/$1)
if [ "$1" != "$NEWVER" ]; then
	echo "New container returned \"${NEWVER}\" when queried via phpversion() - please verify!"
	exit -1
fi

echo
echo "Done!"

PUSHCMD="sudo docker $DOCKER_HOST push tehplayground/$1"
read -p "Would you like to push this to Docker Hub? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Okay, feel free to push to Docker Hub when you're ready with the following command:"
	echo "\$ ${PUSHCMD}"
	exit
fi

echo
echo "Pushing now ..."
echo

$PUSHCMD

echo 
echo "All done! Don't forget to push these changes into git!"
