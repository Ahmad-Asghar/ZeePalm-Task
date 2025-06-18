import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zeepalm_task/screens/auth/home/provider/home_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../profile/profile_screen.dart';
import '../profile/provider/user_profile_provider.dart';
import 'home_screen.dart';
import 'package:zeepalm_task/utils/platform/platform_stub.dart';

List<IconData> icons = [
  Icons.home_rounded,
  Icons.upload,
  Icons.person_rounded,
];

List<Widget> screens = [
  const HomeScreen(),
  const HomeScreen(),
  const ProfileScreen(),
];

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(
      builder: (context, rootProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            Widget scaffold = Scaffold(
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: screens[rootProvider.currentIndex],
                  ),
                  Padding(
                    //padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
                    padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      height: 7.h,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (index) {
                          return GestureDetector(
                            onTap: () async {
                              String senderName = context.read<UserProfileProvider>().userModel.fullName;
                              String senderPic = context.read<UserProfileProvider>().userModel.picture;

                              if (index == 1) {
                                // Show dialog to enter caption
                                String? caption = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController captionController = TextEditingController();

                                    return AlertDialog(
                                      title: Text('Enter Caption'),
                                      content: TextField(
                                        controller: captionController,
                                        decoration: InputDecoration(hintText: "Type your caption here"),
                                        autofocus: true,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(null), // Cancel returns null
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(captionController.text.trim());
                                          },
                                          child: Text('Upload'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (caption != null && caption.isNotEmpty) {
                                  await context.read<HomeProvider>().pickAndUploadVideo(
                                    caption: caption,
                                    uploaderName: senderName,
                                    uploaderImage: senderPic,
                                  );
                                } else {
                                  // Optionally show a message: Caption cannot be empty
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Caption cannot be empty')),
                                  );
                                }
                              } else {
                                context.read<RootProvider>().switchScreen(index);
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: index == rootProvider.currentIndex
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              child: Icon(
                                icons[index],
                                color: index == rootProvider.currentIndex
                                    ? AppColors.white
                                    : Colors.grey,
                                size: index == rootProvider.currentIndex ? 20 : 22,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            );

            // If running on web, constrain max width to 400
            if (kIsWeb) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: scaffold,
                ),
              );
            }
            return scaffold;
          },
        );
      },
    );
  }
}

class RootProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void switchScreen(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}