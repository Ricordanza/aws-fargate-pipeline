# variable
export STAGE="dev"
export NAME="cicd-f"
export BRANCH="master"
export AWS_DEFAULT_REGION="ap-northeast-1"
export AQUA_TOKEN=""
export USE_PROFILE=""

# Optional if VPC linked created
export USE_PROFILE=""
export VPC=""
export PUB_SUB_1=""
export PUB_SUB_2=""
export VPC_CIDER=""

# No editable
if [ -n "$USE_PROFILE" ]; then
    export AWS_DEFAULT_PROFILE=$USE_PROFILE
fi
export SYS_NAME=$NAME-$STAGE
