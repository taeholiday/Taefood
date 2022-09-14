// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taefood/app_localization.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';
import 'package:taefood/utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? chooseType, name, user, password;
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: [
              myLogo(),
              MyStyle().mySizebox(),
              showAppName(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              nameForm(),
              MyStyle().mySizebox(),
              userForm(),
              MyStyle().mySizebox(),
              passwordForm(),
              MyStyle().mySizebox(),
              confirmPasswordForm(),
              MyStyle().mySizebox(),
              MyStyle().showTitleH2('ชนิดของสมาชิก :'),
              MyStyle().mySizebox(),
              userRadio(),
              shopRadio(),
              riderRadio(),
              registerButton(),
            ],
          ),
        ));
  }

  Widget registerButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        style: MyStyle().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (chooseType == null) {
              normalDialog(context, 'โปรด เลือกชนิดของผู้สมัคร');
            } else {
              checkUser();
            }
          }
        },
        child: Text("Register"),
      ),
    );
  }

  Future<void> checkUser() async {
    String url =
        '${MyConstant().domain}/TaeFood/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(
            context, 'User นี่ $user มีคนอื่นใช้ไปแล้ว กรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> registerThread() async {
    print(
        'name = $name, user = $user, password = $password, chooseType = $chooseType');
    String url =
        '${MyConstant().domain}/TaeFood/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$chooseType';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถ สมัครได้ กรุณาลองใหม่ คะ');
      }
    } catch (e) {}
  }

  Widget userRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'User',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้สั่งอาหาร',
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );

  Widget shopRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Shop',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'เจ้าของร้านอาหาร',
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );

  Widget riderRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Rider',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้ส่งอาหาร',
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Fill Name in Blank';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Name :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().errorColor)),
              ),
            ),
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
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
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              onChanged: (value) => password = value.trim(),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Fill Password in Blank';
                } else if (!RegExp("^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])")
                    .hasMatch(value)) {
                  return AppLocalizations.of(context)!
                      .translate("passwordCondition");
                } else if (value.length < 8) {
                  return AppLocalizations.of(context)!
                      .translate("passwordLengthLabel");
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
          ),
        ],
      );

  Widget confirmPasswordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Fill Password in Blank';
                } else if (value != password) {
                  return 'Password not match';
                } else {
                  null;
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
                labelText: 'Confirm password :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().errorColor)),
              ),
            ),
          ),
        ],
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTitle('Ung Food'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );
}
