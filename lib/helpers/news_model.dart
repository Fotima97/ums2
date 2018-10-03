class NewsModel {
  String title;
  String body;
  String id;
  NewsModel({this.title, this.body, this.id});
  factory NewsModel.fromJson(Map<String, dynamic> parsedJson) {
    return NewsModel(
        title: parsedJson['title'] ?? '...',
        body: parsedJson['body'] ?? '...',
        id: parsedJson['id'] ?? '');
  }
}
