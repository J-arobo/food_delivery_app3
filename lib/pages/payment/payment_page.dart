import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';

class PaymentPage extends StatefulWidget {
  final OrderModel orderModel;
  const PaymentPage({super.key, required this.orderModel});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    final callbackUrl = Uri.encodeComponent(
        'https://food-delivery-app-ce205.web.app/order-successful?id=${widget.orderModel.id}');
    final paymentUrl = '${AppConstants.BASE_URL}/payment-mobile'
        '?customer_id=${widget.orderModel.userId}'
        '&order_id=${widget.orderModel.id}'
        '&callback=$callbackUrl';
    html.window.location.href = paymentUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: AppColors.mainColor,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Redirecting to payment gateway..."),
          ],
        ),
      ),
    );
  }
}
