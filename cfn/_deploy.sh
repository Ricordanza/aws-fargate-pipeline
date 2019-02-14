#!/bin/sh
pushd `dirname $0`

# variable
source ./_variable.sh

echo "create resource"
aws cloudformation create-stack \
    --stack-name $SYS_NAME-resource \
    --template-body file://resource.yml \
    --parameters \
        ParameterKey=Stage,ParameterValue=$STAGE \
        ParameterKey=AppName,ParameterValue=$NAME \
        ParameterKey=BranchName,ParameterValue=$BRANCH \
        ParameterKey=AquaMicroScannerToken,ParameterValue=$AQUA_TOKEN \
        ParameterKey=Vpc,ParameterValue=$VPC \
        ParameterKey=PublicSubnet1,ParameterValue=$PUB_SUB_1 \
        ParameterKey=PublicSubnet2,ParameterValue=$PUB_SUB_2 \
        ParameterKey=VpcCider,ParameterValue=$VPC_CIDER \
    --capabilities 'CAPABILITY_NAMED_IAM'

echo "create resource operating ..."
aws cloudformation wait stack-create-complete --stack-name $SYS_NAME-resource

echo "generate config"
sh ./_config_gen.sh

echo "finished !"

popd

exit 0