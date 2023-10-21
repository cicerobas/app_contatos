import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key, required this.contactModel});

  final ContactModel contactModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
            iconSize: 28,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            iconSize: 28,
          )
        ]),
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
                style: const TextStyle(fontSize: 30),
              ),
              const Divider(
                indent: 32,
                endIndent: 32,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.call,
                              size: 36,
                            )),
                        const Text('Ligar')
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.message,
                              size: 36,
                            )),
                        const Text('SMS')
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.mail,
                              size: 36,
                            )),
                        const Text('Email')
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'Detalhes',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          ListTile(
                            horizontalTitleGap: 30,
                            leading: const Icon(Icons.phone),
                            title: Text(contactModel.phoneNumber!),
                          ),
                          if (contactModel.email != null &&
                              contactModel.email != '')
                            ListTile(
                              horizontalTitleGap: 30,
                              leading: const Icon(Icons.mail),
                              title: Text(contactModel.email!),
                            )
                        ],
                      ),
                    )),
              ),
              Wrap(
                spacing: 8,
                children: contactModel.tags!
                    .map((tag) => ChoiceChip(
                          label: Text(tag),
                          selected: true,
                          selectedColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ))
                    .toList(),
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
