import 'package:audiobook/global.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AudioBookRepo {

  static Future<QuerySnapshot> getMusicList({
    bool descending = true,
    required Object field,
  }) async {
    final refLogBooks = FirebaseFirestore.instance
        .collection('audioBooks')
        .orderBy(field, descending: descending)
        .get();

    return refLogBooks;
  }

  static Future<QuerySnapshot> getFeaturedMusicList({
    bool descending = true,
    required Object field,
  }) async {
    final refLogBooks = FirebaseFirestore.instance
        .collection('audioBooks')
        .where(field, isNotEqualTo: 0)
        .orderBy(field, descending: false)
        .get();

    return refLogBooks;
  }

  static Future<QuerySnapshot> rankingData() async {
    final refLogBooks = FirebaseFirestore.instance
        .collection('audioBooks')
        .orderBy('played', descending: true)
        .limit(7)
        .get();
    print('fetched data');
    print(refLogBooks);
    return refLogBooks;
  }

  static Future<QuerySnapshot> tagSort({
    bool descending = true,
    required List<String> tagName,
  }) async {
    final refLogBooks = FirebaseFirestore.instance
        .collection('audioBooks')
        .where('tag', arrayContainsAny: tagName)

        //.orderBy(field, descending: descending)
        .get();

    print('fetched data');

    return refLogBooks;
  }

  static Future<QuerySnapshot> homeTags() async {
    final data = FirebaseFirestore.instance.collection('homeContents').get();
    print('homeContents');
    print(data);
    return data;
  }

  static Future<QuerySnapshot> searchTags() async {
    final data = FirebaseFirestore.instance.collection('searchContents').get();

    return data;
  }

  Future firebaseCounter(MusicModel musicModel) async {
    final data = await FirebaseFirestore.instance
        .collection('audioBooks')
        .doc(musicModel.id)
        .get();
    await FirebaseFirestore.instance
        .collection('audioBooks')
        .doc(musicModel.id)
        .update({'played': data.get('played') + 1});
  }

  Future sampleAudio(MusicModel musicModel) async {
    try {
      if (!audioPlayer.playing) {
        audioPlayerHandlerImpl.stop();
        audioPlayer.setUrl(musicModel.track.first.url);
        audioPlayer.play();
        await Future.delayed(Duration(seconds: 15), () {
          audioPlayer.stop();
          audioHandler.play();
        });
      }
    } catch (e) {
      print('exception in sampleAudio');
      print(e);
    }
  }

  Future<List<String>> fetchAudioFromStorage(String id) async {
    List<String> url = [];
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('AudioBook/${id}');
    final li = await ref.listAll();

    for (int i = 0; i < li.items.length; i++) {
      if (li.items[i].name.contains('.mp3')) {
        url.add(await li.items[i].getDownloadURL());
      }
    }
    return url;
  }
}
