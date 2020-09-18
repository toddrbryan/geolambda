#!/bin/bash

# directory used for development
export DEPLOY_DIR=lambda

# Get Python version
PYVERSION=$(cat /root/.pyenv/version)
MAJOR=${PYVERSION%%.*}
MINOR=${PYVERSION#*.}
PYVER=${PYVERSION%%.*}.${MINOR%%.*}
PYPATH=/root/.pyenv/versions/$PYVERSION/lib/python${PYVER}/site-packages/
BINPATH=/root/.pyenv/versions/$PYVERSION/bin/

echo Creating deploy package for Python $PYVERSION

EXCLUDE="boto3* botocore* pip* docutils* *.pyc setuptools* wheel* coverage* testfixtures* mock* *.egg-info *.dist-info __pycache__ easy_install.py"
BINEXCLUDE="2to3* easy_install* f2py* idle* *.pyc *.egg-info *.dist-info __pycache__ easy_install.py"

EXCLUDES=()
for E in ${EXCLUDE}
do
    EXCLUDES+=("--exclude ${E} ")
done
BINEXCLUDES=()
for E in ${BINEXCLUDE}
do
    BINEXCLUDES+=("--exclude ${E} ")
done

rsync -ax $PYPATH/ $DEPLOY_DIR/ ${EXCLUDES[@]}
rsync -ax $BINPATH/ $DEPLOY_DIR/ ${BINEXCLUDES[@]}

# prepare dir for lambda layer deployment - https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html#configuration-layers-path
cp -r $DEPLOY_DIR ./python
rm ./python/lambda_function.py

# zip up deploy package
zip -ruq lambda-deploy.zip ./python

# cleanup
rm -rf ./python