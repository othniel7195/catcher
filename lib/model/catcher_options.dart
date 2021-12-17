//
//  catcher_options.dart
//  catcher
//
//  Created by jimmy on 2021/12/17.
//

import 'package:catcher/core/catcher_logger.dart';
import 'package:catcher/handler/console_handler.dart';
import 'package:catcher/handler/default_report_action.dart';
import 'package:catcher/handler/report_handler.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_type.dart';

class CatcherOptions {
  final List<ReportHandler> handlers;
  final int handlerTimeout;
  final ReportType reportType;
  final Map<String, ReportType> explicitExceptionReportTypesMap;
  final Map<String, ReportHandler> explicitExceptionHandlersMap;
  final bool handleSilentError;
  final bool Function(Report report)? filterFunction;
  final int reportOccurrenceTimeout;
  final CatcherLogger? logger;
  CatcherOptions(
      this.reportType,
      this.handlers, {
        this.handlerTimeout = 5000,
        this.explicitExceptionReportTypesMap = const {},
        this.explicitExceptionHandlersMap = const {},
        this.handleSilentError = true,
        this.filterFunction,
        this.reportOccurrenceTimeout = 3000,
        this.logger,
      });

  CatcherOptions.getDefaultReleaseOptions()
      : handlers = [ConsoleHandler()],
        reportType = DefaultReportAction(),
        handlerTimeout = 5000,
        explicitExceptionReportTypesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        filterFunction = null,
        reportOccurrenceTimeout = 3000,
        logger = CatcherLogger();

  CatcherOptions.getDefaultDebugOptions()
      : handlers = [ConsoleHandler()],
        reportType = DefaultReportAction(),
        handlerTimeout = 10000,
        explicitExceptionReportTypesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        filterFunction = null,
        reportOccurrenceTimeout = 3000,
        logger = CatcherLogger();

  CatcherOptions.getDefaultProfileOptions()
      : handlers = [ConsoleHandler()],
        reportType = DefaultReportAction(),
        handlerTimeout = 10000,
        explicitExceptionReportTypesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        filterFunction = null,
        reportOccurrenceTimeout = 3000,
        logger = CatcherLogger();
}