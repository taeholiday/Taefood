import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/food_model.dart';
import 'package:taefood/screens/shop/add_food_menu.dart';
import 'package:taefood/screens/shop/edit_food_menu.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';

class ListFoodMenuShop extends StatefulWidget {
  const ListFoodMenuShop({super.key});

  @override
  State<ListFoodMenuShop> createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  bool loadStatus = true; // Process Load JSON
  bool status = true; // Have Data
  List<FoodModel> foodModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      loadStatus = true;
      status = true;
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idShop = preferences.getString('id');
    print('idShop = $idShop');

    String url =
        '${MyConstant().domain}/TaeFood/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        // print('value ==>> $value');

        var result = json.decode(value.data);
        // print('result ==>> $result');

        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().showProgress() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${MyConstant().domain}${foodModels[index].pathImage}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      foodModels[index].nameFood!,
                      style: MyStyle().mainTitle,
                    ),
                    Text(
                      'ราคา ${foodModels[index].price} บาท',
                      style: MyStyle().mainH2Title,
                    ),
                    Text(foodModels[index].detail!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditFoodMenu(
                                foodModel: foodModels[index],
                              ),
                            );
                            Navigator.push(context, route)
                                .then((value) => readFoodMenu());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => deleateFood(foodModels[index]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> deleateFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title:
            MyStyle().showTitleH2('คุณต้องการลบ เมนู ${foodModel.nameFood} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${MyConstant().domain}/TaeFood/deleteFoodWhereId.php?isAdd=true&id=${foodModel.id}';
                  await Dio().get(url).then((value) => readFoodMenu());
                },
                child: Text('ยืนยัน'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยังไม่ลบ'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddFoodMenu(),
                    );
                    Navigator.push(context, route)
                        .then((value) => readFoodMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
