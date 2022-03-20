import 'dart:io';

import 'package:flutter/foundation.dart';

void setTargetPlatformForDesktop({TargetPlatform? platform}) {
  TargetPlatform? targetPlatform;
  if (platform != null) {
    targetPlatform = platform;
  }
  if (targetPlatform == null) {
    if (Platform.isMacOS) {
      targetPlatform = TargetPlatform.iOS;
    } else if (Platform.isLinux || Platform.isWindows) {
      targetPlatform = TargetPlatform.android;
    }
  }
  debugDefaultTargetPlatformOverride = targetPlatform;
}
