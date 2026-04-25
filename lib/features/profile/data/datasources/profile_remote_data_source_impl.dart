import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/models/user_profile_model.dart';

class ProfileRemoteDataSourceImpl {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<UserProfileModel?> getProfile(String uid) async {
    final doc =
        await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserProfileModel.fromMap(uid, doc.data()!);
  }
}
