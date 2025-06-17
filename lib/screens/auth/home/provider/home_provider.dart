import 'dart:io' ;
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/video_model.dart';

class HomeProvider extends ChangeNotifier {
  List<VideoModel> _videos = [];
  bool isLoading = true;

  List<VideoModel> get videos => _videos;

  HomeProvider() {
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading = true;
      notifyListeners();

      var snapshot = await FirebaseFirestore.instance.collection('videos').get();
      _videos = snapshot.docs
          .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("Error fetching videos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadVideo({
    required String caption,
    required String uploaderName,
    required String uploaderImage,
  })
  async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb, // For web, pick bytes
      );

      if (result != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        String videoUrl = '';

        if (kIsWeb) {
          // Web upload via bytes
          Uint8List fileBytes = result.files.single.bytes!;
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('videos/$fileName')
              .putData(fileBytes);

          TaskSnapshot snapshot = await uploadTask;
          videoUrl = await snapshot.ref.getDownloadURL();
        } else {
          // Mobile upload via file path
          File videoFile = File(result.files.single.path!);
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('videos/$fileName')
              .putFile(videoFile);

          TaskSnapshot snapshot = await uploadTask;
          videoUrl = await snapshot.ref.getDownloadURL();
        }

        var docRef = await FirebaseFirestore.instance.collection('videos').add({
          'videoUrl': videoUrl,
          'caption': caption,
          'likes': [],
          'saves': [],
          'uploaderName': uploaderName,
          'uploaderImage': uploaderImage,
        });

        _videos.insert(
          0,
          VideoModel(
            id: docRef.id,
            videoUrl: videoUrl,
            caption: caption,
            likes: [],
            saves: [],
            uploaderName: uploaderName,
            uploaderImage: uploaderImage,
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error uploading video: $e");
    }
  }

  void toggleLike(VideoModel video, String userId) async {
    if (video.likes.contains(userId)) {
      video.likes.remove(userId);
    } else {
      video.likes.add(userId);
    }

    await FirebaseFirestore.instance
        .collection('videos')
        .doc(video.id)
        .update({'likes': video.likes});

    notifyListeners();
  }

  void toggleSave(VideoModel video, String userId) async {
    if (video.saves.contains(userId)) {
      video.saves.remove(userId);
    } else {
      video.saves.add(userId);
    }

    await FirebaseFirestore.instance
        .collection('videos')
        .doc(video.id)
        .update({'saves': video.saves});

    notifyListeners();
  }


  Future<void> downloadVideo(BuildContext context, VideoModel video) async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) return;
      }

      final dio = Dio();
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (dir == null) return;

      final savePath = "${dir.path}/${video.id ?? DateTime.now().millisecondsSinceEpoch}.mp4";

      await dio.download(video.videoUrl, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video downloaded to $savePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }


}
