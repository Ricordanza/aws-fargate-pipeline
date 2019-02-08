#!/bin/sh
pushd `dirname $0`

# variable
source ./_variable.sh

echo "delete bucket"
aws s3 rm s3://$SYS_NAME --recursive

echo "delete code repository"
aws codecommit delete-repository --repository-name $SYS_NAME

echo "delete container repository"
aws ecr delete-repository --repository-name $SYS_NAME --force

echo "delete fargate service"
aws ecs update-service --cluster $SYS_NAME --service service --desired-count 0
aws ecs delete-service --cluster $SYS_NAME --service service

echo "delete deploy application"
aws deploy delete-application --application-name AppECS-$SYS_NAME-service

echo "delete target group 2"
T_G_ARN=$(aws elbv2 describe-target-groups --names cicd-s-dev-service-2 --query 'TargetGroups[].TargetGroupArn' --output text)
aws elbv2 delete-target-group --target-group-arn $T_G_ARN

echo "delete resource stack"
aws cloudformation delete-stack --stack-name $SYS_NAME-resource
echo "resource stack deleting ..."
aws cloudformation wait stack-delete-complete --stack-name $SYS_NAME-resource

sleep 1

echo "resource stack deleting ..."
aws cloudformation delete-stack --stack-name $SYS_NAME-resource
aws cloudformation wait stack-delete-complete --stack-name $SYS_NAME-resource

sleep 1

echo "delete vpc stack"
aws cloudformation delete-stack --stack-name $SYS_NAME-vpc
echo "vpc stack deleting ..."
aws cloudformation wait stack-delete-complete --stack-name $SYS_NAME-vpc

echo "remove finished !"

exit 0