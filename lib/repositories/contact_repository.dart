import 'dart:convert';
import 'package:app_contatos/models/contact_model.dart';
import 'package:app_contatos/models/saved_contacts_model.dart';
import '../services/custom_dio.dart';

class ContactRepository {
  final _customDio = CustomDio();

  Future<bool> saveNewContact(ContactModel contactModel) async {
    var response =
        await _customDio.dio.post('', data: jsonEncode(contactModel.toJson()));
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<SavedContactsModel> getContacts() async {
    var response = await _customDio.dio.get('');
    return SavedContactsModel.fromJson(response.data);
  }
}
