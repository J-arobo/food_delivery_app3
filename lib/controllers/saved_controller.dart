import 'package:food_delivery_app/models/products_model.dart';
import 'package:get/get.dart';

class SavedController extends GetxController {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);
  int get count => _items.length;

  bool isSaved(int id) => _items.any((p) => p.id == id);

  void toggle(ProductModel product) {
    if (isSaved(product.id!)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    update();
  }
}
