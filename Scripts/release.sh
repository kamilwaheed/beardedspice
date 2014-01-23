#!/bin/bash

set -e

# make sure we are in the correct dir when we double-click a .command file
dir=${0%/*}
if [ -d "$dir" ]; then
  cd "$dir"
fi

PRIVATE_KEY_PATH=${HOME}/.ssh/bs-private.pem

# set up your app name, version number, and background image file name
APP_NAME="BeardedSpice"

# you should not need to change these
APP_EXE="${APP_NAME}.app/Contents/MacOS/${APP_NAME}"

pushd ../ > /dev/null
CWD=`pwd`

INFO_PLIST="${CWD}/BeardedSpice/BeardedSpice-Info.plist"
VERSION=$(defaults read $INFO_PLIST CFBundleShortVersionString)

RESOURCE_DIR="${CWD}/BeardedSpice"
BUILD_DIR="${CWD}/build/Release"
STAGING_DIR="${CWD}/build/packaged"      # we copy all our stuff into this dir

echo 'Cleaning.'
# clear out any old data
rm -rf "${STAGING_DIR}"

echo 'Building.'
# build the project
xcodebuild

echo 'Copying to staging directory.'
# copy over the stuff we want in the final disk image to our staging dir
mkdir -p "${STAGING_DIR}"
cp -rpf "${BUILD_DIR}/${APP_NAME}.app" "${STAGING_DIR}"

pushd "${STAGING_DIR}" > /dev/null

# strip the executable
echo "Stripping ${APP_EXE}."
strip -u -r "${APP_EXE}"

# compress the executable if we have upx in PATH
#  UPX: http://upx.sourceforge.net/
if hash upx 2>/dev/null; then
   echo "Compressing (UPX) ${APP_EXE}."
   upx -9 "${APP_EXE}"
fi

# . perform any other stripping/compressing of libs and executables
ZIP_NAME=${APP_NAME}-${VERSION}.zip
zip -r ${ZIP_NAME} ${APP_NAME}.app

echo "Signing zip file."
echo "*** Signature ***"
echo "(Copying to clipboard)"
SIG=`openssl dgst -sha1 -binary < "${ZIP_NAME}" | openssl dgst -dss1 -sign "${PRIVATE_KEY_PATH}" | openssl enc -base64`
echo $SIG
echo $SIG | pbcopy

echo "*** File size ***"
echo $(stat -c %s ${ZIP_NAME})

cp ${ZIP_NAME} ${CWD}
popd > /dev/null # STAGING_DIR

popd > /dev/null # ROOT_DIR
echo 'Done.'
