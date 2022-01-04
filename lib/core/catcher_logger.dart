//
//  catcher_logger.dart
//  catcher
//
//  Created by jimmy on 2021/12/16.
//

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../catcher.dart';

@immutable
class CatcherLogger {
  final Logger _logger = Logger("Catcher");

  void setup() {
    Logger.root.level = Level.SEVERE;
    Logger.root.onRecord.listen((rec) {
      var message =
          '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] ${rec.message}';
      // ignore: avoid_print
      print(
        message,
      );
      Catcher.catcherLog(message);
    });
  }

  void error(String message) {
    _logger.severe(message);
  }
}
