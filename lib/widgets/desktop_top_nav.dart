// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

/// Shared desktop top navigation bar.
/// [activeTab] can be 'home', 'cart', 'saved', or 'profile'.
/// [onSearchTap] wires up the search bar; leave null for a decorative bar.
class DesktopTopNav extends StatelessWidget {
  final String activeTab;
  final VoidCallback? onSearchTap;
  const DesktopTopNav({this.activeTab = 'home', this.onSearchTap, super.key});

  bool _is(String tab) => activeTab == tab;

  Widget _btn(IconData icon, IconData activeIcon, String label, bool active, {VoidCallback? onTap, int badge = 0}) {
    final btn = InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Color(0xFFE6FAFA) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(active ? activeIcon : icon, size: 19, color: active ? AppColors.mainColor : Colors.grey.shade600),
            SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, color: active ? AppColors.mainColor : Colors.grey.shade600, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
    if (badge <= 0) return Padding(padding: EdgeInsets.only(left: 4), child: btn);
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          btn,
          Positioned(
            top: 0, right: 0,
            child: Container(
              width: 17, height: 17,
              decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              child: Center(child: Text('$badge', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () => Get.offAllNamed(RouteHelper.getInitial()),
            child: Text('katqa',
                style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5)),
          ),
          SizedBox(width: 20),
          // Location chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.location_on, size: 13, color: AppColors.mainColor),
              SizedBox(width: 4),
              Text('Nairobi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
              SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey.shade500),
            ]),
          ),
          SizedBox(width: 16),
          // Search bar
          Flexible(
            fit: FlexFit.loose,
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 40,
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(color: Color(0xFFF2F3F5), borderRadius: BorderRadius.circular(24)),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Icon(Icons.search, size: 16, color: Colors.grey.shade400),
                  SizedBox(width: 8),
                  Text('Search food, restaurants…', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                ]),
              ),
            ),
          ),
          Spacer(),
          // Nav buttons
          _btn(Icons.home_outlined, Icons.home, 'Home', _is('home'),
              onTap: () => Get.offAllNamed(RouteHelper.getInitial())),
          GetBuilder<CartController>(builder: (cart) =>
            _btn(Icons.shopping_cart_outlined, Icons.shopping_cart, 'Cart', _is('cart'),
                badge: cart.totalItems,
                onTap: () => Get.toNamed(RouteHelper.getCartPage())),
          ),
          _btn(Icons.favorite_border, Icons.favorite, 'Saved', _is('saved'),
              onTap: () => Get.toNamed(RouteHelper.getSavedPage())),
          _btn(Icons.person_outline, Icons.person, 'Profile', _is('profile'),
              onTap: () => Get.toNamed(RouteHelper.getProfilePage())),
        ],
      ),
    );
  }
}
