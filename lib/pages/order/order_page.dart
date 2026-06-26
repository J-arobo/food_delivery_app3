// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/pages/order/view_order.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/widgets/desktop_top_nav.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    Get.find<AuthController>().userLoggerIn();
    Get.find<OrderController>().getOrderList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildMobileHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 52, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Orders',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87)),
              Text('Track and manage your orders',
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Color(0xFFE6FAFA), shape: BoxShape.circle),
            child: Icon(Icons.receipt_long_outlined,
                color: AppColors.mainColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 4, 20, 14),
      child: Container(
        height: 44,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(9),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle:
              TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'History'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            isDesktop
                ? DesktopTopNav(activeTab: 'home')
                : _buildMobileHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ViewOrder(isCurrent: true),
                  ViewOrder(isCurrent: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
