import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/pages/account/acccount_page.dart';
import 'package:food_delivery_app/pages/cart/cart_history.dart';
import 'package:food_delivery_app/pages/home/main_food_page.dart';
import 'package:food_delivery_app/pages/order/order_page.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List pages = [
    MainFoodPage(),
    OrderPage(),
    CartHistory(),
    AccountPage(),
  ];

  static const _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "home"),
    BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: "history"),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "cart"),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "me"),
  ];

  void onTapNav(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) Get.find<OrderController>().getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: pages[_selectedIndex],
      // On desktop the top nav inside MainFoodPage handles navigation
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.mainColor,
              unselectedItemColor: Colors.grey.shade400,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 0.0,
              unselectedFontSize: 0.0,
              backgroundColor: Colors.white,
              elevation: 8,
              currentIndex: _selectedIndex,
              onTap: onTapNav,
              items: _navItems,
            ),
    );
  }
}
