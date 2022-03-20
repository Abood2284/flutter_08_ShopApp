// Basic model of each product will look like in OrdersScreen
import '../providers/cart.dart';

class OrderItem {
  final String id; // Should have id
  final double amount; // Should display the amount you spent in total
  final List<Cartitem> products; // should display the products you purchased
  final DateTime dateTime; // Should show the time you made the order

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}
