import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

getVideo(avail, String thumbnail) async {
  if (avail.isPresent!) {
    return BetterPlayer.file(Uri.encodeFull(avail.source.toString()),
        betterPlayerConfiguration: BetterPlayerConfiguration(
            autoDetectFullscreenDeviceOrientation: true,
            autoPlay: true,
            placeholder: Image.file(File(thumbnail)),
            placeholderOnTop: true,
            aspectRatio: 9 / 16,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              loadingWidget: SpinKitFadingCircle(
                color: Colors.white,
              ),
              enablePlayPause: false,
              enableFullscreen: false,
              enableOverflowMenu: false,
              forwardSkipTimeInMilliseconds: 2000,
              backwardSkipTimeInMilliseconds: 2000,
            )));
  } else {
    return BetterPlayer.network(
      avail.source.toString(),
      betterPlayerConfiguration: BetterPlayerConfiguration(
          autoDetectFullscreenDeviceOrientation: true,
          autoPlay: true,
          aspectRatio: 9 / 16,
          placeholder: Image.file(File(thumbnail)),
          placeholderOnTop: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            loadingWidget: SpinKitFadingCircle(
              color: Colors.white,
            ),
            enablePlayPause: false,
            enableFullscreen: false,
            enableOverflowMenu: false,
            forwardSkipTimeInMilliseconds: 2000,
            backwardSkipTimeInMilliseconds: 2000,
          )),
    );
  }
}
