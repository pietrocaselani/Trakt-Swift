#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Running pull_request.sh"
    return ./ci/pull_request.sh
elif [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Running master.sh"
    return ./ci/master.sh
fi