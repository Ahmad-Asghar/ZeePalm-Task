import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeepalm_task/screens/auth/sign_up/provider/sign_up_provider.dart';
import 'package:zeepalm_task/screens/auth/sign_up/widgets/sign_up_fields_widget.dart';
import 'package:zeepalm_task/screens/auth/sign_up/widgets/signup_action_buttons_widgets.dart';
import '../../../core/utils/size_utils.dart';
import '../../../widgets/app_name_widget.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: Consumer<SignUpProvider>(
          builder: (context, signUpProvider, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: SizeUtils.sidesPadding),
                child: Column(
                  children: [
                     const AppNameWidget(),
                    SignUpFieldsWidget(signUpProvider: signUpProvider,),
                     SignUpActionButtonsWidgets(signUpProvider: signUpProvider,),

                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
