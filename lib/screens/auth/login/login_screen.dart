
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:zeepalm_task/screens/auth/login/provider/login_provider.dart';
import 'package:zeepalm_task/screens/auth/login/widgets/login_action_buttons_widgets.dart';
import 'package:zeepalm_task/screens/auth/login/widgets/login_fields_widget.dart';
import '../../../core/utils/size_utils.dart';
import '../../../widgets/app_name_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Consumer<LoginProvider>(
          builder: (context, loginProvider, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: SizeUtils.sidesPadding),
                child: Column(
                  children: [
                   const  AppNameWidget(),
                    LoginFieldsWidget(loginProvider: loginProvider,),
                     SizedBox(height: 20,),
                     LoginActionButtonsWidget(loginProvider: loginProvider,),

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
