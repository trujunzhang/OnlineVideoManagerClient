#!/bin/bash
#xcodebuild build -configuration Release -target OnlineVideoManager SYMROOT=build OBJROOT=build


xctool  \
  -workspace OnlineVideoManager.xcworkspace \
  -scheme OnlineVideoManager \
  build