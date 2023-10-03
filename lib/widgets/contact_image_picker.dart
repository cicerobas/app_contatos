import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ContactImagePicker extends StatefulWidget {
  const ContactImagePicker({super.key});

  @override
  State<ContactImagePicker> createState() => _ContactImagePickerState();
}

class _ContactImagePickerState extends State<ContactImagePicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  ImageProvider _contactImage =
      const AssetImage('assets/images/default_image.png');

  bool isDefaultImage = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(80),
              onTap: () => _showImageSourceBottomSheet(context),
              child: CircleAvatar(
                backgroundImage: _contactImage,
                radius: 80,
              ),
            ),
          ),
          OutlinedButton(
              onPressed: () => _showImageSourceBottomSheet(context),
              child: Text(
                isDefaultImage ? 'Adicionar Foto' : 'Alterar Foto',
                style: const TextStyle(fontSize: 16),
              ))
        ],
      ),
    );
  }

  _showImageSourceBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              ListTile(
                onTap: () {
                  _pickImageFromSource(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
              ),
              ListTile(
                onTap: () {
                  _pickImageFromSource(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
              ),
              if (!isDefaultImage)
                ListTile(
                  onTap: () {
                    setState(() {
                      _contactImage =
                          const AssetImage('assets/images/default_image.png');
                      isDefaultImage = true;
                    });
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.delete),
                  title: const Text('Remover'),
                ),
            ],
          ),
        );
      },
    );
  }

  _pickImageFromSource(ImageSource src) async {
    _image = await _picker.pickImage(source: src);

    if (_image != null) {
      File croppedImage = await _cropSelectedImage(_image!.path);
      setState(() {
        _contactImage = FileImage(croppedImage);
        isDefaultImage = false;
      });
    }
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
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Ajustar Foto',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return File(croppedFile!.path);
  }
}
