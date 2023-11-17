import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newamariders/general/dashboard.dart';
import 'package:newamariders/general/order.dart';
import 'package:newamariders/general/ordersDate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllOrders extends StatefulWidget {

  AllOrders({super.key, this.restorationId});
  final String? restorationId;
 

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> with RestorationMixin{
  Query dbRef = FirebaseDatabase.instance.ref().child('Orders');
  final User? user = FirebaseAuth.instance.currentUser;
  var selectedDate;
  List myAllOrders = [];
  var isLoaded = false;
  var end;
  //late var Thistime;

   String? get restorationId => widget.restorationId;
  // var Thistime =((DateTime.now().millisecondsSinceEpoch));

  late var dt2 = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
  late var TAS2 = DateFormat('dd/MM/yyyy').format(dt2);
  late var dateTimeFormat = DateFormat('dd/MM/yyyy', 'en_US').parse(TAS2);
  late var Thistime = dateTimeFormat.millisecondsSinceEpoch;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
       
      );
    },
  );
  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2023),
          lastDate: DateTime(2030),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
         Thistime = _selectedDate.value.millisecondsSinceEpoch;
         getAllOrders();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }


  @override
  void initState(){
    super.initState();
    getAllOrders();
  }

  getAllOrders() async{

    final response = await http.get(Uri.parse("http://api.newamadelivery.co.ke/riderPendingOrders.php?rider=%27${user!.email as String}%27&fromTime=${Thistime.toString()}"));
    setState(() {
      myAllOrders = json.decode(response.body);
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
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
              OutlinedButton(
                        onPressed: () {
                          _restorableDatePickerRouteFuture.present();
                        },
                        child: const Text('Select Day To View',style: TextStyle(color: Colors.black),),
                      ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text(
              //       'Date: $end - $selectedDate',
              //       style: TextStyle(fontSize: 17),
              //     ),
              //     ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //             primary: const Color.fromARGB(255, 0, 63, 114)),
              //         onPressed: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => const OrdersDate()));
              //         },
              //         child: Text('Change Date'))
              //   ],
              // ),
              Visibility(
                visible: isLoaded,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: myAllOrders?.length,
                  itemBuilder: (context, index){
                    var dt3 = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(myAllOrders![index]['assignTime']));
                      var TAS3 = DateFormat('dd/MM/yyyy').format(dt3);
                    return Container(
                          margin: const EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: myAllOrders![index]['status'] == 'Pending'
                                  ? Color.fromARGB(255, 255, 17, 0)
                                  : myAllOrders![index]['status'] == 'Processing'
                                      ? Colors.blue
                                      : myAllOrders![index]['status'] == 'Transit'
                                          ? const Color.fromARGB(
                                              255, 102, 92, 0)
                                          : myAllOrders![index]['status'] == 'Delivered'
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
                                              orderno: myAllOrders![index]['orderID'],
                                              outlet: myAllOrders![index]['outlet'],
                                              status: myAllOrders![index]['status'])));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order No. ${myAllOrders![index]['orderID']}',
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('outlet:${myAllOrders![index]['outlet']}',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                    Text('Status:${myAllOrders![index]['status']}',
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
              // SizedBox(
              //   height: 500,
              //   child: FirebaseAnimatedList(
              //       query: dbRef.orderByChild('RiderMail').equalTo(user!.email),
              //       itemBuilder: (BuildContext context, DataSnapshot snapshot,
              //           Animation<double> animation, int index) {
              //         Map order = snapshot.value as Map;
              //         order['key'] = snapshot.key;
              //         //var getTime = order['postTime']

              //         var dt3 = DateTime.fromMillisecondsSinceEpoch(
              //             int.parse(order['AssignedTime']));
              //         var TAS3 = DateFormat('dd/MM/yyyy').format(dt3);

              //         if (TAS3.compareTo(selectedDate) == 0) {
              //           //allOrders.add(index);

              //           return Container(
              //             margin: const EdgeInsets.all(10),
              //             padding: EdgeInsets.all(15),
              //             decoration: BoxDecoration(
              //                 color: order['status'] == 'Pending'
              //                     ? Color.fromARGB(255, 255, 17, 0)
              //                     : order['status'] == 'Processing'
              //                         ? Colors.blue
              //                         : order['status'] == 'Transit'
              //                             ? const Color.fromARGB(
              //                                 255, 102, 92, 0)
              //                             : order['status'] == 'Delivered'
              //                                 ? Colors.green
              //                                 : Color.fromARGB(80, 126, 1, 42),
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: Row(
              //               children: [
              //                 GestureDetector(
              //                   onTap: () {
              //                     Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                             builder: (context) => Order(
              //                                 orderno: snapshot.key as String,
              //                                 outlet: order['outlet'],
              //                                 status: order['status'])));
              //                   },
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         'Order No. ${snapshot.key}',
              //                         style: const TextStyle(
              //                             fontSize: 18, color: Colors.white),
              //                       ),
              //                       const SizedBox(
              //                         height: 10,
              //                       ),
              //                       Text('outlet:${order['outlet']}',
              //                           style: const TextStyle(
              //                               fontSize: 15, color: Colors.white)),
              //                       Text('Status:${order['status']}',
              //                           style: const TextStyle(
              //                               fontSize: 15, color: Colors.white)),
              //                       const SizedBox(
              //                         height: 10,
              //                       ),
              //                       Text(
              //                         'Date: $TAS3',
              //                         style: TextStyle(
              //                             color: Colors.white, fontSize: 15),
              //                       )
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             ),
              //           );
              //         } else {
              //           return Container();
              //         }
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
