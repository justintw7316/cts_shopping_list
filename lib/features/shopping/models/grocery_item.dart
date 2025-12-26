import 'package:equatable/equatable.dart';

class GroceryItem extends Equatable {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final double price;

  @override
  List<Object> get props {
    return [id, name, price];
  }
}
