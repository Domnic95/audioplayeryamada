import 'package:cloud_firestore/cloud_firestore.dart';

// UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
class FireBaseService {
  static Future<QuerySnapshot> getMusicList({
    SortBy? sortBy,
    bool descending = true,
    required Object field,
  }) async {
    final refLogBooks = FirebaseFirestore.instance
        .collection('audioBooks')
        .orderBy(field, descending: descending)
        .get();
    return refLogBooks;
  }
}

enum SortBy { none, ascending, descending }
