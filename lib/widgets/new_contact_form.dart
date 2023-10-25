import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/models/custom_tags_model.dart';
import 'package:app_contatos/pages/home_page.dart';
import 'package:app_contatos/repositories/contact_repository.dart';
import 'package:app_contatos/repositories/custom_tag_repository.dart';
import 'package:app_contatos/utils/image_util.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewContactForm extends StatefulWidget {
  const NewContactForm({
    super.key,
    required this.isEditing,
    this.contactModel,
  });

  final bool isEditing;
  final ContactModel? contactModel;

  @override
  State<NewContactForm> createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController(text: '');
  final lastNameController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final newTagController = TextEditingController(text: '');

  Map<String, bool> customTags = {};
  bool _isSaving = false, _updateTags = false;
  String? _imgPath;
  CustomTagsModel customTagsModel = CustomTagsModel();
  final _contactRepository = ContactRepository();
  final _customTagRepository = CustomTagRepository();

  @override
  void initState() {
    if (widget.isEditing) {
      firstNameController.text = widget.contactModel!.firstName!;
      lastNameController.text = widget.contactModel!.lastName!;
      phoneController.text = widget.contactModel!.phoneNumber!;
      emailController.text = widget.contactModel!.email!;
    }
    _loadCustomTags().then((value) {
      if (widget.isEditing) {
        widget.contactModel!.tags!.map((e) {
          if (customTags.keys.contains(e)) {
            customTags[e] = true;
          }
        }).toList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nome',
                              contentPadding: EdgeInsets.all(8)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Sobrenome',
                              contentPadding: EdgeInsets.all(8)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Telefone',
                              contentPadding: EdgeInsets.all(8)),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            if (value.length < 15) {
                              return 'Informe um telefone válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email',
                              contentPadding: EdgeInsets.all(8)),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return "Informe um email válido";
                            }
                            return null;
                          },
                        ),
                      ),
                      _tagList(), //Tags para marcação de contatos
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _saveContact().then((value) => value
                                ? widget.isEditing
                                    ? Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(
                                        builder: (context) {
                                          return const HomePage();
                                        },
                                      ), (route) => route.isFirst)
                                    : Navigator.pop(context, true)
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao salvar contato'),
                                    ),
                                  ));
                          }
                        },
                        child: _isSaving
                            ? const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Salvando  '),
                                  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ))
                                ],
                              )
                            : const Text('Salvar')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'))
                  ],
                ),
              ],
            )));
  }

  Wrap _tagList() {
    return Wrap(spacing: 8, children: [
      Wrap(spacing: 8, children: [
        ...customTags.keys
            .toList()
            .map((tag) => InputChip(
                  label: Text(tag),
                  selected: customTags[tag]!,
                  onSelected: (value) {
                    setState(() {
                      customTags[tag] = value;
                    });
                  },
                  onDeleted: () => _removeCustomTag(tag),
                ))
            .toList(),
        InputChip(
            onPressed: () => _addCustomTag(),
            label: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Nova Tag',
                  style: TextStyle(fontSize: 12),
                ),
                Icon(
                  Icons.add,
                  size: 18,
                )
              ],
            ))
      ]),
    ]);
  }

  _removeCustomTag(String tagKey) {
    customTags.remove(tagKey);
    customTagsModel.results![0].tags!.remove(tagKey);
    _customTagRepository.updateCustomTags(customTagsModel);
    setState(() {});
  }

  _addCustomTag() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Nova Tag',
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: newTagController,
            maxLength: 10,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  customTags.addAll({newTagController.text: true});
                  customTagsModel.results![0].tags!.add(newTagController.text);
                  setState(() {
                    _updateTags = true;
                    newTagController.text = '';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Adicionar')),
            ElevatedButton(
                onPressed: () {
                  newTagController.text = '';
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'))
          ],
        );
      },
    );
  }

  Future _loadCustomTags() async {
    customTagsModel = await _customTagRepository.getCustomTags();
    for (var tag in customTagsModel.results![0].tags!) {
      customTags.addAll({tag: false});
    }
    setState(() {});
  }

  Future<bool> _saveContact() async {
    setState(() {
      _isSaving = true;
    });
    if (ImageUtil.selectedImage != null) {
      _imgPath = await ImageUtil().saveImage();
    }

    if (_updateTags) {
      _customTagRepository.updateCustomTags(customTagsModel);
    }

    ContactModel contactData = ContactModel(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        imagePath: _imgPath,
        favorite: widget.contactModel?.favorite ?? false,
        tags: customTags.keys
            .toList()
            .where((e) => customTags[e] == true)
            .toList());

    if (widget.isEditing) {
      return await _contactRepository.updateContact(
          widget.contactModel!.objectId!, contactData);
    }
    return await _contactRepository.saveNewContact(contactData);
  }
}
