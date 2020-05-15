import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/firebase/firestore.dart';
import 'package:flutter_shared/src/firebase/serializable.dart';
import 'package:image/image.dart';

class ImageUrl extends Serializable {
  ImageUrl({this.name, this.id, this.url});

  factory ImageUrl.fromMap(Map data) {
    return ImageUrl(
      id: data.strVal('id'),
      name: data.strVal('name'),
      url: data.strVal('url'),
    );
  }

  final String id;
  final String name;
  final String url;

  @override
  Map<String, dynamic> toMap({bool types = false}) {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['name'] = name;

    return map;
  }

  @override
  String toString() {
    return 'id: $id, name: $name url: $url';
  }
}

class ImageUrlUtils {
  // folder name constants
  static String get chatImageFolder => 'chat-images';

  static Future<void> uploadImage(ImageUrl imageUrl) async {
    final doc = Document<ImageUrl>(path: 'images/${imageUrl.id}');

    try {
      await doc.upsert(imageUrl.toMap());
    } catch (error) {
      print('uploadImage exception: $error');
    }

    return;
  }

  static void addImage(String filename, String url) {
    final Map<String, dynamic> link = <String, dynamic>{};

    link['id'] = Utils.uniqueFirestoreId();
    link['name'] = filename;
    link['url'] = url;

    final ImageUrl imageUrl = ImageUrl.fromMap(link);

    uploadImage(imageUrl);
  }

  static Future<void> deleteImage(ImageUrl imageUrl) async {
    final doc = Document<ImageUrl>(path: 'images/${imageUrl.id}');

    try {
      await doc.delete();

      // delete from firebase too
      await deleteImageStorage(imageUrl.name);
    } catch (error) {
      print('deleteImage exception: $error');
    }
  }

  // saves as JPG by default since they are smallest
  // set to false for PNG with transparency
  static void uploadImageData(String imageName, Uint8List imageData,
      {bool saveAsJpg = true, int maxWidth = 1024}) {
    uploadImageDataReturnUrl(imageName, imageData,
            saveAsJpg: saveAsJpg, maxWidth: maxWidth)
        .then((url) {
      ImageUrlUtils.addImage(imageName, url);
    });
  }

  static Future<String> uploadImageDataReturnUrl(
    String imageName,
    Uint8List imageData, {
    bool saveAsJpg = true,
    int maxWidth = 1024,
    String folder,
  }) async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(folder != null ? '$folder/$imageName' : imageName);

    Image image = decodeImage(imageData);

    // shrink image
    if (image.width > maxWidth) {
      image = copyResize(image, width: maxWidth);
    }

    List<int> data;
    if (saveAsJpg) {
      data = encodeJpg(image, quality: 70);
    } else {
      // png can be large, use jpg unless you need transparency
      data = encodePng(image, level: 7);
    }

    final StorageUploadTask uploadTask =
        firebaseStorageRef.putData(Uint8List.fromList(data));

    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String url = await taskSnapshot.ref.getDownloadURL() as String;

    return url;
  }

  static Future<void> deleteImageStorage(String imageId,
      [String folder]) async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(folder != null ? '$folder/$imageId' : imageId);

    return firebaseStorageRef.delete();
  }
}