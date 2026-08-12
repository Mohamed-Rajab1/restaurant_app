import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  // دالة فتح الروابط (واتساب أو اتصال)
  Future<void> _launchUrl(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن فتح هذا الرابط حالياً'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'تحتاج إلى مساعدة؟ 🎧',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'نحن هنا لخدمتك، تواصل معنا عبر القنوات التالية:',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // StreamBuilder لجلب الأرقام من الفايربيز لحظياً
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('settings')
                .doc('contact_info')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('بيانات التواصل غير متاحة حالياً.');
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final phone = data['phone'] ?? '';
              final whatsapp = data['whatsapp'] ?? '';

              return Column(
                children: [
                  // زرار الاتصال الهاتفي
                  if (phone.isNotEmpty)
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.blue.shade50,
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.phone, color: Colors.white),
                      ),
                      title: const Text(
                        'اتصال هاتفي',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(phone),
                      onTap: () => _launchUrl('tel:$phone', context),
                    ),
                  const SizedBox(height: 12),

                  // زرار الواتساب
                  if (whatsapp.isNotEmpty)
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.green.shade50,
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.wechat, color: Colors.white),
                      ), // استخدم أيقونة مناسبة للواتساب
                      title: const Text(
                        'محادثة واتساب',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(whatsapp),
                      onTap: () {
                        // الرابط ده بيفتح الواتساب مباشرة برقم المطعم
                        _launchUrl('https://wa.me/$whatsapp', context);
                      },
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
