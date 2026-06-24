import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/pages/account/acccount_page.dart';
import 'package:food_delivery_app/pages/auth/sign_in_page.dart';
import 'package:food_delivery_app/pages/auth/sign_up_page.dart';
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

        final bar = BottomNavigationBar(
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: Colors.amberAccent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0,
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: onTapNav,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive),
              label: "history",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "me",
            ),
          ],
        );

        if (!isDesktop) return bar;

        return Container(
          color: Colors.white,
          child: Center(
            child: SizedBox(width: 480, child: bar),
          ),
        );
      }),
    );
  }
}
