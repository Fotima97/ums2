class ChatModel {
  String title;
  String description;
  List<Items> items;

  ChatModel({this.title, this.items, this.description});
  factory ChatModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Items> packages = list.map((i) => Items.fromJson(i)).toList();
    return ChatModel(
            title: parsedJson['title'] ?? '...',
            description: parsedJson['description']?? '...',
            items: packages) ??
        '';
  }
}

class Items {
  String title;
  String price;
  String ussd;
  Items({this.title, this.price, this.ussd});
  factory Items.fromJson(Map<String, dynamic> parsedJson) {
    return Items(
            title: parsedJson['title'] ?? '...',
            price: parsedJson['price'] ?? '...',
            ussd: parsedJson['ussd']) ??
        '...';
  }
}
