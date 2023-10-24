import 'package:app_contatos/models/custom_tags_model.dart';

import '../services/custom_dio.dart';

class CustomTagRepository {
  final _customDio = CustomDio('CustomTags');

  Future<CustomTagsModel> getCustomTags() async {
    var response = await _customDio.dio.get('');
    return CustomTagsModel.fromJson(response.data);
  }

  updateCustomTags(CustomTagsModel customTagsModel) async {
    await _customDio.dio.put('/${customTagsModel.results![0].objectId}',
        data: customTagsModel.results![0]);
  }
}
