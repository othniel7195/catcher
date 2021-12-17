//
//  report_type.dart
//  catcher
//
//  Created by jimmy on 2021/12/17.
//

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_action.dart';
import 'package:flutter/cupertino.dart';

abstract class ReportType {
  late ReportAction _reportAction;

  void setReportAction(ReportAction reportAction) {
    _reportAction = reportAction;
  }

  void requestAction(Report report, BuildContext? context);

  void onActionConfirmed(Report report) {
    _reportAction.onActionConfirmed(report);
  }
  void onActionRejected(Report report) {
    _reportAction.onActionRejected(report);
  }


  List<PlatformType> getSupportedPlatforms();
}