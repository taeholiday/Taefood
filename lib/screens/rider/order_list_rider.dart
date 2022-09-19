import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taefood/model/order_model.dart';
import 'package:taefood/screens/rider/order_detail_rider.dart';
import 'package:taefood/utility/my_api.dart';
import 'package:taefood/utility/my_constant.dart';
import 'package:taefood/utility/my_style.dart';

class OrderListShopRider extends StatefulWidget {
  const OrderListShopRider({super.key});

  @override
  State<OrderListShopRider> createState() => _OrderListShopRiderState();
}

class _OrderListShopRiderState extends State<OrderListShopRider> {
  String? idShop;
  List<OrderModel> orderModels = [];
  List<List<String>> listNameFoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    findIdShopAndReadOrder();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      findIdShopAndReadOrder();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<Null> findIdShopAndReadOrder() async {
    orderModels.clear();
    listNameFoods.clear();
    listPrices.clear();
    listAmounts.clear();
    listSums.clear();
    totals.clear();

    String path = '${MyConstant().domain}/TaeFood/getOrderAll.php?isAdd=true';
    await Dio().get(path).then((value) {
      // print('value ==>> $value');
      var result = json.decode(value.data);
      // print('result ==>> $result');
      for (var item in result) {
        OrderModel model = OrderModel.fromJson(item);
        // print('orderDateTime = ${model.orderDateTime}');

        List<String> nameFoods = MyAPI().createStringArray(model.nameFood!);
        List<String> prices = MyAPI().createStringArray(model.price!);
        List<String> amounts = MyAPI().createStringArray(model.amount!);
        List<String> sums = MyAPI().createStringArray(model.sum!);

        int total = 0;
        for (var item in sums) {
          total = total + int.parse(item);
        }

        setState(() {
          orderModels.add(model);
          listNameFoods.add(nameFoods);
          listPrices.add(prices);
          listAmounts.add(amounts);
          listSums.add(sums);
          totals.add(total);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: orderModels.length,
              itemBuilder: (context, index) => orderModels[index].status! ==
                      'Cooking'
                  ? Card(
                      color: index % 2 == 0
                          ? Colors.lime.shade100
                          : Colors.lime.shade400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyStyle().showTitleH2(orderModels[index].nameUser!),
                            MyStyle()
                                .showTitleH3(orderModels[index].orderDateTime!),
                            buildTitle(),
                            ListView.builder(
                              itemCount: listNameFoods[index].length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index2) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(listNameFoods[index][index2]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(listPrices[index][index2]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(listAmounts[index][index2]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(listSums[index][index2]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MyStyle().showTitleH2('Total :'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: MyStyle()
                                      .showTitleH3Red(totals[index].toString()),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetailRider(
                                                    orderModel:
                                                        orderModels[index]),
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.two_wheeler,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'delivery',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
    );
  }

  changeStatusOrderService(int index, String Status) async {
    String orderId = orderModels[index].id!;
    if (orderId != null && orderId.isNotEmpty) {
      String url =
          '${MyConstant().domain}/TaeFood/editStatusOrderWhereId.php?isAdd=true&id=$orderId&Status=$Status';
      await Dio()
          .get(url)
          .then((value) => print('###### Change Status Success #####'));
    }
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.lime.shade700),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Name Food'),
          ),
          Expanded(
            flex: 1,
            child: Text('Price'),
          ),
          Expanded(
            flex: 1,
            child: Text('Amount'),
          ),
          Expanded(
            flex: 1,
            child: Text('Sum'),
          ),
        ],
      ),
    );
  }
}
