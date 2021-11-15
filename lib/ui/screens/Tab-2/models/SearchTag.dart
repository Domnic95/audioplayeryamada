import 'package:cloud_firestore/cloud_firestore.dart';

class SearchTag {
  List<SearchTagImageUrl> tag;
  String title;

  SearchTag({required this.tag, required this.title});
  factory SearchTag.from(DocumentSnapshot doc, List<SearchTagImageUrl> tags) {
    return SearchTag(tag: tags, title: doc.get('title'));
  }
  factory SearchTag.fromJson(Map<String, dynamic> json) => SearchTag(
      tag: (json['tag'] as List)
          .map((e) => SearchTagImageUrl.fromJson(e))
          .toList(),
      title: json['title']);
  Map<String, dynamic> toJson() =>
      {'tag': tag.map((e) => e.toJson()).toList(), 'title': title};
}

class SearchTagImageUrl {
  String tag;
  String url;
  SearchTagImageUrl({required this.url, required this.tag});
  factory SearchTagImageUrl.fromJson(Map<String, dynamic> json) =>
      SearchTagImageUrl(url: json['url'], tag: json['tag']);
  Map<String, dynamic> toJson() => {'tag': tag, 'url': url};
}
