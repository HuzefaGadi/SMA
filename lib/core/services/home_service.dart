import 'package:ams/core/models/settings.dart';
import 'package:ams/core/utils/shared_pref_util.dart';

class HomeService {
  String getBleDeviceAddress() {
    return SharedPrefUtil.getBleDeviceAddress();
  }

  Future<bool> setBleDeviceAddress(String address) {
    return SharedPrefUtil.setBleDeviceAddress(address);
  }
}
