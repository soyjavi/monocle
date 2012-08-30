#!/bin/bash

#define paths
COMPILER=google-compiler/compiler.jar
SOURCES=../src/build/
NAMESPACE=monocle.
BUILDPATH=../release/
BUILDFILE=$NAMESPACE"js"

#script
clear
echo -e "\033[0m"============================ MONOCLE COMPILER ============================
## Files to compile
FILES_TO_COMPILE=""
FILES_TO_JOIN=""

#Main
DIR=$SOURCES$NAMESPACE
echo -e "\033[33m  [DIR]: "$SOURCES
FILES=(js model.js controller.js view.js mustache.js)
for file in "${FILES[@]}"
do
    FILES_TO_COMPILE=$FILES_TO_COMPILE" --js "$DIR$file
    FILES_TO_JOIN=$FILES_TO_JOIN" "$DIR$file
done

#UNCOMPRESED
cat $FILES_TO_JOIN > $BUILDPATH/monocle.debug.js
echo -e "\033[32m  [BUILD]: monocle.debug.js\033[0m"

#MINIFIED
java -jar $COMPILER $FILES_TO_COMPILE --js_output_file $BUILDPATH/$BUILDFILE
echo -e "\033[32m  [BUILD]: "$BUILDFILE"\033[0m"
echo ============================ /MONOCLE COMPILER ============================
