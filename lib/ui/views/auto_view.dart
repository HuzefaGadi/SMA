import 'dart:async';

import 'package:ams/core/utils/application.dart';
import 'package:ams/core/utils/characteristics_util.dart';
import 'package:ams/core/viewmodels/home_model.dart';
import 'package:ams/ui/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AutoView extends StatefulWidget {
  static const routeName = "HomeView";
  HomeModel homeModel;

  setModel(HomeModel homeModel) {
    this.homeModel = homeModel;
  }

  @override
  _AutoViewState createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  HomeModel model;
  int colorOpacity = 100;
  Timer timer;
  int touchedIndex;

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    model = widget.homeModel;
    super.initState();
    model.refreshPage();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   model.sinks[CharacteristicUtils.allocPower1].add((Random().nextInt(20) + 1).toString());
    //   model.sinks[CharacteristicUtils.delPower1].add((Random().nextInt(10) + 1).toString());
    //   model.sinks[CharacteristicUtils.allocPower2].add((Random().nextInt(20) + 1).toString());
    //   model.sinks[CharacteristicUtils.delPower2].add((Random().nextInt(10) + 1).toString());
    //   model.sinks[CharacteristicUtils.allocPower3].add((Random().nextInt(20) + 1).toString());
    //   model.sinks[CharacteristicUtils.delPower3].add((Random().nextInt(5) + 1).toString());
    // });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //         child: SfRadialGauge(
  //       axes: <RadialAxis>[
  //         RadialAxis(axisLineStyle: AxisLineStyle(thickness: 30, color: Colors.lightBlueAccent), ranges: [
  //           GaugeRange(
  //               startValue: 0,
  //               endValue: 40,
  //               color: Colors.green[100].withAlpha(colorOpacity),
  //               sizeUnit: GaugeSizeUnit.factor,
  //               startWidth: 1,
  //               endWidth: 1),
  //         ], pointers: <GaugePointer>[
  //           MarkerPointer(
  //               value: 30,
  //               enableDragging: true,
  //               markerWidth: 30,
  //               markerHeight: 30,
  //               markerOffset: -15,
  //               color: Colors.indigo),
  //           NeedlePointer(
  //             needleLength: 0.9,
  //             needleStartWidth: 2,
  //             needleEndWidth: 2,
  //             value: 60,
  //             enableDragging: false,
  //             knobStyle: getKnobStyle(),
  //           ),
  //         ])
  //       ],
  //     )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Auto Settings'),
          actions: [Application.getGlobalAction(context, model)],
        ),
        body: StreamBuilder6<String, String, String, String, String, String>(
            initialData: Tuple6("0", "0", "0", "0", "0", "0"),
            streams: Tuple6(
                widget.homeModel.streams[CharacteristicUtils.delPower1],
                widget.homeModel.streams[CharacteristicUtils.allocPower1],
                widget.homeModel.streams[CharacteristicUtils.delPower2],
                widget.homeModel.streams[CharacteristicUtils.allocPower2],
                widget.homeModel.streams[CharacteristicUtils.delPower3],
                widget.homeModel.streams[CharacteristicUtils.allocPower3]
        ),

            builder: (context, snapshots) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset("images/usb.png"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Alloc Power ${snapshots.item2.data} W"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Del Power ${snapshots.item1.data} W"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset("images/usb.png"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Alloc Power ${snapshots.item4.data} W"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Del Power ${snapshots.item3.data} W"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset("images/usb.png"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Alloc Power ${snapshots.item6.data} W"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Del Power ${snapshots.item5.data} W"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                        //  axisLineStyle: AxisLineStyle(thickness: 30, color: Colors.lightBlueAccent),
                        // startAngle: -180,
                        // endAngle: 0,
                        minimum: 0,
                        maximum: 80,
                        minorTicksPerInterval: 10,
                        ticksPosition: ElementsPosition.inside,
                        labelsPosition: ElementsPosition.inside,
                        radiusFactor: 1,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue:
                                  getValue(snapshots.item2.data) +
                                  getValue(snapshots.item4.data) +
                                  getValue(snapshots.item6.data),
                              endValue: 80,
                              color: Colors.grey.withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1),
                          GaugeRange(
                              startValue: 0,
                              endValue: getValue(snapshots.item1.data),
                              color: Colors.green[400].withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1),
                          GaugeRange(
                              startValue: getValue(snapshots.item1.data),
                              endValue: getValue(snapshots.item2.data),
                              color: Colors.green[100].withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1),
                          GaugeRange(
                              startValue: getValue(snapshots.item2.data),
                              endValue:
                                  getValue(snapshots.item2.data) +
                                  getValue(snapshots.item3.data),
                              color: Colors.blue[400].withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1),
                          GaugeRange(
                              startValue:
                                  getValue(snapshots.item2.data) +
                                  getValue(snapshots.item3.data),
                              endValue:
                                  getValue(snapshots.item2.data) +
                                  getValue(snapshots.item4.data),
                              color: Colors.blue[100].withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1),
                          GaugeRange(
                              startValue:
                                  getValue(snapshots.item2.data) +

                                  getValue(snapshots.item4.data),
                              endValue:
                                  getValue(snapshots.item2.data) +
                                  getValue(snapshots.item4.data) +
                                  getValue(snapshots.item5.data),
                              color: Colors.red[400].withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1),
                          GaugeRange(
                              startValue:
                                  getValue(snapshots.item2.data) +
                                  getValue(snapshots.item4.data) +
                                  getValue(snapshots.item5.data),
                              endValue:
                                  getValue(snapshots.item2.data) +

                                  getValue(snapshots.item4.data) +

                                  getValue(snapshots.item6.data),
                              color: Colors.red[100].withAlpha(colorOpacity),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 1,
                              endWidth: 1)
                        ],
                        pointers: <GaugePointer>[
                          MarkerPointer(
                            markerWidth: 50,
                            markerHeight: 50,
                            value:  getValue(snapshots.item2.data),
                            color: Colors.green,
                            enableDragging: true,
                            markerOffset: -30,
                          ),
                          MarkerPointer(
                            markerWidth: 50,
                            markerHeight: 50,
                            value: getValue(snapshots.item2.data)+getValue(snapshots.item4.data),
                            color: Colors.blue,
                            enableDragging: true,
                            markerOffset: -30,
                          ),
                          MarkerPointer(
                            markerWidth: 50,
                            markerHeight: 50,
                            value:  getValue(snapshots.item2.data)+getValue(snapshots.item4.data)+getValue(snapshots.item6.data),
                            color: Colors.red,
                            enableDragging: true,
                            markerOffset: -30,
                          ),
                          NeedlePointer(
                            needleLength: 0.9,
                            needleStartWidth: 2,
                            needleEndWidth: 2,
                            value:  getValue(snapshots.item2.data),
                            enableDragging: false,
                            knobStyle: getKnobStyle(),
                          ),
                          NeedlePointer(
                            needleLength: 0.9,
                            needleStartWidth: 2,
                            needleEndWidth: 2,
                            value:
                                getValue(snapshots.item2.data) +

                                getValue(snapshots.item4.data),
                            enableDragging: false,
                            knobStyle: getKnobStyle(),
                          ),
                          NeedlePointer(
                            needleLength: 0.9,
                            needleStartWidth: 2,
                            needleEndWidth: 2,
                            value:
                                getValue(snapshots.item2.data) +

                                getValue(snapshots.item4.data) +

                                getValue(snapshots.item6.data),
                            enableDragging: false,
                            knobStyle: getKnobStyle(),
                          ),
                        ],
                      ),
                    ]),
                    SizedBox(
                      height: 30,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MobiButton(text: "Refresh", onPressed: () {}),
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
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MobiButton(text: "Night Mode", onPressed: () {}),
                      )),
                    ]),
                  ],
                ),
              );
            }),
      ),
    );
  }

  getKnobStyle() {
    return KnobStyle(knobRadius: 0.02, sizeUnit: GaugeSizeUnit.factor);
  }

  double getValue(String data) {
    return double.parse(data);
  }
}
