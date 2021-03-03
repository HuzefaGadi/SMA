import 'package:ams/core/viewmodels/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RulesView extends StatefulWidget {
  static const routeName = "HomeView";
  HomeModel homeModel;

  setHomeModel(HomeModel homeModel) {
    this.homeModel = homeModel;
  }

  @override
  _RulesViewState createState() => _RulesViewState();
}

class _RulesViewState extends State<RulesView> {
  HomeModel model;

  @override
  void initState() {
    model = widget.homeModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Manual Settings'),
      ),
      body: Container(),
    ));
  }
}
