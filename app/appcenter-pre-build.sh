#!/usr/bin/env bash

# check build branch is master then print alert text
if [ "$APPCENTER_BRANCH" != "master" ];
then

echo "#### \$(PRODUCT_NAME) pre build start ####"
fi