import 'dart:io';

import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/models/saved_contacts_model.dart';
import 'package:app_contatos/pages/contact_detail_page.dart';
import 'package:app_contatos/repositories/contact_repository.dart';
import 'package:app_contatos/repositories/custom_tag_repository.dart';
import 'package:app_contatos/utils/image_util.dart';
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
  final CustomTagRepository _customTagRepository = CustomTagRepository();

  List<ContactModel> filteredContactList = [];
  List<ContactModel> defaultContactList = [];
  List<String> filters = [];
  bool favorite = false;

  @override
  void initState() {
    filteredContactList.addAll(widget.savedContacts.results);
    defaultContactList.addAll(widget.savedContacts.results);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              children: [
                FutureBuilder(
                  initialData: [
                    Visibility(
                      visible: false,
                      child: FilterChip(
                        label: const Text(''),
                        onSelected: (_) {},
                      ),
                    )
                  ],
                  future: getCustomFilters(),
                  builder: (context, snapshot) {
                    return Wrap(
                      spacing: 4,
                      children: [
                        FilterChip(
                          labelPadding: const EdgeInsets.all(0),
                          label: favorite
                              ? const Icon(Icons.star)
                              : const Icon(Icons.star_border),
                          selected: favorite,
                          showCheckmark: false,
                          onSelected: (value) {
                            setState(() {
                              favorite = value;
                              _filterByFav();
                            });
                          },
                        ),
                        ...snapshot.data!
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContactList.length,
              itemBuilder: (context, index) {
                contactModel = filteredContactList[index];
                ImageProvider? contactImg;

                if (contactModel.imagePath != null &&
                    ImageUtil().checkContactImage(contactModel.imagePath!)) {
                  contactImg = FileImage(File(contactModel.imagePath!));
                }

                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactDetailPage(
                              contactModel: filteredContactList[index]),
                        )),
                    leading: CircleAvatar(
                        backgroundImage: contactImg ?? ImageUtil.defaultImage,
                        radius: 30),
                    title: Text(
                      '${contactModel.firstName!} ${contactModel.lastName!}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contactModel.phoneNumber!),
                          Wrap(
                            spacing: 2,
                            children: contactModel.tags!
                                .map((e) => Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ))
                                .toList(),
                          )
                        ]),
                    trailing: IconButton(
                        onPressed: () {
                          filteredContactList[index].favorite =
                              !filteredContactList[index].favorite!;
                          _favoriteContact(filteredContactList[index])
                              .then((_) {
                            setState(() {});
                          });
                        },
                        icon: Icon(contactModel.favorite!
                            ? Icons.star
                            : Icons.star_border)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  Future<bool> _favoriteContact(ContactModel contact) async {
    return await _contactRepository.updateContact(contact.objectId!, contact);
  }

  Future<List<FilterChip>> getCustomFilters() async {
    var customTags = await _customTagRepository.getCustomTags();
    return customTags.results![0].tags!
        .map((tag) => FilterChip(
              selected: filters.contains(tag),
              label: Text(tag),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    filters.add(tag);
                    _filterByTag(true);
                  } else {
                    filters.remove(tag);
                    _filterByTag(false);
                  }
                });
              },
            ))
        .toList();
  }

  void _filterByFav() {
    if (favorite) {
      filteredContactList.sort(
        (a, b) => a.favorite == b.favorite ? 0 : (a.favorite! ? -1 : 1),
      );
    } else {
      filteredContactList = [];
      filteredContactList.addAll(defaultContactList);
    }
  }

  void _filterByTag(bool filter) {
    if (filter) {
      filteredContactList.sort(
        (a, b) => a.tags!.any((e) => filters.contains(e)) ? -1 : 1,
      );
    } else {
      filteredContactList = [];
      filteredContactList.addAll(defaultContactList);
    }
  }
}
