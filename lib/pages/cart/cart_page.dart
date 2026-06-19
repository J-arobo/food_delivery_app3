import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/common_text_button.dart';
import 'package:food_delivery_app/base/no_data_page.dart';
import 'package:food_delivery_app/base/show_custom_snackbar.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/location_controller.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommeded_product_controller.dart';
import 'package:food_delivery_app/controllers/user_controller.dart';
import 'package:food_delivery_app/models/place_order_model.dart';
import 'package:food_delivery_app/pages/home/main_food_page.dart';
import 'package:food_delivery_app/pages/order/delivery_option.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/utils/styles.dart';
import 'package:food_delivery_app/widgets/app_icon.dart';
import 'package:food_delivery_app/widgets/app_text_field.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/pages/order/payment_option_button.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
    return Scaffold(
        body: Stack(
          //stack is easier than column(less errors)
          children: [
            //header
            Positioned(
              top: Dimensions.height20 * 3,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width20 * 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getInitial());
                    },
                    child: AppIcon(
                      icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  AppIcon(
                    icon: Icons.shopping_cart,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  )
                ],
              ),
            ),
            GetBuilder<CartController>(builder: (_cartController) {
              return _cartController.getItems.length > 0
                  ? Positioned(
                      //positioned bcoz we want to make the place scrallable
                      top: Dimensions.height20 * 5,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: 0,
                      child: Container(
                          margin: EdgeInsets.only(top: Dimensions.height15),
                          //color: Colors.red,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GetBuilder<CartController>(
                                builder: (CartController) {
                              var _cartList = CartController.getItems;
                              return ListView.builder(
                                  itemCount: _cartList.length,
                                  itemBuilder: (_, index) {
                                    return Container(
                                      width: double.maxFinite,
                                      height: Dimensions.height20 * 5,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              var popularIndex = Get.find<
                                                      PopularProductController>()
                                                  .popularProductList
                                                  .indexOf(_cartList[index]
                                                      .product!);
                                              if (popularIndex >= 0) {
                                                Get.toNamed(
                                                    RouteHelper.getPopularFood(
                                                        popularIndex,
                                                        "cartpage"));
                                              } else {
                                                var recommendedIndex = Get.find<
                                                        RecommendedProductController>()
                                                    .recommendedProductList
                                                    .indexOf(_cartList[index]
                                                        .product!);
                                                if (recommendedIndex < 0) {
                                                  Get.snackbar(
                                                    "History product",
                                                    "Product review is not available for history products",
                                                    backgroundColor:
                                                        AppColors.mainColor,
                                                    colorText: Colors.white,
                                                  );
                                                } else {
                                                  Get.toNamed(RouteHelper
                                                      .getRecommendedFood(
                                                          recommendedIndex,
                                                          "cartpage"));
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: Dimensions.height20 * 5,
                                              height: Dimensions.height20 * 5,
                                              margin: EdgeInsets.only(
                                                  bottom: Dimensions.height10),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          AppConstants
                                                                  .BASE_URL +
                                                              AppConstants
                                                                  .UPLOAD_URL +
                                                              CartController
                                                                  .getItems[
                                                                      index]
                                                                  .img!)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius20),
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimensions.width10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: Dimensions.height20 * 5,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    BigText(
                                                      text: CartController
                                                          .getItems[index]
                                                          .name!,
                                                      color: Colors.black54,
                                                    ),
                                                    SmallText(text: "Spicy"),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        BigText(
                                                          text: CartController
                                                              .getItems[index]
                                                              .price
                                                              .toString(),
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(
                                                              top: Dimensions
                                                                  .height10,
                                                              bottom: Dimensions
                                                                  .height10,
                                                              left: Dimensions
                                                                  .width10,
                                                              right: Dimensions
                                                                  .width10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Dimensions
                                                                          .radius20),
                                                              color:
                                                                  Colors.white),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  CartController.addItem(
                                                                      _cartList[
                                                                              index]
                                                                          .product!,
                                                                      -1);
                                                                },
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: AppColors
                                                                      .signColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: Dimensions
                                                                        .width10 /
                                                                    2,
                                                              ),
                                                              BigText(
                                                                  text: _cartList[
                                                                          index]
                                                                      .quantity
                                                                      .toString()), // popularProduct.inCartItems.toString()),
                                                              SizedBox(
                                                                width: Dimensions
                                                                        .width10 /
                                                                    2,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  CartController.addItem(
                                                                      _cartList[
                                                                              index]
                                                                          .product!,
                                                                      1);
                                                                  print(
                                                                      "being tapped");
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: AppColors
                                                                      .signColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }),
                          )))
                  : NoDataPage(text: "Your cart is empty!");
            })
          ],
        ),
        bottomNavigationBar:
            GetBuilder<OrderController>(builder: (orderController) {
          _noteController.text = orderController.foodnote;
          return GetBuilder<CartController>(builder: (cartController) {
            return Container(
              padding: EdgeInsets.only(
                  top: Dimensions.height10,
                  bottom: Dimensions.height10,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2),
                ),
              ),
              child: cartController.getItems.length > 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (_) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.9,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                        topRight: Radius
                                                            .circular(Dimensions
                                                                .radius20))),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions
                                                              .width20,
                                                          right: Dimensions
                                                              .width20,
                                                          top: Dimensions
                                                              .height20),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const PaymentOptionButton(
                                                            icon: Icons.money,
                                                            title:
                                                                'cash on delivery',
                                                            subTitle:
                                                                'you pay after getting the delivery',
                                                            index: 0,
                                                          ),
                                                          SizedBox(
                                                            height: Dimensions
                                                                .height10,
                                                          ),
                                                          const PaymentOptionButton(
                                                            icon: Icons
                                                                .paypal_outlined,
                                                            title:
                                                                'digital payment',
                                                            subTitle:
                                                                'safer and faster way of payment',
                                                            index: 1,
                                                          ),
                                                          SizedBox(
                                                            height: Dimensions
                                                                .height30,
                                                          ),

                                                          //calling delivery options
                                                          Text(
                                                            'Delivery options',
                                                            style: robotoMedium,
                                                          ),
                                                          SizedBox(
                                                            height: Dimensions
                                                                    .height10 /
                                                                2,
                                                          ),
                                                          //home delivery
                                                          DeliveryOptions(
                                                              value: "delivery",
                                                              title:
                                                                  "home delivery",
                                                              amount: double.parse(Get
                                                                      .find<
                                                                          CartController>()
                                                                  .totalAmount
                                                                  .toString()),
                                                              isFree: false),
                                                          SizedBox(
                                                            height: Dimensions
                                                                    .height10 /
                                                                2,
                                                          ),
                                                          //take away
                                                          const DeliveryOptions(
                                                              value:
                                                                  "take away",
                                                              title:
                                                                  "take away",
                                                              amount: 10.0,
                                                              isFree: true),
                                                          SizedBox(
                                                            height: Dimensions
                                                                .height20,
                                                          ),
                                                          //Additional info
                                                          Text(
                                                            'Additional info',
                                                            style: robotoMedium,
                                                          ),
                                                          AppTextField(
                                                            textController:
                                                                _noteController,
                                                            hintText: '',
                                                            icon: Icons.note,
                                                            maxLines: true,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                              .whenComplete(() => orderController
                                  .setFoodNote(_noteController.text.trim())),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: CommonTextButton(text: "payment options"),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: Dimensions.height20,
                                  bottom: Dimensions.height20,
                                  left: Dimensions.width20,
                                  right: Dimensions.width20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: Dimensions.width10 / 2,
                                  ),
                                  BigText(
                                      text: "\$ " +
                                          cartController.totalAmount
                                              .toString()),
                                  SizedBox(
                                    width: Dimensions.width10 / 2,
                                  ),
                                ],
                              ),
                            ),
                            //sending to the backend
                            GestureDetector(
                              onTap: () async {
                                if (Get.find<AuthController>().userLoggerIn()) {
                                  await Get.find<AuthController>().updateToken();
                                  if (Get.find<LocationController>()
                                      .addressList
                                      .isEmpty) {
                                    Get.toNamed(RouteHelper.getAddressPage());
                                  } else {
                                    var location =
                                        Get.find<LocationController>()
                                            .getUserAddress();
                                    var cart =
                                        Get.find<CartController>().getItems;
                                    var user =
                                        Get.find<UserController>().userModel;
                                    PlaceOrderBody placeOrder = PlaceOrderBody(
                                        cart: cart,
                                        orderAmount: 100.0,
                                        orderNote: orderController.foodnote,
                                        address: location.address,
                                        latitude: location.latitude,
                                        longitude: location.longitude,
                                        contactPersonNumber: user!.phone,
                                        contactPersonName: user!.name,
                                        scheduledAt: '',
                                        distance: 10.0,
                                        orderType: orderController.orderType,
                                        paymentMethod:
                                            orderController.paymentIndex == 0
                                                ? 'cash_on_delivery'
                                                : 'digital_payment');
                                    /*
                                        //FOR DEBUGGING
                                    print("My type is " + placeOrder.toJson()['order_type']);
                                    //order_type is from place order model
                                    print(placeOrder.toJson());
                                    return;
                                    */
                                    Get.find<OrderController>()
                                        .placeOrder(placeOrder, _callback);
                                  }
                                } else {
                                  Get.toNamed(RouteHelper.getSignInPage());
                                }
                              },
                              child: const CommonTextButton(
                                text: "check out",
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container(),
            );
          });
        }));
  }

  void _callback(bool isSuccess, String message, String orderID) {
    if (isSuccess) {
      Get.find<CartController>().clear();
      Get.find<CartController>().removeCartSharedPreference();
      Get.find<CartController>().addToHistory();
      //choosing which page to go
      if (Get.find<OrderController>().paymentIndex == 0) {
        Get.offNamed(RouteHelper.getOrderSuccessPage(orderID, "success"));
      } else {
        Get.offNamed(RouteHelper.getPaymentPage(
            orderID, Get.find<UserController>().userModel!.id));
      }
    } else {
      showCustomSnackBar(message);
    }
  }
}
