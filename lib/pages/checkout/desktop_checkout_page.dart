// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/pages/address/address_picker_page.dart';
import 'package:food_delivery_app/widgets/desktop_top_nav.dart';
import 'package:food_delivery_app/widgets/pulsing_signal_icon.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

class DesktopCheckoutPage extends StatefulWidget {
  const DesktopCheckoutPage({super.key});

  @override
  State<DesktopCheckoutPage> createState() => _DesktopCheckoutPageState();
}

class _DesktopCheckoutPageState extends State<DesktopCheckoutPage> {
  int _step = 0;
  int _selectedAddress = 0;
  int _selectedPayment = 0;
  String _orderID = '';

  static const _addresses = [
    {'icon': '🏠', 'name': 'Home',       'address': '14 Ngong Road, Karen, Nairobi'},
    {'icon': '🏢', 'name': 'Work',       'address': 'Upper Hill, Nairobi CBD, Nairobi'},
    {'icon': '📍', 'name': "Mum's Place",'address': '45 Kiambu Road, Kiambu'},
  ];

  static const _payments = [
    {'icon': 'mpesa',  'name': 'M-Pesa',          'detail': '**** 7821'},
    {'icon': 'visa',   'name': 'Visa Card',        'detail': '**** **** **** 4242'},
    {'icon': 'paypal', 'name': 'PayPal',           'detail': 'user@example.com'},
    {'icon': 'cash',   'name': 'Cash on Delivery', 'detail': 'Pay when you receive'},
  ];

  static const _statusSteps = [
    {'label': 'Order Confirmed',     'done': true,  'live': false},
    {'label': 'Preparing your food', 'done': true,  'live': true},
    {'label': 'Out for Delivery',    'done': false, 'live': false},
    {'label': 'Delivered',           'done': false, 'live': false},
  ];

  // ── Step indicator ───────────────────────────────────────────────────────────

  Widget _buildStepIndicator(int filled) {
    return Row(
      children: List.generate(4, (i) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
          height: 3,
          decoration: BoxDecoration(
            color: i < filled ? AppColors.mainColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
    );
  }

  // ── STEP 0 — Cart ────────────────────────────────────────────────────────────

  Widget _buildCartStep(CartController cart) {
    final items = cart.getItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(color: Color(0xFFE6FAFA), shape: BoxShape.circle),
              child: Icon(Icons.shopping_cart_outlined, size: 44, color: AppColors.mainColor),
            ),
            SizedBox(height: 24),
            Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            Text('Add some delicious food to get started', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
            SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(RouteHelper.getInitial()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor, elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Browse Menu', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }

    final subtotal = cart.totalAmount;
    const delivery = 50;
    final total = subtotal + delivery;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(children: [
            GestureDetector(
              onTap: () => Get.offAllNamed(RouteHelper.getInitial()),
              child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
            ),
            SizedBox(width: 10),
            Text('Your Cart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Text('${items.length} item${items.length == 1 ? '' : 's'}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          ]),
          SizedBox(height: 24),

          ...items.map((item) => _buildCartItem(item, cart)),

          SizedBox(height: 16),

          // Promo code
          _card(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.label_outline, color: AppColors.mainColor, size: 20),
                SizedBox(width: 8),
                Text('Promo Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ]),
              SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter code (try SAVE10)',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))),
                  ),
                ),
              ]),
            ],
          )),

          SizedBox(height: 16),

          // Order summary
          _card(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ORDER SUMMARY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 1.2)),
              SizedBox(height: 14),
              _row('Subtotal', 'KSh $subtotal'),
              SizedBox(height: 8),
              _row('Delivery Fee', 'KSh $delivery'),
              Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.grey.shade100)),
              _row('Total', 'KSh $total', bold: true, valueColor: AppColors.mainColor),
            ],
          )),

          SizedBox(height: 24),
          _actionBtn('Continue to Address', Icons.arrow_forward_ios, () => setState(() => _step = 1)),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic item, CartController cart) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              AppConstants.BASE_URL + AppConstants.UPLOAD_URL + item.img!,
              width: 64, height: 64, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: Colors.grey.shade200),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(item.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                  GestureDetector(
                    onTap: () => cart.addItem(item.product!, -(item.quantity!)),
                    child: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade400),
                  ),
                ]),
                SizedBox(height: 4),
                Text('KSh ${item.price}', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  _qtyBtn('−', () => cart.addItem(item.product!, -1)),
                  SizedBox(width: 14),
                  Text('${item.quantity}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(width: 14),
                  _qtyBtn('+', () => cart.addItem(item.product!, 1)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 1 — Delivery Address ────────────────────────────────────────────────

  Widget _buildAddressStep(int total) {
    final noteCtrl = TextEditingController();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            GestureDetector(onTap: () => setState(() => _step--), child: Icon(Icons.arrow_back_ios, size: 18)),
            SizedBox(width: 12),
            Expanded(child: _buildStepIndicator(2)),
          ]),
          SizedBox(height: 28),
          Text('Delivery Address', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Where should we bring your order?", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          SizedBox(height: 20),
          ..._addresses.asMap().entries.map((e) => _addressCard(e.key, e.value)),
          SizedBox(height: 8),
          _addAddressCard(),
          SizedBox(height: 20),
          Text('Delivery Note (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: TextField(
              controller: noteCtrl, maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g. Ring the bell twice, blue gate...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.all(16),
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(height: 24),
          GetBuilder<CartController>(builder: (cart) =>
            _actionBtn('Deliver Here · KSh $total', Icons.send_outlined, () => setState(() => _step = 2)),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(int index, Map<String, String> addr) {
    final selected = _selectedAddress == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = index),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Color(0xFFE6FAFA) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.mainColor : Colors.grey.shade200, width: selected ? 1.5 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(addr['icon']!, style: TextStyle(fontSize: 22))),
          ),
          SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(addr['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 2),
              Text(addr['address']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          )),
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.mainColor : Colors.transparent,
              border: Border.all(color: selected ? AppColors.mainColor : Colors.grey.shade300, width: 1.5),
            ),
            child: selected ? Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ]),
      ),
    );
  }

  Widget _addAddressCard() {
    return GestureDetector(
      onTap: () => Get.to(() => const AddressPickerPage()),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.add, size: 16, color: Colors.grey.shade500),
          ),
          SizedBox(width: 12),
          Text('Add a new address', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ]),
      ),
    );
  }

  // ── STEP 2 — Payment ─────────────────────────────────────────────────────────

  Widget _buildPaymentStep(int total) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            GestureDetector(onTap: () => setState(() => _step--), child: Icon(Icons.arrow_back_ios, size: 18)),
            SizedBox(width: 12),
            Expanded(child: _buildStepIndicator(3)),
          ]),
          SizedBox(height: 28),
          Text('Payment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Choose how you'd like to pay", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          SizedBox(height: 20),
          ..._payments.asMap().entries.map((e) => _paymentCard(e.key, e.value)),
          SizedBox(height: 16),
          if (_selectedPayment == 0)
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(color: Color(0xFFE6FAFA), borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(text: TextSpan(
                  children: [
                    TextSpan(text: 'M-Pesa STK Push', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                )),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.teal.shade700, fontSize: 12, height: 1.5),
                    children: [
                      TextSpan(text: 'A payment request of '),
                      TextSpan(text: 'KSh $total', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' will be sent to 07** **** 21. Enter your PIN to confirm.'),
                    ],
                  ),
                ),
              ]),
            ),
          SizedBox(height: 16),
          _card(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount to Pay', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              Text('KSh $total', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          )),
          SizedBox(height: 24),
          _actionBtn('Place Order · KSh $total', Icons.wallet_outlined, () {
            final id = 'ORD-${1000 + Random().nextInt(9000)}';
            setState(() { _orderID = id; _step = 3; });
          }),
        ],
      ),
    );
  }

  Widget _paymentCard(int index, Map<String, String> method) {
    final selected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Color(0xFFE6FAFA) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.mainColor : Colors.grey.shade200, width: selected ? 1.5 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: _paymentIconBg(method['icon']!), borderRadius: BorderRadius.circular(10)),
            child: Icon(_paymentIcon(method['icon']!), color: _paymentIconColor(method['icon']!), size: 22),
          ),
          SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(method['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 2),
              Text(method['detail']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          )),
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.mainColor : Colors.transparent,
              border: Border.all(color: selected ? AppColors.mainColor : Colors.grey.shade300, width: 1.5),
            ),
            child: selected ? Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ]),
      ),
    );
  }

  // ── STEP 3 — Confirmation ────────────────────────────────────────────────────

  Widget _buildConfirmStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          PulsingSignalIcon(size: 80),
          SizedBox(height: 24),
          Text('Order Placed!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              children: [
                TextSpan(text: 'Your food is being prepared. Estimated delivery is '),
                TextSpan(text: '25–30 minutes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                TextSpan(text: '.'),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text('ORDER ID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade400, letterSpacing: 1.5)),
          SizedBox(height: 4),
          Text('#$_orderID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          _card(Column(
            children: _statusSteps.map((s) {
              final done = s['done'] as bool;
              final live = s['live'] as bool;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: done ? AppColors.mainColor : Colors.grey.shade200),
                    child: done ? Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  SizedBox(width: 14),
                  Expanded(child: Text(s['label'] as String,
                    style: TextStyle(fontSize: 14, fontWeight: done ? FontWeight.w600 : FontWeight.normal, color: done ? Colors.black87 : Colors.grey.shade400),
                  )),
                  if (live)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: Color(0xFFE6FAFA), borderRadius: BorderRadius.circular(20)),
                      child: Text('Live', style: TextStyle(color: AppColors.mainColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                ]),
              );
            }).toList(),
          )),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Get.offAllNamed(RouteHelper.getInitial()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Back to Home', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ───────────────────────────────────────────────────────────

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _actionBtn(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _qtyBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
        child: Center(child: Text(label, style: TextStyle(fontSize: 18, color: Colors.black87, height: 1))),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: bold ? Colors.black87 : Colors.grey.shade600, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: bold ? 15 : 13, color: valueColor ?? (bold ? Colors.black87 : Colors.grey.shade800), fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  IconData _paymentIcon(String key) {
    switch (key) {
      case 'mpesa':  return Icons.phone_android;
      case 'visa':   return Icons.credit_card;
      case 'paypal': return Icons.account_balance_wallet_outlined;
      default:       return Icons.money;
    }
  }

  Color _paymentIconBg(String key) {
    switch (key) {
      case 'mpesa':  return Color(0xFFE6FAFA);
      case 'visa':   return Color(0xFFEEF0FF);
      case 'paypal': return Color(0xFFE8F4FD);
      default:       return Color(0xFFFFF8E1);
    }
  }

  Color _paymentIconColor(String key) {
    switch (key) {
      case 'mpesa':  return AppColors.mainColor;
      case 'visa':   return Colors.indigo;
      case 'paypal': return Color(0xFF003087);
      default:       return Colors.orange;
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cart) {
      final total = cart.totalAmount + (cart.getItems.isEmpty ? 0 : 50);

      return Scaffold(
        backgroundColor: Color(0xFFF7F8FA),
        body: Column(
          children: [
            const DesktopTopNav(activeTab: 'cart'),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: IndexedStack(
                      index: _step,
                      children: [
                        _buildCartStep(cart),
                        _buildAddressStep(total),
                        _buildPaymentStep(total),
                        _buildConfirmStep(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
