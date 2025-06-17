import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> push(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return navigatorKey.currentState!.push(
      _buildPageRoute(routeName, arguments: arguments, animation: animation, transitionBuilder: transitionBuilder),
    );
  }

  Future<dynamic> pushReplacement(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return navigatorKey.currentState!.pushReplacement(
      _buildPageRoute(routeName, arguments: arguments, animation: animation, transitionBuilder: transitionBuilder),
    );
  }

  void goBack([dynamic result]) {
    navigatorKey.currentState!.pop(result);
  }

  PageRoute _buildPageRoute(String routeName, {dynamic arguments, bool animation = false, RouteTransitionsBuilder? transitionBuilder}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AppRoutes.routes[routeName]!(context),
      transitionsBuilder: animation
          ? (transitionBuilder ?? _defaultTransition)
          : (context, animation, secondaryAnimation, child) => child,
      transitionDuration: const Duration(milliseconds: 800),
      settings: RouteSettings(arguments: arguments),
    );
  }

  Widget _defaultTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
