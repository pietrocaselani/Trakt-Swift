#!/bin/bash

brew install sonar-scanner
brew install tailor
sudo pip install lizard
bundle install --path vendor/bundle
cd Example && bundle exec pod install
