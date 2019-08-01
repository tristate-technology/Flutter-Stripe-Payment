import UIKit
import Flutter
import Stripe

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
typealias tokenCompletion = (_ token:String?,_ error:Error?)-> Void
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    STPPaymentConfiguration.shared().publishableKey = "----PUBLISHABLE-KEY-----" // // PUT Your publishableKey
    if let controller = window.rootViewController as? FlutterViewController{
         let stripeChannel = FlutterMethodChannel(name: "samples.flutter.dev/StripeToken", binaryMessenger: controller)
        stripeChannel.setMethodCallHandler { (call, result) in
            print("Native method called")
            self.getTokenFromStripe(call.arguments as! [String : Any], withHandler: { (token, error) in
                result(token);
            })

        }
    }
   
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func getTokenFromStripe(_ dict: [String : Any], withHandler completionToken: @escaping tokenCompletion) {
        let cardParams = STPCardParams()
        if let cardNumber = dict["card Number"] as? String{
            cardParams.number = cardNumber
        }
        if let month = dict["Month"] as? String{
            cardParams.expMonth = UInt(month) ?? 0
        }
        if let year = dict["year"] as? String{
            cardParams.expYear = UInt(year) ?? 0
        }
        if let cvc = dict["cvv"] as? String{
            cardParams.cvc = cvc
        }
        if let name = dict["Card HolderName"] as? String{
            cardParams.name = name
        }
        
        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            if token != nil {
                if let tokenId = token?.tokenId {
                    print("\(tokenId)")
                }
                
                // Present error to user...
                completionToken(token?.tokenId, error)
            } else {
                completionToken(token?.tokenId, error)
            }
            
        }
    } 
}
