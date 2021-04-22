import 'dart:async';
import 'dart:math';

import 'package:ams/core/utils/characteristics_util.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

  double allocPowerChannel1,allocPowerChannel2,allocPowerChannel3;
  @override
  void initState() {
    _cpuValue = _cpuData[_cpuData.length - 1].round().toString();
    _diskValue = _diskData[_diskData.length - 1].round().toString();
    _memoryValue = _memoryData[_memoryData.length - 1].round().toString();
    _ethernetValue = _ethernetData[_ethernetData.length - 1].round().toString();
    super.initState();
    widget.homeModel.refreshPage();
    // _timer = Timer.periodic(const Duration(milliseconds: 500), _updateData);
   /* _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // _updateData(timer);
      widget.homeModel.sinks[CharacteristicUtils.allocPower1].add(_getRandomInt(0, 100).toString());
      widget.homeModel.sinks[CharacteristicUtils.delPower1].add(_getRandomInt(0, 100).toString());
      widget.homeModel.sinks[CharacteristicUtils.allocPower2].add(_getRandomInt(0, 100).toString());
      widget.homeModel.sinks[CharacteristicUtils.delPower2].add(_getRandomInt(0, 100).toString());
      widget.homeModel.sinks[CharacteristicUtils.allocPower3].add(_getRandomInt(0, 100).toString());
      widget.homeModel.sinks[CharacteristicUtils.delPower3].add(_getRandomInt(0, 100).toString());
    });*/

    widget.homeModel.streams[CharacteristicUtils.allocPower1].listen((event) {
      setState(() {
        allocPowerChannel1 = double.parse(event);
        print("value added ${double.parse(event)}");
      });
    });
    widget.homeModel.streams[CharacteristicUtils.delPower1].listen((event) {
      setState(() {
        _updateDataSource(allocChannel1ChartData, allocChannel1Count, _allocChannel1SeriesController,allocPowerChannel1);
        _updateDataSource(deliveredChannel1ChartData, deliveredChannel1Count, _deliveredChannel1SeriesController,double.parse(event));
        print("value added ${double.parse(event)}");
      });
    });

    widget.homeModel.streams[CharacteristicUtils.allocPower2].listen((event) {
      setState(() {
        allocPowerChannel2 = double.parse(event);
       // _updateDataSource(allocChannel2ChartData, allocChannel2Count, _allocChannel2SeriesController,double.parse(event));
        print("value added ${double.parse(event)}");
      });
    });
    widget.homeModel.streams[CharacteristicUtils.delPower2].listen((event) {
      setState(() {
        _updateDataSource(allocChannel2ChartData, allocChannel2Count, _allocChannel2SeriesController,allocPowerChannel2);
        _updateDataSource(deliveredChannel2ChartData, deliveredChannel2Count, _deliveredChannel2SeriesController,double.parse(event));
        print("value added ${double.parse(event)}");
      });
    });

    widget.homeModel.streams[CharacteristicUtils.allocPower3].listen((event) {
      setState(() {
        allocPowerChannel3 = double.parse(event);
       // _updateDataSource(allocChannel3ChartData, allocChannel3Count, _allocChannel3SeriesController,double.parse(event));
        print("value added ${double.parse(event)}");
      });
    });
    widget.homeModel.streams[CharacteristicUtils.delPower3].listen((event) {
      setState(() {
        _updateDataSource(allocChannel3ChartData, allocChannel3Count, _allocChannel3SeriesController,allocPowerChannel3);
        _updateDataSource(deliveredChannel3ChartData, deliveredChannel3Count, _deliveredChannel3SeriesController,double.parse(event));
        print("value added ${double.parse(event)}");
      });
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text("View"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, Colors.grey]),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  // _buildChannel1Chart(),
                  _buildChannelChart("Channel 1", allocChannel1ChartData, _allocChannel1SeriesController,
                      deliveredChannel1ChartData, _deliveredChannel1SeriesController),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _buildChannelChart("Channel 2", allocChannel2ChartData, _allocChannel2SeriesController,
                      deliveredChannel2ChartData, _deliveredChannel2SeriesController),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _buildChannelChart("Channel 3", allocChannel3ChartData, _allocChannel3SeriesController,
                      deliveredChannel3ChartData, _deliveredChannel3SeriesController),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _buildChannelChart("Total", allocChannel1ChartData, _allocChannel1SeriesController,
                      deliveredChannel1ChartData, _deliveredChannel1SeriesController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget.homeModel.streams[CharacteristicUtils.allocPower1],
  // widget.homeModel.streams[CharacteristicUtils.delPower1],
  // widget.homeModel.streams[CharacteristicUtils.allocPower2],
  // widget.homeModel.streams[CharacteristicUtils.delPower2],
  // widget.homeModel.streams[CharacteristicUtils.allocPower3],
  // widget.homeModel.streams[CharacteristicUtils.delPower3]),

  List<_ChartData> allocChannel1ChartData = <_ChartData>[];
  List<_ChartData> allocChannel2ChartData = <_ChartData>[];
  List<_ChartData> allocChannel3ChartData = <_ChartData>[];
  List<_ChartData> deliveredChannel1ChartData = <_ChartData>[];
  List<_ChartData> deliveredChannel2ChartData = <_ChartData>[];
  List<_ChartData> deliveredChannel3ChartData = <_ChartData>[];
  ChartSeriesController _allocChannel1SeriesController, _allocChannel2SeriesController, _allocChannel3SeriesController;
  ChartSeriesController _deliveredChannel1SeriesController,
      _deliveredChannel2SeriesController,
      _deliveredChannel3SeriesController;
  List<int> allocChannel1Count = [0];
  List<int> allocChannel2Count = [0];
  List<int> allocChannel3Count = [0];
  List<int> deliveredChannel1Count = [0];
  List<int> deliveredChannel2Count = [0];
  List<int> deliveredChannel3Count = [0];

  /// Private calss for storing the chart series data points.

  Widget _buildChannelChart(String title, List<_ChartData> chartData1, ChartSeriesController controller1,
      List<_ChartData> chartData2, ChartSeriesController controller2) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), color: Colors.white),
            height: _height * .40,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(title,
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
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
                        primaryYAxis:
                            NumericAxis(axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
                        series: <LineSeries<_ChartData, int>>[
                          LineSeries<_ChartData, int>(
                            onRendererCreated: (ChartSeriesController controller) {
                              controller1 = controller;
                            },
                            dataSource: chartData1,
                            color: const Color.fromRGBO(192, 108, 132, 1),
                            xValueMapper: (_ChartData data, _) => data.index,
                            yValueMapper: (_ChartData data, _) => data.value,
                            animationDuration: 0,
                          ),
                          LineSeries<_ChartData, int>(
                            onRendererCreated: (ChartSeriesController controller) {
                              controller2 = controller;
                            },
                            dataSource: chartData2,
                            color: const Color.fromRGBO(245, 167, 11, 1.0),
                            xValueMapper: (_ChartData data, _) => data.index,
                            yValueMapper: (_ChartData data, _) => data.value,
                            animationDuration: 0,
                          )
                        ]),
                  )
                ]),
          ),
        ]);
  }

  ///Continously updating the data source based on timer
  void _updateDataSource(List<_ChartData> chartData, List<int> count, ChartSeriesController controller, double value) {
    chartData.add(_ChartData(count[0]++, value));
    if (chartData.length == 20) {
      chartData.removeAt(0);
      controller?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      controller?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
    }
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

class _ChartData {
  _ChartData(this.index, this.value);

  final int index;
  final num value;
}
