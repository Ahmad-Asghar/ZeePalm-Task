import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/image_constants.dart';
import '../../../core/utils/navigator_services.dart';
import '../../../core/utils/user_pref_utils.dart';
import '../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLogedIn = await UserPrefUtils().getUserLoggedInStatus();

    Future.delayed(const Duration(seconds: 2), () {
      if (!isLogedIn) {
        NavigationService().pushReplacement(AppRoutes.login);
      } else {
        NavigationService().pushReplacement(AppRoutes.root);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
          child: Image.asset(
            color: AppColors.white,
              ImageConstants.APP_LOGO,
            height: 125,
            width: 125,
          )
      ),
    );
  }
}
