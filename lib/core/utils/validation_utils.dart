import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zeepalm_task/core/utils/size_utils.dart';
import '../../widgets/app_text.dart';
import 'app_colors.dart';

bool validateEmail(String? email) {

  print('Email $email');

  if (email == null || email.isEmpty) {
    return false;
  }
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(email)) {
    return false;
  }
  return true;
}

bool validatePassword(String? password, {int minLength = 6}) {
  if (password == null || password.isEmpty) {
    return false;
  }
  if (password.length < minLength) {
    return false;
  }
  return true;
}
bool validateField(String? value, {String fieldName = "Field"}) {
  if (value == null || value.isEmpty) {
    return false;
  }
  return true;
}

bool validateMatchingFields(String? value1, String? value2,
    {String fieldName = "Field"}) {
  if (value1 != value2) {
    return false;
  }
  return true;
}

bool validateNumber(String? value, {int? exactLength}) {
  if (value == null || value.isEmpty) {
    return false;
  }
  final numericRegex = RegExp(r'^[0-9]+$');
  if (!numericRegex.hasMatch(value)) {
    return false;
  }
  if (exactLength != null && value.length != exactLength) {
    return false;
  }
  return true;
}

bool validateURL(String? url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  const urlPattern = r'(http|https):\/\/([\w-]+(\.[\w-]+)+)';
  if (!RegExp(urlPattern).hasMatch(url)) {
    return false;
  }
  return true;
}

bool validateAlphabets(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
    return false;
  }
  return true;
}

void showSnackBar(BuildContext context, String message,{bool isError = false,bool showOnTop=false}) {
  final snackBar = SnackBar(
    backgroundColor: isError?AppColors.red:AppColors.green ,
    margin: EdgeInsets.only(left: SizeUtils.sidesPadding,right: SizeUtils.sidesPadding, top: 2.h,bottom: showOnTop?55.h:2.h),
    behavior: SnackBarBehavior.floating,
      content: CustomTextWidget(title: message,color: Colors.white),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<bool> isConnectedToInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}


String formatDate(DateTime date) {
DateFormat dateFormat = DateFormat("dd MMM yyyy");

String formattedDate = dateFormat.format(date);
return formattedDate;
}


String convertDateFromString(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateFormat dateFormat = DateFormat("dd MMM yyyy");

  String formattedDate = dateFormat.format(date);
  return formattedDate;
}