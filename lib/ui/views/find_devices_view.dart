import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ams/widgets.dart';
import 'package:location/location.dart';

class FindDevicesScreen extends StatefulWidget {
  static const routeName = "findDevicesScreen";
  String bleDevice;

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();

  void setData(Map<String, dynamic> data) {
    if (data.containsKey("bleDevice")) {
      this.bleDevice = data["bleDevice"];
    }
  }
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  void initState() {
    super.initState();

    Location location = new Location();
    bool _serviceEnabled;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BluetoothEnable.enableBluetooth.then((result) async {
        if (result == "true") {
          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              BotToast.showText(text: "Please turn on your GPS");
              return;
            }
          }
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
        } else if (result == "false") {
          //Bluetooth has not been enabled
          BotToast.showText(text: "Please turn on your Bluetooth");
          return;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(Duration(seconds: 2)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
                  initialData: [],
                  builder: (c, snapshot) {
                    if (snapshot.hasData && snapshot.data != null && snapshot.data.isNotEmpty) {
                      return Column(
                        children: snapshot.data.map((d) {
                          print(widget.bleDevice);
                          if (widget.bleDevice != null && d.id.toString() == widget.bleDevice) {
                            FlutterBlue.instance.stopScan();
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context, d);
                            });
                          }
                          return ListTile(
                            title: Text(d.name ?? ""),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data == BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.pop(context, d),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                  }),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) {
                  print("Scanned results:" + snapshot.data.length.toString());
                  return snapshot.hasData
                      ? Column(
                          children: snapshot.data.map((r) {
                            if (widget.bleDevice != null && r.device.id.toString() == widget.bleDevice) {
                              FlutterBlue.instance.stopScan();
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                Navigator.pop(context, r.device);
                              });
                            }
                            return ScanResultTile(
                                result: r,
                                onTap: () {
                                  SchedulerBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pop(context, r.device);
                                  });
                                });
                          }).toList(),
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => FlutterBlue.instance.startScan(
                timeout: Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }
}
