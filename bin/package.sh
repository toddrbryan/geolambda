#!/bin/bash

# directory used for deployment
export DEPLOY_DIR=lambda

echo Creating deploy package

# make deployment directory and add lambda handler
mkdir -p $DEPLOY_DIR/lib
mkdir -p $DEPLOY_DIR/bin

# copy libs
cp -P ${PREFIX}/lib/*.so* $DEPLOY_DIR/lib/
cp -P ${PREFIX}/lib64/libjpeg*.so* $DEPLOY_DIR/lib/

# copy binaries
cp -P ${PREFIX}/bin/gdal* $DEPLOY_DIR/bin/
#cp -P ${PREFIX}/bin/ogr* $DEPLOY_DIR/bin/

strip $DEPLOY_DIR/lib/* || true
strip $DEPLOY_DIR/bin/* || true

# copy GDAL_DATA files over
mkdir -p $DEPLOY_DIR/share
rsync -ax $PREFIX/share/gdal $DEPLOY_DIR/share/
rsync -ax $PREFIX/share/proj $DEPLOY_DIR/share/

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../lambda-deploy.zip ./
