import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactImagePicker extends StatefulWidget {
  const ContactImagePicker({
    super.key,
    required this.isEditing,
    this.contactModel,
  });

  final bool isEditing;
  final ContactModel? contactModel;

  @override
  State<ContactImagePicker> createState() => _ContactImagePickerState();
}

class _ContactImagePickerState extends State<ContactImagePicker> {
  ImageProvider? contactImage;
  bool isDefaultImage = true;
  @override
  void initState() {
    if (widget.isEditing) {
      String? imgPath = widget.contactModel!.imagePath;
      if (imgPath != null && ImageUtil().checkContactImage(imgPath)) {
        contactImage = FileImage(File(imgPath));
        ImageUtil.selectedImage = File(imgPath);
        isDefaultImage = false;
      }
    } else {
      ImageUtil.selectedImage = null;
    }
    super.initState();
  }

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
                backgroundImage: contactImage ?? ImageUtil.defaultImage,
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
                onTap: () async {
                  ImageUtil()
                      .pickImageFromSource(ImageSource.gallery)
                      .then((value) {
                    if (value) {
                      setState(() {
                        contactImage = FileImage(ImageUtil.selectedImage!);
                        isDefaultImage = false;
                      });
                    }
                  });

                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
              ),
              ListTile(
                onTap: () {
                  ImageUtil()
                      .pickImageFromSource(ImageSource.camera)
                      .then((value) {
                    if (value) {
                      setState(() {
                        contactImage = FileImage(ImageUtil.selectedImage!);
                        isDefaultImage = false;
                      });
                    }
                  });
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
              ),
              if (!isDefaultImage)
                ListTile(
                  onTap: () {
                    setState(() {
                      contactImage = ImageUtil.defaultImage;
                      ImageUtil.selectedImage = null;
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
}
