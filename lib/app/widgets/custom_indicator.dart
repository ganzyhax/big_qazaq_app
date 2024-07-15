import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomIndicator extends StatelessWidget {
  final bool? isWhite;
  final double? size;
  const CustomIndicator({super.key, this.isWhite, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (size == null) ? 50 : size,
      width: (size == null) ? 50 : size,
      child: LoadingIndicator(
          indicatorType: Indicator.ballScale,

          /// Required, The loading type of the widget
          colors: (isWhite == true) ? [Colors.white] : [Colors.black],

          /// Optional, The color collections
          strokeWidth: 2,

          /// Optional, The stroke of the line, only applicable to widget which contains line
          backgroundColor: Colors.black.withOpacity(0),

          /// Optional, Background of the widget
          pathBackgroundColor: Colors.black

          /// Optional, the stroke backgroundColor
          ),
    );
  }
}
