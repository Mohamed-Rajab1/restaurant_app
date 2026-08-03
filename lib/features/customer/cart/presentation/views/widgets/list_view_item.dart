import 'package:flutter/material.dart';
import 'package:restaurant_app/features/customer/cart/data/models/cart_item_model.dart';
import 'package:restaurant_app/features/customer/cart/presentation/views/widgets/cart_item_tile.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({super.key, required this.cartItems});

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cartItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return CartItemTile(item: item);
        },
      ),
    );
  }
}
