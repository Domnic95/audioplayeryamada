import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';

class ActorModel {
  ActorModel({
    required this.title,
    required this.musicModel,
  });

  String title;
  List<MusicModel> musicModel;
}
