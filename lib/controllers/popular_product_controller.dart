import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/data/repository/popular_product_repo.dart';
import 'package:food_delivery_app/models/cart_model.dart';
import 'package:food_delivery_app/models/products_model.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});
  // you cant call it directly from UI because it is private ('the _ rep private var')
  List<ProductModel> _popularProductList = [];
  List<ProductModel> get popularProductList => _popularProductList;
  late CartController _cart;

  bool _isloaded = false;
  bool get isloaded => _isloaded;

  // var quality here is in local scope
  int _quantity = 0;
  int get quantity => _quantity; //arrow function/fat arrow
  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;

  Future<void> getPopularProductList() async {
    // await because get returns a future type
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode == 200) {
      //most of apiclient http client return a status code of 200 if the response successful
      _popularProductList = [];
      // repsonse returns a model type of data, this converts it to a model
      _popularProductList.addAll(Product.fromJson(response.body).products);
      _isloaded = true;
      update();
    } else {}
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      //print("increment " + _quantity.toString());
      _quantity = checkQuantity(_quantity + 1);
      //print("number of items " + _quantity.toString());
    } else {
      _quantity = _quantity = checkQuantity(_quantity - 1);
      //print("decrement " + _quantity.toString());
    }
    update();
  }

  // var quality here is in local scope - local scope gets priority over global scope
  // _inCartItems
  int checkQuantity(int quantity) {
    if ((_inCartItems + quantity) < 0) {
      Get.snackbar(
        "Item count",
        "You cant reduce more !",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    } else if ((_inCartItems + quantity) > 20) {
      Get.snackbar(
        "Item count",
        "You cant add more !",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductModel product, cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    var exist = false;
    exist = _cart.existInCart(product);

    //if exist
    //get from storage & store in _inCartItems=3
    //print("exist or not " + exist.toString());
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }
    //print("the quantity in the cart is " + inCartItems.toString());
  }

  void addItem(ProductModel product) {
    if (_quantity > 0) {
      _cart.addItem(product, _quantity);
      Get.snackbar(
        "Added to cart",
        "${product.name} has been added to your cart!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
    }
    _quantity = 0;
    _inCartItems = _cart.getQuantity(product);

    _cart.items.forEach((key, value) {
      print("The id is " +
          value.id.toString() +
          " The quantity is " +
          value.quantity.toString());
    });
    update();
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }
}
