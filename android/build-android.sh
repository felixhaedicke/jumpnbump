#!/bin/bash
SRC_SUBDIRS=". sdl"
TARGET_SDK_VERSION=19

ANDROID_SDK_DIR=$1
ANDROID_NDK_DIR=$2
SDL_SRC_DIR=$3
SDL_MIXER_SRC_DIR=$4
BUILD_CONFIGURATION=$5

if [ $# -lt 5 ]
then
  echo "Usage: ./build-android.sh <Android SDK directory> <Android NDK directory> <SDL source directory> <SDL mixer source directory> <debug|release>" >&2
  exit 1
fi

if [ "${BUILD_CONFIGURATION}" != "debug" ] && [ "${BUILD_CONFIGURATION}" != "release" ]
then
  echo "Invalid build configuration \"${BUILD_CONFIGURATION}\"!" >&2
  exit 1
fi

CURRENT_SCRIPT="`readlink -f $0`"
SRC_DIR="`dirname ${CURRENT_SCRIPT}`"/../

SDL_SRC_DIR="`readlink -f ${SDL_SRC_DIR}`"
SDL_MIXER_SRC_DIR="`readlink -f ${SDL_MIXER_SRC_DIR}`"

"${SRC_DIR}/generate_version_h.sh" || exit $?
"${SRC_DIR}/generate_jumpbump_dat.sh" || exit $?
"${SRC_DIR}/generate_jumpbump_dat_c.sh" || exit $?

SRC_LIST="${PWD}/jumpbump_dat.c "
for src_subdir in ${SRC_SUBDIRS}
do
  for src_file in ${SRC_DIR}/${src_subdir}/*.c
  do
    src_file=`realpath ${src_file}`
    SRC_LIST="${SRC_LIST} ${src_file}"
  done
done

if [ -e "android-project" ]
then
  echo "\"android-project\" exists already!" >&2
  exit 1
fi

cp -r "${SDL_SRC_DIR}/android-project" . || exit $?

"${ANDROID_SDK_DIR}/tools/android" update project --name jumpnbump --target android-${TARGET_SDK_VERSION} --path android-project || exit $?

mkdir -p android-project/src/org/jumpnbump || exit $?

cp "${SRC_DIR}/android"/* android-project/src/org/jumpnbump || exit $?

xmlstarlet ed -L -N android=http://schemas.android.com/apk/res/android -u //manifest/@android:versionCode -v `cat "${SRC_DIR}/VERSION_CODE"` android-project/AndroidManifest.xml || exit $?
xmlstarlet ed -L -N android=http://schemas.android.com/apk/res/android -u //manifest/@android:versionName -v `cat "${SRC_DIR}/VERSION"` android-project/AndroidManifest.xml || exit $?
xmlstarlet ed -L -N android=http://schemas.android.com/apk/res/android -u //manifest/@package -v org.jumpnbump android-project/AndroidManifest.xml || exit $?
xmlstarlet ed -L -N android=http://schemas.android.com/apk/res/android -u //uses-sdk/@android:targetSdkVersion -v ${TARGET_SDK_VERSION} android-project/AndroidManifest.xml || exit $?
xmlstarlet ed -L -N android=http://schemas.android.com/apk/res/android -u //activity/@android:name -v JNBActivity android-project/AndroidManifest.xml || exit $?
xmlstarlet ed -L -N android=http://schemas.android.com/apk/res/android -i //activity -t attr -n android:screenOrientation -v sensorLandscape android-project/AndroidManifest.xml || exit $?
xmlstarlet ed -L -u //string[\@name=\'app_name\'] -v "Jump\\'n\\'Bump" android-project/res/values/strings.xml || exit $?

for i in `find android-project/res -name ic_launcher.png`
do
  convert "${SRC_DIR}/icon.png" -resize `identify "$i" | awk '{print $3}'` "$i" || exit $?
done

ln -s "${SDL_SRC_DIR}" "android-project/jni/SDL" || exit $?
echo "APP_PLATFORM := android-10" >> "android-project/jni/Application.mk" || exit $?
sed -i "s|YourSourceHere.c|${SRC_LIST}|g" "android-project/jni/src/Android.mk" || exit $?
sed -i "s|LOCAL_C_INCLUDES :=|LOCAL_C_INCLUDES := ${PWD} ${SRC_DIR} ../SDL_mixer|g" "android-project/jni/src/Android.mk" || exit $?
sed -i "s|LOCAL_SHARED_LIBRARIES :=|LOCAL_SHARED_LIBRARIES := SDL2_mixer|g" "android-project/jni/src/Android.mk" || exit $?

ln -s "${SDL_MIXER_SRC_DIR}" "android-project/jni/SDL_mixer" || exit $?
sed -i "s/SUPPORT_MOD_MIKMOD := true/SUPPORT_MOD_MIKMOD := false/g" "android-project/jni/SDL_mixer/Android.mk" || exit $?
sed -i "s/SUPPORT_MP3_SMPEG := true/SUPPORT_MP3_SMPEG := false/g" "android-project/jni/SDL_mixer/Android.mk" || exit $?
sed -i "s/SUPPORT_OGG := true/SUPPORT_OGG := false/g" "android-project/jni/SDL_mixer/Android.mk" || exit $?

sed -i "s|//System.loadLibrary(\"SDL2_mixer\")|System.loadLibrary(\"SDL2_mixer\")|g;" "android-project/src/org/libsdl/app/SDLActivity.java" || exit $?

cd android-project || exit $?
NDK_BUILD_ARGS="-j4"
if [ "${BUILD_CONFIGURATION}" != "debug" ]
then
  NDK_BUILD_ARGS="${NDK_BUILD_ARGS} NDK_DEBUG=1"
fi
"${ANDROID_NDK_DIR}/ndk-build" ${NDK_BUILD_ARGS} || exit $?
ANDROID_HOME="${ANDROID_SDK_DIR}" ant ${BUILD_CONFIGURATION} || exit $?

