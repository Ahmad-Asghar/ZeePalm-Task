import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zeepalm_task/routes/app_routes.dart';
import 'package:zeepalm_task/screens/auth/home/provider/home_provider.dart';
import 'package:zeepalm_task/screens/auth/home/root_screen.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/profile_pic_provider.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/user_profile_provider.dart';

import 'core/utils/app_colors.dart';
import 'core/utils/navigator_services.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCFguyeu04Rl5mIg6zHhsX7RX6BhznR4IA",
      authDomain: "voice-writer-d437e.firebaseapp.com",
      projectId: "voice-writer-d437e",
      storageBucket: "voice-writer-d437e.appspot.com",
      messagingSenderId: "1039016699287",
      appId: "1:1039016699287:web:f2bddfc29bac5456e650d2",
      measurementId: "G-YVFDW5RJ50",
    ),
  );
  // } else {
  //   await Firebase.initializeApp();
  // }

  runApp(
    //const MyApp(),
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => RootProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProfilePicProvider()),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
    )
    );
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return   MaterialApp(
        title: '',
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
        ),

      );
    });
  }
}