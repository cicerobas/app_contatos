import 'package:app_contatos/models/contact_model.dart';

class SavedContactsModel {
  List<ContactModel> results = [];

  SavedContactsModel(this.results);

  SavedContactsModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ContactModel>[];
      json['results'].forEach((v) {
        results.add(ContactModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}
