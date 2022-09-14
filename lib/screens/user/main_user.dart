import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/screens/user/show_list_shop_all.dart';
import 'package:taefood/utility/my_style.dart';
import 'package:taefood/utility/signout_process.dart';

class MainUser extends StatefulWidget {
  const MainUser({super.key});

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String? nameUser;
  Widget? currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = ShowListShopAll();
    findUser();
  }

  Future<void> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          MyStyle().iconShowCart(context),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                menuListShop(),
                menuCart(),
                menuStatusFoodOrder(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                menuSignOut(),
              ],
            ),
          ],
        ),
      );

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade700),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'การออกจากแอพ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  ListTile menuStatusFoodOrder() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          // currentWidget = ShowStatusFoodOrder();
        });
      },
      leading: Icon(Icons.restaurant_menu),
      title: Text('แสดงรายการอาหารที่สั่ง'),
      subtitle: Text('แสดงรายการอาหารที่สั่ง และ หรือ ดูสถานะของอาหารที่สั่ง'),
    );
  }

  Widget menuCart() {
    return ListTile(
      leading: Icon(Icons.add_shopping_cart),
      title: Text('ตะกร้า ของฉัน'),
      subtitle: Text('รายการอาหาร ที่อยู่ใน ตะกร้า ยังไม่ได้ Order'),
      onTap: () {
        // Navigator.pop(context);
        // MaterialPageRoute route = MaterialPageRoute(
        //   builder: (context) => ShowCart(),
        // );
        // Navigator.push(context, route);
      },
    );
  }

  ListTile menuListShop() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListShopAll();
        });
      },
      leading: Icon(Icons.home),
      title: Text('แสดงร้านค้า'),
      subtitle: Text('แสดงร้านค้า ที่สามารถสั่งอาหารได้'),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameUser ?? 'Name Login',
        style: TextStyle(color: MyStyle().darkColor),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: MyStyle().primaryColor),
      ),
    );
  }
}
