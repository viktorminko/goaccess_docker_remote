#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Loading configuration environment variables"
source <(sed -E -n 's/[^#]+/export &/ p' $DIR/deployment.env)

echo "Creating deployment package"
mkdir -p $DIR/package
cp $DIR/../id_rsa $DIR/package
cp $DIR/../goaccess.sh $DIR/package
cp $DIR/../log_follower.sh $DIR/package
cp $DIR/../goaccess.conf $DIR/package

tar -C $DIR/package/ -czvf package.tar.gz ./

echo "Deleting package folder"
rm -rf $DIR/package

echo "Setting up docker-machine environment"
eval $(docker-machine env $DOCKER_MACHINE_NAME)

echo "Stopping application containers"
docker-compose stop

echo "Creating application directories on remote machine"
docker-machine ssh $DOCKER_MACHINE_NAME mkdir -p $DEPLOYED_PATH
docker-machine ssh $DOCKER_MACHINE_NAME mkdir -p $DEPLOYED_PATH/log
docker-machine ssh $DOCKER_MACHINE_NAME mkdir -p $DEPLOYED_PATH/report

echo "Copying package archive to droplet"
docker-machine scp -r $DIR/package.tar.gz $DOCKER_MACHINE_NAME:$DEPLOYED_PATH

echo "Extracting package archive"
docker-machine ssh $DOCKER_MACHINE_NAME tar -xf $DEPLOYED_PATH/package.tar.gz -C $DEPLOYED_PATH

echo "Deleting package archive on the server"
docker-machine ssh $DOCKER_MACHINE_NAME rm -f $DEPLOYED_PATH/package.tar.gz

echo "Deleting package archive on localhost"
rm -f $DIR/package.tar.gz

echo "Building application containers"
docker-compose build

echo "Running application containers"
docker-compose up -d


