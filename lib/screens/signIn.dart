import 'package:flutter/material.dart';
import 'package:taefood/utility/my_style.dart';

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
      margin: EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        style: MyStyle().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            print('## user = $user, password = $password');
          }
        },
        child: Text("login"),
      ),
    );
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
