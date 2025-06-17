
import 'package:flutter/cupertino.dart';
import '../screens/auth/home/root_screen.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/auth/sign_up/signup_screen.dart';
import '../screens/auth/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String signUp = '/sign_up';
  static const String login = '/login';
  static const String root = '/root';

  static Map<String, WidgetBuilder> get routes => {

    splashScreen: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    signUp: (_) => SignUpScreen(),
    root: (_) => RootScreen(),


  };
}
