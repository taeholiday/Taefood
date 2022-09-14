class FoodModel {
  final String? id;
  final String? idShop;
  final String? nameFood;
  final String? pathImage;
  final String? price;
  final String? detail;

  FoodModel(this.id, this.idShop, this.nameFood, this.pathImage, this.price,
      this.detail);

  FoodModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idShop = json['idShop'],
        nameFood = json['NameFood'],
        pathImage = json['PathImage'],
        price = json['Price'],
        detail = json['Detail'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['idShop'] = idShop;
    data['NameFood'] = nameFood;
    data['PathImage'] = pathImage;
    data['Price'] = price;
    data['Detail'] = detail;
    return data;
  }
}
