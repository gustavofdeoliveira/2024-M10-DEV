class Photo {
  String? fileName;
  int? id;
  String? url;
  String? userToken;
  String? createdAt;
  String? updatedAt;

  Photo({
    this.fileName,
    this.id,
    this.url,
    this.userToken,
    this.createdAt,
    this.updatedAt,
  });

  Photo.fromJson(Map<String, dynamic> json) {
    userToken = json['user_token'];
    fileName = json['file_name'];
    url = json['url'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_token'] = userToken;
    data['file_name'] = fileName;
    data['url'] = url;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
