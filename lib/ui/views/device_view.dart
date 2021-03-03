import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/ui/widgets/dashboard.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceView extends StatelessWidget {
  static const routeName = "deviceScreen";
  final HomeModel model;
  final List serviceUUID = [
    0x59,
    0x5a,
    0x08,
    0xe4,
    0x86,
    0x2a,
    0x9e,
    0x8f,
    0xe9,
    0x11,
    0xbc,
    0x7c,
    0x7c,
    0x46,
    0x42,
    0x18
  ];

  final List loadCharUUID = [
    0x20,
    0xEE,
    0x8D,
    0x0C,
    0xE1,
    0xF0,
    0x4A,
    0x0C,
    0xB3,
    0x25,
    0xDC,
    0x53,
    0x6A,
    0x68,
    0x86,
    0x01
  ];
  final List statusCharUUID = [
    0x20,
    0xEE,
    0x8D,
    0x0C,
    0xE1,
    0xF0,
    0x4A,
    0x0C,
    0xB3,
    0x25,
    0xDC,
    0x53,
    0x6A,
    0x68,
    0x86,
    0x02
  ];
  final List allocatedPowerCharUUID = [
    0x20,
    0xEE,
    0x8D,
    0x0C,
    0xE1,
    0xF0,
    0x4A,
    0x0C,
    0xB3,
    0x25,
    0xDC,
    0x53,
    0x6A,
    0x68,
    0x86,
    0x0F
  ];

  DeviceView(this.model);

  @override
  Widget build(BuildContext context) {
    BluetoothDevice device = model.getBluetoothDevice();

//        actions: <Widget>[
//          StreamBuilder<BluetoothDeviceState>(
//            stream: device.state,
//            initialData: BluetoothDeviceState.connecting,
//            builder: (c, snapshot) {
//              VoidCallback onPressed;
//              String text;
//              switch (snapshot.data) {
//                case BluetoothDeviceState.connected:
//                  onPressed = () => device.disconnect();
//                  text = 'DISCONNECT';
//                  break;
//                case BluetoothDeviceState.disconnected:
//                  onPressed = () => device.connect(autoConnect: false);
//                  text = 'CONNECT';
//                  break;
//                default:
//                  onPressed = null;
//                  text = snapshot.data.toString().substring(21).toUpperCase();
//                  break;
//              }
//              return FlatButton(
//                  onPressed: onPressed,
//                  child: Text(
//                    text,
//                    style: Theme.of(context)
//                        .primaryTextTheme
//                        .button
//                        .copyWith(color: Colors.white),
//                  ));
//            },
//          )
//        ],
    return device != null
        ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<BluetoothService>>(
                  stream: device.services,
                  initialData: [],
                  builder: (c, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      /*   BluetoothService service = snapshot.data[0];
                      if (service != null) {
                        if (service.characteristics.isNotEmpty) {
                          BluetoothCharacteristic characteristic = service.characteristics[0];
                          if (characteristic != null) {
                            model.setWriteCharacteristic(characteristic);
                            return DashboardWidget(model);
                          }
                        }*/
                      Function eq = const ListEquality().equals;
                      List<BluetoothService> list =
                          snapshot.data.where((service) => eq(service.uuid.toByteArray(), serviceUUID)).toList();

                      if (list.isNotEmpty) {
                        BluetoothService service = list[0];
                        if (service != null) {
                          List<BluetoothCharacteristic> characteristics = service.characteristics
                              .where((characteristic) =>
                                  eq(characteristic.uuid.toByteArray(), allocatedPowerCharUUID) ||
                                  eq(characteristic.uuid.toByteArray(), statusCharUUID) ||
                                  eq(characteristic.uuid.toByteArray(), loadCharUUID))
                              .toList();
                          if (characteristics.isNotEmpty) {
                            for (BluetoothCharacteristic characteristic in characteristics) {
                              if (eq(characteristic.uuid.toByteArray(), allocatedPowerCharUUID)) {
                                model.setPowerCharacteristic(characteristic);
                              } else if (eq(characteristic.uuid.toByteArray(), statusCharUUID)) {
                                model.setStatusCharacteristic(characteristic);
                              } else if (eq(characteristic.uuid.toByteArray(), loadCharUUID)) {
                                model.setLoadCharacteristic(characteristic);
                              }
                            }
                            return DashboardWidget(model);
                          }
                        }
                      }
                    }
                    return Container(child: Center(child: Text('No Suitable Characteristics found')));
                  },
                ),
              ],
            ),
          )
        : Column(
            children: <Widget>[
              Text('Please connect your bluetooth'),
            ],
          );
  }
}
