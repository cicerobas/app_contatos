import 'package:app_contatos/pages/new_contact_page.dart';
import 'package:app_contatos/widgets/contacts_list.dart';
import 'package:flutter/material.dart';

import '../models/saved_contacts_model.dart';
import '../repositories/contact_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var contactRepository = ContactRepository();
  var savedContacts = SavedContactsModel([]);

  static bool? shouldRefresh = true;

  @override
  void initState() {
    _loadContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contatos',
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          shouldRefresh = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NewContactPage(
                  isEditing: false,
                ),
              ));
          if (shouldRefresh != null && shouldRefresh!) {
            _loadContacts();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ContactsList(
        savedContacts: savedContacts,
      ),
    );
  }

  void _loadContacts() async {
    savedContacts = await contactRepository.getContacts();
    setState(() {});
  }
}
