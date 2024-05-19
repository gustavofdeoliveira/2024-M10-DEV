class Tag {
  String? userToken;
  String? name;
  String? description;
  int? id;
  String? createdAt;
  String? updatedAt;

  Tag(
      {this.userToken,
      this.name,
      this.description,
      this.id,
      this.createdAt,
      this.updatedAt});

  Tag.fromJson(Map<String, dynamic> json) {
    userToken = json['user_token'];
    name = json['name'];
    description = json['description'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_token'] = userToken;
    data['name'] = name;
    data['description'] = description;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
