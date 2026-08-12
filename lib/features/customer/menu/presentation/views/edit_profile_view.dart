import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true; // لتحميل البيانات أول ما الشاشة تفتح
  bool _isSaving = false; // لدائرة التحميل جوه زرار الحفظ
  
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // دالة لجلب بيانات العميل الحالية من الفايربيز
  Future<void> _fetchUserData() async {
    if (_currentUser == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _emailController.text = data['email'] ?? _currentUser.email ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في جلب البيانات: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // دالة تحديث البيانات
  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate() || _currentUser == null) return;

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث البيانات بنجاح ✅'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // يرجع للشاشة اللي قبلها بعد الحفظ
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل التحديث: $e'), backgroundColor: Colors.red));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي 👤'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // تحميل مبدئي
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // صورة بروفايل (ديكور)
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 32),

                    // حقل الاسم
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم بالكامل',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.trim().isEmpty ? 'يرجى إدخال الاسم' : null,
                    ),
                    const SizedBox(height: 16),

                    // حقل التليفون
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.trim().isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                    ),
                    const SizedBox(height: 16),

                    // حقل الإيميل (مغلق للقراءة فقط)
                    TextFormField(
                      controller: _emailController,
                      readOnly: true, // 👈 يمنع التعديل
                      style: const TextStyle(color: Colors.grey),
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني (غير قابل للتعديل)',
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // زرار الحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isSaving ? null : _updateUserData,
                        child: _isSaving
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('حفظ التعديلات', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}