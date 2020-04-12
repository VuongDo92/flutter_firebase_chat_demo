import UIKit
import Flutter

let flutterChannelName = "ph.com.channel.platform"

enum FlutterChannelMethod: String {

    // Get the device UUID, should be unique
    case getDeviceUUID = "GET_DEVICE_UUID"
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
      var channel: FlutterMethodChannel!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    controller.view.backgroundColor = UIColor.white
    channel = FlutterMethodChannel(
        name: flutterChannelName,
        binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler(methodCallHandler)
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func methodCallHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("Handling method \(call.method)")
        guard let method = FlutterChannelMethod(rawValue: call.method) else { return }
        switch (method) {
        
        case .getDeviceUUID:
            result(UIDevice.current.identifierForVendor?.uuidString ?? "")
            break
        
        default:
            break;
        }
    }

}
