import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/image_constants.dart';
import '../../../../widgets/text_field.dart';
import '../provider/sign_up_provider.dart';


class SignUpFieldsWidget extends StatelessWidget {
   final  SignUpProvider signUpProvider;
  const SignUpFieldsWidget({super.key, required this.signUpProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.h,),
        CustomTextField(
          controller: signUpProvider.fullNameController,
          title: AppStrings.FULL_NAME,
          hintText: AppStrings.ENTER_FULL_NAME,
        ),
        SizedBox(height: 2.h,),
        CustomTextField(
          controller: signUpProvider.emailController,
          title: AppStrings.EMAIL,
          hintText: AppStrings.ENTER_EMAIL,
        ),
        SizedBox(height: 2.h,),
        CustomTextField(
          controller: signUpProvider.passwordController,
          title: AppStrings.PASSWORD,
          hintText: AppStrings.ENTER_PASSWORD,
          obSecureText: signUpProvider.hidePassword,
          suffix: IconButton(
            icon: SvgPicture.asset(signUpProvider.hidePassword==true?ImageConstants.SHOW_PASSWORD:ImageConstants.HIDE_PASSWORD),
            onPressed: () {
              signUpProvider.toggleShowPassword();
            },
          ),
        ),
        SizedBox(height: 2.h,),
        CustomTextField(
          controller: signUpProvider.confirmPasswordController,
          title: AppStrings.CONFIRM_PASSWORD,
          hintText: AppStrings.CONFIRM_PASSWORD,
          obSecureText: signUpProvider.hidePassword,
          suffix: IconButton(
            icon: SvgPicture.asset(signUpProvider.hidePassword==true?ImageConstants.SHOW_PASSWORD:ImageConstants.HIDE_PASSWORD),
            onPressed: () {
              signUpProvider.toggleShowPassword();
            },
          ),
        ),
        SizedBox(height: 2.h,),
      ],
    );
  }
}
