import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDaYFNrylg1Yt7F8Jl0p8QJZaXuumbPEDQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    Messaging.messaging().apnsToken = deviceToken
      print("Token: \(deviceToken)")
      //apns - apple push notification services
    super.application(application,
    didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
      
  }
}
