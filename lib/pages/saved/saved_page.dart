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
              Text('Saved Items',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87)),
              Text('Your favourite dishes',
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Color(0xFFE6FAFA), shape: BoxShape.circle),
            child:
                Icon(Icons.favorite_border, color: AppColors.mainColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                  color: Color(0xFFFFF0F0), shape: BoxShape.circle),
              child: Icon(Icons.favorite_border,
                  color: Colors.redAccent.shade100, size: 40),
            ),
            SizedBox(height: 20),
            Text('No saved items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tap the heart on any dish to save it here.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCard(ProductModel product, {bool compact = false}) {
    final imgHeight = compact ? 160.0 : 200.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: imgHeight,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.network(
                    AppConstants.BASE_URL +
                        AppConstants.UPLOAD_URL +
                        product.img!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.restaurant, color: Colors.grey.shade400, size: 32),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4)
                    ],
                  ),
                  child: Text('Normal',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GetBuilder<SavedController>(
                  builder: (saved) => GestureDetector(
                    onTap: () => saved.toggle(product),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6)
                        ],
                      ),
                      child: Icon(
                        saved.isSaved(product.id!)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(product.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(width: 8),
                    Text('KSh ${product.price}',
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  product.description ?? 'Freshly prepared',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 13),
                    SizedBox(width: 3),
                    Text('${product.stars ?? 4}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                    SizedBox(width: 10),
                    Icon(Icons.location_on_outlined,
                        color: AppColors.mainColor, size: 13),
                    SizedBox(width: 3),
                    Text('1.7km',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                    SizedBox(width: 10),
                    Icon(Icons.access_time,
                        color: Colors.grey.shade400, size: 13),
                    SizedBox(width: 3),
                    Text('22min',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Get.find<CartController>().addItem(product, 1),
                    icon: Icon(Icons.shopping_cart_outlined,
                        size: 14, color: Colors.white),
                    label: Text('Add to Cart',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isTablet = screenWidth > 600;
    final cols = isDesktop ? 3 : (isTablet ? 2 : 1);
    final useGrid = cols > 1;

    return GetBuilder<SavedController>(builder: (saved) {
      final items = saved.items;
      return Scaffold(
        backgroundColor: Color(0xFFF7F8FA),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isDesktop
                  ? const DesktopTopNav(activeTab: 'saved')
                  : _buildHeader(),
              if (items.isEmpty)
                _buildEmptyState()
              else ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
                  child: Text('Saved Items',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 2, 20, 14),
                  child: Text(
                      '${items.length} dish${items.length == 1 ? '' : 'es'} saved',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13)),
                ),
                Expanded(
                  child: useGrid
                      ? GridView.builder(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols,
                            mainAxisExtent: 320,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: items.length,
                          itemBuilder: (_, i) =>
                              _buildSavedCard(items[i], compact: true),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => SizedBox(height: 16),
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
