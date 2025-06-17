import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/navigator_services.dart';
import '../../../../core/utils/user_pref_utils.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../routes/app_routes.dart';
import '../repo/login_repo.dart';

class LoginProvider extends ChangeNotifier{

  bool hidePassword = true;
  bool isLoading = false;

  final LoginRepo loginRepo = LoginRepo();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  login(BuildContext context) async {
    isLoading=true;
    notifyListeners();

    var loginResult= await loginRepo.login(emailController.text.trim(), passwordController.text.trim());
    if(loginResult is UserCredential){

      await UserPrefUtils().setUserLoggedInStatus(true);
      await UserPrefUtils().saveUserID(loginResult.user!.uid);
      isLoading=false;
      notifyListeners();
      showSnackBar(context, AppStrings.SUCCSSFULLY_LOGIN);
      NavigationService().pushReplacement(AppRoutes.root);

    }else if (loginResult is String){
      isLoading=false;
      notifyListeners();
      showSnackBar(context, loginResult.split(']')[1].trim(), isError: true);
    }


  }


  toggleShowPassword(){
    hidePassword=!hidePassword;
    notifyListeners();

  }

}