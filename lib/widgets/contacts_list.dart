import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/models/saved_contacts_model.dart';
import 'package:app_contatos/pages/contact_detail_page.dart';
import 'package:app_contatos/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key, required this.savedContacts});
  final SavedContactsModel savedContacts;

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  var contactModel = ContactModel();
  final ContactRepository _contactRepository = ContactRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(6),
      child: ListView.builder(
        itemCount: widget.savedContacts.results.length,
        itemBuilder: (context, index) {
          contactModel = widget.savedContacts.results[index];
          ImageProvider contactImg =
              const AssetImage('assets/images/default_image.png');

          if (contactModel.imagePath != null &&
              File(contactModel.imagePath!).existsSync()) {
            contactImg = FileImage(File(contactModel.imagePath!));
          }

          return Card(
            child: ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactDetailPage(
                        contactModel: widget.savedContacts.results[index]),
                  )),
              leading: CircleAvatar(backgroundImage: contactImg, radius: 30),
              title: Text(
                '${contactModel.firstName!} ${contactModel.lastName!}',
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Text(contactModel.phoneNumber!),
              trailing: IconButton(
                  onPressed: () {
                    widget.savedContacts.results[index].favorite =
                        !widget.savedContacts.results[index].favorite!;
                    _favoriteContact(widget.savedContacts.results[index])
                        .then((_) {
                      setState(() {});
                    });
                  },
                  icon: Icon(
                      contactModel.favorite! ? Icons.star : Icons.star_border)),
            ),
          );
        },
      ),
    ));
  }

  Future<bool> _favoriteContact(ContactModel contact) async {
    return await _contactRepository.updateContact(contact.objectId!, contact);
  }
}
