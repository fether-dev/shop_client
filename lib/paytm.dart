import 'package:ecart_client1/paytm_payments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
class Paypaytm extends StatefulWidget {

  int index;
  final String username;
   List list;
      Paypaytm({this.index,this.list,this.username});

@override
  _PaypaytmState createState() => new _PaypaytmState();

}
class _PaypaytmState extends State<Paypaytm> {
 

  @override
  void initState() {
    super.initState();
    setResponseListener();
  }
  void setResponseListener(){
    //setting a listener on payment response
    PaytmPayments.responseStream.listen((Map<dynamic, dynamic> responseData){
     print(responseData);
      /*
      * {RESPMSG : [MSG]} // this is the type of map object received, except for one case.
      *
      * In this unique case, Transaction Response is received of the format:
      * {CURRENCY: INR, ORDERID: 1557210948833, STATUS: TXN_FAILURE, BANKTXNID: , RESPMSG: Invalid checksum, MID: rxazcv89315285244163, RESPCODE: 330, TXNAMOUNT: 10.00}
      *
      * Call any method here to handle payment process on receiving response. According to the response received.
      * handleResponse();
      *
      * */
    });
  }

  // method to initiate payment
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPayment() async {
    // try/catch any Exceptions.
    try {
      await PaytmPayments.makePaytmPayment(
        "HSZtRz20664631372837", // [YOUR_MERCHANT_ID] (required field)
        //"https://ajax8732.000webhostapp.com/generateChecksum.php", // [YOUR_CHECKSUM_URL] (required field)
        "https://fluttertest.000webhostapp.com/paytm/generateChecksum.php",
        customerId: "12345", // [UNIQUE_ID_FOR_YOUR_CUSTOMER] (auto generated if not specified)
        orderId: DateTime.now().millisecondsSinceEpoch.toString(), // [UNIQUE_ID_FOR_YOUR_ORDER] (auto generated if not specified)
        txnAmount: "10000.0", // default: 10.0
        channelId: "WAP", // default: WAP (STAGING value)
        industryTypeId: "Retail", // default: Retail (STAGING value)
        website: "APPSTAGING", // default: APPSTAGING (STAGING value)
        staging: true, // default: true (by default paytm staging environment is used)
        showToast: true, // default: true (by default shows callback messages from paytm in Android Toasts)
      );
    } on Exception {

      print("Some error occurred");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paytm Payment'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: (){
              initPayment();
            },
            child: Text("Make Payment"),
          ),
        ),
      ),
    );
  }
}