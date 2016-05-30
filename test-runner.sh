#!/bin/bash

################################################################################
# Ensure our environment variables are set
################################################################################
if [ "$IMAGE" == "" ]; then
  echo "You must define a \$IMAGE environment variable"
  exit 1
fi

################################################################################
# Kick off with some debug
################################################################################
echo ""
echo "Test Runner Configuration:"
echo ""
echo "Image: $IMAGE"

################################################################################
# Build our images
################################################################################
echo ""
echo "Building image.."
echo ""
cd $IMAGE && docker build -t $IMAGE . || exit 1
cd ..

################################################################################
# Running shellcheck
################################################################################
echo ""
echo "Checking shell scripts"
echo ""
shellcheck 7.0-cli/bin/* 7.0-fpm/bin/* nginx/bin/* || exit 1
