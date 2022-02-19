/*
 * @Author: jimmy.zhao
 * @Date: 2021-12-16 16:31:23
 * @LastEditTime: 2022-02-18 19:12:13
 * @LastEditors: jimmy.zhao
 * @Description: 
 * 
 * 
 */
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
      Catcher.catcherLog(message);
    });
  }

  void error(String message) {
    _logger.severe(message);
  }
}
