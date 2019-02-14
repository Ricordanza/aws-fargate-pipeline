# variable
export STAGE="dev"
#export NAME="cicd-f"
export NAME="ao-test"
export BRANCH="master"
export AWS_DEFAULT_REGION="ap-northeast-1"
export AQUA_TOKEN="Mzg4ZTRkMGI1NTQ3"
export USE_PROFILE=""

# Optional if VPC linked created
export USE_PROFILE=""
export VPC="vpc-614c4805"
export PUB_SUB_1="subnet-73fe6128"
export PUB_SUB_2="subnet-8fae72c6"
export VPC_CIDER="172.31.0.0/16"

# No editable
if [ -n "$USE_PROFILE" ]; then
    export AWS_DEFAULT_PROFILE=$3
fi
export SYS_NAME=$NAME-$STAGE
