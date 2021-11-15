import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    bookmark,
    this.email = "",
    history,
    this.id = "",
    this.inSubscription = false,
    joinDate,
    recommended,
  })  : this.bookmark = bookmark ?? [],
        this.history = history ?? [],
        this.joinDate = joinDate ?? Timestamp.now(),
        this.recommended = recommended ?? [];

  List<String> bookmark;
  String email;
  List<String> history;
  String id;
  bool inSubscription;
  Timestamp joinDate;
  List<String> recommended;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        bookmark: List<String>.from((json["bookmark"] ?? []).map((x) => x)),
        email: json["email"] ?? "",
        history: List<String>.from((json["history"] ?? []).map((x) => x)),
        id: json["id"] ?? "",
        inSubscription: json["inSubscription"] ?? false,
        joinDate: json["joinDate"] ?? Timestamp.now(),
        recommended:
            List<String>.from((json["recommended"] ?? []).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "bookmark": List<dynamic>.from(bookmark.map((x) => x)),
        "email": email,
        "history": List<dynamic>.from(history.map((x) => x)),
        "id": id,
        "inSubscription": inSubscription,
        "joinDate": joinDate,
        "recommended": List<dynamic>.from(recommended.map((x) => x)),
      };
}
