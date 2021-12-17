//
//  report_handler.dart
//  catcher
//
//  Created by jimmy on 2021/12/16.
//

import 'package:catcher/core/catcher_logger.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/cupertino.dart';

abstract class ReportHandler {

  late CatcherLogger logger;

  Future<bool> handle(Report report, BuildContext? context);

  List<PlatformType> getSupportedPlatforms();
}