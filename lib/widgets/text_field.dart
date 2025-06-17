import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../core/utils/app_colors.dart';
import 'app_text.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  String? title;
  TextEditingController? controller;
  Widget? prefix;
  Widget? suffix;
  bool? obSecureText;

  CustomTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.prefix,
      this.title,
      this.suffix,
      this.obSecureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Padding(
                padding: EdgeInsets.only(bottom: 0.6.h),
                child: CustomTextWidget(
                    title: title.toString(),
                    fontSize: 4.1.w,
                    fontWeight: FontWeight.w600),
              )
            : const SizedBox(),
        Container(
          height: 6.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xfff2f2f2).withOpacity(0.2)
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.35),
            //     spreadRadius: 5,
            //     blurRadius: 7,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
          ),
          child: TextFormField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            obscureText: obSecureText??false,
            style: TextStyle(
                fontSize: 4.4.w, color: AppColors.fieldTextColor),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 4.2.w, color: AppColors.greyTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xfff2f2f2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
                prefixIcon: prefix,
                suffixIcon: suffix),
          ),
        ),
      ],
    );
  }
}

// height: 6.h,
// width: double.maxFinite,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// color: Colors.white,
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.35),
// spreadRadius: 5,
// blurRadius: 7,
// offset: const Offset(0, 3),
// ),
// ],
// ),
