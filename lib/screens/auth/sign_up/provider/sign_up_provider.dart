import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/navigator_services.dart';
import '../../../../core/utils/user_pref_utils.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../routes/app_routes.dart';
import '../../profile/model/user_model.dart';
import '../repo/sign_up_repo.dart';

class SignUpProvider extends ChangeNotifier {
  bool hidePassword = true;
  bool isLoading = false;

  final SignUpRepo signUpRepo = SignUpRepo();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final signUpResult = await signUpRepo.signUp(email, password);

    if (signUpResult is UserCredential) {
      final userModel = UserModel(
        fullName: fullNameController.text.trim(),
        email: email,
        uid: signUpResult.user!.uid,
      );
      final addUserResult = await signUpRepo.addNewUser(userModel, signUpResult);
      if (addUserResult is bool) {

        await UserPrefUtils().setUserLoggedInStatus(true);
        await UserPrefUtils().saveUserID(signUpResult.user!.uid);
        isLoading = false;
        notifyListeners();
        showSnackBar(context, AppStrings.ACCOUNT_CREATED_SUCCESSFULLY);
        NavigationService().pushReplacement(AppRoutes.root);

      } else if (addUserResult is String) {
        isLoading = false;
        notifyListeners();
        showSnackBar(context, addUserResult.split(']')[1].trim(), isError: true);
      }
    }
    else if (signUpResult is String) {
      isLoading = false;
      notifyListeners();
      showSnackBar(context, signUpResult.split(']')[1].trim(), isError: true);
    }
  }

  void toggleShowPassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }



}

