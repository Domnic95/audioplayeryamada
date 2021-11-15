import 'package:audiobook/core/services/audioBookRepo.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/screens/Tab-1/homeScreen.dart';
import 'ui/screens/Tab-2/searchScreen.dart';
import 'ui/screens/Tab-2/widgets/audioPlayer/audioPlayerHandler.dart';
import 'ui/screens/Tab-3/bookmarkScreen.dart';
import 'ui/screens/Tab-4/profileScreen.dart';

late AudioPlayerHandler audioHandler;
late AudioPlayerHandlerImpl audioPlayerHandlerImpl;
final audioPlayer = AudioPlayer();
late SharedPreferences prefs;

String currentPlayerId = ""; // track url
String currentQueueId = ""; // mediaModel id
int currentMusicModelTrackIndex = 0;
MusicModel? currentMusicModel;

final List<Widget> navigationTabList = [
  HomeScreen(),
  SearchScreen(),
  BookMarkScreen(),
  ProfileScreen()
];

CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('users');

class FirebaseInstance {
  static late final FirebaseAuth? firebaseAuth;
}

List<String> inAppMusicIds = [];

List<MusicModel> allMusicList = [];
Future globalListInit() async {
  prefs = await SharedPreferences.getInstance();
  final snap =
      await AudioBookRepo.getMusicList(field: 'rank', descending: false);
  allMusicList.addAll(snap.docs.map((doc) {
    return MusicModel.fromFirestore(doc);
  }));
}
