import 'dart:async';

import 'package:ams/core/services/home_service.dart';
import 'package:ams/core/utils/characteristics_util.dart';
import 'package:ams/core/viewmodels/base_model.dart';
import 'package:ams/locator.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomeModel extends BaseModel {
  final HomeService _homeService = locator<HomeService>();
  BluetoothDevice _bluetoothDevice;
  List<BluetoothCharacteristic> characteristics = [];
  String response = "";
  List<StreamController> _streamControllers = [];
  List<Stream> streams = [];
  List<Sink> sinks = [];
  List<String> characteristicUUIDs = [];
  String commonCharSuffix = "86686a-53dc-25b3-0c4a-f0e10c8dee20";
  int totalReadings = 40;
  List<String> readingTitles = [];
  HomeModel() {
    _streamControllers = [];
    streams = [];
    sinks = [];
    for (int i = 0; i < totalReadings; i++) {
      _streamControllers.add(StreamController<String>());
      streams.add(_streamControllers[i].stream.asBroadcastStream());
      sinks.add(_streamControllers[i].sink);
    }

    for (int i = 0; i < totalReadings / 3; i++) {
      characteristicUUIDs.add(i.toRadixString(16).padLeft(2, '0').toLowerCase() + commonCharSuffix);
    }
    characteristics = List.filled(totalReadings, null);
    readingTitles.add("Port");
    readingTitles.add("Load");
    readingTitles.add("Status");
    readingTitles.add("Fault");
    readingTitles.add("Req V");
    readingTitles.add("Req C");
    readingTitles.add("Req P");
    readingTitles.add("Alloc P");
    readingTitles.add("Del V");
    readingTitles.add("Del C");
    readingTitles.add("Del P");
    readingTitles.add("Spare");
  }

  Future<void> setCharacteristics(List<BluetoothCharacteristic> chars) async {
    for (BluetoothCharacteristic characteristic in chars) {
      await setCharacteristic(characteristic);
    }
  }

  Future<void> setCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      int characteristicIndex = characteristicUUIDs.indexOf(characteristic.uuid.toString());
      print("setCharacteristic uuid ${characteristic.uuid.toString()}");
      print("setCharacteristic index ${characteristicIndex}");

      characteristics[characteristicIndex] = characteristic;

      characteristics[characteristicIndex]
          .value
          .listen(new CharacteristicUtils().getCharacteristicListener(this, characteristicIndex * 3));
      await characteristic.setNotifyValue(true);
    } catch (e) {
      print(e);
    }
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

  @override
  void dispose() {
    super.dispose();
    clearStreams();
  }

  void clearStreams() {
    for (int i = 0; i < _streamControllers.length; i++) {
      _streamControllers[i].close();
    }
  }
}
