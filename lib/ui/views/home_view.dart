import 'package:ams/core/utils/application.dart';
import 'package:ams/core/viewmodels/base_model.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/locator.dart';
import 'package:ams/ui/views/auto_view.dart';
import 'package:ams/ui/views/base_view.dart';
import 'package:ams/ui/views/manual_view.dart';
import 'package:ams/ui/views/settings_view.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'find_devices_view.dart';

class HomeView extends StatefulWidget {
  static const routeName = "HomeView";

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BaseView<HomeModel>(onModelReady: (model) async {
          model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
          String bleDevice = model.getBleDeviceAddress();
          if (bleDevice != null) {
            print("Bluetooth state");
            print(!model.isBluetoothConnected());
            if (!model.isBluetoothConnected()) {
              SchedulerBinding.instance.addPostFrameCallback((_) async {
                var device = await Navigator.pushNamed(context, FindDevicesScreen.routeName,
                    arguments: {"bleDevice": bleDevice});
                Application.connectDeviceAndDiscoverServices(device, model);
              });
            }
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              var device = await Navigator.pushNamed(context, FindDevicesScreen.routeName);
              Application.connectDeviceAndDiscoverServices(device, model);
            });
          }
        }, builder: (context, model, child) {
          return getItemToDisplay(currentIndex, model);
        }),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Auto"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Manual"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "View"),
          ],
          currentIndex: currentIndex,
          onTap: (currentIndex) {
            setState(() {
              this.currentIndex = currentIndex;
            });
          },
        ),
      ),
    );
  }

  getItemToDisplay(int selectedIndex, HomeModel model) {
    switch (selectedIndex) {
      case 0:
        AutoView autoView = locator<AutoView>();
        autoView.setModel(model);
        return autoView;
      case 1:
        ManualView manualView = locator<ManualView>();
        manualView.setModel(model);
        return manualView;
      case 2:
        SettingsView settingsView = locator<SettingsView>();
        settingsView.setHomeModel(model);
        return settingsView;
      //return Container();
    }
  }
}
