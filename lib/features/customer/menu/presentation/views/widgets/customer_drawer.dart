import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/features/auth/presentation/views/login_view.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/edit_profile_view.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/support_bottom_sheet.dart'; // 👈 مسار ملف الدعم اللي عملناه

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة المستخدم (زائر أم مسجل دخول)
    final User? user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. رأس القائمة (بيانات المستخدم)
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.indigo),
            ),
            // لو زائر هنكتب "زائر"، لو مسجل هنجيب اسمه أو إيميله
            accountName: Text(
              isGuest
                  ? 'مرحباً بك كضيف'
                  : (user.displayName ?? 'عميلنا العزيز'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              isGuest ? 'سجل دخولك لتجربة أفضل' : (user.email ?? ''),
            ),
          ),

          // 2. تعديل الملف الشخصي (يظهر للمسجلين فقط)
          if (!isGuest)
            ListTile(
              leading: const Icon(Icons.manage_accounts, color: Colors.indigo),
              title: const Text('تعديل الحساب', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context); // قفل القائمة الجانبية

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileView(),
                  ),
                );
              },
            ),

          // 3. زرار الدعم الفني (يفتح النافذة اللي عملناها قبل كده)
          ListTile(
            leading: const Icon(Icons.support_agent, color: Colors.green),
            title: const Text('الدعم الفني', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // قفل القائمة الجانبية
              // فتح نافذة الدعم السفلية
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SupportBottomSheet(),
              );
            },
          ),

          const Divider(thickness: 1), // خط فاصل أنيق
          // 4. زرار تسجيل الخروج / أو تسجيل الدخول
          ListTile(
            leading: Icon(
              isGuest ? Icons.login : Icons.logout,
              color: isGuest ? Colors.blue : Colors.red,
            ),
            title: Text(
              isGuest ? 'تسجيل الدخول / إنشاء حساب' : 'تسجيل الخروج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isGuest ? Colors.blue : Colors.red,
              ),
            ),
            onTap: () async {
              if (!isGuest) {
                // لو مسجل دخول -> نعمل Sign Out
                await FirebaseAuth.instance.signOut();
              }

              // في الحالتين (زائر داس تسجيل دخول، أو عميل داس خروج) هنوديه لشاشة اللوجين
              if (context.mounted) {
                // بنستخدم pushAndRemoveUntil عشان نمسح كل الشاشات السابقة وميقدرش يرجع بالـ Back
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
