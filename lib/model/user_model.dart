class UserModel {
  final String? id;
  final String? chooseType;
  final String? name;
  final String? user;
  final String? password;
  final String? nameShop;
  final String? address;
  final String? phone;
  final String? urlPicture;
  final String? lat;
  final String? lng;
  final String? token;

  UserModel(
      this.id,
      this.chooseType,
      this.name,
      this.user,
      this.password,
      this.nameShop,
      this.address,
      this.phone,
      this.urlPicture,
      this.lat,
      this.lng,
      this.token);

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chooseType = json['ChooseType'],
        name = json['Name'],
        user = json['User'],
        password = json['Password'],
        nameShop = json['NameShop'],
        address = json['Address'],
        phone = json['Phone'],
        urlPicture = json['UrlPicture'],
        lat = json['Lat'],
        lng = json['Lng'],
        token = json['Token'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['ChooseType'] = chooseType;
    data['Name'] = name;
    data['User'] = user;
    data['Password'] = password;
    data['NameShop'] = nameShop;
    data['Address'] = address;
    data['Phone'] = phone;
    data['UrlPicture'] = urlPicture;
    data['Lat'] = lat;
    data['Lng'] = lng;
    data['Token'] = token;
    return data;
  }
}
