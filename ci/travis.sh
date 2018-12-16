#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Running master.sh"
    ./ci/master.sh
else
    echo "Running pull_request.sh"
    ./ci/pull_request.sh
fi
