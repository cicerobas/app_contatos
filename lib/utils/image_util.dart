import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageUtil {
  static const defaultImage = AssetImage('assets/images/default_image.png');
  static File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  bool checkContactImage(String path) => File(path).existsSync();

  Future<String> saveImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        basename(selectedImage!.path).replaceAll('image_cropper_', '');
    final imgPath = '${dir.path}/$fileName';
    if (!checkContactImage(imgPath)) {
      await selectedImage!.copy(imgPath);
    }
    return imgPath;
  }

  Future<bool> pickImageFromSource(ImageSource src) async {
    _image = await _picker.pickImage(source: src);
    if (_image != null) {
      selectedImage = await _cropSelectedImage(_image!.path);
      return true;
    }
    return false;
  }

  Future<File> _cropSelectedImage(String imgPath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imgPath,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Ajustar Foto',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Ajustar Foto',
        ),
      ],
    );
    return File(croppedFile!.path);
  }
}
