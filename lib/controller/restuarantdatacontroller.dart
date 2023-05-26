// Define your API route or controller

import 'dart:developer';

import 'package:asubrix/services/apiservices.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/restaurantdata.dart';

class RestaurantDataController extends GetxController {
  RestaurantData? restaurantData;
  bool loading = true;
  GetStorage storage = GetStorage();

  // Define your API endpoint
  Future getRestaurantDataHandler() async {
    final jsonData = await ApiServices.fetchData();
    if (jsonData != null) {
      restaurantData = jsonData.first!;
      loading = false;
      update();
      log(restaurantData.toString());
    }
  }
}
