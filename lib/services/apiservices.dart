
import 'dart:developer';

import '../model/restaurantdata.dart';
import 'package:http/http.dart' as http;

class ApiServices {
static  Future<List<RestaurantData?>?> fetchData() async {
    final url = Uri.parse('https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parseApiResponse(response.body);
    } else {
      log('Request failed with status: ${response.statusCode}.');
    }
    return null;
  }
}
