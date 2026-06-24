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

  Widget _navItem(int index, IconData icon, String label) {
    final selected = _selectedIndex == index;
    final color = selected ? AppColors.mainColor : Colors.amberAccent;
    return TextButton.icon(
      onPressed: () => onTapNav(index),
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 700;

      if (isDesktop) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                _navItem(0, Icons.home_outlined, 'Home'),
                _navItem(1, Icons.archive, 'Orders'),
                _navItem(2, Icons.shopping_cart, 'Cart'),
                _navItem(3, Icons.person, 'Account'),
              ],
            ),
          ),
          body: pages[_selectedIndex],
        );
      }

      return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppColors.mainColor,
            unselectedItemColor: Colors.amberAccent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0.0,
            unselectedFontSize: 0.0,
            currentIndex: _selectedIndex,
            onTap: onTapNav,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: "history"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "cart"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "me"),
            ]),
      );
    });
  }
}
