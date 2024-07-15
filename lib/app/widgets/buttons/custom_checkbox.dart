import 'package:flutter/material.dart';

class CircleCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CircleCheckbox({required this.value, required this.onChanged});

  @override
  _CircleCheckboxState createState() => _CircleCheckboxState();
}

class _CircleCheckboxState extends State<CircleCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.value ? Colors.green : Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: widget.value
            ? Icon(
                Icons.check,
                size: 18.0,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
