package com.jimmy.catcher

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

/** CatcherPlugin */
class CatcherPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : BasicMessageChannel<String>

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = BasicMessageChannel(flutterPluginBinding.binaryMessenger, "catcher", StringCodec.INSTANCE)
    channel.setMessageHandler { message, _ ->
      if (message != null) {
        android.util.Log.e("CATCHER", message)
      }
    }
  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMessageHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
  }
}

