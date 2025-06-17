import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../widgets/text_field.dart';
import '../provider/login_provider.dart';


class LoginFieldsWidget extends StatelessWidget {
   final  LoginProvider loginProvider;
  const LoginFieldsWidget({super.key, required this.loginProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.h,),
        CustomTextField(
          controller: loginProvider.emailController,
          title: AppStrings.EMAIL,
          hintText:  AppStrings.ENTER_EMAIL,
        ),
        SizedBox(height: 2.h,),
        CustomTextField(
          controller: loginProvider.passwordController,
          title:  AppStrings.PASSWORD,
          hintText:  AppStrings.ENTER_PASSWORD,
          obSecureText: loginProvider.hidePassword,
          suffix: IconButton(
            icon: SvgPicture.asset(loginProvider.hidePassword==true?ImageConstants.SHOW_PASSWORD:ImageConstants.HIDE_PASSWORD),
            onPressed: () {
              loginProvider.toggleShowPassword();
            },
          ),
        ),
      ],
    );
  }
}
