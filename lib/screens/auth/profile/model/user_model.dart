
import '../../../../core/utils/validation_utils.dart';

class UserModel {
  String fullName;
  String uid;
  String email;
  String picture;
  String? createdAt;
  List<String>? videoUploaded;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.picture = '',
    this.videoUploaded,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'uid': uid,
      'email': email,
      'picture': picture.isEmpty ? '' : picture,
      'videoUploaded': videoUploaded ?? [],
      'createdAt': createdAt??formatDate(DateTime.now()),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] as String,
      uid: json['uid'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      videoUploaded: json['videoUploaded'] != null
          ? List<String>.from(json['videoUploaded'])
          : [],
    );
  }
}
