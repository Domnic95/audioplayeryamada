import 'dart:convert';
import 'dart:developer';

import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/services/Helper/SpHelper.dart';
import 'package:audiobook/core/services/audioBookRepo.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/SearchTag.dart';
import 'package:audiobook/ui/screens/Tab-2/models/actormodel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/scenarioModel.dart';
import 'package:audiobook/ui/screens/Tab-2/models/searchModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

class SearchController extends GetxController {
  late bool isGenreNext;
  late bool isScenarioAuthorNext;
  late bool isVoiceActorNext;
  List<MusicModel> byGenre = [];
  List<MusicModel> byGenreType = [];
  List<SearchTag> searchTag = [];
  SpHelper spHelper = SpHelper();

  SearchController() {
    isGenreNext = true;
    isScenarioAuthorNext = true;
    isVoiceActorNext = true;
    getDataFromSearch();
  }
  getDataFromSearch() {
    searchTag = [];

    String searchData = spHelper.getPreference(sp_search);
    if (searchData != '') {
      searchTag = (jsonDecode(searchData) as List)
          .map((e) => SearchTag.fromJson(e))
          .toList();
    }
  }

  Future fetchTag() async {
    List<SearchTag> localSearchTag = [];
    searchTag.clear();
    final snap = await AudioBookRepo.searchTags();
    //  await FirebaseAuth.instance.signInAnonymously();
    for (int j = 0; j < snap.docs.length; j++) {
      List<SearchTagImageUrl> subTag = [];
      for (int i = 0; i < snap.docs[j].get('tag').length; i++) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('Tag/${snap.docs[j].get('tag')[i]}.png');

        final fetchedData = await ref.getDownloadURL();
        subTag.add(SearchTagImageUrl(
            url: fetchedData, tag: snap.docs[j].get('tag')[i]));
      }
      localSearchTag.add(SearchTag.from(snap.docs[j], subTag));
    }
    final maps = localSearchTag.map((e) => e.toJson()).toList();
    searchTag = localSearchTag;
    String data = jsonEncode(maps);
    spHelper.setPreference(sp_search, data);

    // snap.docs.map((e) async {}).toList();
    //await FirebaseAuth.instance.signOut();

    // return localSearchTag;
  }

  Future<List<MusicModel>> getDataBytTag(List<String> tag) async {
    List<MusicModel> data = [];

    final snap = await AudioBookRepo.tagSort(tagName: tag);

    data.addAll(snap.docs.map((doc) {
      return MusicModel.fromFirestore(doc);
    }));

    return data;
  }

  Future<List<SearchModel>> getListByGenreType(int offset) async {
    if (isGenreNext == false) return [];
    List<MusicModel> list = [];
    Map<String, List<MusicModel>> genre = {};
    final snap =
        await AudioBookRepo.getMusicList(field: "genre", descending: false);

    list.addAll(snap.docs.map((e) {
      return MusicModel.fromFirestore(e);
    }));

    // list.forEach((element) {
    //   if (genre[element.genre] == null) genre[element.genre] = [];
    //   genre[element.genre]!.add(element);
    // });

    List<SearchModel> searchModel = genre.entries
        .map((entry) => SearchModel(title: entry.key, musicModel: entry.value))
        .toList();

    isGenreNext = false;
    return searchModel;
  }

  List<MusicModel> byScenarioAuthor = [];

  Future<List<ScenarioModel>> getListByScenarioAuthor(int offset) async {
    if (isScenarioAuthorNext == false) return [];
    List<MusicModel> list = [];
    Map<String, List<MusicModel>> scenario = {};
    final snap = await AudioBookRepo.getMusicList(
        field: "scenarioAuthor", descending: false);

    list.addAll(snap.docs.map((e) {
      return MusicModel.fromFirestore(e);
    }));

    // list.forEach((element) {
    //   if (scenario[element.scenarioAuthor.name] == null)
    //     scenario[element.scenarioAuthor.name] = [];
    //   scenario[element.scenarioAuthor.name]!.add(element);
    // });

    List<ScenarioModel> scenarioModel = scenario.entries
        .map(
            (entry) => ScenarioModel(title: entry.key, musicModel: entry.value))
        .toList();

    isScenarioAuthorNext = false;
    return scenarioModel;
  }

  List<ActorModel> bySearchActor = [];

  Future<List<ActorModel>> getListByVoiceActor(int offset) async {
    if (isVoiceActorNext == false) return [];
    List<MusicModel> list = [];
    Map<String, List<MusicModel>> actor = {};
    final snap = await AudioBookRepo.getMusicList(
        field: "voiceActor", descending: false);

    list.addAll(snap.docs.map((e) {
      return MusicModel.fromFirestore(e);
    }));

    // list.forEach((element) {
    //   if (actor[element.voiceActor.name] == null)
    //     actor[element.voiceActor.name] = [];
    //   actor[element.voiceActor.name]!.add(element);
    // });

    List<ActorModel> actorModel = actor.entries
        .map((entry) => ActorModel(title: entry.key, musicModel: entry.value))
        .toList();

    isVoiceActorNext = false;
    return actorModel;
  }
}
