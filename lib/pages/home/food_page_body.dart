// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommeded_product_controller.dart';
import 'package:food_delivery_app/models/products_model.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
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

  final _categories = <Map<String, Object>>[
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Trending', 'icon': Icons.local_fire_department_outlined},
    {'label': 'Healthy', 'icon': Icons.eco_outlined},
    {'label': 'Breakfast', 'icon': Icons.coffee_outlined},
    {'label': 'Meat', 'icon': Icons.set_meal_outlined},
    {'label': 'Seafood', 'icon': Icons.water_outlined},
    {'label': 'Vegan', 'icon': Icons.spa_outlined},
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
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 700;

      final column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCarousel(constraints.maxWidth),
          SizedBox(height: 16),
          _buildCategoryChips(),
          SizedBox(height: 20),
          _buildRecommendedHeader(),
          SizedBox(height: 12),
          _buildRecommendedGrid(),
          SizedBox(height: 24),
        ],
      );

      if (isDesktop) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 900),
            child: column,
          ),
        );
      }
      return column;
    });
  }

  // ── Hero carousel ──────────────────────────────────────────────────────────

  Widget _buildHeroCarousel(double availableWidth) {
    final height = (availableWidth * 0.55).clamp(220.0, 340.0);
    return GetBuilder<PopularProductController>(builder: (ctrl) {
      if (!ctrl.isloaded) {
        return SizedBox(
          height: height,
          child: Center(
              child: CircularProgressIndicator(color: AppColors.mainColor)),
        );
      }
      return SizedBox(
        height: height,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: ctrl.popularProductList.length,
              itemBuilder: (_, i) =>
                  _buildHeroItem(i, ctrl.popularProductList[i]),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: DotsIndicator(
                  dotsCount: ctrl.popularProductList.isEmpty
                      ? 1
                      : ctrl.popularProductList.length,
                  position: _currPageValue,
                  decorator: DotsDecorator(
                    color: Colors.white.withValues(alpha: 0.5),
                    activeColor: Colors.white,
                    size: Size.square(7),
                    activeSize: Size(18, 7),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeroItem(int index, ProductModel product) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.getPopularFood(index, "home")),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text('4.5 (1287)',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(width: 14),
                  Icon(Icons.location_on_outlined,
                      color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text('5.7km',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(width: 14),
                  Icon(Icons.access_time, color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text('30min',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
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
      height: 38,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.mainColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppColors.mainColor
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _categories[i]['icon'] as IconData,
                    size: 14,
                    color: selected ? Colors.white : Colors.grey.shade600,
                  ),
                  SizedBox(width: 6),
                  Text(
                    _categories[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          selected ? Colors.white : Colors.grey.shade700,
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

  Widget _buildRecommendedGrid() {
    return GetBuilder<RecommendedProductController>(builder: (ctrl) {
      if (!ctrl.isloaded) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppColors.mainColor),
          ),
        );
      }
      return LayoutBuilder(builder: (context, constraints) {
        final cols = constraints.maxWidth > 900
            ? 3
            : constraints.maxWidth > 560
                ? 2
                : 1;

        if (cols == 1) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            itemCount: ctrl.recommendedProductList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (_, i) =>
                _buildFoodCard(i, ctrl.recommendedProductList[i]),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 0.78,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: ctrl.recommendedProductList.length,
            itemBuilder: (_, i) =>
                _buildFoodCard(i, ctrl.recommendedProductList[i]),
          ),
        );
      });
    });
  }

  // ── Food card ──────────────────────────────────────────────────────────────

  Widget _buildFoodCard(int index, ProductModel product) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.getRecommendedFood(index, "home")),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    product.description ?? 'With Chinese characteristics',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
