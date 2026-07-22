import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String role; // الأدوار: 'admin', 'cashier', 'kitchen', 'customer'

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  // الـ props بتعرف فلاتر إن لو اتنين Entity ليهم نفس الـ uid والـ role يبقوا متطابقين
  List<Object?> get props => [uid, name, email, role];
}
