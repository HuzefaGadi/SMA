import 'dart:typed_data';

import 'package:ams/core/viewmodels/home_model.dart';

class CharacteristicUtils {
  static const port1 = 0,
      port2 = 1,
      port3 = 2,
      load1 = 3,
      load2 = 4,
      load3 = 5,
      status1 = 6,
      status2 = 7,
      status3 = 8,
      fault1 = 9,
      fault2 = 10,
      fault3 = 11,
      reqVolt1 = 12,
      reqVolt2 = 13,
      reqVolt3 = 14,
      reqCurr1 = 15,
      reqCurr2 = 16,
      reqCurr3 = 17,
      reqPower1 = 18,
      reqPower2 = 19,
      reqPower3 = 20,
      allocPower1 = 21,
      allocPower2 = 22,
      allocPower3 = 23,
      delVolt1 = 24,
      delVolt2 = 25,
      delVolt3 = 26,
      delCurr1 = 27,
      delCurr2 = 28,
      delCurr3 = 29,
      delPower1 = 30,
      delPower2 = 31,
      delPower3 = 32,
      spare1 = 33,
      spare2 = 34,
      spare3 = 35,
      totalAvailable = 36,
      totalDelivered = 37,
      pool = 38,
      totalSpare = 39;

  Function getCharacteristicListener(HomeModel model, int startIndex) {
    switch (startIndex) {
      case CharacteristicUtils.load1:
        return getLoadCharacteristicListener(model, startIndex);
      case CharacteristicUtils.status1:
        return getStatusCharacteristicListener(model, startIndex);
      case CharacteristicUtils.delPower1:
      case CharacteristicUtils.allocPower1:
      case CharacteristicUtils.reqPower1:
        return getCharacteristicInWattsListener(model, startIndex, 500);
      case CharacteristicUtils.delCurr1:
      case CharacteristicUtils.reqCurr1:
      case CharacteristicUtils.delVolt1:
      case CharacteristicUtils.reqVolt1:
        return getCharacteristicInWattsListener(model, startIndex, 1000);
      default:
        return (value) {
          try {
            print("getCharacteristicListener $startIndex");
            print(value);
            String response = "";
            if (value != null && value.isNotEmpty) {
              response = get16BitNumber(value).toString();
              int channelNo = value.first;
              model.sinks[startIndex + channelNo].add(response);
            }
          } catch (e) {
            print(e);
          }
        };
    }
  }
}

Function getCharacteristicInWattsListener(HomeModel model, int startIndex, int division) {
  return (value) {
    try {
      print("getCharacteristicInWattsListener");
      print(value);
      String response = "";
      if (value != null && value.isNotEmpty) {
        response = (get16BitNumber(value) / division).toString();
        int channelNo = value.first;
        model.sinks[startIndex + channelNo].add(response);
      }
    } catch (e) {
      print(e);
    }
  };
}

Function getLoadCharacteristicListener(HomeModel model, int startIndex) {
  return (value) {
    try {
      print("getLoadCharacteristicListener");
      print(value);
      if (value != null && value.isNotEmpty) {
        String response = getLoadType(value[1]);
        int channelNo = value.first;
        model.sinks[startIndex + channelNo].add(response);
      }
    } catch (e) {
      print(e);
    }
  };
}

Function getStatusCharacteristicListener(HomeModel model, int startIndex) {
  return (value) {
    try {
      print("getStatusCharacteristicListener");
      print(value);
      if (value != null && value.isNotEmpty) {
        String response = getStatusType(value[1]);
        int channelNo = value.first;
        model.sinks[startIndex + channelNo].add(response);
      }
    } catch (e) {
      print(e);
    }
  };
}

getLoadType(value) {
  String response = "";
  switch (value) {
    case 0:
      response = "Unknown";
      break;
    case 1:
      response = "PD Fixed";
      break;
    case 2:
      response = "PD PPS CV";
      break;
    case 3:
      response = "PD PPS Max";
      break;
    case 4:
      response = "BC (DCP)";
      break;
    case 5:
      response = "QC";
      break;
    case 6:
      response = "AFC";
      break;
  }
  return response;
}

String getStatusType(value) {
  String response = "";
  switch (value) {
    case 0:
      response = "Undefined";
      break;
    case 1:
      response = "Initialization";
      break;
    case 2:
      response = "Ready";
      break;
    case 3:
      response = "Charging";
      break;
    case 4:
      response = "Disable";
      break;
    case 5:
      response = "RSV";
      break;
    case 6:
      response = "RSV";
      break;
    default:
      response = "RSV";
      break;
  }
  return response;
}

get16BitNumber(List<dynamic> value) {
  ByteData byteData = new ByteData.view(new Int8List.fromList(value).buffer, 1, 2);
  return byteData.getUint16(0, Endian.little);
}
