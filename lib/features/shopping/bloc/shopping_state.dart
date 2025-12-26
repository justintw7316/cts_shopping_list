import 'package:equatable/equatable.dart';

import '../models/grocery_item.dart';

class ShoppingState extends Equatable {
  const ShoppingState({
    required this.items,
    required this.selectedIds,
  });

  factory ShoppingState.initial() {
    const listGroceryItems = [
      GroceryItem(id: 'apples', name: 'Apples', price: 3.99),
      GroceryItem(id: 'bread', name: 'Bread', price: 2.49),
      GroceryItem(id: 'milk', name: 'Milk', price: 4.29),
      GroceryItem(id: 'eggs', name: 'Eggs', price: 5.99),
      GroceryItem(id: 'cheese', name: 'Cheese', price: 6.49),
      GroceryItem(id: 'chicken', name: 'Chicken', price: 8.99),
      GroceryItem(id: 'rice', name: 'Rice', price: 4.79),
      GroceryItem(id: 'pasta', name: 'Pasta', price: 3.29),
      GroceryItem(id: 'tomatoes', name: 'Tomatoes', price: 3.49),
      GroceryItem(id: 'coffee', name: 'Coffee', price: 12.99),
    ];

    return const ShoppingState(
      items: listGroceryItems,
      selectedIds: <String>{},
    );
  }

  final List<GroceryItem> items;
  final Set<String> selectedIds;

  double get total => items
    .where((item) => selectedIds.contains(item.id))
    .fold(0, (sum, item) => sum + item.price);

  ShoppingState copyWith({
    List<GroceryItem>? items,
    Set<String>? selectedIds,
  }) {
    return ShoppingState(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [items, selectedIds];
}
