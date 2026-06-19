import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders; // map is for storing data locally

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    //ApiClient is used to talk to the server
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      //maps are wrapper in {}, lists in []
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token', //bearer - token type
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token', //bearer - token type
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await get(uri, headers: headers ?? _mainHeaders);
      //print(response.body.toString());
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    //print(body.toString());
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      //print(response.toString());
      return response;
    } catch (e) {
      //print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
