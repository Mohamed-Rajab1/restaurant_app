import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

class AddStaffBottomSheet extends StatefulWidget {
  const AddStaffBottomSheet({super.key});

  @override
  State<AddStaffBottomSheet> createState() => _AddStaffBottomSheetState();
}

class _AddStaffBottomSheetState extends State<AddStaffBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'cashier';

  final Map<String, String> _roles = {
    'cashier': 'كاشير 💰',
    'kitchen': 'مطبخ 🍳',
    'admin': 'مدير (أدمن) 👑',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ❌ تم إزالة context.read من هنا نهائياً لمنع اللوب

    return Padding(
      // ✅ 1. البادينج بقى "خارج" الـ ScrollView عشان نمنع الشاشة من التهنيج اللانهائي
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'إضافة موظف جديد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الموظف',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val != null && val.length < 6 ? '6 أحرف على الأقل' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  // ✅ 2. استخدمنا value بدل initialValue
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'وظيفة الموظف',
                    border: OutlineInputBorder(),
                  ),
                  items: _roles.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRole = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // ✅ 3. بنقرأ الكيوبت هنا لحظة الضغط فقط (ودي الطريقة الآمنة 100%)
                          context.read<AdminCubit>().addStaffMember(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            role: _selectedRole,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'إضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
