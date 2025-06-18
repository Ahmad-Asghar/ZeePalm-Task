import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zeepalm_task/screens/auth/home/provider/home_provider.dart';
import 'package:zeepalm_task/widgets/app_text.dart';
import '../../../core/utils/app_colors.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/profile_avatar.dart';
import '../profile/provider/user_profile_provider.dart';
import 'model/video_model.dart';
import 'package:video_player/video_player.dart';
import '../../../services/file_downloader.dart';

class VideoPlayerItem extends StatefulWidget {
  final VideoModel video;
  final String? currentUserId;

  const VideoPlayerItem({
    required this.video,
    required this.currentUserId,
    super.key,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: Stack(
        children: [
          _controller.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
              :  Center(child: CustomLoadingIndicator(color: AppColors.primaryColor,)),

          if (!_controller.value.isPlaying && _controller.value.isInitialized )
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),

          // Action buttons (like, save, download)
          if (widget.currentUserId != null)
            Positioned(
              right: 16,
              bottom: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildIconButton(
                    icon:
                    buildAvatarImage(widget.video.uploaderImage, widget.video.uploaderName),
                  ),
                  const SizedBox(height: 16),
                  _buildIconButton(
                    icon: Icon(
                      widget.video.likes.contains(widget.currentUserId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 30,
                    ),
                    onPressed: () {
                      provider.toggleLike(
                          widget.video, widget.currentUserId!);
                    },
                    label: widget.video.likes.length.toString(),
                  ),
                  const SizedBox(height: 16),
                  _buildIconButton(
                    icon: Icon(
                      widget.video.saves.contains(widget.currentUserId)
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: Colors.yellow,
                      size: 30,
                    ),
                    onPressed: () {
                      provider.toggleSave(
                          widget.video, widget.currentUserId!);
                    },
                    label: widget.video.saves.length.toString(),
                  ),
                  const SizedBox(height: 16),
                  Consumer<DownloaderProvider>(
                    builder: (context,downloaderProvider, child) {
                      return
                      downloaderProvider.status == DownloadStatus.downloading&&
                      downloaderProvider.currentFileName == widget.video.videoUrl
                          ?
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextWidget(title: "Downloading ${downloaderProvider.progress.toInt()}%",fontSize: 14,),
                          ],
                        ),
                      ):
                        _buildIconButton(
                        icon: const Icon(Icons.download,
                            color: Colors.white, size: 30),
                        onPressed: () {
                          FileDownloader.downloadFile(
                            context: context,
                            url: widget.video.videoUrl,
                            fileName: widget.video.videoUrl.split('/').last,
                            onProgress: (progress) {
                              debugPrint("Downloading: ${progress.toStringAsFixed(0)}%");
                            },
                          );
                        },
                      );
                    }
                  ),
                ],
              ),
            ),

          // Uploader info and caption
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.video.uploaderName}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.video.caption,
                  style:
                  const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required Widget icon,
    VoidCallback? onPressed,
    String? label,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 8,
              )
            ],
          ),
          child: IconButton(
            icon: icon,
            onPressed: onPressed,
          ),
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

   String? currentUserId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProfileProvider>(context, listen: false);
      if (userProvider.userModel.uid.isEmpty) {
        setState(() {
          currentUserId = userProvider.userModel.uid;
        });
      }
    });
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProfileProvider>(context);

    if (!userProvider.isLoading && currentUserId == null && userProvider.userModel.uid.isNotEmpty) {
      currentUserId = userProvider.userModel.uid;
    }

    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CustomLoadingIndicator()),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                pageSnapping: true,
                physics: const ClampingScrollPhysics(),
                itemCount: provider.videos.length,
                itemBuilder: (context, index) {
                  final video = provider.videos[index];
                  return VideoPlayerItem(
                    video: video,
                    currentUserId: currentUserId,
                  );
                },
              ),
              provider.isUploading?
              Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 50),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(title: "Uploading..",fontSize: 14,),
                        SizedBox(width: 10,),
                        CustomLoadingIndicator(
                          size: 17,
                          color: AppColors.primaryColor,)
                      ],
                    ),
                  ):SizedBox()
            ],
          ),
        );
      },
    );
  }
}
