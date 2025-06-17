import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_strings.dart';
import '../core/utils/image_constants.dart';
import 'app_text.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Image.asset(
          ImageConstants.APP_LOGO,
          height: 80,
          width: 80,
          color: AppColors.primaryColor,
        ),
        SizedBox(
          height: 1.h
        ),
        CustomTextWidget(
          title: AppStrings.APP_NAME,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
          fontSize: 5.5.w,
        )
      ],
    );
  }
}
