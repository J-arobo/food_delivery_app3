import 'dart:ui' show ImageFilter;
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
  List pages = [
    MainFoodPage(),
    OrderPage(),
    CartHistory(),
    AccountPage(),
  ];

  void onTapNav(int index) {
    setState(() {
      // to trigger UI change
      _selectedIndex = index;
    });
    if (index == 1) {
      Get.find<OrderController>().getOrderList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: LayoutBuilder(builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        const navItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: "history"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "me"),
        ];

        if (!isDesktop) {
          return BottomNavigationBar(
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
            items: navItems,
          );
        }

        // Desktop / tablet: floating pill
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 56,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: AppColors.mainColor,
                    unselectedItemColor: Colors.grey.shade400,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedFontSize: 0.0,
                    unselectedFontSize: 0.0,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    currentIndex: _selectedIndex,
                    onTap: onTapNav,
                    items: navItems,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
