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

sleep 1

echo "create resource"
aws cloudformation create-stack \
    --stack-name $SYS_NAME-resource \
    --template-body file://resource.yml \
    --parameters \
        ParameterKey=Stage,ParameterValue=$STAGE \
        ParameterKey=AppName,ParameterValue=$NAME \
        ParameterKey=BranchName,ParameterValue=$BRANCH \
    --capabilities 'CAPABILITY_NAMED_IAM'

echo "create resource operating ..."
aws cloudformation wait stack-create-complete --stack-name $SYS_NAME-resource

echo "generate config"
sh ./_config_gen.sh

echo "finished !"

popd

exit 0