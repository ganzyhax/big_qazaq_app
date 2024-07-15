import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientSvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final bool isSelected;
  final LinearGradient? color;

  const GradientSvgIcon({
    Key? key,
    this.color,
    required this.isSelected,
    required this.assetName,
    this.size = 24.0, // Default size, can be adjusted as needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => (isSelected)
          ? AppColors().kPrimaryGradientGreenColor.createShader(bounds)
          : (color != null)
              ? AppColors().kPrimaryGradientWhite.createShader(bounds)
              : AppColors().kPrimaryGradientGrey.createShader(bounds),
      blendMode: BlendMode
          .srcIn, // This blend mode applies the shader to the source colors.
      child: SvgPicture.asset(
        assetName,
        width: size,
        height: size,
        color:
            Colors.white, // This color is necessary for the blend mode to work
      ),
    );
  }
}
