import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/screens/rider/main_rider.dart';
import 'package:taefood/screens/shop/main_shop.dart';
import 'package:taefood/screens/user/main_user.dart';
import 'package:taefood/screens/signIn.dart';
import 'package:taefood/screens/signUp.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';
import 'package:taefood/utility/normal_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<void> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString(MyConstant().keyType);
      String? idLogin = preferences.getString(MyConstant().keyId);
      print('idLogin = $idLogin');
      print(chooseType);
      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(const MainUser());
        } else if (chooseType == 'Shop') {
          routeToService(const MainShop());
        } else if (chooseType == 'Rider') {
          routeToService(const MainRider());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: [
            showHeeadDrawer(),
            signInmenu(),
            signUpmenu(),
          ],
        ),
      );

  ListTile signInmenu() {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text('Sign In'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (value) => const SignIn(),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpmenu() {
    return ListTile(
      leading: const Icon(Icons.person_add),
      title: const Text('Sign Up'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (value) => const SignUp(),
        );
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('guest.jpg'),
      accountName: Text("Guest"),
      accountEmail: Text('Please Login'),
    );
  }
}
