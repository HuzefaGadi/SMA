import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ams/core/models/rule.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/locator.dart';
import 'package:ams/ui/views/find_devices_view.dart';
import 'package:ams/ui/views/home_view.dart';
import 'package:ams/ui/views/rules_detail_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeView.routeName:
        return MaterialPageRoute(builder: (_) => HomeView());
      case RulesDetailsView.routeName:
        RulesDetailsView rulesDetailsView = locator<RulesDetailsView>();
        if (settings.arguments != null) {
          rulesDetailsView.setArguments(settings.arguments);
        }
        return MaterialPageRoute(builder: (_) => rulesDetailsView);
      case FindDevicesScreen.routeName:
        FindDevicesScreen findDevicesScreen = locator<FindDevicesScreen>();
        if (settings.arguments != null) {
          Map<String, dynamic> data = settings.arguments;
          findDevicesScreen.setData(data);
        }
        return MaterialPageRoute(builder: (_) => findDevicesScreen);
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
