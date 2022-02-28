import '../../cart/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<Cartitem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}
