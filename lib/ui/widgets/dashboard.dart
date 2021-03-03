import 'package:ams/core/viewmodels/home_model.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget {
  HomeModel model;

  DashboardWidget(this.model);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  bool clicked = true;

  String timerValue = 'NA';

  @override
  Widget build(BuildContext context) {
    /*if (widget.model.passwordFailed) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Please enter correct password"),
                content: TextFormField(
                  onChanged: (password) {
                    print(password);
                  },
                ),
            actions: [
              FlatButton(onPressed: (){}, child: Text("SET"))
            ],
              ));
      widget.model.passwordFailed = false;
    }*/

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Power"),
        Text(widget.model.power),
        Text("Load"),
        Text(widget.model.load),
        Text("Status"),
        Text(widget.model.status),
      ],
    );
  }
}
