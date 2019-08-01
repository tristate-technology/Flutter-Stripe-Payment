import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String cardNumber;
String cardHolderName;
String month;
String year;
String cvv;
CardType cardtype;

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
  dinnerClub
}

class CreditCardWidget extends StatefulWidget {
  @override
  _CreditCardWidget createState() => _CreditCardWidget();
}

class _CreditCardWidget extends State<CreditCardWidget> {

  static const platform = const MethodChannel('samples.flutter.dev/StripeToken');
  /*var cardNumberController = TextEditingController();
  var cardNameController = TextEditingController();
  var expiryController = TextEditingController();
  var cvvController = TextEditingController();*/
  FocusNode cardNumberFocus, cardNameFocus, expiryFocus, cvvFocus;

  @override
  void initState() {
    super.initState();
    cardNumber = cardNumber ?? "XXXX XXXX XXXX XXXX";
    cardHolderName = cardHolderName ?? "XXX";
    month = month ?? "XX";
    year = year ?? "XXXX";
    cvv = cvv ?? "XXX";
    cardNumberFocus = FocusNode();
    cardNameFocus = FocusNode();
    expiryFocus = FocusNode();
    cvvFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Add Credit Card",
              style: TextStyle(
                  fontFamily: "ExtraBoldFont",
                  fontSize: 20.0,
                  color: Colors.white),
            ),
          ),
          body: SafeArea(
            child:SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: cardDesign(context)),
                Card(
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            style: TextStyle(
                                fontFamily: "SemiBoldFont", fontSize: 15.0),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            maxLength: 19,
                            autovalidate: true,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              MaskedTextInputFormatter(
                                mask: 'xxxx-xxxx-xxxx-xxxx',
                                separator: '-',
                              ),
                            ],
                            validator: (value) {
                              String displayValue =
                                  value.replaceAll(RegExp('-'), '');

                              Future.delayed(
                                  Duration.zero,
                                  () => setState(() {
                                        cardtype = detectCardType(displayValue);
                                        String valueCheck =
                                            value.replaceAll(RegExp('-'), ' ');
                                        cardNumber = valueCheck;
                                      }));

                             // print(displayValue);
                              if (displayValue.length > 0) {
                                if (!isNumeric(displayValue)) {
                                  return "Card number must be in digit";
                                }else if (displayValue.length < 16){
                                  return "Enter valid card number";
                                }
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Card Number',
                              counter: new SizedBox(
                                height: 0.0,
                              ),
                            ),
                            onFieldSubmitted: (String val) {
                              Navigator.of(context).focusScopeNode.requestFocus(cardNameFocus);
                            },
                            focusNode: cardNumberFocus,
                          )),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            autovalidate: true,
                            style: TextStyle(
                                fontFamily: "SemiBoldFont", fontSize: 15.0),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              Future.delayed(
                                  Duration.zero,
                                  () => setState(() {
                                        cardHolderName = value;
                                      }));
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Card Holder Name',
                              counter: new SizedBox(
                                height: 0.0,
                              ),
                            ),
                            onFieldSubmitted: (String val) {
                              Navigator.of(context).focusScopeNode.requestFocus(expiryFocus);
                            },
                            focusNode: cardNameFocus,
                          )),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: "SemiBoldFont",
                                        fontSize: 15.0),
                                    maxLength: 7,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      MaskedTextInputFormatter(
                                        mask: 'MM/YYYY',
                                        separator: '/',
                                      ),
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    autovalidate: true,
                                    validator: validateMonthAndYear,
                                    decoration: InputDecoration(
                                      labelText: 'Expiry (MM/YYYY)',
                                      counter: new SizedBox(
                                        height: 0.0,
                                      ),
                                    ),
                                    onFieldSubmitted: (String val) {
                                      Navigator.of(context).focusScopeNode.requestFocus(cvvFocus);
                                    },
                                    focusNode: expiryFocus,
                                  ))),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: "SemiBoldFont",
                                        fontSize: 15.0),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: 'CVV',
                                        counter: new SizedBox(
                                          height: 0.0,
                                        )),
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    autovalidate: true,
                                    validator: (value) {
                                      Future.delayed(
                                          Duration.zero,
                                              () => setState(() {
                                            cvv = value;
                                          }));
                                      if (value.length > 0) {
                                        if (!isNumeric(value)) {
                                          return "CVV must be in digit";
                                        }
                                      }
                                      return null;
                                    },
                                    focusNode: cvvFocus,
                                  ))),
                        ],
                      ),

                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.all(15),
                    //color: Colors.cyan,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                        borderRadius: BorderRadius.all(Radius.circular(10.0),)
                    ),
                    child:FlatButton(onPressed: (){
                      String cardValue =
                      cardNumber.replaceAll(RegExp('-'), '');
                      print(validateMonthAndYear == null);
                      var strMonthAndYear = validateMonthAndYear('$month/$year');
                      print (strMonthAndYear);

                      if ((!isNumeric(cardValue)) && (cardValue.length >= 16) && (strMonthAndYear == null) && (cvv.length > 2) ){
                           _getstripeToken();
                       }else {
                        return null;
                      }
                      },
                      disabledColor: Colors.white,

                      highlightColor: Colors.transparent,
                      color: Colors.transparent,
                      child: new Column(

                        mainAxisSize: MainAxisSize.min,

                        children: <Widget>[
                          new Text("Proceed to checkout",style: TextStyle(color: Colors.white,fontFamily: "SemiBoldFont", fontSize: 18.0))
                        ],
                      ),
                    )

                )
              ],
            ),
          )),
    );
  }

  // .... Validation for Month and Year TextInput ....
  String validateMonthAndYear(String value) {
    {
      //print('Updated $value');
      List<String> monthAndYear = value.split("/");
      // if (monthAndYear.length > 1){
      if (value.length > 0) {
        if (!isNumeric(monthAndYear[0])) {
          return "Month must be in digit";
        }
        int monthValue = int.parse(monthAndYear[0]);
        if (monthValue > 12) {
          return "Invalid Month";
        }
        if (monthAndYear.length > 1) {

          String value = monthAndYear[1];
          if (value.length > 0) {
            int yearValue = int.parse(monthAndYear[1]);
            Future.delayed(
                Duration.zero,
                    () => setState(() {
                  month = monthValue.toString();
                  year = yearValue.toString();
                }));
            var now = new DateTime.now();
            if (yearValue < now.year) {
              return "Invalid Year";
            }
           // print(yearValue);

          }
        }
      }
    }
    return null;
  }

  // .... Validation for Numeric value ....
  String validateNumericValue(String value) {
    if (!isNumeric(value)) {
      return "Card number must be in digit";
    }
    return null;
  }

  // ... Create a widget for Credit card UI ...
  Widget cardDesign(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      //padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(15.0),
      color: Colors.cyan,
      child: Container(
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10),
                      height: 60,
                      child: cardImage()),
                ],
                //color: Colors.black,
              ),
              Container(
                //color: Colors.black,
                width: MediaQuery.of(context).size.width,
                // height: 200,
                child: Center(
                  //padding: EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    //color: Colors.grey,
                    child: Text(
                      cardNumberString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.green,
                //margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Month/Year",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "SemiBoldFont",
                        fontSize: 15.0,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                // color: Colors.red,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    monthString() + "/" + yearString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              Container(
                // color: Colors.red,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "$cardHolderName",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  String _stripeToken = 'Unknown battery level.';
  Future<void> _getstripeToken() async {

    String cardNumberValue =
    cardNumber.replaceAll(RegExp(' '), '');
    var details = {'card Number':cardNumberValue,'Card HolderName':cardHolderName,'Month':month, 'year': year, 'cvv':cvv };
    String stripeToken;
    try {
      /*if(Platform.isAndroid) {
        platform.invokeMethod('getStripeToken', details);
      } else {*/
        final result = await platform.invokeMethod('getStripeToken', details);
        print(result);
        stripeToken = result;
//        showAccessToken(stripeToken);
        Alert(
          context: context,
          type: AlertType.success,
          title: "Stripe Token",
          desc: stripeToken,
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.cyan,
              radius: BorderRadius.circular(0.0),
            ),
          ],
        ).show();

      setState(() {
        _stripeToken = stripeToken;
      });
//      }
    } on PlatformException catch (e) {
      print('Failed to Generate Stripe token');
      //batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
  }

  showAccessToken(String stripeToken) {
//    stripeToken = result;
    Alert(
      context: context,
      type: AlertType.success,
      title: "Stripe Token",
      desc: stripeToken,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.cyan,
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  void setStripeToken(String accessToken) {
    showAccessToken(accessToken);
    setState(() {
      this._stripeToken = accessToken;
    });
  }

  String cardNumberString() {
    if (cardNumber.length > 0) {
      return cardNumber;
    } else {
      return "XXXX XXXX XXX XXXX XXXX";
    }
  }

  String monthString() {
    if (month.length > 0) {
      return month;
    } else {

      return "XX";
    }
  }

  String yearString() {
    if (year.length > 0) {
      return year;
    } else {
      return "XXXX";
    }
  }

  // .... Get cardImage based on CardType ....
  Widget cardImage() {
    if (cardtype == CardType.visa) {
      return Image.asset(
        "images/visa.png",
        fit: BoxFit.scaleDown,
      );
    } else if (cardtype == CardType.mastercard) {
      return Image.asset(
        "images/mastercard.png",
        fit: BoxFit.scaleDown,
      );
    } else if (cardtype == CardType.discover) {
      return Image.asset(
        "images/discover.png",
        fit: BoxFit.scaleDown,
      );
    } else if (cardtype == CardType.dinnerClub) {
      return Image.asset(
        "images/diners_club.png",
        fit: BoxFit.scaleDown,
      );
    } else if (cardtype == CardType.americanExpress) {
      return Image.asset(
        "images/amex.png",
        fit: BoxFit.scaleDown,
      );
    }
    return null;
  }

  //... CardNumber pattern Array....

  Map<CardType, Set<List<String>>> cardNumberPattern = {
    CardType.visa: {
      ['4'],
    },
    CardType.americanExpress: {
      ['34'],
      ['37'],
    },
    CardType.discover: {
      ['6011'],
      ['622126', '622925'],
      ['644', '649'],
      ['65']
    },
    CardType.mastercard: {
      ['51', '55'],
      ['2221', '2229'],
      ['223', '229'],
      ['23', '26'],
      ['270', '271'],
      ['2720'],
    },
    CardType.dinnerClub: {
      ['54', '55'],
      ['300', '305'],
      ['3095'],
      ['36'],
      ['38', '39'],
    },
  };

  // .... Detect card based on cardNumber.......
  CardType detectCardType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumberPattern.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }
}
