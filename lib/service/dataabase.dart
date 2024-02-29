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

  Future<QuerySnapshot> Search(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }

  creatChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }
}
