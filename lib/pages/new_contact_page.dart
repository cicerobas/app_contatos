import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/widgets/contact_image_picker.dart';
import 'package:app_contatos/widgets/new_contact_form.dart';
import 'package:flutter/material.dart';

class NewContactPage extends StatelessWidget {
  const NewContactPage({
    super.key,
    required this.isEditing,
    this.contactModel,
  });

  final bool isEditing;
  final ContactModel? contactModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(isEditing ? 'Editar Contato' : 'Novo Contato'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ContactImagePicker(
                contactModel: contactModel,
                isEditing: isEditing,
              ),
              Expanded(
                  child: NewContactForm(
                contactModel: contactModel,
                isEditing: isEditing,
              ))
            ],
          ),
        ));
  }
}
