import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/order_model.dart';
import 'package:taefood/model/user_model.dart';
import 'package:taefood/screens/rider/order_customer_rider.dart';
import 'package:taefood/utility/my_api.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';

class OrderDetailRider extends StatefulWidget {
  final OrderModel? orderModel;
  const OrderDetailRider({super.key, this.orderModel});

  @override
  State<OrderDetailRider> createState() => _OrderDetailRiderState();
}

class _OrderDetailRiderState extends State<OrderDetailRider> {
  OrderModel? orderModel;
  UserModel? userModel;
  bool status = true;

  @override
  void initState() {
    orderModel = widget.orderModel;
    super.initState();
    readDataShop();
  }

  Future<void> readDataShop() async {
    String url =
        '${MyConstant().domain}/TaeFood/getUserWhereId.php?isAdd=true&id=${orderModel!.idShop}';
    await Dio().get(url).then((value) {
      print('value = $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
          status = false;
        });
        print('nameShop = ${userModel!.nameShop}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดงาน"),
      ),
      body: status == true
          ? Center(
              child: MyStyle().showProgress(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      MyStyle().showTitleH2('ร้าน ${orderModel!.nameShop}'),
                    ],
                  ),
                  Row(
                    children: [
                      MyStyle()
                          .showTitleH3('ที่อยู่ร้าน ${userModel!.address}'),
                    ],
                  ),
                  Row(
                    children: [
                      MyStyle().showTitleH3Red(
                          'เบอร์โทรติดต่อร้าน ${userModel!.phone}'),
                    ],
                  ),
                  MyStyle().mySizebox(),
                  showMap(),
                  MyStyle().mySizebox(),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        changeStatusOrderService("Rider");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderCustomerRider(
                                transport: orderModel!.transport.toString(),
                                userId: orderModel!.idUser.toString(),
                                orderId: orderModel!.id.toString(),
                              ),
                            ),
                            (route) => false);
                      },
                      icon: Icon(
                        Icons.two_wheeler,
                        color: Colors.white,
                      ),
                      label: Text(
                        'รับงาน',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
    );
  }

  void changeStatusOrderService(String Status) async {
    String orderId = orderModel!.id!;
    if (orderId != null && orderId.isNotEmpty) {
      String url =
          '${MyConstant().domain}/TaeFood/editStatusOrderWhereId.php?isAdd=true&id=$orderId&Status=$Status';
      await Dio()
          .get(url)
          .then((value) => print('###### Change Status Success #####'));
    }
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

    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }
}
