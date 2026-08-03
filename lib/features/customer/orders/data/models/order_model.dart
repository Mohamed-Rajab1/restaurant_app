import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/customer/cart/data/models/cart_item_model.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<CartItemModel> items;
  final double totalPrice;
  final String address;
  final String phone;
  final String status; // 'pending', 'preparing', 'delivered', 'cancelled'
  final DateTime createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.address,
    required this.phone,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toFirestore()).toList(),
      'totalPrice': totalPrice,
      'address': address,
      'phone': phone,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // قراءة من Firestore
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items:
          (data['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromFirestore(item))
              .toList() ??
          [],
      totalPrice: (data['totalPrice'] as num).toDouble(),
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
