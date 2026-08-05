import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildAnalyticsTab extends StatelessWidget {
  const BuildAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('لا توجد بيانات متاحة'));
        }

        final orders = snapshot.data!.docs;
        double totalRevenue = 0;
        int completedOrders = 0;

        for (var doc in orders) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['status'] == 'delivered') {
            totalRevenue += (data['totalPrice'] ?? 0).toDouble();
            completedOrders++;
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStatCard(
                title: 'إجمالي الأرباح (الطلبات المسلّمة)',
                value: '${totalRevenue.toStringAsFixed(2)} ج.م',
                color: Colors.green,
                icon: Icons.monetization_on,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                title: 'عدد الطلبات المكتملة',
                value: '$completedOrders طلبات',
                color: Colors.blue,
                icon: Icons.check_circle,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                title: 'إجمالي كل الطلبات بالسيستم',
                value: '${orders.length} طلبات',
                color: Colors.orange,
                icon: Icons.receipt_long,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
