import 'package:food_delivery_app/data/repository/order_repo.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/place_order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  OrderRepo orderRepo;
  OrderController({required this.orderRepo});
  bool _isLoading = false;
  List<OrderModel> _currentOrderList = [];
  List<OrderModel> _historyOrderList = [];

  bool get isLoading => _isLoading;
  List<OrderModel> get currentOrderList => _currentOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;
  String _orderType = "delivery";
  String get orderType => _orderType;

  String _foodnote = " ";
  String get foodnote => _foodnote;

  Future<void> placeOrder(PlaceOrderBody placeOrder, Function callback) async {
    _isLoading = true;
    Response response = await orderRepo.placeOrder(placeOrder);
    //callback function
    if (response.statusCode == 200) {
      _isLoading = false;
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID);
      print("success, status code: " + response.statusCode.toString());
    } else {
      print("failed, status code: " + response.statusCode.toString());
      print("failed, response body: " + response.body.toString());
      callback(false, response.statusText!, '-1');
    }
  }

  //getting all orders
  Future<void> getOrderList() async {
    _isLoading = true;
    Response response = await orderRepo.getOrderList();
    if (response.statusCode == 200) {
      _historyOrderList = []; // cleaning the list from server
      _currentOrderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        //chceking the status of certain orders
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'accepted' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'handover' ||
            orderModel.orderStatus == 'picked_up') {
          _currentOrderList.add(orderModel);
        } else {
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      _historyOrderList = [];
      _currentOrderList = [];
    }
    _isLoading = false;
    //print("The length of current orders " + _currentOrderList.length.toString());
    /* history orders - completed ones */
    //print("The length of history orders " + _historyOrderList.length.toString());
    update();
  }

  //selecting payment method
  void setPaymentIndex(int index) {
    _paymentIndex = index;
    update();
  }

  //shifting between home and take away
  void setDeliveryType(String type) {
    _orderType = type;
    update();
  }

  //displaying additional info
  void setFoodNote(String note) {
    _foodnote = note;
  }
}
