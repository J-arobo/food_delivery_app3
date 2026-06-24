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
  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  Widget build(BuildContext context) {
    // to check height of deviceprint("current height is "+MediaQuery.of(context).size.height.toString());
    return RefreshIndicator(
        onRefresh: _loadResource,
        child: Column(
          children: [
            //showing the header
            Container(
              child: Container(
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
                        showSearch(
                          context: context,
                          delegate: FoodSearchDelegate(),
                        );
                      },
                      child: Center(
                        child: Container(
                          width: Dimensions.height45,
                          height: Dimensions.height45,
                          child: Icon(Icons.search,
                              color: Colors.white, size: Dimensions.iconSize24),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius15),
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //showing the body
            Expanded(
                child: SingleChildScrollView(
              child: FoodPageBody(),
            ))
          ],
        ));
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
