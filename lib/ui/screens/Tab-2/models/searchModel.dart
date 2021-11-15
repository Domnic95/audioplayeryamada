import '../../Tab-1/models/musicModel.dart';

class SearchModel {
  SearchModel({
    required this.title,
    required this.musicModel,
  });

  String title;
  List<MusicModel> musicModel;
}
