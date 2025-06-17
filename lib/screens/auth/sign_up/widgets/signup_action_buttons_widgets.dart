
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/navigator_services.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/main_button.dart';
import '../provider/sign_up_provider.dart';


class SignUpActionButtonsWidgets extends StatelessWidget {
 final  SignUpProvider signUpProvider;
  const SignUpActionButtonsWidgets({super.key, required this.signUpProvider});

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
                 if(!signUpProvider.isLoading){
                   if(
                   validateEmail(signUpProvider.emailController.text.trim())
                       && validatePassword(signUpProvider.passwordController.text.trim())
                       &&validatePassword(signUpProvider.confirmPasswordController.text.trim())
                       &&validateField(signUpProvider.fullNameController.text.trim())
                   ){
                     if(validateMatchingFields(signUpProvider.passwordController.text.trim(), signUpProvider.confirmPasswordController.text.trim())){
                       signUpProvider.signUp(context);
                     }else{
                       showSnackBar(context, AppStrings.PASSWORDS_SHOULD_BE_SAME,isError: true);
                     }

                   }
                   else{
                     showSnackBar(context, AppStrings.FILL_FIELDS_PROPERLY,isError: true);
                   }
                 }
                  },
                  child:
                  signUpProvider.isLoading?Center(
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
                  CustomTextWidget(title: AppStrings.SIGN_UP,color: AppColors.white,),

                )
            )
          ],
        ),
        SizedBox(height: 4.h),
        CustomTextWidget(title: AppStrings.ALREADY_HAVE_ACCOUNT,color: AppColors.fieldTextColor,),
        SizedBox(height: 1.h,),
        Row(
          children: [
            Expanded(
                child: CustomMainButton(
                  elevation: 6,
                  color: AppColors.white,
                  borderRadius: 15,
                  onTap: () {
                    NavigationService().goBack();
                  },
                  child: CustomTextWidget(title: AppStrings.LOGIN,color: AppColors.black,),


                )
            )
          ],
        ),
      ],
    );
  }
}
