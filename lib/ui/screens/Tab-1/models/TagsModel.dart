import 'package:cloud_firestore/cloud_firestore.dart';

class TagsModel {
  String tag;
  String title;
  TagsModel({required this.tag, required this.title});
  factory TagsModel.from(DocumentSnapshot doc) {
    return TagsModel(tag: doc.get('tag'), title: doc.get('title'));
  }
}
