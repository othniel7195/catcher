/*
 * @Author: jimmy.zhao
 * @Date: 2021-12-16 15:06:04
 * @LastEditTime: 2022-02-18 17:44:01
 * @LastEditors: jimmy.zhao
 * @Description: 
 * 
 * 
 */
library catcher;

export 'package:catcher/core/catcher_error.dart';
export 'package:catcher/handler/console_handler.dart';
export 'package:catcher/core/catcher_logger.dart';
export 'package:catcher/handler/report_handler.dart';
export 'package:catcher/model/catcher_options.dart';
export 'package:catcher/model/report_type.dart';
export 'package:catcher/model/report_action.dart';
import 'package:flutter/services.dart';

class Catcher {
  static const BasicMessageChannel _channel =
      BasicMessageChannel("catcher", StringCodec());

  static catcherLog(String message) {
    _channel.send(message);
  }
}
