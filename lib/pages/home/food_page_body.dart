// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommeded_product_controller.dart';
import 'package:food_delivery_app/models/products_model.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  final _pageController = PageController();
  double _currPageValue = 0.0;
  int _selectedCategory = 0;

  // Parallel lists avoid Object→IconData cast issues
  static const _categoryLabels = [
    'All', 'Trending', 'Healthy', 'Breakfast', 'Meat', 'Seafood', 'Vegan'
  ];
  static const _categoryIcons = <IconData>[
    Icons.grid_view_rounded,
    Icons.local_fire_department_outlined,
    Icons.eco_outlined,
    Icons.coffee_outlined,
    Icons.set_meal_outlined,
    Icons.water_outlined,
    Icons.spa_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _currPageValue = _pageController.page ?? 0.0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroCarousel(),
        SizedBox(height: 16),
        if (!isDesktop) ...[
          _buildCategoryChips(),
          SizedBox(height: 20),
        ] else
          SizedBox(height: 8),
        _buildRecommendedHeader(),
        SizedBox(height: 12),
        _buildRecommendedGrid(screenWidth),
        SizedBox(height: 24),
      ],
    );
  }

  // ── Hero carousel ──────────────────────────────────────────────────────────

  Widget _buildHeroCarousel() {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final height = screenWidth >= 768 ? 288.0 : 208.0;
      return GetBuilder<PopularProductController>(builder: (ctrl) {
        if (!ctrl.isloaded) {
          return SizedBox(
            height: height,
            child: Center(
                child: CircularProgressIndicator(color: AppColors.mainColor)),
          );
        }
        final count = ctrl.popularProductList.length;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: height,
              child: PageView.builder(
                controller: _pageController,
                itemCount: count,
                itemBuilder: (_, i) => _buildHeroItem(
                  i,
                  ctrl.popularProductList[i],
                  _currPageValue,
                  count,
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  Widget _buildHeroItem(
      int index, ProductModel product, double currPage, int dotsCount) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.getPopularFood(index, "home")),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.78)
              ],
              stops: [0.35, 1.0],
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Text(
                product.name!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              // Stats row with dots pushed to the right end
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text('4.5 (1287)',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(width: 14),
                  Icon(Icons.location_on_outlined,
                      color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text('5.7km',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(width: 14),
                  Icon(Icons.access_time, color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text('30min',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                  Spacer(),
                  DotsIndicator(
                    dotsCount: dotsCount < 1 ? 1 : dotsCount,
                    position: currPage,
                    decorator: DotsDecorator(
                      color: Colors.white.withValues(alpha: 0.45),
                      activeColor: Colors.white,
                      size: Size.square(6),
                      activeSize: Size(16, 6),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Category chips ─────────────────────────────────────────────────────────

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categoryLabels.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: selected ? AppColors.mainColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      selected ? AppColors.mainColor : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _categoryIcons[i],
                    size: 15,
                    color:
                        selected ? Colors.white : Colors.grey.shade600,
                  ),
                  SizedBox(width: 6),
                  Text(
                    _categoryLabels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Recommended header ─────────────────────────────────────────────────────

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Food pairing',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.tune, size: 16, color: AppColors.mainColor),
              SizedBox(width: 4),
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Recommended grid ───────────────────────────────────────────────────────

  Widget _buildRecommendedGrid(double screenWidth) {
    return GetBuilder<RecommendedProductController>(builder: (ctrl) {
      if (!ctrl.isloaded) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppColors.mainColor),
          ),
        );
      }

      final cols = screenWidth > 900 ? 3 : screenWidth > 600 ? 2 : 1;

      if (cols == 1) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: ctrl.recommendedProductList.length,
          separatorBuilder: (_, __) => SizedBox(height: 16),
          itemBuilder: (_, i) =>
              _buildFoodCard(i, ctrl.recommendedProductList[i]),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisExtent: 290,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: ctrl.recommendedProductList.length,
          itemBuilder: (_, i) =>
              _buildFoodCard(i, ctrl.recommendedProductList[i]),
        ),
      );
    });
  }

  // ── Food card ──────────────────────────────────────────────────────────────

  Widget _buildFoodCard(int index, ProductModel product) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(RouteHelper.getRecommendedFood(index, "home")),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Image.network(
                      AppConstants.BASE_URL +
                          AppConstants.UPLOAD_URL +
                          product.img!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      'Normal',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.favorite_border,
                        size: 15, color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'KSh ${product.price}',
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Text(
                    product.description ?? 'Freshly prepared',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
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
                              fontSize: 12,
                              color: Colors.grey.shade700)),
                      SizedBox(width: 10),
                      Icon(Icons.location_on_outlined,
                          color: AppColors.mainColor, size: 13),
                      SizedBox(width: 3),
                      Text('1.7km',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700)),
                      SizedBox(width: 10),
                      Icon(Icons.access_time,
                          color: Colors.grey.shade400, size: 13),
                      SizedBox(width: 3),
                      Text('22min',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700)),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Get.find<CartController>().addItem(product, 1),
                      icon: Icon(Icons.shopping_cart_outlined, size: 13, color: Colors.white),
                      label: Text('Add to Cart',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
