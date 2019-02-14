#!/bin/sh
pushd `dirname $0`

# variable
source ./_variable.sh

# create vpc
sh ./_deploy_vpc.sh

# create vpc
sh ./_deploy.sh

echo "finished !"

popd

exit 0