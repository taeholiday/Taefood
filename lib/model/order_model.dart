class OrderModel {
  final String? id;
  final String? orderDateTime;
  final String? idUser;
  final String? nameUser;
  final String? idShop;
  final String? nameShop;
  final String? distance;
  final String? transport;
  final String? idFood;
  final String? nameFood;
  final String? price;
  final String? amount;
  final String? sum;
  final String? idRider;
  final String? status;

  OrderModel(
      this.id,
      this.orderDateTime,
      this.idUser,
      this.nameUser,
      this.idShop,
      this.nameShop,
      this.distance,
      this.transport,
      this.idFood,
      this.nameFood,
      this.price,
      this.amount,
      this.sum,
      this.idRider,
      this.status);

  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderDateTime = json['OrderDateTime'],
        idUser = json['idUser'],
        nameUser = json['NameUser'],
        idShop = json['idShop'],
        nameShop = json['NameShop'],
        distance = json['Distance'],
        transport = json['Transport'],
        idFood = json['idFood'],
        nameFood = json['NameFood'],
        price = json['Price'],
        amount = json['Amount'],
        sum = json['Sum'],
        idRider = json['idRider'],
        status = json['Status'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['OrderDateTime'] = orderDateTime;
    data['idUser'] = idUser;
    data['NameUser'] = nameUser;
    data['idShop'] = idShop;
    data['NameShop'] = nameShop;
    data['Distance'] = distance;
    data['Transport'] = transport;
    data['idFood'] = idFood;
    data['NameFood'] = nameFood;
    data['Price'] = price;
    data['Amount'] = amount;
    data['Sum'] = sum;
    data['idRider'] = idRider;
    data['Status'] = status;
    return data;
  }
}
