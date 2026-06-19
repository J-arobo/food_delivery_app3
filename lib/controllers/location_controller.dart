import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/data/API/api_checker.dart';
import 'package:food_delivery_app/data/repository/location_repo.dart';
import 'package:food_delivery_app/models/address_model.dart';
import 'package:food_delivery_app/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;
  Position _position = Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      altitudeAccuracy: 1,
      heading: 1,
      headingAccuracy: 1,
      speed: 1,
      speedAccuracy: 1);
  Position _pickPosition = Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      altitudeAccuracy: 1,
      heading: 1,
      headingAccuracy: 1,
      speed: 1,
      speedAccuracy: 1);
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;
  late List<AddressModel> _allAddressList; //_allAddresslist=[];
  List<AddressModel> get allAddressList => _allAddressList;
  final List<String> _addressTypeList = ["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  bool _updateAddressData = true;
  bool _changeAddress = true;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  /*
 for service zone
 */
  bool _isloadig = false;
  bool get isloading => _isloadig;
  /*
  whether user is in service zone or not
  */
  bool _inZone = false;
  bool get inZone => _inZone;
  /*
  showing and hiding the button as the map loads
  */
  bool _buttonDisabled = true;
  bool get buttonDisabled => _buttonDisabled;

  /*
  save the google map suggestions for address
  */
  List<Prediction> _predictionList = [];

  Future<void> getCurrrentLocation(bool fromAddress,
      {required GoogleMapController mapController,
      LatLng? defaultLatLng,
      bool notify = true}) async {
    _loading = true;
    if (notify) {
      update();
    }
    AddressModel _addressModel;
    late Position _myPosition;
    Position _test;

    //Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best);
    //_myPosition = newLocalData;
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      _myPosition = position;

      //print();

      if (fromAddress) {
        _position = _myPosition;
      } else {
        _pickPosition = _myPosition;
      }
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(_myPosition.latitude, _myPosition.longitude))));
      Placemark _myPlaceMark;
      try {
        if (!GetPlatform.isWeb) {
          List<Placemark> placeMarks = await placemarkFromCoordinates(
              _myPosition.latitude, _myPosition.longitude);
          _myPlaceMark = placeMarks.first;
        } else {
          String _address = await getAddressfromGeocode(
              LatLng(_myPosition.latitude, _myPosition.longitude));
          _myPlaceMark = Placemark(
              name: _address, locality: '', postalCode: '', country: '');
        }
      } catch (e) {
        String _address = await getAddressfromGeocode(
            LatLng(_myPosition.latitude, _myPosition.longitude));
        _myPlaceMark = Placemark(
            name: _address, locality: '', postalCode: '', country: '');
      }

      fromAddress ? _placemark = _myPlaceMark : _pickPlacemark = _myPlaceMark;

      //ResponseModel _responseModel = await getZone(_myPosition.latitude.toString(), _myPosition.longitude.toString(), markerLoad /*markerload*/);
      //_buttonDisabled = !_responseModel.isSuccess;

      _addressModel = AddressModel(
        latitude: _myPosition.latitude.toString(),
        longitude: _myPosition.longitude.toString(),
        //zoneId = _responseModel.isSuccess ? int.parse()
        address: '${_myPlaceMark.name ?? ''}'
            '${_myPlaceMark.locality ?? ''} '
            '${_myPlaceMark.postalCode ?? ''} '
            '${_myPlaceMark.country ?? ''}',
        addressType: _myPlaceMark,
      );
      _loading = false;
      update();
      print("ha " + _myPosition.toString());
    }).catchError((e) {
      _myPosition = Position(
          longitude: defaultLatLng != null
              ? defaultLatLng.longitude
              : double.maxFinite,
          latitude:
              defaultLatLng != null ? defaultLatLng.latitude : double.maxFinite,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          altitudeAccuracy: 1,
          heading: 1,
          headingAccuracy: 1,
          speed: 1,
          speedAccuracy: 1);
      print("error " + e);
    });

    //return _addressModel
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    //if (kIsWeb) return;  - works fine on web without this.
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1,
              accuracy: 1,
              altitude: 1,
              altitudeAccuracy: 1,
              headingAccuracy: 1,
              speed: 1,
              speedAccuracy: 1);
        } else {
          _pickPosition = Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1,
              accuracy: 1,
              altitude: 1,
              altitudeAccuracy: 1,
              headingAccuracy: 1,
              speed: 1,
              speedAccuracy: 1);
        }

        //   ResponseModel _responseModel = await getZone(
        //       position.target.latitude.toString(),
        //       position.target.longitude.toString(),
        //       false);
        /*
            if button value is false we are in the service area
            */
        //     _buttonDisabled = !_responseModel.isSuccess;
        if (_changeAddress) {
          String _address = await getAddressfromGeocode(
              LatLng(position.target.latitude, position.target.longitude));
          fromAddress
              ? _placemark = Placemark(name: _address)
              : _pickPlacemark = Placemark(name: _address);
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        print(e);
      }

      _loading = false;
      update();
    } else {
      _updateAddressData = true;
    }

    // not sure about this

    ResponseModel _responseModel = await getZone(
        position.target.latitude.toString(),
        position.target.longitude.toString(),
        true);
    /*
          if button value is false we are in the service area
          */
    _buttonDisabled = !_responseModel.isSuccess;
  }

  Future<String> getAddressfromGeocode(LatLng latlng) async {
    String _address = "Unknown Location Found";
    Response response = await locationRepo.getAddressfromGeocode(latlng);
    if (response.body["status"] == 'OK') {
      _address = response.body["results"][0]['formatted_address'].toString();
      //print("printing address " + _address);
    } else {
      print("Error getting the Google api");
    }
    update();
    return _address;
  }

  Map<String, dynamic> _getAddress = {};
  Map get getAddress => _getAddress; //

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    /*
    converting to map using jsonDecode
    */
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      print(e);
    }
    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAddressList();
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
      await saveUserAddress(addressModel);
    } else {
      print("Couldn't save the address" + response.statusText!);
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  void setAddressData() {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }

  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;
    if (markerLoad) {
      _loading = true;
    } else {
      _isloadig = true;
    }
    update();
    Response response = await locationRepo.getZone(lat, lng);
    if (response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body["zone_id"].toString());
    } else {
      _inZone = false;
      _responseModel = ResponseModel(true, response.statusText!);
    }
    if (markerLoad) {
      _loading = false;
    } else {
      _isloadig = false;
    }
    // for debugging
    //print("zone response is " + response.statusCode.toString());
    /*
    status code 
    200 - went well
    404 - route problem/server
    500 - problem with server, not app - like wrong calculations
    403 - permission problem
    */
    update();

    return _responseModel;
  }

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  setLocation(
      String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlacesDetailsResponse detail;
    Response response = await locationRepo.setLocattion(placeID);
    detail = PlacesDetailsResponse.fromJson(response.body);
    _pickPosition = Position(
        latitude: detail.result.geometry!.location.lat,
        longitude: detail.result.geometry!.location.lng,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
        altitudeAccuracy: 1,
        headingAccuracy: 1);
    _pickPlacemark = Placemark(name: address);
    _changeAddress = false;
    if (!mapController.isNull) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
          zoom: 17)));
    }
    _loading = false;
    update();
  }
}
