import 'dart:convert';

import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/services/Helper/SpHelper.dart';
import 'package:audiobook/core/services/audioBookRepo.dart';
import 'package:audiobook/ui/screens/Tab-1/models/TagsModel.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/actormodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<MusicModel> rankWiseMusic = [];
  List<MusicModel> newArrival = [];
  late bool isFeaturedDataNext;
  late bool isRankWiseNext;
  late bool isNewArrival;
  late bool isActorName;
  late bool isPopMusic;
  SpHelper spHelper = SpHelper();
  List<TagsModel> tagsModel = [];

  HomeController() {
    isFeaturedDataNext = true;
    isRankWiseNext = true;
    isNewArrival = true;
    isActorName = true;
    isPopMusic = true;
    fetchTag();
    getDataFromCache();
  }
  Future fetchTag() async {
    final snap = await AudioBookRepo.homeTags();
    tagsModel.addAll(snap.docs.map((e) {
      return TagsModel.from(e);
    }));

    update();
  }

  getDataFromCache() {
    features = [];
    newArrival = [];
    rankWiseMusic = [];
    //sp_viewRanking
    String featureData = spHelper.getPreference(sp_feature);
    String newArrivalData = spHelper.getPreference(sp_newArrival);
    String viewRankingData = spHelper.getPreference(sp_viewRanking);
    if (featureData != '') {
      features = retreive(featureData);
    }
    if (newArrivalData != '') {
      newArrival = retreive(newArrivalData);
    }
    if (viewRankingData != '') {
      rankWiseMusic = retreive(viewRankingData);
    }
  }

  List<MusicModel> retreive(String data) {
    List<MusicModel> datas =
        (jsonDecode(data) as List).map((e) => MusicModel.fromJson(e)).toList();
    return datas;
  }

  Future getMusicListRankWise() async {
    List<MusicModel> local = [];
    //  if (isRankWiseNext == false) return [];
    final snap = await AudioBookRepo.rankingData();
    // rankWiseMusic.addAll(snap.docs.map((doc) {
    //   return MusicModel.fromFirestore(doc);
    // }));
    for (int i = 0; i < snap.docs.length; i++) {
      List<String> list =
          await AudioBookRepo().fetchAudioFromStorage(snap.docs[i].id);
      local.add(MusicModel.fromFirestore(snap.docs[i], url: list));
    }
    isRankWiseNext = false;
    final maps = local.map((e) => e.toJson()).toList();
    rankWiseMusic = local;
    String data = jsonEncode(maps);
    spHelper.setPreference(sp_viewRanking, data);

    update();

    //return rankWiseMusic;
  }

  Future getMusicListNewArrival() async {
    List<MusicModel> local = [];

    final snap = await AudioBookRepo.getMusicList(field: 'date');

    for (int i = 0; i < snap.docs.length; i++) {
      List<String> list =
          await AudioBookRepo().fetchAudioFromStorage(snap.docs[i].id);
      local.add(MusicModel.fromFirestore(snap.docs[i], url: list));
    }
    final maps = local.map((e) => e.toJson()).toList();
    newArrival = local;
    String data = jsonEncode(maps);
    spHelper.setPreference(sp_newArrival, data);
    isNewArrival = false;
    update();
    //return newArrival;
  }

  Future<List<MusicModel>> getDataBytTag(String tag) async {
    List<MusicModel> data = [];

    final snap = await AudioBookRepo.tagSort(tagName: [tag]);

    // data.addAll(snap.docs.map((doc) {
    //   return MusicModel.fromFirestore(doc);
    // }));
    for (int i = 0; i < snap.docs.length; i++) {

      List<String> list =
          await AudioBookRepo().fetchAudioFromStorage(snap.docs[i].id);
      data.add(MusicModel.fromFirestore(snap.docs[i], url: list));
    }

    return data;
  }

  List<MusicModel> actorName = [];

  Future<List<ActorModel>> getListByVoiceActor(int offset) async {
    if (isActorName == false) return [];
    List<MusicModel> list = [];
    Map<String, List<MusicModel>> actor = {};
    final snap = await AudioBookRepo.getMusicList(
        field: "voiceActor", descending: false);

    // list.addAll(snap.docs.map((e) {
    //   return MusicModel.fromFirestore(e);
    // }));
    for (int i = 0; i < snap.docs.length; i++) {
      List<String> urls =
          await AudioBookRepo().fetchAudioFromStorage(snap.docs[i].id);
      list.add(MusicModel.fromFirestore(snap.docs[i], url: urls));
    }
    // list.forEach((element) {
    //   if (actor[element.voiceActor.name] == null)
    //     actor[element.voiceActor.name] = [];
    //   actor[element.voiceActor.name]!.add(element);
    // });

    List<ActorModel> actorModel = actor.entries
        .map((entry) => ActorModel(title: entry.key, musicModel: entry.value))
        .toList();

    isActorName = false;
    return actorModel;
  }

  List<MusicModel> features = [];
  Future getMusicListFeatures() async {
    List<MusicModel> local = [];
    if (isFeaturedDataNext == false) return [];
    final snap = await AudioBookRepo.getFeaturedMusicList(field: 'featured');
    for (int i = 0; i < snap.docs.length; i++) {
      List<String> list =
          await AudioBookRepo().fetchAudioFromStorage(snap.docs[i].id);
      local.add(MusicModel.fromFirestore(snap.docs[i], url: list));
    }
    final maps = local.map((e) => e.toJson()).toList();
    // searchTag = newArrival;
    features = local;
    String data = jsonEncode(maps);
    spHelper.setPreference(sp_feature, data);
    // features.addAll(snap.docs.map((doc) {
    //   return MusicModel.fromFirestore(doc);
    // }));

    isFeaturedDataNext = false;
    update();
  }
}
