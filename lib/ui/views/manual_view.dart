import 'package:ams/core/utils/application.dart';
import 'package:ams/core/utils/characteristics_util.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/ui/views/bluetooth_off_view.dart';
import 'package:ams/ui/widgets/custom_widgets.dart';
import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ManualView extends StatefulWidget {
  HomeModel model;

  setModel(HomeModel model) {
    this.model = model;
  }

  @override
  _ManualViewState createState() => _ManualViewState();
}

class _ManualViewState extends State<ManualView> {
  HomeModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
    BluetoothEnable.enableBluetooth.then((status) {
      if (status == "false") {
        // BotToast.showText(text: "Please turn on your Bluetooth");
        return;
      } else {
        setState(() {});
      }
    });
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
                title: Text('Manual Settings'),
                actions: [Application.getGlobalAction(context, model)],
              ),
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, Colors.grey]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        DeviceView(model),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state == BluetoothState.off) {
            return BluetoothOffView(state: state);
          } else {
            return Container();
          }
        });
  }
}

class DeviceView extends StatelessWidget {
  static const routeName = "deviceScreen";
  final HomeModel model;
  final String serviceUUID = "1842467c-7cbc-11e9-8f9e-2a86e4085a59";
  final String serviceUUID2 = "1942467c-7cbc-11e9-8f9e-2a86e4085a59";
  final String loadCharUUID = "0186686a-53dc-25b3-0c4a-f0e10c8dee20";
  final String statusCharUUID = "0286686a-53dc-25b3-0c4a-f0e10c8dee20";
  final String deliveredPowerCharUUID = "0a86686a-53dc-25b3-0c4a-f0e10c8dee20";

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
                      // BluetoothService service = snapshot.data[0];
                      // if (service != null) {
                      //   if (service.characteristics.isNotEmpty) {
                      //     BluetoothCharacteristic characteristic = service.characteristics[0];
                      //     if (characteristic != null) {
                      //       //  model.setWriteCharacteristic(characteristic);
                      //       return DashboardWidget(model);
                      //     }
                      //   }
                      // }

                      List<BluetoothService> list = snapshot.data
                          .where((service) =>
                              service.uuid.toString() == serviceUUID || service.uuid.toString() == serviceUUID2)
                          .toList();

                      if (list.isNotEmpty) {
                        BluetoothService service = list[0].uuid.toString() == serviceUUID ? list[0] : list[1];
                        BluetoothService service2 = list[0].uuid.toString() == serviceUUID2 ? list[0] : list[1];
                        if (service2 != null) {
                          List<BluetoothCharacteristic> characteristics = service2.characteristics
                              .where((characteristic) =>
                                  characteristic.uuid.toString() == ("02" + model.commonCharSuffix2))
                              .toList();
                          if (characteristics.isNotEmpty) {
                            model.setCharacteristicForRefresh(characteristics[0]);
                          }
                        }
                        if (service != null) {
                          List<BluetoothCharacteristic> characteristics = service.characteristics
                              .where(
                                  (characteristic) => characteristic.uuid.toString().endsWith(model.commonCharSuffix))
                              .toList();
                          if (characteristics.isNotEmpty) {
                            model.setCharacteristics(characteristics);
                            return DashboardWidget(model);
                          }
                        }
                      }
                    }
                    return DashboardWidget(model);
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

class DashboardWidget extends StatefulWidget {
  final HomeModel model;

  DashboardWidget(this.model);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  bool clicked = true;
  String timerValue = 'NA';

  @override
  void dispose() {
    // widget.model.clearStreams();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.model.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < widget.model.readingTitles.length; i++) {
      children.add(
        Unit.name(widget.model, i * 3, widget.model.readingTitles[i], 3),
      );
    }
    // children.add(AvailableTotalUnit.name(widget.model));
    children.add(SizedBox(
      height: 16,
    ));
    children.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MobiButton(text: "Req Power Alloc", onPressed: () {}),
      )),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MobiButton(text: "Disable", onPressed: () {}),
      )),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MobiButton(text: "Reset", onPressed: () {}),
      ))
    ]));
    children.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MobiButton(text: "Night Mode", onPressed: () {}),
      )),
    ]));
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class AvailableTotalUnit extends StatefulWidget {
  HomeModel model;

  @override
  _AvailableTotalUnitState createState() => _AvailableTotalUnitState();

  AvailableTotalUnit.name(this.model);
}

class _AvailableTotalUnitState extends State<AvailableTotalUnit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text("Tot. Avail"), Text("Tot. Deli"), Text("Pool"), Text("Tot. Spare")],
        ),
        Row(
          children: [
            StreamBuilder<String>(
                stream: widget.model.streams[CharacteristicUtils.totalAvailable],
                builder: (context, snapshot) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(snapshot.data ?? ""),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                    ),
                  ));
                }),
            StreamBuilder<String>(
                stream: widget.model.streams[0],
                builder: (context, snapshot) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(snapshot.data ?? ""),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                    ),
                  ));
                }),
            StreamBuilder<String>(
                stream: widget.model.streams[0],
                builder: (context, snapshot) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(snapshot.data ?? ""),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                    ),
                  ));
                }),
            StreamBuilder<String>(
                stream: widget.model.streams[0],
                builder: (context, snapshot) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(snapshot.data ?? ""),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                    ),
                  ));
                }),
          ],
        )
      ],
    );
  }
}

class Unit extends StatefulWidget {
  HomeModel model;
  int startIndex;
  String title;
  int totalChannels;

  Unit.name(this.model, this.startIndex, this.title, this.totalChannels);

  @override
  _UnitState createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (widget.title != null) {
      children.add(
        Expanded(child: MobiText(text: widget.title)),
      );
    }
    for (int i = 0; i < widget.totalChannels; i++) {
      children.add(widget.startIndex == 0 ? getCableStatus(i) : getOtherStatus(i));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  getCableStatus(i) {
    return StreamBuilder<String>(
        stream: widget.model.streams[widget.startIndex + i],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("snapshotdata ${snapshot.data}");
          }
          return Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.all(5),
              child: Center(
                child: Image.asset("images/usb.png"),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(),
              ),
            ),
          ));
        });
  }

  getOtherStatus(i) {
    return StreamBuilder<String>(
        stream: widget.model.streams[widget.startIndex + i],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("snapshotdata ${snapshot.data}");
          }
          return Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.all(5),
              child: Center(
                child: Text(snapshot.data ?? ""),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.grey, Colors.white]),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(),
              ),
            ),
          ));
        });
  }
}
