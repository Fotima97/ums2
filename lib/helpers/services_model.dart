class ServicesModel {
  String title;
  String body;
  Buttons buttons;

  ServicesModel({this.title, this.body, this.buttons});
  factory ServicesModel.fromJson(Map<String, dynamic> parsedJson) {
    return ServicesModel(
        title: parsedJson['title'] ?? '',
        body: parsedJson['body'] ?? '',
        buttons: Buttons.fromJson(parsedJson['buttons']));
  }
}

class Buttons {
  Settings accept;
  Settings decline;
  Buttons({this.accept, this.decline});
  factory Buttons.fromJson(Map<String, dynamic> json) {
    return Buttons(
        accept: Settings.fromJson(json['accept']),
        decline: Settings.fromJson(json['decline'] ?? null));
  }
}

class Settings {
  String title;
  String icon;
  String ussd;
  Settings({this.title, this.icon, this.ussd});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
        title: json['title'] ?? '',
        icon: json['icon'] ?? '',
        ussd: json['ussd'] ?? '');
  }
}
