import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ams/core/viewmodels/base_model.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/locator.dart';
import 'package:ams/ui/views/base_view.dart';
import 'package:ams/ui/views/bluetooth_off_view.dart';
import 'package:ams/ui/views/device_view.dart';
import 'package:ams/ui/views/rules_view.dart';
import 'package:ams/ui/views/settings_view.dart';
import 'package:ams/ui/widgets/custom_widgets.dart';
import 'package:ams/ui/widgets/dashboard.dart';

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
                connectDeviceAndDiscoverServices(device, model);
              });
            }
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              var device = await Navigator.pushNamed(context, FindDevicesScreen.routeName);
              connectDeviceAndDiscoverServices(device, model);
            });
          }
        }, builder: (context, model, child) {
          return getItemToDisplay(currentIndex, model);
        }),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Auto")),
            BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Manual")),
            BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("View")),
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
        return FlutterBlueApp(model);
      case 1:
        // RulesView rulesView = locator<RulesView>();
        // rulesView.setHomeModel(model);
        // return rulesView;
        return Container();

      case 2:
        // SettingsView settingsView = locator<SettingsView>();
        // settingsView.setHomeModel(model);
        // return settingsView;
        return Container();
    }
  }
}

class FlutterBlueApp extends StatefulWidget {
  HomeModel model;

  FlutterBlueApp(this.model);

  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  HomeModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Auto Settings'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () async {
                        var device = await Navigator.pushNamed(context, FindDevicesScreen.routeName);
                        connectDeviceAndDiscoverServices(device, model);
                      },
                      child: Icon(Icons.settings_bluetooth),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DeviceView(model),
                    ],
                  ),
                ),
              ),
            );
          }
          return BluetoothOffView(state: state);
        });
  }
}

void connectDeviceAndDiscoverServices(Object device, HomeModel model) {
  if (device != null) {
    model.setState(ViewState.Busy);
    model.setBluetoothDevice(device);
    try {
      model.connectBluetoothDevice();
    } catch (e) {
      print(e);
    }

    BotToast.showLoading();
    Future.delayed(Duration(seconds: 3), () {
      print("This is called");
      BluetoothDevice device = model.getBluetoothDevice();
      device.discoverServices();
      BotToast.closeAllLoading();
    });
    model.setState(ViewState.Idle);
  }
}
