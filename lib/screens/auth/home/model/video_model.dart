class VideoModel {
  String id;
  String videoUrl;
  String caption;
  List<String> likes;
  List<String> saves;
  String uploaderName;
  String uploaderImage;
  bool isLiked;
  bool isSaved;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.caption,
    required this.likes,
    required this.saves,
    required this.uploaderName,
    required this.uploaderImage,
    this.isLiked = false,
    this.isSaved = false,
  });

  factory VideoModel.fromMap(Map<String, dynamic> data, String docId) {
    return VideoModel(
      id: docId,
      videoUrl: data['videoUrl'] ?? '',
      caption: data['caption'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      saves: List<String>.from(data['saves'] ?? []),
      uploaderName: data['uploaderName'] ?? '',
      uploaderImage: data['uploaderImage'] ?? '',
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'caption': caption,
      'likes': likes,
      'saves': saves,
      'uploaderName': uploaderName,
      'uploaderImage': uploaderImage,
    };
  }
}
