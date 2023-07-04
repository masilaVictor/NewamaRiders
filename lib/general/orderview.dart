import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
class OrderView extends StatefulWidget {
  String orderno;
  String outlet;
  String status;
  OrderView({super.key, required this.orderno, required this.outlet, required this.status});

  @override
  State<OrderView> createState() => _OrderViewState( orderno, outlet, status);
}

class _OrderViewState extends State<OrderView> {
  String orderno;
  String outlet;
  String status;
  _OrderViewState(this.orderno, this.outlet, this.status);
  final dataseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    Query dbRef1 = FirebaseDatabase.instance
        .ref()
        .child('Orders/${orderno}/customerDetails');
    Query dbRef2 =
        FirebaseDatabase.instance.ref().child('Orders/${orderno}/items');
    Query dbRef3 =
        FirebaseDatabase.instance.ref().child('Orders/${orderno}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 63, 114),
          title: Text('Order No $orderno', style: TextStyle(color: Colors.white),),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                  Image.asset('assets/images/cart.png'),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(197, 245, 16, 0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Column(
                        children: [
                          Expanded(
                            child: FirebaseAnimatedList(query: dbRef1, 
                            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation,
                            int index){
                              Map orders = snapshot.value as Map;
                              orders['key'] = snapshot.key;
                              return Column(
                                
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Status - ${status}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                                      Text('|'),
                                      Text('Store - ${outlet}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),    

                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Customer: ${orders['Customer']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                                      Text('Contacts: ${orders['Contacts']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),

                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Area: ${orders['Area']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                                      Text('Landmark: ${orders['Landmark']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),

                                    ],
                                  ),
                                     
                                ],
                              );

                              

                              
                              
                            }),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Text('Order Details', style: TextStyle(color: Colors.white,fontSize: 19, fontWeight: FontWeight.w500),),

                          Expanded(
                            child: FirebaseAnimatedList(query: dbRef2, 
                            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation,
                            int index){
                              Map order = snapshot.value as Map;
                              order['key'] = snapshot.key;
                              return Column(
                                
                                children: [
                                 
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Order Description: ${order['Item']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                                      Text('Amount: Ksh.${order['Price']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),

                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Quantity: ${order['Quantity']}', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                                     
                                    ],
                                  ),

                                  
                                     
                                ],
                              );
                              
                            }),
                          ),
                          
                          
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: (){
                  if(status == 'Dispatched'){

                  }
                  else{
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text('Status Alert!'),
                        content: Text('Order not dispatched. Contact Dispatch.'),
                        actions: [
                          ElevatedButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text('Back'))
                        ],
                      );
                    });
                  }
                }, 
                child: Text('Proceed to Delivery'))
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}