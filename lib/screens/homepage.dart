import 'dart:developer';
import 'package:asubrix/controller/cartcontroller.dart';
import 'package:asubrix/controller/restuarantdatacontroller.dart';
import 'package:asubrix/model/cartmodel.dart';
import 'package:asubrix/model/restaurantdata.dart';
import 'package:asubrix/screens/checkoutscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/authservices.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantDataController dataController =
      Get.put(RestaurantDataController());

  final CartController cartController = Get.put(CartController());
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchdata();
    dataController.getRestaurantDataHandler();
  }

  fetchdata() async {
    userData = await AuthServices.fetchUserData() ?? {};
    log("message $userData");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDataController>(
      builder: (_) {
        log(_.loading.toString());
        // print(dataController.restaurantData!.tableMenuList!.length);
        return _.loading
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : DefaultTabController(
                length: dataController.restaurantData!.tableMenuList!.length,
                child: Scaffold(
                  drawer: CustomDrawer(
                    userData: userData,
                  ),
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    iconTheme: const IconThemeData(color: Colors.black),
                    actions: [
                      Obx(() => CartLogoWithBadge(
                          logo: const Icon(Icons.shopping_cart_rounded),
                          badgeCount: cartController.getTotalItems()))
                    ],
                    bottom: TabBar(
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      labelColor: const Color.fromARGB(255, 233, 44, 107),
                      indicatorColor: const Color.fromARGB(255, 233, 44, 107),
                      tabs: dataController.restaurantData!.tableMenuList!
                          .map((e) => Tab(text: e.menuCategory))
                          .toList(),
                    ),
                  ),
                  body: TabBarView(
                      children: dataController.restaurantData!.tableMenuList!
                          .map((e) {
                    final data = dataController.restaurantData!.tableMenuList!
                        .firstWhere((element) =>
                            e.menuCategoryId == element.menuCategoryId)
                        .categoryDishes;

                    return Center(
                      child: ListView(
                        children: data!
                            .map(
                              (e) => ItemWidget(data: e),
                            )
                            .toList(),
                      ),
                    );
                  }).toList()),
                ),
              );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  final CategoryDish data;

  ItemWidget({
    super.key,
    required this.data,
  });

  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    data.dishType == 1
                        ? 'assets/non_veg_icon.png'
                        : 'assets/veg_icon.png',
                    height: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      data.dishName.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "INR ${data.dishPrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text("${data.dishCalories} calories"),
                const SizedBox(width: 4.0),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              data.dishDescription.toString(),
              style: const TextStyle(),
            ),
            const SizedBox(height: 8.0),
            CartAddRemoveButton(
                cartController: cartController,
                cartItem: CartItem(
                    id: data.dishId.toString(),
                    name: data.dishName.toString(),
                    calories: data.dishCalories.toString(),
                    amount: data.dishPrice!,
                    type: data.dishType!)),
            const SizedBox(
              height: 10,
            ),
            data.addonCat!.isNotEmpty
                ? const Text('Customizations available',
                    style: TextStyle(color: Colors.red, fontSize: 15))
                : const SizedBox()
          ],
        ),
        trailing: Image.network(
          data.dishImage.toString(),
          width: 40,
          height: 40,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image,
              size: 40,
              color: Colors.grey,
            );
          },
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            return const SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator());
          },
        ),
        isThreeLine: true,
        dense: true,
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }
}

class CartAddRemoveButton extends StatelessWidget {
  final CartController cartController;
  final CartItem cartItem;
  final String type;

  const CartAddRemoveButton(
      {super.key,
      required this.cartController,
      required this.cartItem,
      this.type = "large"});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: type == "small" ? null : 140,
      height: type == "small" ? 33 : 40,
      decoration: BoxDecoration(
        color: type == "small" ? Colors.green.shade800 : Colors.green,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: IconButton(
              icon: Icon(
                Icons.remove,
                size: type == "small" ? 14 : null,
              ),
              onPressed: () {
                cartController.removeCartItem(cartItem);
              },
              color: Colors.white,
            ),
          ),
          Obx(() => Text(
                cartController.getQuantityForItem(cartItem.id).toString(),
                style: TextStyle(
                    fontSize: type == "small" ? 14 : 20, color: Colors.white),
              )),
          Flexible(
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: type == "small" ? 14 : null,
              ),
              onPressed: () {
                cartController.addToCart(cartItem);
              },
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CartLogoWithBadge extends StatelessWidget {
  final Widget logo;
  final int badgeCount;

  const CartLogoWithBadge(
      {Key? key, required this.logo, required this.badgeCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (badgeCount != 0) {
          Get.to(() => CheckoutScreen());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: logo,
            ),
            if (badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    log(userData.toString());
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                userData['profile'] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(userData['profile']),
                        radius: 40.0,
                      )
                    : const CircleAvatar(
                        radius: 40.0,
                        child: Icon(Icons.person),
                      ),
                const SizedBox(height: 16.0),
                Text(
                  userData['name'] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'ID: ${userData['id']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: AuthServices.userLogOut,
          ),
        ],
      ),
    );
  }
}
