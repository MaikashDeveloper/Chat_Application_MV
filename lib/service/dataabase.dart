import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemil(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("E-mail", isEqualTo: email)
        .get();
  }
}
