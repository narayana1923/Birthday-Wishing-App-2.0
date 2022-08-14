import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

videoPreview(String video, String thumbnailer) async {
  try {
    File f = File(video);
    if (!await f.exists())
      throw Exception;
    else {
      return BetterPlayer.file(
        video,
        betterPlayerConfiguration: BetterPlayerConfiguration(
            autoDetectFullscreenDeviceOrientation: true,
            autoPlay: true,
            placeholder: Image.file(File(thumbnailer)),
            placeholderOnTop: true,
            aspectRatio: 9 / 16,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              loadingWidget: SpinKitFadingCircle(
                color: Colors.white,
              ),
              showControls: false,
            )),
      );
    }
  } catch (e) {
    return BetterPlayer.network(
      video,
      betterPlayerConfiguration: BetterPlayerConfiguration(
          autoDetectFullscreenDeviceOrientation: true,
          autoPlay: true,
          placeholder: Image.file(File(thumbnailer)),
          aspectRatio: 9 / 16,
          placeholderOnTop: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            loadingWidget: SpinKitFadingCircle(
              color: Colors.white,
            ),
            showControls: false,
          )),
    );
  }
}
