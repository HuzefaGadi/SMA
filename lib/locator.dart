import 'package:ams/core/utils/application.dart';
import 'package:get_it/get_it.dart';
import 'package:ams/core/services/home_service.dart';
import 'package:ams/core/utils/shared_pref_util.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/ui/views/find_devices_view.dart';
import 'package:ams/ui/views/rules_detail_view.dart';
import 'package:ams/ui/views/rules_view.dart';
import 'package:ams/ui/views/settings_view.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => HomeService());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => FindDevicesScreen());
  locator.registerFactory(() => SharedPrefUtil());
  locator.registerFactory(() => SettingsView());
  locator.registerFactory(() => RulesDetailsView());
  locator.registerFactory(() => RulesView());
  locator.registerFactory(() => Application());
}
