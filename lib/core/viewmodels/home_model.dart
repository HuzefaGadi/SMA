import 'package:ams/core/services/home_service.dart';
import 'package:ams/core/viewmodels/base_model.dart';
import 'package:ams/locator.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomeModel extends BaseModel {
  final HomeService _homeService = locator<HomeService>();
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _powerCharacteristic, _loadCharacteristic, _statusCharacteristic;
  String power, load, status;
  String response = "";

  BluetoothCharacteristic get powerCharacteristic => _powerCharacteristic;

  BluetoothCharacteristic get loadCharacteristic => _loadCharacteristic;

  BluetoothCharacteristic get statusCharacteristic => _statusCharacteristic;

  Future<void> setPowerCharacteristic(BluetoothCharacteristic characteristic) async {
    print("setPowerCharacteristic");
    _powerCharacteristic = characteristic;
    await _powerCharacteristic.setNotifyValue(true);
    _powerCharacteristic.value.listen(getPowerCharesteristicListener());
  }

  Future<void> setLoadCharacteristic(BluetoothCharacteristic characteristic) async {
    print("setLoadCharacteristic");
    _loadCharacteristic = characteristic;
    await _loadCharacteristic.setNotifyValue(true);
    _loadCharacteristic.value.listen(getLoadCharacteristicListener());
  }

  Future<void> setStatusCharacteristic(BluetoothCharacteristic characteristic) async {
    print("setStatusCharacteristic");
    _statusCharacteristic = characteristic;
    await _statusCharacteristic.setNotifyValue(true);
    _statusCharacteristic.value.listen(getStatusCharacteristicListener());
  }

  void setBluetoothDevice(BluetoothDevice device) {
    _bluetoothDevice = device;
    _homeService.setBleDeviceAddress(device.id.toString());
  }

  bool isBluetoothConnected() {
    return _bluetoothDevice?.state == BluetoothDeviceState.connected;
  }

  String getBleDeviceAddress() {
    return _homeService.getBleDeviceAddress();
  }

  void connectBluetoothDevice() {
    if (_bluetoothDevice != null) {
      _bluetoothDevice.connect(autoConnect: false);
    }
  }

  BluetoothDevice getBluetoothDevice() {
    return _bluetoothDevice;
  }

  Function getPowerCharesteristicListener() {
    return (value) {
      try {
        print("getPowerCharesteristicListener");
        print(value);
        String abc = "";
        for (int i in value) {
          abc += '${i} ';
        }
        response = abc;
        print(response);
        if (value.isNotEmpty) {
          power = response;
          setState(ViewState.Idle);
        }
      } catch (e) {
        print(e);
      }
    };
  }

  Function getLoadCharacteristicListener() {
    return (value) {
      try {
        print("getLoadCharacteristicListener");
        print(value);
        String abc = "";
        for (int i in value) {
          abc += '${i} ';
        }
        response = abc;
        print(response);
        if (value.isNotEmpty) {
          load = response;
          setState(ViewState.Idle);
        }
      } catch (e) {
        print(e);
      }
    };
  }

  Function getStatusCharacteristicListener() {
    return (value) {
      try {
        print("getStatusCharacteristicListener");
        print(value);
        String abc = "";
        for (int i in value) {
          abc += '${i} ';
        }
        response = abc;
        print(response);
        if (value.isNotEmpty) {
          status = response;
          setState(ViewState.Idle);
        }
      } catch (e) {
        print(e);
      }
    };
  }

  List<int> getInt32Bytes(x) {
    List<int> bytes = [0, 0, 0, 0];
    for (var i = 0; i < 4; i++) {
      bytes[i] = x & (255);
      x = x >> 8;
    }
    return bytes;
  }

  List<int> getInt16Bytes(x) {
    List<int> bytes = [0, 0];
    for (var i = 0; i < 2; i++) {
      bytes[i] = x & (255);
      x = x >> 8;
    }
    return bytes;
  }
}
