//
//  default_report_action.dart
//  catcher
//
//  Created by jimmy on 2021/12/17.
//

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_type.dart';
import 'package:flutter/cupertino.dart';

class DefaultReportAction extends ReportType {


  @override
  List<PlatformType> getSupportedPlatforms() => [
    PlatformType.iOS,
    PlatformType.android,
    PlatformType.web
  ];

  @override
  void requestAction(Report report, BuildContext? context) {
    super.onActionConfirmed(report);
  }
}