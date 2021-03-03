class Settings {
  String password;
  int tempUnit;
  String thermostat;

  Settings({this.password, this.tempUnit, this.thermostat});

  Settings.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    tempUnit = json['tempUnit'];
    thermostat = json['thermostat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['tempUnit'] = this.tempUnit;
    data['thermostat'] = this.thermostat;
    return data;
  }
}
