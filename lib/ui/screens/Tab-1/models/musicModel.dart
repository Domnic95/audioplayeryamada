import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MusicModel {
  MusicModel({
    required this.track,
    required this.cv,
    required this.featured,
    // required this.date,
    required this.desc,
    required this.counter,
    // required this.genre,
    required this.image,
    required this.about,
    // required this.rank,
    //required this.scenarioAuthor,
    required this.title,
    // required this.voiceActor,
    required this.id,
  });

  List<Track> track = [];
  // String about;
  List<String> cv = [];
  Timestamp date = Timestamp.now();
  String desc = '';
  int counter = 0;
  // String genre;
  int featured = 0;
  String image = '';
  String about = '';
  // double rank;
  //ScenarioAuthor scenarioAuthor;
  String title = '';
  // VoiceActor voiceActor;
  String id = '';

  getImageUrl() async {
    if (image == "") {
      var url = await FirebaseStorage.instance
          .ref("AudioBook")
          .child("/$id/image.webp")
          .getDownloadURL();
      image = url;
    }
  }

  factory MusicModel.fromFirestore(DocumentSnapshot snapshot,
      {List<String>? url}) {
    List<Track> tracks = [];
    final list = snapshot.get("track") ?? [];
    if (url != null) {
      if (url.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          tracks.add(Track.fromJson(list[i], url: url[i]));
        }
      } else {
        tracks = List<Track>.from(list.map((x) => Track.fromJson(x)).toList());
      }
    } else {
      tracks = List<Track>.from(list.map((x) => Track.fromJson(x)).toList());
    }

    return MusicModel(
        // track: List<Track>.from((snapshot.get("track") ?? []).map((x) =>
        //     Track.fromJson(x,
        //         url: url != null ? (url.isNotEmpty ? url[0] : null) : null))),
        track: tracks,
        cv: List<String>.from(snapshot.get("cv").map((x) => x)),
        // date: snapshot.get("date") ?? Timestamp.now(),
        desc: snapshot.get("desc") ?? "",
        //  genre: snapshot.get("genre") ?? "",
        image: snapshot.get("image") ?? "",
        counter: snapshot.get('played'),
        about: snapshot.get('about') ?? "",
        // rank: double.parse((snapshot.get("rank") ?? "0.0").toString()),

        // scenarioAuthor:
        //     ScenarioAuthor.fromFireStore(snapshot.get("scenarioAuthor")),
        // //ScenarioAuthor(image: '',name: ''),

        title: snapshot.get("title") ?? "",
        // voiceActor: VoiceActor.fromFireStore(snapshot.get("voiceActor")),
        featured: snapshot.get("featured") ?? 0,
        id: snapshot.id);
  }
  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
      track: (json['track'] as List).map((e) => Track.fromJson(e)).toList(),
      cv: (json['cv'] as List).map((e) => e.toString()).toList(),
      featured: json['featured'],
      // date: json['date'],
      desc: json['desc'],
      counter: json['counter'],
      image: json['image'],
      about: json['about'],
      title: json['title'],
      id: json['id']);
  Map<String, dynamic> toJson() => {
        'track': track.map((e) => e.toJson()).toList(),
        'cv': cv.map((e) => e.toString()).toList(),
        'featured': featured,
        // 'date': date,
        'desc': desc,
        'counter': counter,
        'image': image,
        'about': about,
        'title': title,
        'id': id
      };
}

class VoiceActor {
  VoiceActor({
    required this.image,
    required this.name,
  });

  String image;
  String name;

  factory VoiceActor.fromFireStore(Map map) => VoiceActor(
        image: map["image"] ?? "",
        name: map["name"] ?? "",
      );
}

class ScenarioAuthor {
  ScenarioAuthor({
    required this.image,
    required this.name,
  });

  String image;
  String name;

  factory ScenarioAuthor.fromFireStore(Map map) => ScenarioAuthor(
        image: map["image"] ?? "",
        name: map["name"] ?? "",
      );
}

class Track {
  Track({
    required this.name,
    required this.url,
    required this.duration,
  });

  String name;
  String url;
  int duration;

  factory Track.fromJson(Map map, {String? url}) {
    return Track(
      name: map["name"] ?? "",
      url: url ??  "",
      duration: map["duration"] ?? 0,
    );
  }
  Map<String, dynamic> toJson() =>
      {'name': name, 'url': url, 'duration': duration};
}
