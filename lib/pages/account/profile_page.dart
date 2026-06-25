// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/widgets/desktop_top_nav.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/location_controller.dart';
import 'package:food_delivery_app/controllers/user_controller.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _recentOrders = [
    {'id': '#ORD-1842', 'items': 'Biriani, Mandazi',    'date': '22 Jun 2026', 'amount': 'KSh 570', 'img': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=120&q=80'},
    {'id': '#ORD-1801', 'items': 'Nyama Choma, Pilau',  'date': '18 Jun 2026', 'amount': 'KSh 760', 'img': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=120&q=80'},
    {'id': '#ORD-1776', 'items': 'Ugali & Sukuma',      'date': '12 Jun 2026', 'amount': 'KSh 250', 'img': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=120&q=80'},
  ];

  static const _menuItems = [
    {'icon': 'box',     'title': 'Order History',    'sub': 'View past orders'},
    {'icon': 'pin',     'title': 'Saved Addresses',  'sub': '3 addresses saved'},
    {'icon': 'card',    'title': 'Payment Methods',  'sub': 'M-Pesa · Visa'},
    {'icon': 'prefs',   'title': 'Preferences',      'sub': 'Notifications, dietary'},
  ];

  @override
  void initState() {
    super.initState();
    if (Get.find<AuthController>().userLoggerIn()) {
      Get.find<UserController>().getUserInfo();
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return 'U';
  }

  IconData _menuIcon(String key) {
    switch (key) {
      case 'box':   return Icons.inventory_2_outlined;
      case 'pin':   return Icons.location_on_outlined;
      case 'card':  return Icons.credit_card_outlined;
      default:      return Icons.tune_outlined;
    }
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 52, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kenya', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 18)),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 13, color: Colors.grey.shade500),
                SizedBox(width: 2),
                Text('Nairobi', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ]),
            ],
          ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Color(0xFFE6FAFA), shape: BoxShape.circle),
            child: Icon(Icons.search, color: AppColors.mainColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: Color(0xFFE6FAFA), shape: BoxShape.circle),
                child: Icon(Icons.person_outline, size: 40, color: AppColors.mainColor),
              ),
              SizedBox(height: 20),
              Text('Sign in to view your profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Access your orders, saved items and settings.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(RouteHelper.getSignInPage()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String name, {double size = 64, double fontSize = 22, double radius = 14}) {
    return Stack(
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(radius)),
          child: Center(child: Text(_initials(name), style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold))),
        ),
        Positioned(
          bottom: 0, right: 0,
          child: Container(
            width: 22, height: 22,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]),
            child: Icon(Icons.edit, size: 12, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLoggedIn(String name, String email, String phone) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full-width white user banner
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(32, 28, 32, 28),
              child: Row(
                children: [
                  _buildUserAvatar(name, size: 72, fontSize: 26, radius: 16),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade400),
                        SizedBox(width: 6),
                        Text(email, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      ]),
                      SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.phone_outlined, size: 14, color: Colors.grey.shade400),
                        SizedBox(width: 6),
                        Text(phone, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),

            // Gray content area
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row — full width, box-style
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          _desktopStatCell('3', 'Orders'),
                          VerticalDivider(width: 1, color: Colors.grey.shade100),
                          _desktopStatCell('4', 'Saved'),
                          VerticalDivider(width: 1, color: Colors.grey.shade100),
                          _desktopStatCell('7', 'Reviews'),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Two-column: menu left, recent orders right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left — menu items
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
                          ),
                          child: Column(
                            children: _menuItems.asMap().entries.map((e) {
                              final last = e.key == _menuItems.length - 1;
                              return Column(children: [
                                _menuRow(e.value),
                                if (!last) Divider(height: 1, color: Colors.grey.shade100, indent: 62),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      // Right — recent orders + sign out
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RECENT ORDERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 1.2)),
                            SizedBox(height: 12),
                            ..._recentOrders.map((order) => _orderCard(order)),
                            SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: _signOut,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    Icon(Icons.logout_outlined, color: Colors.redAccent, size: 18),
                                    SizedBox(width: 8),
                                    Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600)),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _desktopStatCell(String value, String label) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.mainColor)),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedIn(String name, String email, String phone) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Row(
                children: [
                  _buildUserAvatar(name),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.email_outlined, size: 13, color: Colors.grey.shade400),
                          SizedBox(width: 4),
                          Expanded(child: Text(email, style: TextStyle(color: Colors.grey.shade500, fontSize: 12), overflow: TextOverflow.ellipsis)),
                        ]),
                        SizedBox(height: 3),
                        Row(children: [
                          Icon(Icons.phone_outlined, size: 13, color: Colors.grey.shade400),
                          SizedBox(width: 4),
                          Text(phone, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14),

            // Stats row
            Row(
              children: [
                _statCard('3', 'Orders'),
                SizedBox(width: 10),
                _statCard('4', 'Saved'),
                SizedBox(width: 10),
                _statCard('7', 'Reviews'),
              ],
            ),

            SizedBox(height: 14),

            // Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                children: _menuItems.asMap().entries.map((e) {
                  final last = e.key == _menuItems.length - 1;
                  return Column(
                    children: [
                      _menuRow(e.value),
                      if (!last) Divider(height: 1, color: Colors.grey.shade100, indent: 62),
                    ],
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24),

            // Recent orders
            Text('RECENT ORDERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 1.2)),
            SizedBox(height: 12),
            ..._recentOrders.map((order) => _orderCard(order)),

            SizedBox(height: 24),

            // Sign out
            Center(
              child: GestureDetector(
                onTap: _signOut,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout_outlined, color: Colors.redAccent, size: 18),
                      SizedBox(width: 8),
                      Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainColor)),
            SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _menuRow(Map<String, String> item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: Color(0xFFE6FAFA), borderRadius: BorderRadius.circular(10)),
            child: Icon(_menuIcon(item['icon']!), color: AppColors.mainColor, size: 18),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title']!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(item['sub']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _orderCard(Map<String, String> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              order['img']!, width: 56, height: 56, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: Colors.grey.shade200),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order['id']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 2),
                Text(order['items']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                SizedBox(height: 2),
                Text(order['date']!, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(order['amount']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 4),
              Text('Delivered', style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  void _signOut() {
    Get.find<AuthController>().clearSharedData();
    Get.find<CartController>().clear();
    Get.find<CartController>().clearCartHistory();
    Get.find<LocationController>().clearAddressList();
    Get.offAllNamed(RouteHelper.getSignInPage());
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isLoggedIn = Get.find<AuthController>().userLoggerIn();
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            isDesktop ? DesktopTopNav(activeTab: 'profile') : _buildHeader(),
            if (!isLoggedIn)
              _buildSignInPrompt()
            else
              GetBuilder<UserController>(builder: (userCtrl) {
                if (!userCtrl.isLoading || userCtrl.userModel == null) {
                  return Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.mainColor)));
                }
                return isDesktop
                    ? _buildDesktopLoggedIn(
                        userCtrl.userModel!.name,
                        userCtrl.userModel!.email,
                        userCtrl.userModel!.phone,
                      )
                    : _buildLoggedIn(
                        userCtrl.userModel!.name,
                        userCtrl.userModel!.email,
                        userCtrl.userModel!.phone,
                      );
              }),
          ],
        ),
      ),
    );
  }
}
