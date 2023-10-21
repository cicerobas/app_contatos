import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/models/saved_contacts_model.dart';
import 'package:app_contatos/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  var contactRepository = ContactRepository();
  var savedContacts = SavedContactsModel([]);
  var contactModel = ContactModel();

  @override
  void initState() {
    _loadContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: savedContacts.results.length,
      itemBuilder: (context, index) {
        contactModel = savedContacts.results[index];
        ImageProvider contactImg =
            const AssetImage('assets/images/default_image.png');
        if (contactModel.imagePath != null) {
          contactImg = FileImage(File(contactModel.imagePath!));
        }
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: contactImg, radius: 30),
            title: Text(
              '${contactModel.firstName!} ${contactModel.lastName!}',
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(contactModel.phoneNumber!),
            trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                    contactModel.favorite! ? Icons.star : Icons.star_border)),
          ),
        );
      },
    ));
  }

  void _loadContacts() async {
    savedContacts = await contactRepository.getContacts();
    setState(() {});
  }
}
