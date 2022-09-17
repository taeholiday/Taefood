// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/screens/user/show_shop_food_menu.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = [];
  List<Widget> shopCards = [];

  @override
  void initState() {
    super.initState();
    readShop();
  }

  Future<void> readShop() async {
    String url =
        '${MyConstant().domain}/TaeFood/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      // print('value = $value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);

        String nameShop = model.nameShop!;
        if (nameShop.isNotEmpty && mounted) {
          print('NameShop = ${model.nameShop}');
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopFoodMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyStyle().mySizebox(),
            Expanded(
                child: Image.network(
                    '${MyConstant().domain}${userModel.urlPicture}')),
            MyStyle().mySizebox(),
            MyStyle().showTitleH3(userModel.nameShop!),
            MyStyle().mySizebox(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 220.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: shopCards,
          );
  }
}
