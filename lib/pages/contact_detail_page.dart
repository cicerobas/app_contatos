import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/pages/home_page.dart';
import 'package:app_contatos/pages/new_contact_page.dart';
import 'package:app_contatos/repositories/contact_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key, required this.contactModel});

  final ContactModel contactModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () => _deleteContact(contactModel.objectId!, context),
            icon: const Icon(Icons.delete),
            iconSize: 28,
          ),
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewContactPage(
                      isEditing: true, contactModel: contactModel),
                )),
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
                            onPressed: () =>
                                _callNumber(contactModel.phoneNumber!, 'tel'),
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
                            onPressed: () =>
                                _callNumber(contactModel.phoneNumber!, 'sms'),
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
                            onPressed: () {
                              if (contactModel.email == null ||
                                  contactModel.email == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Email indisponível para o contato')));
                              } else {
                                _sendEmail(contactModel.email!);
                              }
                            },
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

  void _sendEmail(String email) async {
    final Uri params = Uri(scheme: 'mailto', path: email);
    String url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _callNumber(String phoneNumber, String action) async {
    final url =
        '$action:${UtilBrasilFields.obterTelefone(phoneNumber, mascara: false)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  _getContactImage(String? path) {
    return (path != null && File(path).existsSync())
        ? FileImage(File(contactModel.imagePath!))
        : const AssetImage('assets/images/default_image.png');
  }

  _deleteContact(String objectId, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Deletar contato?',
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    ContactRepository()
                        .deleteContact(objectId)
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false));
                  },
                  child: const Text(
                    'Sim',
                    style: TextStyle(fontSize: 18),
                  )),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Não',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
        );
      },
    );
  }
}
