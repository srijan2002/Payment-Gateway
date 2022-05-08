import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _razorpay = Razorpay();
  String text = "";
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment successful");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment Successful!")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("payment failed");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment Failed!")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print("another wallet");
  }

  dynamic calc_amt() {
    double x = double.parse(amountController.text);
    x = x * 100;
    return x.toInt().toString();
  }

  Future<String> create_order() async {
    String amt = calc_amt();
    var dio = Dio();
    var response = await dio
        .post('https://payment-gateway-02.herokuapp.com/order', data: {
      'key': dotenv.env['KEY'],
      'secret': dotenv.env['SECRET'],
      'amount': amt
    });
    print(response.data.toString());
    return response.data.toString();
  }

  void checkout() async {
    String amt = calc_amt();
    String orderid = await create_order();
    var options = {
      'key': dotenv.env['KEY'],
      'amount': int.parse(amt), //in the smallest currency sub-unit.
      'name': 'Elite_Raven',
      'order_id': orderid, // Generate order_id using Orders API
      'description': 'Payment Gateway using Razorpay API and Flutter',
      'timeout': 240, // in seconds
      'prefill': {'contact': '9330427421', 'email': 'srjnmajumdar8@gmail.com'},
      'send_sms_hash': true,
      'retry': {'enabled': true, 'max_count': 4},
      'image': 'https://www.carlogos.org/car-logos/tesla-logo-2000x2890.png',
      'theme': {'color': '#F50D94', 'backdrop_color': '#07E2FF'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF72AEE8),
                Color(0xFF7DD5F1),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Hi Srijan 👋",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Split Your Bill",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17.sp,
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Stack(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 6.h),
                        child: Container(
                          width: 80.w,
                          height: 65.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.sp),
                                  topLeft: Radius.circular(30.sp),
                                  bottomLeft: Radius.circular(15.sp),
                                  bottomRight: Radius.circular(15.sp))),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/burger.png',
                                // color: Colors.amber,
                                height: 25.h,
                              ),
                              // SizedBox(height: 2.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total  Bill",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (text != "") ? "Rs. $text" : "Rs. 0",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 1.3.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "5 Cheese Burger",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 3.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 0),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      text = value;
                                    });
                                  },
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        letterSpacing: 0.1),
                                  ),
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.sp),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          2.w, 1.h, 2.w, 1.h),
                                      labelText: 'Enter Amount',
                                      prefixText: ' Rs. ',
                                      prefixStyle: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      labelStyle: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500))),
                                  //
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FloatingActionButton(
                        onPressed: () async {
                          checkout();
                        },
                        backgroundColor: Colors.black,
                        child: Icon(Icons.arrow_forward_rounded),
                      ),
                      top: 61.h,
                      left: 32.5.w,
                    )
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
