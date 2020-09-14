#!/bin/bash

# Step 7: Download and build the APL Core Library
cd $HOME/alexa-kittai
git clone --single-branch --branch v1.3.3 git://github.com/alexa/apl-core-library.git 
cd $HOME/alexa-kittai/apl-core-library
mkdir build
cd build
cmake ..
make

# Step 8: Install Alexa Smart Screen SDK dependencies
cd $HOME/alexa-kittai/third-party
wget https://github.com/zaphoyd/websocketpp/archive/0.8.1.tar.gz -O websocketpp-0.8.1.tar.gz
tar -xvzf websocketpp-0.8.1.tar.gz
rm websocketpp-0.8.1.tar.gz

cd $HOME/alexa-kittai/third-party
sudo apt-get -y install libasio-dev --no-install-recommends 

cd $HOME/alexa-kittai/third-party
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs


# Step 9: Download and build the Alexa Smart Screen SDK
cd $HOME/alexa-kittai
git clone git://github.com/alexa/alexa-smart-screen-sdk.git

cp $HOME/Downloads/package-lock.json $HOME/alexa-kittai/alexa-smart-screen-sdk/modules/GUI/js/.

cp HOME/alexa-kittai/build/Integration/AlexaClientSDKConfig.json $HOME/alexa-kittai/BACKUP-AlexaClientSDKConfig.json

cd $HOME/alexa-kittai
mkdir ss-build
cd ss-build

cmake -DCMAKE_PREFIX_PATH=$HOME/alexa-kittai/sdk-install \
 -DKITTAI_KEY_WORD_DETECTOR=ON \
 -DKITTAI_KEY_WORD_DETECTOR_LIB_PATH=$THIRD_PARTY_PATH/snowboy/lib/kittai/libsnowboy-detect.a \
 -DKITTAI_KEY_WORD_DETECTOR_INCLUDE_DIR=$THIRD_PARTY_PATH/snowboy/include \
 -DWEBSOCKETPP_INCLUDE_DIR=$HOME/alexa-kittai/third-party/websocketpp-0.8.1 \
 -DDISABLE_WEBSOCKET_SSL=ON \
 -DGSTREAMER_MEDIA_PLAYER=ON \
 -DCMAKE_BUILD_TYPE=DEBUG \
 -DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=$HOME/alexa-kittai/third-party/portaudio/lib/.libs/libportaudio.a \
 -DPORTAUDIO_INCLUDE_DIR=$HOME/alexa-kittai/third-party/portaudio/include/ \
 -DAPL_CORE=ON \
 -DAPLCORE_INCLUDE_DIR=$HOME/alexa-kittai/apl-core-library/aplcore/include \
 -DAPLCORE_LIB_DIR=$HOME/alexa-kittai/apl-core-library/build/aplcore \
 -DYOGA_INCLUDE_DIR=$HOME/alexa-kittai/apl-core-library/build/yoga-prefix/src/yoga \
 -DYOGA_LIB_DIR=$HOME/alexa-kittai/apl-core-library/build/lib \
  ../alexa-smart-screen-sdk
  
make

cp $HOME/alexa-kittai/BACKUP-AlexaClientSDKConfig.json $HOME/alexa-kittai/build/Integration/AlexaClientSDKConfig.json

read -p "Test the Alexa Smart Screen SDK sample app [Y/n]: "
exit

# Step 10: Test the Alexa Smart Screen SDK sample app
cd $HOME/alexa-kittai/ss-build
PA_ALSA_PLUGHW=1 ./modules/Alexa/SampleApp/src/SampleApp -C \
$HOME/alexa-kittai/sdk-build/Integration/AlexaClientSDKConfig.json -C \
$HOME/alexa-kittai/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json -L INFO


python3 /home/pi/alexa-kittai/snowboy/voiceactivation.py



