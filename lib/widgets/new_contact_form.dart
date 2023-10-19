import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewContactForm extends StatefulWidget {
  const NewContactForm({super.key});

  @override
  State<NewContactForm> createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  var tags = {'Amigo': false, 'Familia': false, 'Trabalho': false};

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
                        onPressed: () {
                          debugPrint(phoneController.text.length.toString());
                          if (_formKey.currentState!.validate()) {
                            debugPrint('Form OK');
                          }
                        },
                        child: const Text('Salvar')),
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
    return Wrap(children: [
      Wrap(
        spacing: 8,
        children: tags.keys
            .toList()
            .map((tag) => FilterChip(
                  label: Text(tag),
                  selected: tags[tag]!,
                  onSelected: (value) {
                    setState(() {
                      tags[tag] = value;
                    });
                  },
                ))
            .toList(),
      ),
      InputChip(
        //TODO inserir função de tag customizada
        label: const Text('Nova Tag'),
        onPressed: () {},
      )
    ]);
  }
}
