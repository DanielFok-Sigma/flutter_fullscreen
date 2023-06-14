

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum FullScreenMode { EMERSIVE, EMERSIVE_STICKY, LEANBACK }


class FlutterFullscreen {
  static const MethodChannel _channel = MethodChannel('fullscreen');

  /// To enable fullscreen mode, pass the fullscreen mode as an argument the the enterFullScreen method of the FullScreen class.
  static Future<void> enterFullScreen(FullScreenMode fullScreenMode) async {
    if (Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else if (Platform.isAndroid) {
      try {
        if (fullScreenMode == FullScreenMode.EMERSIVE) {
          await _channel.invokeMethod('emersive');
        } else if (fullScreenMode == FullScreenMode.EMERSIVE_STICKY) {
          await _channel.invokeMethod('emersiveSticky');
        } else if (fullScreenMode == FullScreenMode.LEANBACK) {
          await _channel.invokeMethod('leanBack');
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  /// to get the current status of the SystemUI
  static Future<bool?> get isFullScreen async {
    bool? status;
    try {
      status = await _channel.invokeMethod("status");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return status;
  }

  /// Exit full screen
  static Future<void> exitFullScreen() async {
    if (Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    } else if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('exitFullScreen');
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}
