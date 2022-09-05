import 'package:flutter/material.dart';
import 'package:taefood/screens/signIn.dart';
import 'package:taefood/screens/signUp.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return const UserAccountsDrawerHeader(
      accountName: Text("Guest"),
      accountEmail: Text('Please Login'),
    );
  }
}
