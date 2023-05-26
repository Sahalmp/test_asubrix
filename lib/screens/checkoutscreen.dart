import 'package:asubrix/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/cartcontroller.dart';
import '../model/cartmodel.dart';
import 'Homepage.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          title: const Text(
            "Order Summary",
          ),
        ),
        body: Obx(
          () => cartController.cartItems.isEmpty
              ? const Center(
                  child: Text("No Items"),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade800,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              '${cartController.cartItems.length} Dishes - ${cartController.getTotalItems()} Items',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          cartController.cartItems.length,
                                      itemBuilder: (context, index) {
                                        CartItem item =
                                            cartController.cartItems[index];

                                        return CartItemWidget(
                                            item: item,
                                            cartController: cartController);
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Amount',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17),
                                          ),
                                          Text(
                                              "INR ${cartController.calculateTotalAmount().toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ExpandedButton(
                            icon: null,
                            text: "Place Order",
                            color: Colors.green.shade800,
                            onpressed: () async {
                              await showOrderSuccessDialog(context);
                              cartController.clearCartItems();
                              Get.offAll(const HomeScreen());
                            }),
                      ),
                    )
                  ],
                ),
        ));
  }
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.item,
    required this.cartController,
  });

  final CartItem item;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                item.type == 1
                    ? 'assets/non_veg_icon.png'
                    : 'assets/veg_icon.png',
                height: 20.0,
              ),
              const SizedBox(width: 4.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Flexible(
                                    child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            )),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: CartAddRemoveButton(
                            cartController: cartController,
                            cartItem: item,
                            type: "small",
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                            "INR ${cartController.calculateItemAmount(item: item).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("INR ${item.amount.toStringAsFixed(2)}"),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("${item.calories} calories"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider()
        ],
      ),
    );
  }
}

Future<void> showOrderSuccessDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48.0,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Order Placed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Order successfully placed.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
