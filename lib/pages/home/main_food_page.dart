// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommeded_product_controller.dart';
import 'package:food_delivery_app/pages/home/food_page_body.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';


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

  static const _popularSpots = <Map<String, String>>[
    {'name': "Mama's Kitchen", 'cuisine': 'Kenyan', 'time': '20min', 'img': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200&q=80'},
    {'name': 'Nairobi Grill',  'cuisine': 'BBQ',    'time': '25min', 'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200&q=80'},
    {'name': 'Spice Route',    'cuisine': 'Indian', 'time': '30min', 'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200&q=80'},
  ];

  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  void initState() {
    super.initState();
    _loadResource();
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
            _buildDesktopTopNav(context),
            Expanded(
              child: Container(
                color: const Color(0xFFF7F8FA),
                child: LayoutBuilder(builder: (ctx, constraints) {
                  final bodyWidth = constraints.maxWidth.clamp(0.0, 1400.0);
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: bodyWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left sidebar
                          Container(
                            width: 220,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: _buildDesktopSidebar(),
                            ),
                          ),
                          // Center content
                          Expanded(
                            child: SingleChildScrollView(child: FoodPageBody()),
                          ),
                          // Right panel
                          _buildRightPanel(),
                        ],
                      ),
                    ),
                  );
                }),
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

  Widget _buildDesktopTopNav(BuildContext context) {
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
          Text(
            'katqa',
            style: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(width: 20),
          // Location chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.location_on, size: 13, color: AppColors.mainColor),
              SizedBox(width: 4),
              Text('Nairobi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
              SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey.shade500),
            ]),
          ),
          SizedBox(width: 16),
          // Search bar — Flexible(loose) so maxWidth is actually respected
          Flexible(
            fit: FlexFit.loose,
            child: GestureDetector(
              onTap: () => showSearch(context: context, delegate: FoodSearchDelegate()),
              child: Container(
                height: 40,
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F3F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Icon(Icons.search, size: 16, color: Colors.grey.shade400),
                  SizedBox(width: 8),
                  Text('Search food, restaurants…',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
            ),
          ),
          Spacer(),
          // Nav buttons
          _topNavBtn(Icons.home_outlined, 'Home', true),
          GetBuilder<CartController>(builder: (cart) =>
            _topNavBtn(Icons.shopping_cart_outlined, 'Cart', false, badge: cart.totalItems),
          ),
          _topNavBtn(Icons.favorite_border, 'Saved', false),
          _topNavBtn(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _topNavBtn(IconData icon, String label, bool active, {int badge = 0}) {
    final btn = TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: active ? AppColors.mainColor : Colors.grey.shade600),
      label: Text(label, style: TextStyle(fontSize: 13, color: active ? AppColors.mainColor : Colors.grey.shade600, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      style: TextButton.styleFrom(
        backgroundColor: active ? Color(0xFFE6FAFA) : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    if (badge <= 0) return Container(margin: EdgeInsets.only(left: 4), child: btn);
    return Container(
      margin: EdgeInsets.only(left: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          btn,
          Positioned(
            top: -2, right: -4,
            child: Container(
              width: 18, height: 18,
              decoration: BoxDecoration(color: AppColors.mainColor, shape: BoxShape.circle),
              child: Center(child: Text('$badge', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade100)),
      ),
      child: GetBuilder<CartController>(builder: (cart) {
        final items = cart.getItems;
        final subtotal = cart.totalAmount;
        const deliveryFee = 50;
        final total = subtotal + (items.isEmpty ? 0 : deliveryFee);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text('YOUR ORDER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade400, letterSpacing: 1.5)),
            ),
            if (items.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: Color(0xFFE6FAFA), borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.shopping_cart_outlined, color: AppColors.mainColor, size: 24),
                      ),
                      SizedBox(height: 12),
                      Text('Cart is empty', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                      SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Add items from the menu\nto get started', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade400, height: 1.5)),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              AppConstants.BASE_URL + AppConstants.UPLOAD_URL + item.img!,
                              width: 52, height: 52, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: Colors.grey.shade200),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                SizedBox(height: 2),
                                Text('KSh ${item.price}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    _qtyBtn('−', () => cart.addItem(item.product!, -1)),
                                    SizedBox(width: 8),
                                    Text('${item.quantity}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    SizedBox(width: 8),
                                    _qtyBtn('+', () => cart.addItem(item.product!, 1)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade100))),
                child: Column(
                  children: [
                    _summaryRow('Subtotal', 'KSh $subtotal'),
                    SizedBox(height: 6),
                    _summaryRow('Delivery Fee', 'KSh $deliveryFee'),
                    SizedBox(height: 6),
                    Divider(color: Colors.grey.shade100),
                    SizedBox(height: 4),
                    _summaryRow('Total', 'KSh $total', bold: true),
                    SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity, height: 42,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (Get.find<AuthController>().userLoggerIn()) {
                            Get.toNamed(RouteHelper.getCartPage());
                          } else {
                            Get.toNamed(RouteHelper.getSignInPage());
                          }
                        },
                        icon: Icon(Icons.shopping_cart_outlined, size: 15, color: Colors.white),
                        label: Text(
                          Get.find<AuthController>().userLoggerIn()
                              ? 'Proceed to Checkout'
                              : 'Sign in to Checkout',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Promo code', hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 34, width: 54,
                          decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(8)),
                          child: Center(child: Text('Apply', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500))),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _qtyBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(6)),
        child: Center(child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1))),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: bold ? Colors.grey.shade800 : Colors.grey.shade500, fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: bold ? 13 : 12, color: bold ? AppColors.mainColor : Colors.grey.shade800, fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ],
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
          SizedBox(height: 24),
          Text(
            'POPULAR SPOTS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade400,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 12),
          ..._popularSpots.map((spot) => Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    spot['img']!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 40, height: 40,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.restaurant, size: 20, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(spot['name']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800), overflow: TextOverflow.ellipsis),
                      Text('${spot['cuisine']} · ${spot['time']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 14, color: Colors.grey.shade300),
              ],
            ),
          )),
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
