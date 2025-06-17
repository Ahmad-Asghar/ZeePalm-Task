import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../core/utils/app_colors.dart';
import 'app_text.dart';
import 'loading_indicator.dart';

Widget buildAvatarImage(String imageUrl, String name, {double? radius, bool? showCustomAvatar = false}) {
  if (imageUrl.isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _buildShadowedAvatar(
        CircleAvatar(
          backgroundImage: imageProvider,
          radius: radius,
        ),
        radius,
      ),
      placeholder: (context, url) => CustomLoadingIndicator(color: AppColors.primaryColor,),
      errorWidget: (context, url, error) => _buildInitialsAvatar(name, radius),
    );
  }

  return _buildInitialsAvatar(name, radius);
}

Widget _buildInitialsAvatar(String name, double? radius) {
  String initial = (name.isNotEmpty) ? name.trim().split(' ').map((word) => word[0].toUpperCase()).join() : 'U';
  return _buildShadowedAvatar(
    CircleAvatar(
      backgroundColor: AppColors.white,
      radius: radius,
      child: CustomTextWidget(
      title: initial,
        color: AppColors.primaryColor,
        fontSize: 21.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    radius,
  );
}

Widget _buildShadowedAvatar(Widget avatar, double? radius) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: avatar,
  );
}
