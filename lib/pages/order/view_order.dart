// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/custom_loader.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

class ViewOrder extends StatelessWidget {
  final bool isCurrent;
  const ViewOrder({super.key, required this.isCurrent});

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'processing':
      case 'confirmed':
      case 'accepted':
      case 'handover':
        return Colors.orange;
      case 'canceled':
      case 'failed':
        return Colors.redAccent;
      default:
        return AppColors.mainColor;
    }
  }

  Widget _buildOrderCard(OrderModel order) {
    final color = _statusColor(order.orderStatus);
    final amount = order.orderAmount != null
        ? 'KSh ${order.orderAmount!.toStringAsFixed(0)}'
        : '';
    final itemCount = order.detailsCount ?? 0;
    final dateRaw = order.createdAt ?? '';
    String dateDisplay = '';
    if (dateRaw.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateRaw);
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        dateDisplay = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      } catch (_) {
        dateDisplay = dateRaw.length > 10
            ? dateRaw.substring(0, 10)
            : dateRaw;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFE6FAFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.receipt_long_outlined,
                  color: AppColors.mainColor, size: 22),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order #${order.id}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 3),
                  if (itemCount > 0)
                    Text('$itemCount item${itemCount == 1 ? '' : 's'}',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                  if (dateDisplay.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(dateDisplay,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.orderStatus ?? 'pending',
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (amount.isNotEmpty) ...[
                  SizedBox(height: 6),
                  Text(amount,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Color(0xFFE6FAFA), shape: BoxShape.circle),
            child: Icon(Icons.receipt_outlined,
                size: 36, color: AppColors.mainColor),
          ),
          SizedBox(height: 16),
          Text(isCurrent ? 'No active orders' : 'No order history',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
              isCurrent
                  ? 'Place an order and track it here'
                  : 'Your completed orders will show here',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return GetBuilder<OrderController>(builder: (orderController) {
      if (orderController.isLoading) return CustomLoader();

      final orderList = (isCurrent
              ? orderController.currentOrderList
              : orderController.historyOrderList)
          .reversed
          .toList();

      if (orderList.isEmpty) return _buildEmpty();

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(
            isDesktop ? 40 : 20, 16, isDesktop ? 40 : 20, 24),
        itemCount: orderList.length,
        itemBuilder: (_, i) => _buildOrderCard(orderList[i]),
      );
    });
  }
}
