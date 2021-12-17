//
//  report.dart
//  catcher
//
//  Created by jimmy on 2021/12/16.
//

import 'package:catcher/model/platform_type.dart';
import 'package:flutter/foundation.dart';

@immutable
class Report {
  final dynamic error;
  final dynamic stackTrace;
  final DateTime dateTime;
  final FlutterErrorDetails? errorDetails;
  final PlatformType platformType;
  final Map<String, dynamic> customParameters;

  const Report(
      this.error,
      this.stackTrace,
      this.dateTime,
      this.errorDetails,
      this.platformType,
      this.customParameters
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      "error": error.toString(),
      "dateTime": dateTime.toIso8601String(),
      "platformType": describeEnum(platformType),
      "customParameters": customParameters,
      "stackTrace": stackTrace.toString(),

    };
    return json;
  }
}