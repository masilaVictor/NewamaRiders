import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newamariders/auth/login.dart';
import 'package:newamariders/general/allorders.dart';
import 'package:newamariders/general/orderview.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Assignments');
  final User? user = FirebaseAuth.instance.currentUser;
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
    var store;
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
                height: 262,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Welcome,  ',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Text(user!.email as String, style: TextStyle(color: Colors.white, fontSize: 16),),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 119, 194, 255),
                          ),
                          onPressed: (){
                            FirebaseAuth.instance.signOut();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          }, child: Text('Exit'))
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
                            color: Color.fromARGB(169, 183, 253, 214)
                          ),
                          child: SizedBox(
                            width: 116,
                            height: 66,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AllOrders(selectedDate: TAS4, end: TAS5)));
                                
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.store,color: Colors.white),
                                  Text('All Orders', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                                  Text('Total: 30', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),)
                                ],
                              ),
                            ),

                          ),
                        ),
                         Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(199, 96, 85, 247)
                          ),
                          child: SizedBox(
                            width: 116,
                            height: 66,
              
                            child: GestureDetector(
                              onTap: (){
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.motorcycle_outlined,color: Colors.white),
                                  Text('Delivered Orders', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                                  Text('Total: 28', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),)
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
                            color: Color.fromARGB(169, 250, 231, 57)
                          ),
                          child: SizedBox(
                            width: 116,
                            height: 66,
                            child: GestureDetector(
                              onTap: (){
                                
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.arrow_back_sharp,color: Colors.white),
                                  Text('Returned Orders', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                                  Text('Total: 0', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),)
                                ],
                              ),
                            ),

                          ),
                        ),
                         Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(197, 253, 57, 57)
                          ),
                          child: SizedBox(
                            width: 116,
                            height: 66,
              
                            child: GestureDetector(
                              onTap: (){
                                
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.backspace_sharp,color: Colors.white),
                                  Text('Cancelled Orders', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                                  Text('Total: 2', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),)
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
                  Text('Activity Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('New Orders - $TAS2', style: TextStyle(color:const Color.fromARGB(255, 39, 36, 36),fontSize: 16, fontWeight: FontWeight.w500),),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(50, 64, 195, 255),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order No.', style: TextStyle(fontWeight: FontWeight.w500),),
                                    Text('Store', style: TextStyle(fontWeight: FontWeight.w500),),
                                    
                                    Text('Status',style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('Assigned Time',style: TextStyle(fontWeight: FontWeight.w500))

                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                
                                  Expanded(
                                      
                                    child: FirebaseAnimatedList(
                                         query: dbRef.orderByChild('RiderMail').equalTo(user!.email),
                                                        itemBuilder: (BuildContext context, DataSnapshot snapshot,
                                                          Animation<double> animation, int index) {
                                                          Map orders = snapshot.value as Map;
                                                          orders['key'] = snapshot.key;
                                    
                                                          // var dt3 = DateTime.fromMillisecondsSinceEpoch(
                                                          // orders['postTime'].millisecondsSinceEpoch);
                                                          // var TAS3 = DateFormat('dd/MM/yyyy').format(dt3);
                                    
                                                          
                                                          if(orders['outlet'] == 'Naivas Mountain Mall'){
                                                            store = 'Mountain Mall';
                                                          }
                                                          
                                                          else if(orders['outlet'] == 'Naivas Gateway Mall'){
                                                            store = 'Gateway Mall';
                                                          }
                                                          else{
                                                            store = 'Not Set';
                                                          }

                                                      
                                                          if(orders['Time'] == null){
                                                              return Container();
                                                                  }
                                                          else{
                                                            var dt3 = DateTime.fromMillisecondsSinceEpoch(
                                                              int.parse(orders['Time']));
                                                          var TAS3 = DateFormat('dd/MM/yyyy').format(dt3);
                                                          var TAS9 = DateFormat('hh:mm a').format(dt3);
                                                          if (TAS3.compareTo(TAS2) == 0){
                                                            return GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orderno: snapshot.key as String, outlet: store, status: orders['status'])));
                                                                
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text('${snapshot.key}'),
                                                                      Text(store),
                                                                      Text('${orders['status']}'),
                                                                      Text('$TAS9'),
                                                                      
                                    
                                                                    ],
                                                                  ),
                                                                  
                                                                  const SizedBox(
                                                                    height: 13,
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                          else{
                                                            return Container();
                                                          }
                                                          }
                                                            }
                                                                                   
                                                                    ),
                                    ),
                                    GestureDetector(
                                      onTap: (){},
                                      child: GestureDetector(
                                        onTap: (){
                                         
                                        },
                                        child: Row(
                                          children: [
                                            Text('View All', style: TextStyle(color: Colors.red),),
                                            Icon(Icons.arrow_forward_ios, size: 10,color: Colors.red,)
                                      
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