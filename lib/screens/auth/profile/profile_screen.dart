import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/profile_pic_provider.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/user_profile_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/profile_avatar.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: CustomTextWidget(title: 'Profile',fontWeight: FontWeight.w600,fontSize: 17.sp),
      ),
      body: Consumer<UserProfileProvider>(
          builder: (context, userProfileProvider, _) {
            return userProfileProvider.isLoading?
            const Center(child: CircularProgressIndicator()):
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: double.maxFinite,height: 2.h),
                  ProfileImageWidget(userProfileProvider: userProfileProvider),
                  SizedBox(width: double.maxFinite,height: 1.h,),
                  CustomTextWidget(title: userProfileProvider.userModel.fullName, fontSize: 21.sp, fontWeight: FontWeight.w600,),
                  SizedBox(height: 1.h,),
                  CustomTextWidget(title: userProfileProvider.userModel.email,color: AppColors.greyTextColor),
                  SizedBox(height: 1.h),
                  CustomTextWidget(title: 'Created At: ${userProfileProvider.userModel.createdAt}',color: AppColors.greyTextColor),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomMainButton(
                          color: AppColors.primaryColor,
                          onTap: () async {
                            if(!userProfileProvider.isUpdating){

                              final profilePicProvider = Provider.of<ProfilePicProvider>(context, listen: false);
                              if(profilePicProvider.imagePath.isNotEmpty || (kIsWeb && profilePicProvider.webImageBytes != null && profilePicProvider.webImageBytes!.isNotEmpty)) {
                                userProfileProvider.isUpdating = true;
                                userProfileProvider.notifyListeners();
                                var result =  await profilePicProvider.uploadImageToFirebase(context);
                                if (result['isSuccess']) {
                                  userProfileProvider.userModel.picture = result['imageUrl'];
                                  bool updateModel = await userProfileProvider.updateUser(userProfileProvider.userModel);
                                  if (updateModel) {
                                    showSnackBar(context, result['responseData']);
                                  } else {
                                    showSnackBar(context, 'Failed to update user.', isError: true);
                                  }
                                } else {
                                  showSnackBar(context, result['responseData'], isError: true);
                                }
                              }
                              userProfileProvider.isUpdating = false;
                              userProfileProvider.notifyListeners();
                            }
                          },
                          child: userProfileProvider.isUpdating?const CustomLoadingIndicator():
                          CustomTextWidget(title: 'Save',color: AppColors.white)
                      ),
                      SizedBox(width: 20),
                      CustomMainButton(
                          color: AppColors.red,
                          onTap: () async {
                            if(!userProfileProvider.isLoggingOut){
                                 userProfileProvider.logout(context);
                            }
                          },
                          child: userProfileProvider.isLoggingOut?const CustomLoadingIndicator():
                          CustomTextWidget(title: 'Logout',color: AppColors.white)
                      ),
                    ],
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}











class ProfileImageWidget extends StatelessWidget {
  final UserProfileProvider userProfileProvider;
  const ProfileImageWidget({super.key, required this.userProfileProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePicProvider>(
      builder: (context, profileProvider, child) {
        Widget imageWidget;

        if (kIsWeb && profileProvider.webImageBytes != null && profileProvider.webImageBytes!.isNotEmpty) {
          imageWidget = ClipOval(
            child: Image.memory(
              profileProvider.webImageBytes!,
              fit: BoxFit.cover,
              width: 110,
              height: 110,
              errorBuilder: (context, error, stackTrace) {
                return buildAvatarImage(
                  userProfileProvider.userModel.picture,
                  userProfileProvider.userModel.fullName,
                  radius: 55,
                );
              },
            ),
          );
        }
        else if (!kIsWeb && profileProvider.imagePath.isNotEmpty) {
          imageWidget = ClipOval(
            child: Image.file(
              io.File(profileProvider.imagePath),
              fit: BoxFit.cover,
              width: 110,
              height: 110,
            ),
          );
        } else {
          imageWidget = buildAvatarImage(
            userProfileProvider.userModel.picture,
            userProfileProvider.userModel.fullName,
            radius: 55,
          );
        }

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: imageWidget,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () async {
                  await profileProvider.pickImage(context);
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


