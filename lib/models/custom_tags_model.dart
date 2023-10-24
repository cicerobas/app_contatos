class CustomTagsModel {
  List<Results>? results;

  CustomTagsModel({this.results});

  CustomTagsModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? objectId;
  List<String>? tags;

  Results({this.objectId, this.tags});

  Results.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['tags'] = tags;
    return data;
  }
}
