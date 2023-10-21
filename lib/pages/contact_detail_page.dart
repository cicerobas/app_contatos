import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key, required this.contactModel});

  final ContactModel contactModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: CircleAvatar(
                  backgroundImage: _getContactImage(contactModel.imagePath),
                  radius: 100,
                ),
              ),
              Text(
                '${contactModel.firstName!} ${contactModel.lastName!}',
                style: TextStyle(fontSize: 30),
              )
            ],
          ),
        ));
  }

  _getContactImage(String? path) {
    return (path != null && File(path).existsSync())
        ? FileImage(File(contactModel.imagePath!))
        : const AssetImage('assets/images/default_image.png');
  }
}
