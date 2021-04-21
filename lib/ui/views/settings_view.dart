import 'dart:async';
import 'dart:math';

import 'package:ams/core/utils/characteristics_util.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// class SettingsView extends StatefulWidget {
//   static const routeName = "HomeView";
//   HomeModel homeModel;
//
//   setHomeModel(HomeModel homeModel) {
//     this.homeModel = homeModel;
//   }
//
//   @override
//   _SettingsViewState createState() => _SettingsViewState();
// }

class SettingsView extends StatefulWidget {
  static const routeName = "HomeView";
  HomeModel homeModel;

  setHomeModel(HomeModel homeModel) {
    this.homeModel = homeModel;
  }

  @override
  _SparklineLiveUpdateState createState() => _SparklineLiveUpdateState();
}

class _SparklineLiveUpdateState extends State<SettingsView> {
  _SparklineLiveUpdateState();

  double _height = 140;
  Timer _timer;
  String _cpuValue = '';
  String _diskValue = '';
  String _memoryValue = '';
  String _ethernetValue = '';
  List<double> _cpuData = <double>[2];
  List<double> _diskData = <double>[3];
  List<double> _memoryData = <double>[2];
  List<double> _ethernetData = <double>[3];

  @override
  void initState() {
    _cpuValue = _cpuData[_cpuData.length - 1].round().toString();
    _diskValue = _diskData[_diskData.length - 1].round().toString();
    _memoryValue = _memoryData[_memoryData.length - 1].round().toString();
    _ethernetValue = _ethernetData[_ethernetData.length - 1].round().toString();
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), _updateData);
  }

  @override
  void dispose() {
    _cpuData = <double>[];
    _diskData = <double>[];
    _memoryData = <double>[];
    _ethernetData = <double>[];
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Container(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildChannel1Chart(),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
          ),
          _buildDiskDataChart(),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
          ),
          _buildMemoryDataChart(),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
          ),
          _buildEthernetDataChart(),
        ],
      )),
    );
  }

  // widget.homeModel.streams[CharacteristicUtils.allocPower1],
  // widget.homeModel.streams[CharacteristicUtils.delPower1],
  // widget.homeModel.streams[CharacteristicUtils.allocPower2],
  // widget.homeModel.streams[CharacteristicUtils.delPower2],
  // widget.homeModel.streams[CharacteristicUtils.allocPower3],
  // widget.homeModel.streams[CharacteristicUtils.delPower3]),

  Widget _buildChannel1Chart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5))),
            height: _height * .20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('CPU',
                          textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(
                          '$_cpuValue'
                          '%'
                          ' '
                          '${int.parse(_cpuValue) / 5}'
                          ' GHz',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 12, color: Color.fromRGBO(110, 43, 113, 1)))),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                  Expanded(
                      child: StreamBuilder<dynamic>(
                          stream: widget.homeModel.streams[CharacteristicUtils.allocPower1],
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SfSparkAreaChart(
                                data: snapshot.data,
                                axisLineWidth: 0,
                                color: Color.fromRGBO(184, 71, 189, 0.35),
                                borderColor: Color.fromRGBO(184, 71, 189, 1),
                                borderWidth: 1,
                              );
                            } else {
                              return Container();
                            }
                          }))
                ]),
          ),
        ]);
  }

  Widget _buildDiskDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5))),
            height: _height * .20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('Disk',
                          textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('$_diskValue' '%',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(34, 15, 132, 1),
                          ))),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                  Expanded(
                      child: SfSparkAreaChart(
                    data: _diskData,
                    axisCrossesAt: 0,
                    axisLineWidth: 0,
                    color: Color.fromRGBO(128, 94, 246, 0.3),
                    borderColor: Color.fromRGBO(128, 94, 246, 1),
                    borderWidth: 1,
                  ))
                ]),
          ),
        ]);
  }

  Widget _buildMemoryDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5))),
              height: _height * .20,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('Memory',
                            textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                            '${int.parse(_memoryValue) / 10}'
                            '/'
                            '15.8 GB '
                            '('
                            '${(((int.parse(_memoryValue) / 10) / 15.8) * 100).round()}'
                            '%'
                            ')',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(23, 118, 217, 1),
                            ))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Expanded(
                        child: SfSparkAreaChart(
                            data: _memoryData,
                            axisCrossesAt: 0,
                            axisLineWidth: 0,
                            color: Color.fromRGBO(89, 176, 227, 0.3),
                            borderColor: Color.fromRGBO(89, 176, 227, 1),
                            borderWidth: 1))
                  ])),
        ]);
  }

  Widget _buildEthernetDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5))),
              height: _height * .20,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('Ethernet',
                            textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('R: ' '${int.parse(_ethernetValue)}' ' Kbps',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(40, 144, 90, 1),
                            ))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Expanded(
                        child: SfSparkAreaChart(
                      data: _ethernetData,
                      axisCrossesAt: 0,
                      axisLineWidth: 0,
                      color: Color.fromRGBO(89, 190, 103, 0.3),
                      borderColor: Color.fromRGBO(89, 190, 103, 1),
                      borderWidth: 1,
                    ))
                  ])),
        ]);
  }

  ///Get random value
  double _getRandomInt(int _min, int _max) {
    final Random _random = Random();
    return _min + _random.nextInt(_max - _min).toDouble();
  }

  void _updateData(Timer timer) {
    if (_cpuData.length > 10) {
      _cpuData.removeAt(0);
    }
    if (_diskData.length > 10) {
      _diskData.removeAt(1);
      _diskData[0] = 0;
    }
    if (_memoryData.length > 10) {
      _memoryData.removeAt(0);
    }
    if (_ethernetData.length > 10) {
      _ethernetData.removeAt(0);
    }
    // widget.homeModel.sinks[CharacteristicUtils.allocPower1].add(_getRandomInt(0, 40));
    setState(() {
      _cpuData = List.from(_getCPUData());
      _diskData = List.from(_getDiskData());
      _memoryData = List.from(_getMemoryData());
      _ethernetData = List.from(_getEthernetData());
      _cpuValue = _cpuData[_cpuData.length - 1].round().toString();
      _diskValue = _diskData[_diskData.length - 1].round().toString();
      _memoryValue = _memoryData[_memoryData.length - 1].round().toString();
      _ethernetValue = _ethernetData[_ethernetData.length - 1].round().toString();
    });
  }

  //ignore: unused_element
  List<double> _getCPUData() {
    _cpuData.add(_getRandomInt(0, 40));
    return _cpuData;
  }

  //ignore: unused_element
  List<double> _getDiskData() {
    _diskData.add(_getRandomInt(55, 65));
    return _diskData;
  }

  //ignore: unused_element
  List<double> _getMemoryData() {
    _memoryData.add(_getRandomInt(0, 80));
    return _memoryData;
  }

  //ignore: unused_element
  List<double> _getEthernetData() {
    _ethernetData.add(_getRandomInt(0, 70));
    return _ethernetData;
  }
}
// class _SettingsViewState extends State<SettingsView> {
//   int _temperatureUnit = 0;
//   Settings settings = SharedPrefUtil.getSettings();
//   String _password;
//   List<num> _cpuData = [10, 20, 10, 0];
//   @override
//   void initState() {
//     _temperatureUnit = settings.tempUnit;
//     _password = settings.password;
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Timer.periodic(Duration(seconds: 3), (Timer t) {
//         print("Adding value");
//         _cpuData.add(_getRandomInt(0, 100));
//         setState(() {});
//       });
//     });
//   }
//
//   double _getRandomInt(int _min, int _max) {
//     final Random _random = Random();
//     return _min + _random.nextInt(_max - _min).toDouble();
//   }
//
//   @override
//   void dispose() {
//     settings.tempUnit = _temperatureUnit;
//     settings.password = _password;
//     SharedPrefUtil.setSettings(settings);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: BaseView<HomeModel>(
//           onModelReady: (model) async {
//             model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
//           },
//           builder: (context, model, child) {
//             return Scaffold(
//               appBar: AppBar(title: Text('View')),
//               body: Column(children: [
//                 Container(
//                   width: 300,
//                   child: SfSparkAreaChart(
//                     data: _cpuData,
//                     axisLineWidth: 0,
//                     color: Color.fromRGBO(184, 71, 189, 0.35),
//                     borderColor: Color.fromRGBO(184, 71, 189, 1),
//                     borderWidth: 1,
//                   ),
//                 )
//               ]),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
