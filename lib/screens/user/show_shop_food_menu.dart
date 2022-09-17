// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/screens/user/about_shop.dart';
import 'package:taefood/screens/user/show_menu_food.dart';
import 'package:taefood/utility/my_style.dart';

class ShowShopFoodMenu extends StatefulWidget {
  final UserModel? userModel;
  const ShowShopFoodMenu({Key? key, this.userModel}) : super(key: key);
  @override
  _ShowShopFoodMenuState createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel? userModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(
      userModel: userModel,
    ));
    listWidgets.add(ShowMenuFood(
      userModel: userModel,
    ));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'รายละเอียดร้าน',
    );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: 'เมนูอาหาร',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[MyStyle().iconShowCart(context)],
        title: Text(userModel!.nameShop!),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showBottonNavigationBar(),
    );
  }

  BottomNavigationBar showBottonNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showMenuFoodNav(),
        ],
      );
}
