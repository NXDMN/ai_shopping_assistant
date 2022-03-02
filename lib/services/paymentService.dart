import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ai_shopping_assistant/constants.dart';

class PaymentService {
  static Future<dynamic> createPaymentIntent(Map<String, dynamic> data) async {
    try {
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: data,
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
