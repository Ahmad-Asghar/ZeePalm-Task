import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:zeepalm_task/screens/auth/home/provider/home_provider.dart';
import '../../../services/file_downloader.dart';
import '../../../widgets/loading_indicator.dart';
import '../profile/provider/user_profile_provider.dart';
import 'model/video_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CustomLoadingIndicator()),
          );
        }

        return Scaffold(

          body: kIsWeb
              ? ListView.builder(

            padding: EdgeInsets.zero,
            itemCount: provider.videos.length,
            itemBuilder: (context, index) {
              final video = provider.videos[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: VideoPlayerItem(video: video),
              );
            },
          )
              : PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            pageSnapping: true,
            physics: const ClampingScrollPhysics(),
            itemCount: provider.videos.length,
            itemBuilder: (context, index) {
              final video = provider.videos[index];
              return VideoPlayerItem(video: video);
            },
          ),
        );
      },
    );
  }
}



class VideoPlayerItem extends StatefulWidget {
  final VideoModel video;
  const VideoPlayerItem({required this.video, super.key});

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
    final userProvider = Provider.of<UserProfileProvider>(context);
    final currentUserId = userProvider.userModel.uid;

    return Stack(
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
            : const Center(child: CircularProgressIndicator()),

        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.video.uploaderImage),
                radius: 25,
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {
                  provider.toggleLike(widget.video, currentUserId);
                },
                icon: Icon(
                  widget.video.likes.contains(currentUserId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Text(
                widget.video.likes.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {
                  provider.toggleSave(widget.video, currentUserId);
                },
                icon: Icon(
                  widget.video.saves.contains(currentUserId)
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: Colors.yellow,
                  size: 30,
                ),
              ),
              Text(
                widget.video.saves.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {
                  FileDownloader.downloadFile(
                    context: context,
                    url: widget.video.videoUrl,
                    fileName: widget.video.videoUrl.split('/').last,
                    onProgress: (progress) {
                      debugPrint("Downloading: ${progress.toStringAsFixed(0)}%");
                    },
                  );

                 // provider.downloadVideo(context, widget.video);
                },
                icon: const Icon(Icons.download, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),

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
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                widget.video.caption,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        )
      ],
    );
  }
}
