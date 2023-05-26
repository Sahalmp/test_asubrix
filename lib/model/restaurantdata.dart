// To parse this JSON data, do
//
//     final restaurantData = restaurantDataFromJson(jsonString);

import 'dart:convert';

List<RestaurantData> parseApiResponse(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<RestaurantData>((json) => RestaurantData.fromJson(json))
      .toList();
}

class RestaurantData {
  String? restaurantId;
  String? restaurantName;
  String? restaurantImage;
  String? tableId;
  String? tableName;
  String? branchName;
  String? nexturl;
  List<TableMenuList>? tableMenuList;

  RestaurantData({
    this.restaurantId,
    this.restaurantName,
    this.restaurantImage,
    this.tableId,
    this.tableName,
    this.branchName,
    this.nexturl,
    this.tableMenuList,
  });

  factory RestaurantData.fromRawJson(String str) =>
      RestaurantData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantData.fromJson(Map<String, dynamic> json) => RestaurantData(
        restaurantId: json["restaurant_id"],
        restaurantName: json["restaurant_name"],
        restaurantImage: json["restaurant_image"],
        tableId: json["table_id"],
        tableName: json["table_name"],
        branchName: json["branch_name"],
        nexturl: json["nexturl"],
        tableMenuList: json["table_menu_list"] == null
            ? []
            : List<TableMenuList>.from(
                json["table_menu_list"]!.map((x) => TableMenuList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "restaurant_name": restaurantName,
        "restaurant_image": restaurantImage,
        "table_id": tableId,
        "table_name": tableName,
        "branch_name": branchName,
        "nexturl": nexturl,
        "table_menu_list": tableMenuList == null
            ? []
            : List<dynamic>.from(tableMenuList!.map((x) => x.toJson())),
      };
}

class TableMenuList {
  String? menuCategory;
  String? menuCategoryId;
  String? menuCategoryImage;
  String? nexturl;
  List<CategoryDish>? categoryDishes;

  TableMenuList({
    this.menuCategory,
    this.menuCategoryId,
    this.menuCategoryImage,
    this.nexturl,
    this.categoryDishes,
  });

  factory TableMenuList.fromRawJson(String str) =>
      TableMenuList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TableMenuList.fromJson(Map<String, dynamic> json) => TableMenuList(
        menuCategory: json["menu_category"],
        menuCategoryId: json["menu_category_id"],
        menuCategoryImage: json["menu_category_image"],
        nexturl: json["nexturl"],
        categoryDishes: json["category_dishes"] == null
            ? []
            : List<CategoryDish>.from(
                json["category_dishes"]!.map((x) => CategoryDish.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu_category": menuCategory,
        "menu_category_id": menuCategoryId,
        "menu_category_image": menuCategoryImage,
        "nexturl": nexturl,
        "category_dishes": categoryDishes == null
            ? []
            : List<dynamic>.from(categoryDishes!.map((x) => x.toJson())),
      };
}

class AddonCat {
  String? addonCategory;
  String? addonCategoryId;
  int? addonSelection;
  String? nexturl;
  List<CategoryDish>? addons;

  AddonCat({
    this.addonCategory,
    this.addonCategoryId,
    this.addonSelection,
    this.nexturl,
    this.addons,
  });

  factory AddonCat.fromRawJson(String str) =>
      AddonCat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddonCat.fromJson(Map<String, dynamic> json) => AddonCat(
        addonCategory: json["addon_category"],
        addonCategoryId: json["addon_category_id"],
        addonSelection: json["addon_selection"],
        nexturl: json["nexturl"],
        addons: json["addons"] == null
            ? []
            : List<CategoryDish>.from(
                json["addons"]!.map((x) => CategoryDish.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "addon_category": addonCategory,
        "addon_category_id": addonCategoryId,
        "addon_selection": addonSelection,
        "nexturl": nexturl,
        "addons": addons == null
            ? []
            : List<dynamic>.from(addons!.map((x) => x.toJson())),
      };
}

class CategoryDish {
  String? dishId;
  String? dishName;
  double? dishPrice;
  String? dishImage;
  DishCurrency? dishCurrency;
  num? dishCalories;
  String? dishDescription;
  bool? dishAvailability;
  int? dishType;
  String? nexturl;
  List<AddonCat>? addonCat;

  CategoryDish({
    this.dishId,
    this.dishName,
    this.dishPrice,
    this.dishImage,
    this.dishCurrency,
    this.dishCalories,
    this.dishDescription,
    this.dishAvailability,
    this.dishType,
    this.nexturl,
    this.addonCat,
  });

  factory CategoryDish.fromRawJson(String str) =>
      CategoryDish.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryDish.fromJson(Map<String, dynamic> json) => CategoryDish(
        dishId: json["dish_id"],
        dishName: json["dish_name"],
        dishPrice: json["dish_price"]?.toDouble(),
        dishImage: json["dish_image"],
        dishCurrency: dishCurrencyValues.map[json["dish_currency"]],
        dishCalories: (json["dish_calories"] as num?)?.round(),
        dishDescription: json["dish_description"],
        dishAvailability: json["dish_Availability"],
        dishType: json["dish_Type"],
        nexturl: json["nexturl"],
        addonCat: json["addonCat"] == null
            ? []
            : List<AddonCat>.from(
                json["addonCat"]!.map((x) => AddonCat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dish_id": dishId,
        "dish_name": dishName,
        "dish_price": dishPrice,
        "dish_image": dishImage,
        "dish_currency": dishCurrencyValues.reverse[dishCurrency],
        "dish_calories": dishCalories!,
        "dish_description": dishDescription,
        "dish_Availability": dishAvailability,
        "dish_Type": dishType,
        "nexturl": nexturl,
        "addonCat": addonCat == null
            ? []
            : List<dynamic>.from(addonCat!.map((x) => x.toJson())),
      };
}

// ignore: constant_identifier_names
enum DishCurrency { SAR }

final dishCurrencyValues = EnumValues({"SAR": DishCurrency.SAR});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
