import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<void> alertLocationService(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: ListTile(
        leading: Image.asset("images/logo.png"),
        title: Text(title),
        subtitle: Text(message),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Text('OK'))
      ],
    ),
  );
}

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        title: Text(message),
      ),
      children: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.red),
            ))
      ],
    ),
  );
}
