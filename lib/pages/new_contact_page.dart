import 'package:app_contatos/widgets/contact_image_picker.dart';
import 'package:flutter/material.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo Contato'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ContactImagePicker(),
        ));
  }
}
