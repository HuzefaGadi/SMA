import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ams/core/models/settings.dart';
import 'package:ams/core/utils/application.dart';
import 'package:ams/core/utils/shared_pref_util.dart';
import 'package:ams/ui/router.dart' as rtr;
import 'package:ams/ui/views/home_view.dart';

import 'locator.dart';
import 'ui/shared/locatization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await SharedPrefUtil.init();
  Settings settings = SharedPrefUtil.getSettings();
  if (settings == null) {
    settings = Settings();
    settings.password = "1234";
    settings.tempUnit = 1;
    SharedPrefUtil.setSettings(settings);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      title: 'AMS',
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      navigatorKey: locator<Application>().navigatorKey,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      onGenerateRoute: rtr.Router.generateRoute,
      initialRoute: HomeView.routeName,
    );
  }
}
