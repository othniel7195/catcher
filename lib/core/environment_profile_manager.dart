//
//  environment_profile_manager.dart
//  catcher
//
//  Created by jimmy on 2021/12/17.
//

import 'dart:io';
import 'package:catcher/model/environment_profile.dart';
import 'package:flutter/foundation.dart';

class EnvironmentProfileManager {
  static EnvironmentProfile getApplicationProfile() {
    if (kReleaseMode) {
      return EnvironmentProfile.release;
    }
    if (kDebugMode) {
      return EnvironmentProfile.debug;
    }
    if (kProfileMode) {
      return EnvironmentProfile.profile;
    }

    return EnvironmentProfile.debug;
  }

  static bool isWeb() => kIsWeb;

  static bool isAndroid() => Platform.isAndroid;

  static bool isIos() => Platform.isIOS;
}