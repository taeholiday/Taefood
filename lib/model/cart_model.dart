class CartModel {
  final int? id;
  final String? idShop;
  final String? nameShop;
  final String? idFood;
  final String? nameFood;
  final String? price;
  final String? amount;
  final String? sum;
  final String? distance;
  final String? transport;

  CartModel(this.id, this.idShop, this.nameShop, this.idFood, this.nameFood,
      this.price, this.amount, this.sum, this.distance, this.transport);

  CartModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idShop = json['idShop'],
        nameShop = json['nameShop'],
        idFood = json['idFood'],
        nameFood = json['nameFood'],
        price = json['price'],
        amount = json['amount'],
        sum = json['sum'],
        distance = json['distance'],
        transport = json['transport'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['idShop'] = idShop;
    data['nameShop'] = nameShop;
    data['idFood'] = idFood;
    data['nameFood'] = nameFood;
    data['price'] = price;
    data['amount'] = amount;
    data['sum'] = sum;
    data['distance'] = distance;
    data['transport'] = transport;
    return data;
  }
}
