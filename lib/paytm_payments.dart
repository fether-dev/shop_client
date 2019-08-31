import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PaytmPayments {

  // Channel to communicate with Native code
  static const MethodChannel _channel = const MethodChannel('paytm_payments');

  static StreamController<Map<dynamic,dynamic>> responseController = StreamController<Map<dynamic,dynamic>>.broadcast();
  static Stream<Map<dynamic,dynamic>> get responseStream => responseController.stream;
  static Sink<Map<dynamic,dynamic>> get responseSink => responseController.sink;

  /* makePaytmPayment can be used to:
  * Make payments using staging environment, staging test is required to be done before receiving the production details from paytm
  * Make production environment payments too by setting staging param to true
  * */
  static Future<Null> makePaytmPayment(String merchantId, String checksumUrl, {String website = "APPSTAGING", String industryTypeId = "Retail", String channelId = "WAP", String customerId = "", String orderId = "", String txnAmount = "10", String mobileNumber = "", String email = "", bool staging = true, bool showToast = true}) async {

    if(merchantId == null || checksumUrl == null)
      return null;

    if(customerId.isEmpty){
      customerId = generateCustomerId();
    }

    if(orderId.isEmpty){
      orderId = generateOrderId();
    }
    if(mobileNumber.isEmpty){
     mobileNumber = "XXXXXXXXX";
    }


    // setup callback url
    String callBackUrl;
    if(staging)
      callBackUrl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    else
      callBackUrl = "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";

    // build payment object
    Map<String, String> paymentObject = {
      "MID" : merchantId,
      "ORDER_ID" : orderId,
      "CUST_ID" : customerId,
      "MOBILE_NO" : mobileNumber,
      "EMAIL" :email,
      "CHANNEL_ID" : channelId,
      "TXN_AMOUNT" : txnAmount,
      "WEBSITE" : website,
      "INDUSTRY_TYPE_ID" : industryTypeId,
      "CALLBACK_URL" : callBackUrl,
      };

    // get checksum hash
    String checksumHash = await generateChecksum(checksumUrl, paymentObject);

    // update payment object with checksumhash value
    paymentObject.addAll({
      "CHECKSUMHASH" : checksumHash,
    });

    // initiate payment
    Map<dynamic, dynamic> res = await _channel.invokeMethod('paytmPayment', {"order_data" : paymentObject, "staging" : staging, "show_toast" : showToast},);
    responseSink.add(res);

    return null;
  }

  static Future<String> generateChecksum(String url, Map<String, String> paymentObject) async {

    var res = await http.post(url, body: paymentObject);

    return convert.jsonDecode(res.body)["CHECKSUMHASH"];
  }

  // generates a random customer ID
  static String generateCustomerId() {

    return (DateTime.now().millisecondsSinceEpoch / 1000).toString();
  }

  // generates a random order ID
  static String generateOrderId() {

    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
