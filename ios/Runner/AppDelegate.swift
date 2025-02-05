// import Flutter
// import UIKit
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "com.litmaclimited.passwordmanager/csv"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    setupMethodChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupMethodChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
    methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "saveCSV":
        self?.handleSaveCSV(call: call, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

 private func handleSaveCSV(call: FlutterMethodCall, result: @escaping FlutterResult) {
     guard let args = call.arguments as? [String: Any],
           let data = args["data"] as? String else {
         print("Failed to extract CSV data from arguments: \(call.arguments ?? "nil")")
         result(FlutterError(code: "INVALID_ARGUMENT", message: "No data provided", details: nil))
         return
     }

     let filePath = saveCSVToFile(csvData: data)
     if let path = filePath {
         result(path)
     } else {
         result(FlutterError(code: "SAVE_FAILED", message: "Failed to save CSV file", details: nil))
     }
 }


  private func saveCSVToFile(csvData: String) -> String? {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }

    let fileURL = documentsDirectory.appendingPathComponent("data.csv")

    do {
      try csvData.write(to: fileURL, atomically: true, encoding: .utf8)
      return fileURL.path
    } catch {
      print("Error writing file: \(error)")
      return nil
    }
  }
}
