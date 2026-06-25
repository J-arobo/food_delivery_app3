// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/controllers/saved_controller.dart';
import 'package:food_delivery_app/pages/account/profile_page.dart';
import 'package:food_delivery_app/pages/checkout/mobile_checkout_page.dart';
import 'package:food_delivery_app/pages/home/main_food_page.dart';
import 'package:food_delivery_app/pages/order/order_page.dart';
import 'package:food_delivery_app/pages/saved/saved_page.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

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
    const MobileCheckoutPage(),
    const SavedPage(),
    const ProfilePage(),
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
      bottomNavigationBar: isDesktop
          ? null
          : GetBuilder<CartController>(builder: (cart) {
              return GetBuilder<SavedController>(builder: (saved) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.mainColor,
                  unselectedItemColor: Colors.grey.shade400,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  backgroundColor: Colors.white,
                  elevation: 8,
                  currentIndex: _selectedIndex,
                  onTap: onTapNav,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grid_view_outlined),
                      activeIcon: Icon(Icons.grid_view),
                      label: 'Browse',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.shopping_cart_outlined),
                          if (cart.totalItems > 0)
                            Positioned(
                              top: -6, right: -6,
                              child: Container(
                                width: 16, height: 16,
                                decoration: BoxDecoration(color: AppColors.mainColor, shape: BoxShape.circle),
                                child: Center(
                                  child: Text('${cart.totalItems}',
                                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      activeIcon: Icon(Icons.shopping_cart),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.favorite_border),
                          if (saved.count > 0)
                            Positioned(
                              top: -6, right: -6,
                              child: Container(
                                width: 16, height: 16,
                                decoration: BoxDecoration(color: AppColors.mainColor, shape: BoxShape.circle),
                                child: Center(
                                  child: Text('${saved.count}',
                                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      activeIcon: Icon(Icons.favorite),
                      label: 'Saved',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                );
              });
            }),
    );
  }
}
