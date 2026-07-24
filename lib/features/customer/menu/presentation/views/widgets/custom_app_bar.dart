import 'package:flutter/material.dart';

class CartBadgeIcon extends StatelessWidget {
  final int itemCount;
  final VoidCallback? onTap;

  const CartBadgeIcon({super.key, this.itemCount = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed:
              onTap ??
              () {
                // TODO: Go to Cart Screen
              },
        ),
        // بنظهر الـ Badge بس لو فيه عناصر في السلة أكبر من 0
        if (itemCount > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '$itemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
