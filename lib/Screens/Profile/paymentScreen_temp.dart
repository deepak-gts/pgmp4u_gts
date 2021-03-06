import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/purchase_interface.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/utils/event.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PaymentScreenTest extends StatefulWidget {
  const PaymentScreenTest({Key key}) : super(key: key);

  @override
  _PaymentScreenTestState createState() => _PaymentScreenTestState();
}

class _PaymentScreenTestState extends State<PaymentScreenTest> {
  // Razorpay _razorpay;

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  CollectionReference users =
      FirebaseFirestore.instance.collection('staticData');

  PurchaseProvider provider;
  Map<String, dynamic> paymentIntentData;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<PurchaseProvider>(context, listen: false);
    apiCall();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Map mapResponse;
  bool buttonPress = false;

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   paymentStatus("success");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PaymentStatus(status: "success"),
  //       ));
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   paymentStatus("failed");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PaymentStatus(status: "failure"),
  //       ));
  // }

  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(Uri.parse(CHECK_COUPON), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });
    print(convert.jsonDecode(response.body));
    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      var responseData = convert.jsonDecode(response.body);
      setState(() {
        mapResponse = responseData["data"];
      });
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  // void openCheckout(key, value, currency) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('email');
  //   // var options = {
  //   //   'key': key,
  //   //   'amount': value * 100,
  //   //   //"order_id": orderId,
  //   //   "currency": currency,
  //   //   'name': 'PgMP4U',
  //   //   'description': '',
  //   //   'prefill': {'contact': '', 'email': stringValue},
  //   // };
  //   /// Todo : call payment geyway
  //   // create payment method

  //   try {
  //     makePayment(value.toString(), currency, stringValue, context);
  //     // _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }

  // Future displayPaymentSheet(BuildContext context) async {
  //   print(">>>>> 1234");

  //   try {
  //     return await Stripe.instance
  //         .presentPaymentSheet(
  //             parameters: PresentPaymentSheetParameters(
  //       clientSecret: paymentIntentData['client_secret'],
  //       confirmPayment: true,
  //     ))
  //         .whenComplete(() {
  //       print('payment intent' + paymentIntentData['id'].toString());
  //       print('payment intent' + paymentIntentData['client_secret'].toString());
  //       print('payment intent' + paymentIntentData['amount'].toString());
  //       print('payment intent' + paymentIntentData.toString());
  //       //orderPlaceApi(paymentIntentData!['id'].toString());
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => PaymentStatus(status: "success"),
  //           ));

  //       paymentIntentData = null;
  //     }).onError((error, stackTrace) {
  //       print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
  //     });
  //   } on StripeException catch (e) {
  //     print('Exception/DISPLAYPAYMENTSHEET==> $e');
  //     showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //               content: Text("Cancelled "),
  //             ));
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  // Future<void> makePayment(String amount, String currency, String email,
  //     BuildContext context) async {
  //   print("start make payment");
  //   try {
  //     paymentIntentData = await createPaymentIntent(
  //         amount, currency); //json.decode(response.body);
  //     // print('Response body==>${response.body.toString()}');
  //     print("payment intend $paymentIntentData");
  //     if (paymentIntentData != null) {
  //       await Stripe.instance
  //           .initPaymentSheet(
  //               paymentSheetParameters: SetupPaymentSheetParameters(
  //                   paymentIntentClientSecret:
  //                       paymentIntentData['client_secret'],
  //                   applePay: true,
  //                   googlePay: true,
  //                   testEnv: false,
  //                   // allowsDelayedPaymentMethods: true,
  //                   billingDetails: BillingDetails(email: email),
  //                   style: ThemeMode.dark,
  //                   merchantCountryCode: 'US',
  //                   merchantDisplayName: 'PGMP4U'))
  //           .then((value) {});

  //       ///now finally display payment sheeet
  //       var respose = await displayPaymentSheet(context);

  //       print(">>>>>>> res $respose");
  //     }
  //   } catch (e, s) {
  //     print('exception >>> :$e$s');
  //   }
  // }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                // 'Bearer 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',
                'Bearer sk_test_51KVy8SSF6JrV3GLogJeRpAKacDUfbLP805VkGqujJoOkVTQCGdjAvWg95FBKUcjTvemkF6gkkyFO6DHPk7MAKfSS00feFh8x4J',

            /// FOR test mode
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = int.parse(((double.parse(amount)) * 100).floor().toString());
    return a.toString();
  }

  Future paymentStatus(status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.post(
      Uri.parse(TAKE_PAYMENT),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': stringValue
      },
      body: json.encode({
        "payment_status": status,
        "price": 129,
        "payment_repsonse": "sfadfeaf",
        "client_secret": "212421424",
        "access_type": "life_time"
      }),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      if (mapResponse == null) {
        GFToast.showToast(
          'Payment status updated',
          context,
          toastPosition: GFToastPosition.BOTTOM,
        );
      } else {
        if (mapResponse["discount"] == 100) {
          Navigator.of(context).pushNamed('/mock-test');
          GFToast.showToast(
            'You became premium now,Now you can access mock test',
            context,
            toastPosition: GFToastPosition.BOTTOM,
          );
        } else {
          GFToast.showToast(
            'Payment status updated',
            context,
            toastPosition: GFToastPosition.BOTTOM,
          );
        }
      }
    }
  }

  Future getOrderId(key, price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.post(
      Uri.parse(GET_RAZOR_PAY_ORDER_ID),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': stringValue
      },
      body: json.encode({"amount": 100 / 100}),
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      Map mapResponce = json.decode(response.body);

      // openCheckout(key, 100, mapResponce["data"]["id"]);
      setState(() {});
      // print(convert.jsonDecode(response.body));
    }
  }

  Future takePayment(status, price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.post(
      Uri.parse(TAKE_PAYMENT),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': stringValue
      },
      body: json.encode({
        "payment_status": status,
        "price": price,
        "payment_repsonse": "sfadfeaf",
        "client_secret": "212421424",
        "access_type": "life_time",
        "coupon_id": mapResponse["coupon_id"]
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        buttonPress = true;
      });
      print(json.decode(response.body));
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
          future: users.doc('Zli1qoSMV4yLT0ZhdfsV').get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              return Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          width: width,
                          // height: height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 15),
                                child: GestureDetector(
                                  onTap: () => {Navigator.of(context).pop()},
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 27,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 30, bottom: 25),
                                    child: Image.asset('assets/premium.png'),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: Text(
                                    'Get Unlimited Access to Mock Test',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: width * (30 / 420),
                                        color: _colorfromhex("#3D4AB4"),
                                        letterSpacing: 0.3),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Text(
                                    buttonPress == true
                                        ? '${(data["mock_test_price"] - ((mapResponse["discount"] / 100) * data["mock_test_price"])).toInt()} \$'
                                        : '${data["mock_test_price"]} \$',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: width * (44 / 420),
                                        color: _colorfromhex("#3D4AB4"),
                                        letterSpacing: 0.3),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Text(
                                    'Lifetime Access',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: 24,
                                        color: _colorfromhex("#3D4AB4"),
                                        letterSpacing: 0.3),
                                  ),
                                ),
                              ),
                              mapResponse != null && buttonPress == false
                                  ? Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        height: 40,
                                        // alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: _colorfromhex("#3A47AD"),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: OutlinedButton(
                                          onPressed: () => {
                                            // setState(() => {buttonPress = true}),
                                            print(mapResponse["discount"]),
                                            if (mapResponse["discount"] == 100)
                                              {paymentStatus("success")}
                                            else
                                              {
                                                setState(
                                                    () => {buttonPress = true})
                                              }
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0))),
                                          ),
                                          child: Text(
                                            'Apply Coupon',
                                            style: TextStyle(
                                                fontFamily: 'Roboto Medium',
                                                fontSize: 20,
                                                color: Colors.white,
                                                letterSpacing: 0.3),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Consumer<PurchaseProvider>(
                                builder: (context, value, child) {
                                  var latestState =
                                      value.serverResponse.getContent();
                                  if (latestState is Loading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (latestState is Default) {
                                    value.showToast(
                                        context, latestState.message);
                                  }

                                  print(
                                      "value.serverResponse = ${latestState is Success}");
                                  if (latestState is Success) {
                                    print("Pop called");
                                    Future.delayed(Duration.zero, () async {
                                      Navigator.pop(context, true);
                                    });
                                  }
                                  return BuyButtons(data);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
                width: width,
                height: height,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF")),
                )));
          },
        ),
      ),
    );
  }

  Widget BuyButtons(data) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),

            height: 40,
            // alignment: Alignment.center,
            decoration: BoxDecoration(
                color: _colorfromhex("#3A47AD"),
                borderRadius: BorderRadius.circular(30.0)),
            child: OutlinedButton(
              onPressed: () {
                if (Platform.isIOS) {
                  print("buttonClicked ${provider.products[0].id}");
                  provider.products.forEach((e) {
                    print("Product id => ${e.id}");
                    if (e.id == storeKeyConsumable) {
                      provider.buy(e);
                    }
                  });
                } else {
                  // if (mapResponse == null) {
                  //   openCheckout(data["razorpay_key"], data["mock_test_price"],
                  //       data["Currency"]);
                  // } else {
                  //   openCheckout(
                  //       data["razorpay_key"],
                  //       (data["mock_test_price"] -
                  //               ((mapResponse["discount"] / 100) *
                  //                   data["mock_test_price"]))
                  //           .toInt(),
                  //       data["Currency"]);
                  // }
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                      fontFamily: 'Roboto Medium',
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 0.3),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Platform.isIOS
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Purchased previously? "),
                    InkWell(
                      child: Text(
                        "Restore purchase",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        provider.restore();
                      },
                    )
                  ],
                ),
              )
            : Text("")
      ],
    );
  }
}
