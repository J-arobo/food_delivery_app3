// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/widgets/desktop_top_nav.dart';
import 'package:food_delivery_app/controllers/saved_controller.dart';
import 'package:food_delivery_app/models/products_model.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

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

  Widget _buildEmptyState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(color: Color(0xFFFFF0F0), shape: BoxShape.circle),
            child: Icon(Icons.favorite_border, color: Colors.redAccent.shade100, size: 40),
          ),
          SizedBox(height: 20),
          Text('No saved items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Tap the heart on any dish to save it here.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSavedCard(ProductModel product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey.shade200),
                  ),
                ),
              ),
              // Label badge
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                  child: Text('Normal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ),
              // Heart button (filled red)
              Positioned(
                top: 10, right: 10,
                child: GetBuilder<SavedController>(builder: (saved) =>
                  GestureDetector(
                    onTap: () => saved.toggle(product),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 6)],
                      ),
                      child: Icon(
                        saved.isSaved(product.id!) ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(product.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(width: 8),
                    Text('KSh ${product.price}', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  product.description ?? 'Freshly prepared',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text('${product.stars ?? 4}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    SizedBox(width: 14),
                    Icon(Icons.location_on_outlined, color: AppColors.mainColor, size: 14),
                    SizedBox(width: 4),
                    Text('1.7km', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    SizedBox(width: 14),
                    Icon(Icons.access_time, color: Colors.grey.shade400, size: 14),
                    SizedBox(width: 4),
                    Text('22min', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.find<CartController>().addItem(product, 1),
                    icon: Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.white),
                    label: Text('Add to Cart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SavedController>(builder: (saved) {
      final items = saved.items;
      return Scaffold(
        backgroundColor: Color(0xFFF7F8FA),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              MediaQuery.of(context).size.width > 900
                  ? const DesktopTopNav(activeTab: 'saved')
                  : _buildHeader(),
              if (items.isEmpty)
                _buildEmptyState()
              else ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Row(
                    children: [
                      Text('Saved Items', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 2, 20, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${items.length} dish${items.length == 1 ? '' : 'es'} saved',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _buildSavedCard(items[i]),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
