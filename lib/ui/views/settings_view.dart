import 'package:ams/core/models/settings.dart';
import 'package:ams/core/utils/shared_pref_util.dart';
import 'package:ams/core/viewmodels/base_model.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/ui/views/base_view.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsView extends StatefulWidget {
  static const routeName = "HomeView";
  HomeModel homeModel;

  setHomeModel(HomeModel homeModel) {
    this.homeModel = homeModel;
  }

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _temperatureUnit = 0;
  Settings settings = SharedPrefUtil.getSettings();
  String _password;

  @override
  void initState() {
    _temperatureUnit = settings.tempUnit;
    _password = settings.password;
    super.initState();
  }

  @override
  void dispose() {
    settings.tempUnit = _temperatureUnit;
    settings.password = _password;
    SharedPrefUtil.setSettings(settings);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BaseView<HomeModel>(
          onModelReady: (model) async {
            model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
          },
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(title: Text('View')),
              body: Container(),
            );
          },
        ),
      ),
    );
  }
}
