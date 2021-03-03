import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MobiLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class MobiButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double width, height;

  MobiButton(
      {@required this.text,
      @required this.onPressed,
      this.width = double.infinity,
      this.height = 40,
      this.padding,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        color: color ?? Colors.redAccent,
        child: Center(
          child: Padding(
            padding: padding ?? EdgeInsets.all(0),
            child: Text(
              text,
              style: Theme.of(context).primaryTextTheme.button.copyWith(color: textColor ?? Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class MobiTextFormField extends StatelessWidget {
  final Function onChanged;
  final Function onTap;
  final String label;
  final Widget prefixIcon;
  final String initialValue;
  final bool readOnly;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLength;
  final bool obscureText;

  const MobiTextFormField(
      {this.label,
      this.obscureText = false,
      this.onChanged,
      this.prefixIcon,
      this.onTap,
      this.initialValue,
      this.readOnly,
      this.controller,
      this.keyboardType,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        onChanged: onChanged,
        onTap: onTap,
        maxLength: maxLength,
        keyboardType: keyboardType ?? TextInputType.text,
        initialValue: initialValue,
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
          labelText: label,
          prefixIcon: prefixIcon,
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }
}

class MobiTextFormFieldLight extends StatelessWidget {
  final Function onChanged;
  final Function onTap;
  final String label;
  final Widget prefixIcon;
  final String initialValue;
  final bool readOnly;
  final TextEditingController controller;
  final TextAlign textAlign;
  final TextInputType keyboardType;

  const MobiTextFormFieldLight(
      {this.label,
      this.onChanged,
      this.prefixIcon,
      this.onTap,
      this.initialValue,
      this.readOnly,
      this.controller,
      this.textAlign,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.white,
      ),
      child: TextFormField(
        textAlign: textAlign ?? TextAlign.left,
        style: TextStyle(color: Colors.white, fontSize: 20),
        onChanged: onChanged,
        onTap: onTap,
        initialValue: initialValue,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class MobiText extends StatelessWidget {
  final String text;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final TextOverflow textOverflow;
  final double iconGapWidth;
  final Function onTap;

  const MobiText(
      {@required this.text,
      this.prefixIcon,
      this.textStyle,
      this.iconGapWidth = 40,
      this.textOverflow = TextOverflow.visible,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>();
    if (prefixIcon != null) {
      children.add(prefixIcon);
      children.add(SizedBox(
        width: iconGapWidth,
      ));
    }

    children.add(Flexible(
      fit: FlexFit.loose,
      child: Text(
        text,
        overflow: textOverflow,
        softWrap: true,
        style: this.textStyle ?? TextStyle(fontSize: 20),
      ),
    ));
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.black,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class MobiDropDown extends StatelessWidget {
  final String hint;
  final Function onChanged;
  final List<Widget> items;
  final Object value;
  final Icon prefixIcon;
  final bool isDense;

  MobiDropDown(
      {this.hint,
      @required this.onChanged,
      @required this.items,
      @required this.value,
      this.isDense = true,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      isDense: isDense,
      value: value,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      ),
      onChanged: onChanged,
      items: items,
      hint: Text(hint ?? ""),
    );
  }
}

//  TextStyle kMyStyle = TextStyle(fontSize: textSize, color: color);
//  return kMyStyle;
