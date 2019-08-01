package com.stripe_demo

import android.media.session.MediaSession
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import java.lang.Exception
import com.stripe.android.Stripe
import com.stripe.android.TokenCallback
import com.stripe.android.model.Card
import com.stripe.android.model.Token
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

  private val GET_ACCESS_TOKEN = "samples.flutter.dev/StripeToken";
//  private val SET_ACCESS_TOKEN = "samples.flutter.dev/StripeToken";

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    /*Card card = Card.create("4242424242424242", 12, 2020, "123");
    if (!card.validateCard()) {

    }*/
    MethodChannel(flutterView, GET_ACCESS_TOKEN).setMethodCallHandler(object : MethodChannel.MethodCallHandler {
      override fun onMethodCall(p0: MethodCall, p1: MethodChannel.Result) {
        getStripeToken(p0.arguments as HashMap<String, String>,p1)
      }
    })
  }

  public fun getStripeToken(hashMap: HashMap<String,String>, resultMethod: MethodChannel.Result) {
    val card = Card.create(hashMap.get("card Number"), hashMap.get("Month")?.toInt(), hashMap.get("year")?.toInt(), hashMap.get("cvv"))
    if(card.validateCVC()) {
      val stripe = Stripe(this,"----PUBLISHABLE-KEY-----") // PUT Your publishableKey

      stripe.createToken(card, object : TokenCallback {
        override fun onSuccess(result: Token) {
          resultMethod.success(result.id)
//          MethodChannel(flutterView,GET_ACCESS_TOKEN).invokeMethod("setStripeToken", result.id);
        }

        override fun onError(e: Exception) {
          resultMethod.error(e.message,e.localizedMessage, null)
        }
      })
    }
  }
}