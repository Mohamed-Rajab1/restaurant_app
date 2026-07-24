// features/customer/menu/data/data_sources/menu_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<MealModel>> getMeals({String? category});
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final FirebaseFirestore firestore;

  MenuRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<MealModel>> getMeals({String? category}) async {
    Query query = firestore.collection('meals');

    // تصفية الوجبات حسب القسم إذا كان مختاراً وليس "الكل"
    if (category != null && category != 'الكل') {
      query = query.where('category', isEqualTo: category);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs
        .map(
          (doc) => MealModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }
}
