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

  bool isLoaded = true;

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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewContactPage(isEditing: false),
                )).then((value) {
              setState(() {
                if (value != null && value) {
                  _loadContacts();
                }
              });
            });
          },
          child: const Icon(Icons.add),
        ),
        body: savedContacts.results.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum Contato',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
              )
            : isLoaded
                ? ContactsList(savedContacts: savedContacts)
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
  }

  void _loadContacts() async {
    setState(() {
      isLoaded = false;
    });
    savedContacts = await contactRepository.getContacts();
    setState(() {
      isLoaded = true;
    });
  }
}
