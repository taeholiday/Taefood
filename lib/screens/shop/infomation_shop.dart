import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/screens/shop/add_info_shop.dart';
import 'package:taefood/screens/shop/edit_info_shop.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';

class InfomationShop extends StatefulWidget {
  const InfomationShop({super.key});

  @override
  State<InfomationShop> createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<void> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/TaeFood/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      print('value = $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('nameShop = ${userModel!.nameShop}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameShop!.isEmpty
                ? showNoData(context)
                : showListInfoShop(),
        addAnEditButton(),
      ],
    );
  }

  Widget addAnEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 16.0,
                bottom: 16.0,
              ),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  print('you click floating');
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeToAddInfo() {
    Widget widget =
        userModel!.nameShop!.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  Widget showListInfoShop() {
    return Column(
      children: [
        MyStyle().showTitleH2('รายละเอียดร้าน ${userModel!.nameShop}'),
        showImage(),
        Row(
          children: <Widget>[
            MyStyle().showTitleH2('ที่อยู่ของร้าน'),
          ],
        ),
        Row(
          children: <Widget>[
            Text(userModel!.address!),
          ],
        ),
        MyStyle().mySizebox(),
        showMap(),
      ],
    );
  }

  Set<Marker> shopMarker() {
    return <Marker>{
      Marker(
          markerId: MarkerId('shopID'),
          position: LatLng(
            double.parse(userModel!.lat!),
            double.parse(userModel!.lng!),
          ),
          infoWindow: InfoWindow(
              title: 'ตำแหน่งร้าน',
              snippet:
                  'ละติจูต = ${userModel!.lat}, ลองติจูต = ${userModel!.lng}'))
    };
  }

  Widget showMap() {
    double lat = double.parse(userModel!.lat!);
    double lng = double.parse(userModel!.lng!);
    print('lat = $lat, lng = $lng');

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Container showImage() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network('${MyConstant().domain}${userModel!.urlPicture}'),
    );
  }

  Widget showNoData(BuildContext context) {
    return MyStyle()
        .titleCenter(context, 'ยังไม่มี ข้อมูล กรุณาเพิ่มข้อมูลด้วย คะ');
  }
}
