#!/bin/bash

if sed --version 2>/dev/null | grep -q GNU; then
	alias sedi='sed -i '
else
	alias sedi='sed -i "" '
fi

pushd `dirname $0`

# variable
source ./_variable.sh

# ファイル作成
cp -fp ../taskdef.template ../taskdef.json 

# アカウントID取得
AWS_ID=`aws sts get-caller-identity --query "Account" --output text`

# 置換
sedi -e "s!AWS_ID!$AWS_ID!g" ../taskdef.json
sedi -e "s!APPNAME!$NAME!g" ../taskdef.json
sedi -e "s!STAGE!$STAGE!g" ../taskdef.json

popd

exit 0