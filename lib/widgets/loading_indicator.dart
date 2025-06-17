import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../core/utils/app_colors.dart';



class CustomLoadingIndicator extends StatelessWidget {
  final Color? color;
   const CustomLoadingIndicator({super.key,this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3.h,
      width: 3.h,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color:color?? AppColors.white,
        ),
      ),
    );
  }
}
