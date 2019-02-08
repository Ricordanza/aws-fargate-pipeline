# variable
export STAGE="dev"
export NAME="cicd-s"
export SYS_NAME=$NAME-$STAGE
export BRANCH="master"
export AWS_DEFAULT_REGION="ap-northeast-1"
export USE_PROFILE=""
if [ -n "$USE_PROFILE" ]; then
    export AWS_DEFAULT_PROFILE=$3
fi
