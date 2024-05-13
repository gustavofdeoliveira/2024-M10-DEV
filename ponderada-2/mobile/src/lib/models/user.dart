class User {
  String? accessToken;
  String? expiration;
  UserInfo? userInfo;

  User({this.accessToken, this.expiration, this.userInfo});

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiration = json['expiration'];
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['expiration'] = expiration;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    return data;
  }
}

class UserInfo {
  String? email;
  String? userToken;
  String? name;
  bool? isActive;
  bool? isSuperuser;
  int? id;
  String? createdAt;
  String? updatedAt;

  UserInfo(
      {this.email,
      this.userToken,
      this.name,
      this.isActive,
      this.isSuperuser,
      this.id,
      this.createdAt,
      this.updatedAt});

  UserInfo.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userToken = json['user_token'];
    name = json['name'];
    isActive = json['is_active'];
    isSuperuser = json['is_superuser'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['user_token'] = userToken;
    data['name'] = name;
    data['is_active'] = isActive;
    data['is_superuser'] = isSuperuser;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
