import 'package:ams/core/viewmodels/base_model.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/ui/views/find_devices_view.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Application {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  static Widget getGlobalAction(BuildContext context, HomeModel model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          var device = await Navigator.pushNamed(context, FindDevicesScreen.routeName);
          connectDeviceAndDiscoverServices(device, model);
        },
        child: Icon(Icons.settings_bluetooth),
      ),
    );
  }

  static connectDeviceAndDiscoverServices(Object device, HomeModel model) {
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
}
