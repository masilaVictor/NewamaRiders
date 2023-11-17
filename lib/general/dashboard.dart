import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newamariders/auth/login.dart';
import 'package:newamariders/general/allorders.dart';
import 'package:newamariders/general/cancelledOrders.dart';
import 'package:newamariders/general/deliveredOrders.dart';
import 'package:newamariders/general/orderview.dart';
import 'package:newamariders/general/returnedOrders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  
  Query dbRef = FirebaseDatabase.instance.ref().child('Assignments');
  final User? user = FirebaseAuth.instance.currentUser;

  var pendingOrders = [];
  var myAllOrders = [];
  var myDeliveredOrders = [];
  var myReturnedOrders = [];
  var myCancelledOrders = [];
  var isLoaded = false;
  var allOrders = 0;
  var deliveredOrders = 0;
  var returnedOrders = 0;
  var cancelledOrders = 0;
  var dte3;
  

  



  @override
  void initState(){


    super.initState();
    
    getPendingOrders();
    getAllOrders();
    getDeliveredOrders();
    getCancelledOrders();


  }

  getPendingOrders() async{
    var dt2 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    var TAS2 = DateFormat('dd/MM/yyyy').format(dt2);
    var dateTimeFormat = DateFormat('dd/MM/yyyy', 'en_US').parse(TAS2);
    dte3 = dateTimeFormat.millisecondsSinceEpoch;
    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderPendingOrders.php?rider=%27${user!.email as String}%27&fromTime=${dte3.toString()}"));
    setState(() {
      pendingOrders = json.decode(response.body);
      isLoaded = true;
    });
  }

   getAllOrders() async{
    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderAll.php?rider=${user!.email as String}"));
    setState(() {
      myAllOrders = json.decode(response.body);
      allOrders = myAllOrders.length;

    });
  }
     getReturnedOrders() async{
    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderReturned.php?rider=${user!.email as String}"));
    setState(() {
      myReturnedOrders = json.decode(response.body);
      returnedOrders = myReturnedOrders.length;

    });
  }

    getCancelledOrders() async{
    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderCancelled.php?rider=${user!.email as String}"));
    setState(() {
      myCancelledOrders = json.decode(response.body);
      cancelledOrders = myCancelledOrders.length;
    });
  }

   getDeliveredOrders() async{
    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderDelivered.php?rider=${user!.email as String}"));
    setState(() {
      myDeliveredOrders = json.decode(response.body);
      deliveredOrders = myDeliveredOrders.length;

    });
  }
  @override
  Widget build(BuildContext context) {
    var dt4 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    var TAS4 = DateFormat('dd/MM/yyyy').format(dt4);
    var TAS5 = TAS4;
    int check = 0;
    var dt2 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    var TAS2 = DateFormat('dd/MM/yyyy').format(dt2);
    // var dateTimeFormat = DateFormat('dd/MM/yyyy', 'en_US').parse(TAS2);
    // var dte3 = dateTimeFormat.millisecondsSinceEpoch;
    
    
    var store;
    var dateCheck;
    var dte = '16/11/2023';
    var dte2;
    
    // if(TAS2 == dte){
    //   dateCheck = 'Date is equal'; 
      
    //   setState(() {
    //     dte = TAS2;
    //     var dateTimeFormat = DateFormat('dd/MM/yyyy', 'en_US').parse(TAS2);
    //     dte3 = dateTimeFormat.millisecondsSinceEpoch;

    //   });                     
    // }
    // else{
    //   dateCheck = 'Date not equal';
    // }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 119, 194, 255),
                      Color.fromARGB(255, 1, 62, 112),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome,  ',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Text(
                              user!.email as String,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 119, 194, 255),
                            ),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text('Exit'))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(169, 183, 253, 214)),
                          child: SizedBox(
                            width: 116,
                            height: 66,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllOrders()));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.store, color: Colors.white),
                                  Text(
                                    'All Orders',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Total: ${allOrders}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(199, 96, 85, 247)),
                          child: SizedBox(
                            width: 116,
                            height: 66,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DeliveredOrders(
                                           )));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.motorcycle_outlined,
                                      color: Colors.white),
                                  Text(
                                    'Delivered Orders',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Total: ${deliveredOrders}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(169, 250, 231, 57)),
                          child: SizedBox(
                            width: 116,
                            height: 66,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReturnedOrders(
                                          )));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.arrow_back_sharp,
                                      color: Colors.white),
                                  Text(
                                    'Returned Orders',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Total: ${returnedOrders}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(197, 253, 57, 57)),
                          child: SizedBox(
                            width: 116,
                            height: 66,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CancelledOrders(
                                            )));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.backspace_sharp,
                                      color: Colors.white),
                                  Text(
                                    'Cancelled Orders',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Total: ${cancelledOrders}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: [
                  Text(
                    'Activity Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'New Orders - $TAS2',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 39, 36, 36),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Text(dateCheck),
                        
                        
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(50, 64, 195, 255),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 270,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order No.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Store',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                            Text('Assigned',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                   
                                  ],
                                ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Visibility(
                                  visible: isLoaded,

                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: pendingOrders?.length,
                                    itemBuilder: (context,index){
                                        var dt3 = DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(pendingOrders![index]['assignTime']));
                                        var TAS3 = DateFormat('hh:mm:ss a').format(dt3);
                                      return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderView(
                                                                orderno: pendingOrders![index]['orderID'],
                                                                outlet:  pendingOrders![index]['outlet'],
                                                                status:  pendingOrders![index]['status'])));
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('${pendingOrders![index]['orderID']}'),
                                                      Text(pendingOrders![index]['outlet']),
                                                      Text(
                                                          '${pendingOrders![index]['status']}'),
                                                          Text(TAS3),
                                                     
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 13,
                                                  )
                                                ],
                                              ),
                                            );

                                    }),
                                    replacement: CircularProgressIndicator(),
                                    
                                    ),






                                // Expanded(
                                //   child: FirebaseAnimatedList(
                                //       query: dbRef
                                //           .orderByChild('RiderMail')
                                //           .equalTo(user!.email),
                                //       itemBuilder: (BuildContext context,
                                //           DataSnapshot snapshot,
                                //           Animation<double> animation,
                                //           int index) {
                                //         Map orders = snapshot.value as Map;
                                //         orders['key'] = snapshot.key;

                                //         // var dt3 = DateTime.fromMillisecondsSinceEpoch(
                                //         // orders['postTime'].millisecondsSinceEpoch);
                                //         // var TAS3 = DateFormat('dd/MM/yyyy').format(dt3);

                                //         if (orders['outlet'] ==
                                //             'Naivas Mountain Mall') {
                                //           store = 'Mountain Mall';
                                //         } else if (orders['outlet'] ==
                                //             'Naivas Gateway Mall') {
                                //           store = 'Gateway Mall';
                                //         } else {
                                //           store = 'Not Set';
                                //         }

                                //         if (orders['Time'] == null) {
                                //           return Container();
                                //         } else {
                                //           var dt3 = DateTime
                                //               .fromMillisecondsSinceEpoch(
                                //                   int.parse(orders['Time']));
                                //           var TAS3 = DateFormat('dd/MM/yyyy')
                                //               .format(dt3);
                                //           var TAS9 =
                                //               DateFormat('hh:mm a').format(dt3);
                                //           if (TAS3.compareTo(TAS2) == 0) {
                                //             return GestureDetector(
                                //               onTap: () {
                                //                 Navigator.push(
                                //                     context,
                                //                     MaterialPageRoute(
                                //                         builder: (context) =>
                                //                             OrderView(
                                //                                 orderno: snapshot
                                //                                         .key
                                //                                     as String,
                                //                                 outlet: store,
                                //                                 status: orders[
                                //                                     'status'])));
                                //               },
                                //               child: Column(
                                //                 children: [
                                //                   Row(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .spaceBetween,
                                //                     children: [
                                //                       Text('${snapshot.key}'),
                                //                       Text(store),
                                //                       Text(
                                //                           '${orders['status']}'),
                                //                       Text('$TAS9'),
                                //                     ],
                                //                   ),
                                //                   const SizedBox(
                                //                     height: 13,
                                //                   )
                                //                 ],
                                //               ),
                                //             );
                                //           } else {
                                //             return Container();
                                //           }
                                //         }
                                //       }),
                                // ),
                                GestureDetector(
                                  onTap: () {},
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AllOrders(
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'View All',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 10,
                                          color: Colors.red,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
