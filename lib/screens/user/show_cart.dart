import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/cart_model.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';
import 'package:taefood/utility/normal_dialog.dart';
import 'package:taefood/utility/sqlite_helper.dart';
// import 'package:toast/toast.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = [];
  int total = 0;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();
    print('object length ==> ${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum!;
        int sumInt = int.parse(sumString);
        setState(() {
          status = false;
          cartModels = object;
          total = total + sumInt;
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: status
          ? Center(
              child: Text('ตะกร้าว่างเปล่า'),
            )
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildNameShop(),
            buildHeadTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
            buildClearCartButton(),
            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget buildClearCartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
          child: ElevatedButton.icon(
              onPressed: () {
                confirmDeleteAllData();
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              label: Text(
                'Clear ตะกร้า',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
          child: ElevatedButton.icon(
              onPressed: () {
                orderThread();
              },
              icon: Icon(
                Icons.fastfood,
                color: Colors.white,
              ),
              label: Text(
                'Order',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyStyle().showTitleH2('Total : '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3Red(total.toString()),
          )
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('ร้าน ${cartModels[0].nameShop}'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle()
                  .showTitleH3('ระยะทาง = ${cartModels[0].distance} กิโลเมตร'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle()
                  .showTitleH3('ค่าขนส่ง = ${cartModels[0].transport} บาท'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH3('ราการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('ผลรวม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().mySizebox(),
          )
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(cartModels[index].nameFood!),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].price!),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].amount!),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].sum!),
            ),
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async {
                    int id = cartModels[index].id!;
                    print('You Click Delete id = $id');
                    await SQLiteHelper().deleteDataWhereId(id).then((value) {
                      print('Success Delete id = $id');
                      readSQLite();
                    });
                  },
                )),
          ],
        ),
      );

  Future<Null> confirmDeleteAllData() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการจะลบ รายการอาหารทั้งหมด จริงๆ หรือ ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await SQLiteHelper().deleteAllData().then((value) {
                    readSQLite();
                  });
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                label: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String orderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    String idShop = cartModels[0].idShop!;
    String nameShop = cartModels[0].nameShop!;
    String distance = cartModels[0].distance!;
    String transport = cartModels[0].transport!;

    List<String> idFoods = [];
    List<String> nameFoods = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      idFoods.add(model.idFood!);
      nameFoods.add(model.nameFood!);
      prices.add(model.price!);
      amounts.add(model.amount!);
      sums.add(model.sum!);
    }

    String idFood = idFoods.toString();
    String nameFood = nameFoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUser = preferences.getString('id');
    String? nameUser = preferences.getString('Name');

    print(
        'orderDateTime = $orderDateTime, idUser = $idUser, nameUser = $nameUser, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport');
    print(
        'idFood = $idFood, nameFood = $nameFood, price = $price, amount = $amount, sum = $sum');

    String url =
        '${MyConstant().domain}/TaeFood/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport&idFood=$idFood&NameFood=$nameFood&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=UserOrder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        clearAllSQLite();
        normalDialog(context, 'ส่ง Order ไปที่ ร้านค้าแล้ว คะ');
      } else {
        normalDialog(context, 'ไม่สามารถ Order ได้ กรุณาลองใหม่');
      }
    });
  }

  Future<Null> clearAllSQLite() async {
    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }
}
