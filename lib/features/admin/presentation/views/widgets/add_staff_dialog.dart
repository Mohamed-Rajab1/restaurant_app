import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

class AddStaffDialog extends StatefulWidget {
  const AddStaffDialog({super.key});

  @override
  State<AddStaffDialog> createState() => _AddStaffDialogState();
}

class _AddStaffDialogState extends State<AddStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // الوظيفة الافتراضية
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
    final adminCubit = context.read<AdminCubit>();

    return AlertDialog(
      title: const Text(
        'إضافة موظف جديد',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

              // قائمة اختيار الوظيفة
              DropdownButtonFormField<String>(
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
                    setState(() => _selectedRole = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              adminCubit.addStaffMember(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                role: _selectedRole,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('إضافة', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
