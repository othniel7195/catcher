import Flutter
import UIKit

public class SwiftCatcherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterBasicMessageChannel(name: "catcher", binaryMessenger: registrar.messenger(), codec: FlutterStringCodec.sharedInstance())
    channel.setMessageHandler { message, _ in
        print(message)
    }
  }
}
