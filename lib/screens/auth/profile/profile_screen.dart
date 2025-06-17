import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/profile_pic_provider.dart';
import 'package:zeepalm_task/screens/auth/profile/provider/user_profile_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/profile_avatar.dart';


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
                  ProfileImageWidget(userProfilePicProvider: userProfileProvider,),
                  SizedBox(width: double.maxFinite,height: 1.h,),
                  CustomTextWidget(title: userProfileProvider.userModel.fullName, fontSize: 21.sp, fontWeight: FontWeight.w600,),
                  SizedBox(height: 1.h,),
                  CustomTextWidget(title: userProfileProvider.userModel.email,color: AppColors.greyTextColor),
                  SizedBox(height: 1.h),
                  CustomTextWidget(title: 'Created At: ${userProfileProvider.userModel.createdAt}',color: AppColors.greyTextColor),
                  SizedBox(height: 3.h),
                  CustomMainButton(
                      color: AppColors.primaryColor,
                      onTap: (){
                        if(!userProfileProvider.isUpdating){
                          final profilePicProvider = Provider.of<ProfilePicProvider>(context, listen: false);
                          if(profilePicProvider.imagePath.isNotEmpty){
                            userProfileProvider.updateUserImage(profilePicProvider.imagePath,context);
                          }
                        }
                      },
                      child: userProfileProvider.isUpdating?const CustomLoadingIndicator():
                      CustomTextWidget(title: 'Save',color: AppColors.white)
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
  final UserProfileProvider userProfilePicProvider;
  const ProfileImageWidget({super.key, required this.userProfilePicProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePicProvider>(
      builder: (context, profileProvider, child) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 14.h,
              height: 14.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: profileProvider.imagePath.isEmpty
                    ? buildAvatarImage(
                  userProfilePicProvider.userModel.picture,
                  userProfilePicProvider.userModel.fullName,
                  radius: 14.h / 2,
                )
                    : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.greyTextColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      File(profileProvider.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                onTap: () async {
                  await profileProvider.pickImage(context);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 17,
                    color: AppColors.white,
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

