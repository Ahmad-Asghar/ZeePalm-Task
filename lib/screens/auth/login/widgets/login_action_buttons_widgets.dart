import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/navigator_services.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/main_button.dart';
import '../provider/login_provider.dart';


class LoginActionButtonsWidget extends StatelessWidget {
  final LoginProvider loginProvider;
  const LoginActionButtonsWidget({super.key, required this.loginProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [
            Expanded(
                child: CustomMainButton(
                  color: AppColors.primaryColor,
                  borderRadius: 15,
                  onTap: () {
                    if(!loginProvider.isLoading){
                      if(
                      validateEmail(loginProvider.emailController.text.trim())
                          &&validatePassword(loginProvider.passwordController.text.trim())){
                        loginProvider.login(context);
                      }else{
                        showSnackBar(context, AppStrings.FILL_FIELDS_PROPERLY,isError: true);
                      }
                    }
                  },
                  child:
                  loginProvider.isLoading?Center(
                    child: SizedBox(
                      height: 3.h,
                      width: 3.h,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ):
                  CustomTextWidget(title:  AppStrings.LOGIN,color: AppColors.white,),

                )
            )
          ],
        ),
        SizedBox(height: 4.h),
        CustomTextWidget(title:  AppStrings.DONT_HAVE_AN_ACCOUNT,color: AppColors.fieldTextColor,),
        SizedBox(height: 1.h,),
        Row(
          children: [
            Expanded(
                child: CustomMainButton(
                  elevation: 6,
                  color: AppColors.white,
                  borderRadius: 15,
                  onTap: () {
                    NavigationService().push(AppRoutes.signUp);
                  },
                  child: CustomTextWidget(title:  AppStrings.SIGN_UP,color: AppColors.black,),


                )
            )
          ],
        ),
      ],
    );
  }
}
