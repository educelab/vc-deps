#!/bin/bash

versionMajor=`cat CMakeLists.txt | grep -m 1 "project(vc-deps VERSION " | sed 's/.*VERSION \([0-9]*\).*/\1/'`
versionMinor=`cat CMakeLists.txt | grep -m 1 "project(vc-deps VERSION " | sed 's/.*VERSION [0-9]*\.\([0-9]*\).*/\1/'`
versionPatch=`cat CMakeLists.txt | grep -m 1 "project(vc-deps VERSION " | sed 's/.*VERSION [0-9]*\.[0-9]*.\([0-9]*\).*/\1/'`
commitHash=`git log -1 --format="%h"`
revisioncount=`git log $(git rev-list --tags --max-count=1)..${commitHash} --oneline | wc -l | tr -d ' '`

if [[ ${1} == "--short" ]]; then
    echo "${versionMajor}.${versionMinor}.${versionPatch}"
elif [[ ${1} == "--tweak" ]]; then
    echo "${commitHash}-$revisioncount"
else
    echo "${versionMajor}.${versionMinor}.${versionPatch}.${commitHash}-$revisioncount"
fi
