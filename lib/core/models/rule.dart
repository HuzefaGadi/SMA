class Rule {
  int index;
  bool created;
  bool enabled;
  int onmin;
  int offmin;
  int weekday;
  String name;

  Rule({this.index, this.created, this.enabled, this.onmin, this.offmin, this.weekday, this.name});

  Rule.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    created = json['created'];
    enabled = json['enabled'];
    onmin = json['onmin'];
    offmin = json['offmin'];
    weekday = json['weekday'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['created'] = this.created;
    data['enabled'] = this.enabled;
    data['onmin'] = this.onmin;
    data['offmin'] = this.offmin;
    data['weekday'] = this.weekday;
    data['name'] = this.name;
    return data;
  }
}
