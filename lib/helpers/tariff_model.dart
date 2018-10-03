class TarrifModel {
  String title;
  String price;
  String ussd;
  List<Description> description;

  TarrifModel({this.title, this.price, this.ussd, this.description});
  factory TarrifModel.fromJson(Map<String, dynamic> parsedJson) {
    var desc = parsedJson['descriptions'] as List;
    List<Description> packages =
        desc.map((i) => Description.fromJson(i)).toList();
    return TarrifModel(
            title: parsedJson['title'] ?? '...',
            price: parsedJson['price'] ?? '...',
            ussd: parsedJson['ussd'] ?? '...',
            description: packages) ??
        '';
  }
}

class Description {
  String title;
  String value;
  String icon;
  Description({this.title, this.value, this.icon});
  factory Description.fromJson(Map<String, dynamic> parsedJson) {
    return Description(
            title: parsedJson['title'] ?? '...',
            value: parsedJson['value'] ?? '...',
            icon: parsedJson['icon']) ??
        '...';
  }
}
