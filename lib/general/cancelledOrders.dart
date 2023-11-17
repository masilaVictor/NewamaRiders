import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newamariders/general/cancelledDate.dart';
import 'package:newamariders/general/dashboard.dart';
import 'package:newamariders/general/deliveredDate.dart';
import 'package:newamariders/general/order.dart';
import 'package:newamariders/general/ordersDate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CancelledOrders extends StatefulWidget {
  var selectedDate;
  var end;
  CancelledOrders({super.key, });

  @override
  State<CancelledOrders> createState() =>
      _CancelledOrdersState();
}

class _CancelledOrdersState extends State<CancelledOrders> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Orders');
  final User? user = FirebaseAuth.instance.currentUser;
  var selectedDate;
  var end;
  var isLoaded = false;
  List myCancelledOrders = [];
  var cancelledOrders = 0;
  
  _CancelledOrdersState();

  @override
  void initState(){
    super.initState();
    getCancelledOrders();
  }

  getCancelledOrders() async{
    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderCancelled.php?rider=${user!.email as String}"));
    setState(() {
      myCancelledOrders = json.decode(response.body);
   
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelled Orders'),
        backgroundColor: const Color.fromARGB(255, 3, 83, 148),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            children: [
              Visibility(
                visible: isLoaded,
                child: ListView.builder(
                   physics: NeverScrollableScrollPhysics(),
                  
                  shrinkWrap: true,
                  itemCount: myCancelledOrders?.length,
                  itemBuilder: (context, index){
                    var dt3 = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(myCancelledOrders![index]['assignTime']));
                      var TAS3 = DateFormat('dd/MM/yyyy').format(dt3);
                    return Container(
                          margin: const EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: myCancelledOrders![index]['status'] == 'Cancelled'
                                  ? Color.fromARGB(255, 255, 17, 0)
                                  : myCancelledOrders![index]['status'] == 'Processing'
                                      ? Colors.blue
                                      : myCancelledOrders![index]['status'] == 'Transit'
                                          ? const Color.fromARGB(
                                              255, 102, 92, 0)
                                          : myCancelledOrders![index]['status'] == 'Delivered'
                                              ? Colors.green
                                              : Color.fromARGB(80, 126, 1, 42),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Order(
                                              orderno: myCancelledOrders![index]['orderID'],
                                              outlet: myCancelledOrders![index]['outlet'],
                                              status: myCancelledOrders![index]['status'])));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order No. ${myCancelledOrders![index]['orderID']}',
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('outlet:${myCancelledOrders![index]['outlet']}',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                    Text('Status:${myCancelledOrders![index]['status']}',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Date: $TAS3',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );

                  }),
                  replacement: CircularProgressIndicator(),
                  
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
