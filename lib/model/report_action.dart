//
//  report_action.dart
//  catcher
//
//  Created by jimmy on 2021/12/17.
//

import 'package:catcher/model/report.dart';

abstract class ReportAction {
  void onActionConfirmed(Report report);
  void onActionRejected(Report report);
}