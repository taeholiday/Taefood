import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';
import 'package:taefood/utility/normal_dialog.dart';

class EditInfoShop extends StatefulWidget {
  const EditInfoShop({super.key});

  @override
  State<EditInfoShop> createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel? userModel;
  String? nameShop, address, phone, urlPicture;
  LatLng? latLng;
  File? file;
  bool editImage = false;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    if (position != null) {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        print('lat = ${latLng!.latitude}');
      });
    }
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idShop = preferences.getString('id');
    print('idShop ==>> $idShop');

    String url = '${MyConstant().domain}/TaeFood/.php?isAdd=true&id=$idShop';

    Response response = await Dio().get(url);
    print('response ==>> $response');

    var result = json.decode(response.data);
    print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel!.nameShop;
        address = userModel!.address;
        phone = userModel!.password;
        urlPicture = userModel!.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปรับปรุง รายละเอียดร้าน'),
      ),
      body: userModel == null ? MyStyle().showProgress() : showContent(),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameShopForm(),
            showImage(),
            addressForm(),
            phoneForm(),
            latLng == null ? MyStyle().showProgress() : showMap(),
            editButton()
          ],
        ),
      );
  Widget editButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
          style: MyStyle().myButtonStyle(),
          onPressed: () => confirmDialog(),
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          label: Text(
            'ปรับปรุง รายละเอียด',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณแน่ใจว่าจะ ปรับปรุงรายละเอียดร้าน นะคะ ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text('แน่ใจ'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ไม่แน่ใจ'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    print(editImage);
    if (editImage == true) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameFile = 'editShop$i.jpg';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      String urlUpload = '${MyConstant().domain}/TaeFood/saveShop.php';
      await Dio().post(urlUpload, data: formData);
      urlPicture = '/TaeFood/Shop/$nameFile';

      String id = userModel!.id!;
      // print('id = $id');

      String url =
          '${MyConstant().domain}/TaeFood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=${latLng!.latitude}&Lng=${latLng!.longitude}';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยัง อัพเดทไม่ได้ กรุณาลองใหม่');
      }
    } else {
      String id = userModel!.id!;
      // print('id = $id');

      String url =
          '${MyConstant().domain}/TaeFood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=${latLng!.latitude}&Lng=${latLng!.longitude}';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยัง อัพเดทไม่ได้ กรุณาลองใหม่');
      }
    }
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => chooseImage(ImageSource.camera),
            ),
            Container(
              width: 250.0,
              height: 250.0,
              child: file == null
                  ? Image.network('${MyConstant().domain}$urlPicture')
                  : Image.file(file!),
            ),
            IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseImage(ImageSource.gallery),
            ),
          ],
        ),
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker()
          .pickImage(source: source, maxWidth: 800.0, maxHeight: 800.0);

      setState(() {
        file = File(image!.path);
        editImage = true;
      });
    } catch (e) {}
  }

  Widget showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latLng!.latitude, latLng!.longitude),
      zoom: 16.0,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      margin: EdgeInsets.only(top: 16.0),
      height: 250,
      child: latLng == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLng!,
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: <Marker>{
                Marker(
                  markerId: MarkerId('id'),
                  position: latLng!,
                  infoWindow: InfoWindow(
                      title: 'You Location',
                      snippet:
                          'lat = ${latLng!.latitude}, lng = ${latLng!.longitude}'),
                ),
              },
            ),
    );
  }

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์ติดต่อร้าน',
              ),
            ),
          ),
        ],
      );
}
