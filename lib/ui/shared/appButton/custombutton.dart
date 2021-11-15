import 'package:audiobook/ui/shared/appButton/customButtonextension.dart';
import 'package:flutter/material.dart';

class ButtonProps {
  double height;
  TextStyle textStyle;
  BoxBorder? border;
  Color backgroundColor;
  ButtonProps({
    required this.height,
    required this.textStyle,
    required this.backgroundColor,
    this.border,
  });
}

class CustomButton extends StatefulWidget {
  final CustomButtonType type;
  final String text;
  final Function()? onTap;
  final double width;
  final ButtonProps props;
  final double padding;
  final double radius;
  final Widget? widget;
  final double? height;

  CustomButton(
      {required this.type,
      required this.text,
      required this.onTap,
      this.width = 0,
      props,
      this.padding = 0,
      this.radius = 100,
      this.widget,
      this.height})
      : props = props ?? type.props;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.padding),
        width: widget.width == 0 ? 200 : widget.width,
        height: widget.height == null ? widget.props.height : widget.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.radius),
            ),
            color: widget.props.backgroundColor,
            border: widget.props.border),
        alignment: Alignment.center,
        child: widget.widget == null
            ? Text(widget.text, style: widget.props.textStyle)
            : widget.widget,
      ),
      // ),
    );
  }
}
