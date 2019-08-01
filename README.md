![alt text](https://github.com/HemantDixit10/Flutter-Stripe-Payment/blob/master/flutter_logo.jpeg)
# Flutter-Stripe-Payment

[![Licence Status](https://github.com/HemantDixit10/TagListView/blob/master/TagListView/TagListView/Images/licence.svg)](https://opensource.org/licenses/MIT)

Stripe payment token generate from Flutter. Stripe official flutter SDK is not available. We have to implement it using native bridge. In this demo we have created native iOS (Swift) and Android(Kotlin) bridge for getting stripe token. We have used IOS and Android Stripe SDK for generate payment token. This token can be use for future payment so you can easily do payment from server side using charge method.

# IOS:
Please update your publishable key in AppDelegate.swift

``` STPPaymentConfiguration.shared().publishableKey = "----PUBLISHABLE-KEY-----" ```

# Android:
Please update your publishable key in MainActivity

``` val stripe = Stripe(this,"----PUBLISHABLE-KEY-----") ```



# License
Flutter-Stripe-Payment is available under the MIT license. See the LICENSE file for more info.
