class CartItem {
  final String id;
  final String name;
  final String calories;
  final double amount;
  final int type;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.amount,
    required this.type,
    this.quantity = 1, // Default quantity is 1
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'amount': amount,
      'type': type,
      'quantity': quantity,
    };
  }
}
