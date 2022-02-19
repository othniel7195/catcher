//
//  catcher.dart
//  catcher
//
//  Created by jimmy on 2021/12/17.
//

import 'dart:async';
import 'dart:isolate';

import 'package:catcher/handler/report_handler.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:catcher/model/environment_profile.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_action.dart';
import 'package:catcher/model/report_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'catcher_logger.dart';
import 'environment_profile_manager.dart';

class CatcherError with ReportAction {
  static late CatcherError _instance;
  final Widget? rootWidget;

  final void Function()? runAppFunction;

  CatcherOptions? releaseConfig;
  CatcherOptions? debugConfig;
  CatcherOptions? profileConfig;

  final bool enableLogger;
  final bool ensureInitialized;
  final Map<String, dynamic>? customParameters;

  late CatcherOptions _currentConfig;
  late CatcherLogger _logger;

  final List<Report> _cachedReports = [];
  final Map<DateTime, String> _reportsOcurrenceMap = {};

  CatcherError({
    this.rootWidget,
    this.runAppFunction,
    this.releaseConfig,
    this.debugConfig,
    this.profileConfig,
    this.enableLogger = true,
    this.ensureInitialized = false,
    this.customParameters,
  }) : assert(
          rootWidget != null || runAppFunction != null,
          "You need to provide rootWidget or runAppFunction",
        ) {
    _configure();
  }

  void _configure() {
    _instance = this;
    _setupCurrentConfig();
    _configureLogger();
    _setupErrorHooks();
    _setupReportActionInReportType();
  }

  void _setupCurrentConfig() {
    switch (EnvironmentProfileManager.getApplicationProfile()) {
      case EnvironmentProfile.release:
        {
          if (releaseConfig != null) {
            _currentConfig = releaseConfig!;
          } else {
            _currentConfig = CatcherOptions.getDefaultReleaseOptions();
          }
          break;
        }
      case EnvironmentProfile.debug:
        {
          if (debugConfig != null) {
            _currentConfig = debugConfig!;
          } else {
            _currentConfig = CatcherOptions.getDefaultDebugOptions();
          }
          break;
        }
      case EnvironmentProfile.profile:
        {
          if (profileConfig != null) {
            _currentConfig = profileConfig!;
          } else {
            _currentConfig = CatcherOptions.getDefaultProfileOptions();
          }
          break;
        }
    }
  }

  void updateConfig({
    CatcherOptions? debugConfig,
    CatcherOptions? profileConfig,
    CatcherOptions? releaseConfig,
  }) {
    if (debugConfig != null) {
      this.debugConfig = debugConfig;
    }
    if (profileConfig != null) {
      this.profileConfig = profileConfig;
    }
    if (releaseConfig != null) {
      this.releaseConfig = releaseConfig;
    }
    _setupCurrentConfig();
    _setupReportActionInReportType();
    _configureLogger();
  }

  void _setupReportActionInReportType() {
    _currentConfig.reportType.setReportAction(this);
    _currentConfig.explicitExceptionReportTypesMap.forEach(
      (error, reportType) {
        reportType.setReportAction(this);
      },
    );
  }

  Future _setupErrorHooks() async {
    FlutterError.onError = (FlutterErrorDetails details) async {
      _reportError(details.exception, details.stack, errorDetails: details);
    };

    if (!EnvironmentProfileManager.isWeb()) {
      Isolate.current.addErrorListener(
        RawReceivePort((dynamic pair) async {
          final isolateError = pair as List<dynamic>;
          _reportError(
            isolateError.first.toString(),
            isolateError.last.toString(),
          );
        }).sendPort,
      );
    }

    if (rootWidget != null) {
      _runZonedGuarded(() {
        runApp(rootWidget!);
      });
    } else if (runAppFunction != null) {
      _runZonedGuarded(() {
        runAppFunction!();
      });
    } else {
      throw ArgumentError("Provide rootWidget or runAppFunction to Catcher.");
    }
  }

  void _runZonedGuarded(void Function() callback) {
    runZonedGuarded<Future<void>>(() async {
      if (ensureInitialized) {
        WidgetsFlutterBinding.ensureInitialized();
      }
      callback();
    }, (dynamic error, StackTrace stackTrace) {
      _reportError(error, stackTrace);
    });
  }

  void _configureLogger() {
    if (_currentConfig.logger != null) {
      _logger = _currentConfig.logger!;
    } else {
      _logger = CatcherLogger();
    }
    if (enableLogger) {
      _logger.setup();
    }

    for (var handler in _currentConfig.handlers) {
      handler.logger = _logger;
    }
  }

  static void reportCheckedError(dynamic error, dynamic stackTrace) {
    dynamic errorValue = error;
    dynamic stackTraceValue = stackTrace;
    errorValue ??= "undefined error";
    stackTraceValue ??= StackTrace.current;
    _instance._reportError(error, stackTrace);
  }

  void _reportError(
    dynamic error,
    dynamic stackTrace, {
    FlutterErrorDetails? errorDetails,
  }) async {
    if (errorDetails?.silent == true &&
        _currentConfig.handleSilentError == false) {
      return;
    }

    _cleanPastReportsOccurences();

    final Report report = Report(error, stackTrace, DateTime.now(),
        errorDetails, _getPlatformType(), customParameters ?? {});

    if (_isReportInReportsOccurencesMap(report)) {
      return;
    }

    if (_currentConfig.filterFunction != null &&
        _currentConfig.filterFunction!(report) == false) {
      return;
    }
    _cachedReports.add(report);
    ReportType? reportType =
        _getReportTypeFromExplicitExceptionReportTypeMap(error);
    reportType ??= _currentConfig.reportType;
    if (!isReportModeSupportedInPlatform(report, reportType)) {
      return;
    }
    _addReportInReportsOccurencesMap(report);

    reportType.requestAction(report, null);
  }

  bool isReportModeSupportedInPlatform(Report report, ReportType reportType) {
    if (reportType.getSupportedPlatforms().isEmpty) {
      return false;
    }
    return reportType.getSupportedPlatforms().contains(report.platformType);
  }

  ReportType? _getReportTypeFromExplicitExceptionReportTypeMap(dynamic error) {
    final errorName = error != null ? error.toString().toLowerCase() : "";
    ReportType? reportType;
    _currentConfig.explicitExceptionReportTypesMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportType = value;
        return;
      }
    });
    return reportType;
  }

  ReportHandler? _getReportHandlerFromExplicitExceptionHandlerMap(
    dynamic error,
  ) {
    final errorName = error != null ? error.toString().toLowerCase() : "";
    ReportHandler? reportHandler;
    _currentConfig.explicitExceptionHandlersMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportHandler = value;
        return;
      }
    });
    return reportHandler;
  }

  @override
  void onActionConfirmed(Report report) {
    final ReportHandler? reportHandler =
        _getReportHandlerFromExplicitExceptionHandlerMap(report.error);
    if (reportHandler != null) {
      _handleReport(report, reportHandler);
      return;
    }

    for (final ReportHandler handler in _currentConfig.handlers) {
      _handleReport(report, handler);
    }
  }

  void _handleReport(Report report, ReportHandler reportHandler) {
    if (!isReportHandlerSupportedInPlatform(report, reportHandler)) {
      return;
    }

    reportHandler.handle(report, null).catchError((dynamic handlerError) {
      _logger.error(
        "Error occurred in ${reportHandler.toString()}: ${handlerError.toString()}",
      );
    }).then((result) {
      if (result) {
        _cachedReports.remove(report);
      }
    }).timeout(
      Duration(milliseconds: _currentConfig.handlerTimeout),
      onTimeout: () {
        _logger.error(
          "${reportHandler.toString()} failed to report error because of timeout",
        );
      },
    );
  }

  bool isReportHandlerSupportedInPlatform(
    Report report,
    ReportHandler reportHandler,
  ) {
    if (reportHandler.getSupportedPlatforms().isEmpty == true) {
      return false;
    }
    return reportHandler.getSupportedPlatforms().contains(report.platformType);
  }

  @override
  void onActionRejected(Report report) {
    for (var handler in _currentConfig.handlers) {
      _handleReport(report, handler);
    }
    _cachedReports.remove(report);
  }

  CatcherOptions? getCurrentConfig() {
    return _currentConfig;
  }

  PlatformType _getPlatformType() {
    if (EnvironmentProfileManager.isWeb()) {
      return PlatformType.web;
    }
    if (EnvironmentProfileManager.isAndroid()) {
      return PlatformType.android;
    }
    if (EnvironmentProfileManager.isIos()) {
      return PlatformType.iOS;
    }
    return PlatformType.unknown;
  }

  void _cleanPastReportsOccurences() {
    final int occurenceTimeout = _currentConfig.reportOccurrenceTimeout;
    final DateTime nowDateTime = DateTime.now();
    _reportsOcurrenceMap.removeWhere((key, value) {
      final DateTime occurenceWithTimeout =
          key.add(Duration(milliseconds: occurenceTimeout));
      return nowDateTime.isAfter(occurenceWithTimeout);
    });
  }

  bool _isReportInReportsOccurencesMap(Report report) {
    if (report.error != null) {
      return _reportsOcurrenceMap.containsValue(report.error.toString());
    } else {
      return false;
    }
  }

  void _addReportInReportsOccurencesMap(Report report) {
    if (report.error != null && _currentConfig.reportOccurrenceTimeout > 0) {
      _reportsOcurrenceMap[DateTime.now()] = report.error.toString();
    }
  }

  static CatcherError getInstance() {
    return _instance;
  }
}
