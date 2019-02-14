#!/bin/sh
pushd `dirname $0`

# variable
source ./_variable.sh

echo "create vpc"
aws cloudformation create-stack \
    --stack-name $SYS_NAME-vpc \
    --template-body file://vpc.yml \
    --parameters \
        ParameterKey=Stage,ParameterValue=$STAGE \
        ParameterKey=AppName,ParameterValue=$NAME \

echo "create vpc operating ..."
aws cloudformation wait stack-create-complete --stack-name $SYS_NAME-vpc

echo "create vpc finished !"

popd

exit 0