class InternetPackages {
  String title;
  String description;
  List<Packages> itemList;

  InternetPackages({this.title, this.description, this.itemList});
  factory InternetPackages.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Packages> packages = list.map((i) => Packages.fromJson(i)).toList();
    return InternetPackages(
            title: parsedJson['title'] ?? '...',
            description: parsedJson['description'] ?? '...',
            itemList: packages) ??
        '';
  }
}

class Packages {
  String title;
  String price;
  String ussd;
  Packages({this.title, this.price, this.ussd});
  factory Packages.fromJson(Map<String, dynamic> parsedJson) {
    return Packages(
            title: parsedJson['title'] ?? '...',
            price: parsedJson['price'] ?? '...',
            ussd: parsedJson['ussd']) ??
        '...';
  }
}
