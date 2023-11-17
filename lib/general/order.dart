import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  String outlet;
  String status;
  String orderno;
  Order(
      {super.key,
      required this.orderno,
      required this.outlet,
      required this.status});

  @override
  State<Order> createState() => _OrderState(orderno, status, outlet);
}

class _OrderState extends State<Order> {
  String orderno;
  String outlet;
  String status;
  final dataseRef = FirebaseDatabase.instance.ref();
  _OrderState(this.orderno, this.outlet, this.status);
    List thisOrder = [];
  var isLoaded = false;

   getThisOrder() async {
    final response = await http.get(Uri.parse(
        "http://api.newamadelivery.co.ke/fetchOrder.php?orderId=${orderno}"));
    setState(() {
      thisOrder = json.decode(response.body);
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getThisOrder();
   
  }

  @override
  Widget build(BuildContext context) {
    Query dbRef1 = FirebaseDatabase.instance
        .ref()
        .child('Orders/${orderno}/customerDetails');
    Query dbRef2 =
        FirebaseDatabase.instance.ref().child('Orders/${orderno}/items');
    Query dbRef3 = FirebaseDatabase.instance.ref().child('Orders/${orderno}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Order No. $orderno'),
        backgroundColor: const Color.fromARGB(255, 3, 83, 148),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Image.asset('assets/images/cart.png'),
              const SizedBox(
                height: 90,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(197, 245, 16, 0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 230,
                  child: Column(
                    children: [
                      Visibility(
                            visible: isLoaded,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: thisOrder?.length,
                              itemBuilder: (context, index) {
                                var dt3 =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(thisOrder![index]
                                                ['postTime']));
                                    var TAS3 =
                                        DateFormat('dd/MM/yyyy').format(dt3);
                                return Container(
                                  
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(
                                    children: [
                                      Text('Date: ${TAS3}',style: TextStyle(color: Colors.white),),
                                      const SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Status - ${status}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text('|'),
                                          Text(
                                            'Store - ${outlet}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Customer: ${thisOrder![index]['customer']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'Contacts: ${thisOrder![index]['contacts']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Area: ${thisOrder![index]['area']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Landmark: ${thisOrder![index]['landmark']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Items: ${thisOrder![index]['item']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Value: Kes ${thisOrder![index]['price']}/=',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            )),
                    ],
                  )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
