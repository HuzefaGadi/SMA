import 'package:ams/core/models/rule.dart';
import 'package:ams/core/models/settings.dart';
import 'package:ams/core/utils/shared_pref_util.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RulesDetailsView extends StatefulWidget {
  static const routeName = "RulesDetailView";
  HomeModel homeModel;
  Rule rule;

  setArguments(RulesArguments rulesArguments) {
    this.homeModel = rulesArguments.model;
    this.rule = rulesArguments.rule;
  }

  @override
  _RulesDetailsViewState createState() => _RulesDetailsViewState();
}

class RulesArguments {
  RulesArguments({this.model, this.rule});

  final HomeModel model;
  final Rule rule;
}

class _RulesDetailsViewState extends State<RulesDetailsView> {
  Settings settings = SharedPrefUtil.getSettings();
  TextEditingController ruleNameController = new TextEditingController();
  TextEditingController startTimeController = new TextEditingController();
  TextEditingController endTimeController = new TextEditingController();
  List<bool> days = [true, true, true, true, true, true, true];
  List<String> daysName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  HomeModel model;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(title: Text('Rule Details')), body: Container()),
    );
  }
}
