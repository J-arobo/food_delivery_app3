import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/pages/account/acccount_page.dart';
import 'package:food_delivery_app/pages/cart/cart_page.dart';
import 'package:food_delivery_app/pages/home/main_food_page.dart';
import 'package:food_delivery_app/pages/order/order_page.dart';
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
    CartPage(),
    AccountPage(),
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
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: "home",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: "history",
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        if (cart.totalItems > 0)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${cart.totalItems}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: "cart",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: "me",
                  ),
                ],
              );
            }),
    );
  }
}
