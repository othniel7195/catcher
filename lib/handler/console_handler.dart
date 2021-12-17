//
//  console_handler.dart
//  catcher
//
//  Created by jimmy on 2021/12/16.
//

import 'package:catcher/core/catcher_logger.dart';
import 'package:catcher/handler/report_handler.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/cupertino.dart';

class ConsoleHandler extends ReportHandler {

  @override
  List<PlatformType> getSupportedPlatforms() {
    return [
      PlatformType.iOS,
      PlatformType.android,
      PlatformType.web
    ];
  }

  @override
  Future<bool> handle(Report report, BuildContext? context) {
    logger.error("================= CATCHER LOG ==================");
    logger.error("Crash occurred on ${report.dateTime}");
    logger.error("");
    logger.error("---------- ERROR ----------");
    logger.error("${report.error}");
    logger.error("");
    logger.error("------- STACK TRACE -------");
    for (final entry in report.stackTrace.toString().split("\n")) {
      logger.error(entry);
    }
    logger.error("------- CUSTOM INFO -------");
    for (final entry in report.customParameters.entries) {
      logger.error("${entry.key}: ${entry.value}");
    }
    logger.error("================================================");

    return Future.value(true);
  }

}