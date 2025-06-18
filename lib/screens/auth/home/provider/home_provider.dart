import 'dart:io' ;
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
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
  }) async {
    try {
      debugPrint("Opening file picker for video...");

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result == null) {
        debugPrint("No video selected. Exiting function.");
        return;
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String videoUrl = '';

      debugPrint("Video file picked successfully. Filename: $fileName");

      if (kIsWeb) {
        debugPrint("Running on Web platform.");

        Uint8List fileBytes = result.files.single.bytes!;
        debugPrint("File bytes obtained: ${fileBytes.lengthInBytes} bytes.");

        UploadTask uploadTask = FirebaseStorage.instance
            .ref('videos/$fileName')
            .putData(fileBytes);

        debugPrint("Uploading video to Firebase Storage...");

        TaskSnapshot snapshot = await uploadTask;
        videoUrl = await snapshot.ref.getDownloadURL();

        debugPrint("Upload complete. Download URL: $videoUrl");
      } else {
        debugPrint("Running on Mobile/Desktop platform.");

        final filePath = result.files.single.path;
        if (filePath == null) {
          debugPrint("File path is null. Exiting function.");
          return;
        }

        debugPrint("File path: $filePath");

        io.File videoFile = io.File(filePath);
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('videos/$fileName')
            .putFile(videoFile);

        debugPrint("Uploading video to Firebase Storage...");

        TaskSnapshot snapshot = await uploadTask;
        videoUrl = await snapshot.ref.getDownloadURL();

        debugPrint("Upload complete. Download URL: $videoUrl");
      }

      debugPrint("Saving video metadata to Firestore...");

      var docRef = await FirebaseFirestore.instance.collection('videos').add({
        'videoUrl': videoUrl,
        'caption': caption,
        'likes': [],
        'saves': [],
        'uploaderName': uploaderName,
        'uploaderImage': uploaderImage,
        'uploadedAt': DateTime.now(),
      });

      debugPrint("Video metadata saved successfully with document ID: ${docRef.id}");

    } catch (e, stackTrace) {
      debugPrint("Error uploading video: $e");
      debugPrint("Stack trace: $stackTrace");
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




}
