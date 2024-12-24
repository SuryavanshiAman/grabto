
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static late  Razorpay _razorpay;

  static void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static void dispose() {
    _razorpay.clear();
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // print("Payment Successful: ${response.paymentId}");
    // Add your logic to handle payment success
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    //print("Payment Error: ${response.code.toString()} - ${response.message}");
    // Add your logic to handle payment failure
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    //print("External Wallet: ${response.walletName}");
    // Handle external wallet payments
  }

  static void startPayment({
    required String orderId,
    required String apiKey,
    required int amount,
    required String name,
    required String description,
    required String email,
    required String contact,
    required String app_image,
    required int duration,
    void Function(PaymentSuccessResponse) successCallback = _handlePaymentSuccess,
    void Function(PaymentFailureResponse) errorCallback = _handlePaymentError,
    void Function(ExternalWalletResponse) externalWalletCallback = _handleExternalWallet,
  }) {


    var options = {
      'key': apiKey,
      'amount': amount,
      'name': name,
      'description': description,
      'order_id': '$orderId',
      'timeout': duration, // in seconds
      'prefill': {'contact': contact, 'email': email},
      // 'external': {
      //   'wallets': ['paytm']
      // },
      'image': app_image,
      //'theme.color': '#FF5733',
      'theme.color': "#DA1A22",
      // 'recurring': 1,
    };

    try {
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successCallback);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorCallback);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletCallback);
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}
