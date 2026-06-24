// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommeded_product_controller.dart';
import 'package:food_delivery_app/pages/home/food_page_body.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/controllers/recommeded_product_controller.dart';
import 'package:food_delivery_app/models/products_model.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';


class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  _MainFoodPageState createState() => _MainFoodPageState();
}



class _MainFoodPageState extends State<MainFoodPage> {
  int _selectedSidebarCategory = 0;

  static const _categoryLabels = [
    'All', 'Trending', 'Healthy', 'Breakfast', 'Meat', 'Seafood', 'Vegan',
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

  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConstructionDialog();
    });
  }

  void _showConstructionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFF00695C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction_rounded, color: Colors.white, size: 52),
              SizedBox(height: 20),
              Text(
                "Still Building!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato",
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Some features may not be fully available yet — check back soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: "Lato",
                  ),
                ),
              ),
              SizedBox(height: 28),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Got it",
                    style: TextStyle(
                      color: Color(0xFF00695C),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    final header = Container(
      margin: EdgeInsets.only(
          top: Dimensions.height45, bottom: Dimensions.height15),
      padding: EdgeInsets.only(
          left: Dimensions.width20, right: Dimensions.width20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              BigText(text: "Kenya", color: AppColors.mainColor),
              Row(
                children: [
                  SmallText(text: "Nairobi", color: Colors.black54),
                  Icon(Icons.arrow_drop_down_rounded)
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: FoodSearchDelegate());
            },
            child: Center(
              child: Container(
                width: Dimensions.height45,
                height: Dimensions.height45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  color: AppColors.mainColor,
                ),
                child: Icon(Icons.search,
                    color: Colors.white, size: Dimensions.iconSize24),
              ),
            ),
          ),
        ],
      ),
    );

    if (isDesktop) {
      return RefreshIndicator(
        onRefresh: _loadResource,
        child: Column(
          children: [
            header,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: SingleChildScrollView(
                      child: _buildDesktopSidebar(),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(child: FoodPageBody()),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResource,
      child: Column(
        children: [
          header,
          Expanded(
            child: SingleChildScrollView(child: FoodPageBody()),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CATEGORIES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12),
          ..._categoryLabels.asMap().entries.map((e) {
            final i = e.key;
            final selected = _selectedSidebarCategory == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedSidebarCategory = i),
              child: Container(
                margin: EdgeInsets.only(bottom: 4),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.mainColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _categoryIcons[i],
                      size: 18,
                      color: selected ? AppColors.mainColor : Colors.grey.shade600,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _categoryLabels[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected ? AppColors.mainColor : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

//Searching for food
class FoodSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search food...';

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type to search for food'));
    }

    final popular = Get.find<PopularProductController>()
        .popularProductList
        .where((p) => p.name!.toLowerCase().contains(query.toLowerCase()))
        .map((p) => MapEntry('popular', p))
        .toList();

    final recommended = Get.find<RecommendedProductController>()
        .recommendedProductList
        .where((p) => p.name!.toLowerCase().contains(query.toLowerCase()))
        .map((p) => MapEntry('recommended', p))
        .toList();

    final all = [...popular, ...recommended];

    if (all.isEmpty) return Center(child: Text('No results for "$query"'));

    return ListView.builder(
      itemCount: all.length,
      itemBuilder: (context, index) {
        final product = all[index].value;
        final type = all[index].key;
        return ListTile(
          leading: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(AppConstants.BASE_URL +
                    AppConstants.UPLOAD_URL + product.img!),
              ),
            ),
          ),
          title: Text(product.name!),
          subtitle: Text('\$ ${product.price}',
              style: TextStyle(color: AppColors.mainColor)),
          onTap: () {
            close(context, null);
            if (type == 'popular') {
              final idx = Get.find<PopularProductController>()
                  .popularProductList.indexOf(product);
              Get.toNamed(RouteHelper.getPopularFood(idx, 'home'));
            } else {
              final idx = Get.find<RecommendedProductController>()
                  .recommendedProductList.indexOf(product);
              Get.toNamed(RouteHelper.getRecommendedFood(idx, 'home'));
            }
          },
        );
      },
    );
  }
}
