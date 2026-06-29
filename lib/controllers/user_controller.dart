import 'package:food_delivery_app/data/repository/user_repo.dart';
import 'package:food_delivery_app/models/response_model.dart';
import 'package:food_delivery_app/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({required this.userRepo});

  bool _isLoading = false;
  bool _hasFailed = false;
  UserModel? _userModel;
  bool get isLoading => _isLoading;
  bool get hasFailed => _hasFailed;
  UserModel? get userModel => _userModel;

  Future<ResponseModel> getUserInfo() async {
    _hasFailed = false;
    try {
      Response response = await userRepo.getUserInfo();
      late ResponseModel responseModel;
      if (response.statusCode == 200) {
        _userModel = UserModel.fromJson(response.body);
        _isLoading = true;
        _hasFailed = false;
        responseModel = ResponseModel(true, "successfully");
      } else {
        _hasFailed = true;
        responseModel = ResponseModel(false, response.statusText ?? "Error");
      }
      update();
      return responseModel;
    } catch (_) {
      _hasFailed = true;
      update();
      return ResponseModel(false, "Network error");
    }
  }
}
