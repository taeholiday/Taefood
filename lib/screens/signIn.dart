// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/screens/rider/main_rider.dart';
import 'package:taefood/screens/shop/main_shop.dart';
import 'package:taefood/screens/user/main_user.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';
import 'package:taefood/utility/normal_dialog.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Field
  String? user, password;
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[Colors.white, MyStyle().primaryColor],
            center: Alignment(0, -0.3),
            radius: 1.0,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyStyle().showLogo(),
                      MyStyle().mySizebox(),
                      MyStyle().showTitle('Tae Food'),
                      MyStyle().mySizebox(),
                      userForm(),
                      MyStyle().mySizebox(),
                      passwordForm(),
                      loginButton()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        style: MyStyle().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            print('## user = $user, password = $password');
            checkAuthen();
          }
        },
        child: Text("login"),
      ),
    );
  }

  Future<void> checkAuthen() async {
    String url =
        '${MyConstant().domain}/TaeFood/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);

      var result = json.decode(response.data);

      for (Map<String, dynamic> map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String? chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeTuService(const MainUser(), userModel);
          } else if (chooseType == 'Shop') {
            routeTuService(const MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            routeTuService(const MainRider(), userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่ ');
        }
      }
    } catch (e) {
      print('Have e Error ===>> ${e.toString()}');
    }
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MyConstant().keyId, userModel.id!);
    preferences.setString(MyConstant().keyType, userModel.chooseType!);
    preferences.setString(MyConstant().keyName, userModel.name!);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
          onChanged: (value) => user = value.trim(),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Fill User in Blank';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().errorColor)),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
          onChanged: (value) => password = value.trim(),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Fill Password in Blank';
            } else {
              return null;
            }
          },
          obscureText: statusRedEye,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              },
              icon: statusRedEye
                  ? Icon(
                      Icons.remove_red_eye,
                      color: MyStyle().darkColor,
                    )
                  : Icon(
                      Icons.remove_red_eye_outlined,
                      color: MyStyle().darkColor,
                    ),
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().errorColor)),
          ),
        ),
      );
}
