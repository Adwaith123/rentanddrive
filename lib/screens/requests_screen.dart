import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // @override
  // void initState() {
  //   super.initState();
  // check();
  // }

  // void check() async{
  //   final data= await firestoreInstance.collection("users2").doc(user!.uid).get();
  //   if(data.data()==null)
  //   {
  //     flag=1;
  //   }
  //   else{
  //     flag=0;
  //   }
  //
  // }

  final user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  int flag = 0;

  // void getData() async {
  //
  //   firestoreInstance
  //       .collection("users")
  //       .doc(snapshot.data!['requests'][index])
  //       .get(),
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: firestoreInstance.collection("users").doc(user!.uid).get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data==null){

              return Center(
                child: Text(
                  'no requests yet',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
    if (snapshot.data!.exists == false) {
              print("nuller1");
              return Center(
                child: Text(
                  'no requests yet',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {

      print("has data wsa called");
              if (snapshot.data!['type'] == "user" ) {
                print("is a user");
               if( snapshot.data!['selected']!="0")
                 {
                   return Center(
                     child: Text(
                       'a request was accepted by an user check status',
                       style: TextStyle(fontSize: 18),
                     ),
                   );
                 }
               else
                 {
                   return Center(
                     child: Text(
                       "no requests yet 2",
                       style: TextStyle(fontSize: 18),
                     ),
                   );
                 }

              }
              else {
                  print("called here ");
                if (snapshot.data!['requests'].length == 0) {
                  return Center(
                    child: Text(
                      'no requests yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else  {
                  print("called list view");
                  print(snapshot.data!['requests']);
                  print(snapshot.data!['requests'][0][0]+"121");
                  return ListView.builder(
                      itemCount: snapshot.data!['requests'].length,
                      itemBuilder: (BuildContext context, int index) {
                        print("list view called " + index.toString());
                        String tempUser=snapshot.data!['requests'][index];
                        String newUser=tempUser.replaceAll(' ', '');
                        print(tempUser);
                        print(newUser);

                        // print(snapshot.data!['requests']);
                        print(snapshot.data!['requests'].length);
                        return FutureBuilder<DocumentSnapshot>(
                            future: firestoreInstance
                                .collection("users")
                                .doc(newUser)
                                .get(),
                            builder: (context, snapshot) {

                            if(snapshot.connectionState==ConnectionState.done)
                              {
                                if(snapshot.data==null)
                                {
                                  Center(
                                    child: Text(
                                      'no requests yet 1',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );

                                }
                                else if (snapshot.data!.exists == false) {
                                  print("nuller2");
                                  return Center(
                                    child: Text(
                                      'no requests yet 2',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                }
                               else if (snapshot.hasData) {
                                  return Container(
                                   margin:EdgeInsets.all(5),

                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [Colors.blue.shade400, Colors.blue.shade900]),
                                        borderRadius: BorderRadius.circular(10)),


                                    child: ListTile(subtitle: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                            snapshot.data!['phone'],
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 15)),
                                        Text("license no :${snapshot.data!['license']}"
                                            ,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 15)),

                                        Text("DOB :${snapshot.data!['dob']}"
                                            ,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 15)),
                                      ],
                                    ),
                                      trailing: Container(height:40,width:80,decoration: BoxDecoration(color: Colors.blueAccent,borderRadius:BorderRadius.circular(3)),

                                        child: TextButton(
                                          onPressed: () async {
                                            await firestoreInstance
                                                .collection("users")
                                                .doc(user!.uid)
                                                .update({"selected": newUser,"requests":[]}).then((_) {
                                              print("sucess added to owner");
                                              setState(() {

                                              });
                                            });


                                            await firestoreInstance
                                                .collection("users")
                                                .doc(newUser)
                                                .update({"selected":user!.uid}).then((_) {
                                              print("sucess added to user as well");

                                            });


                                          },
                                          child: Text("accept",
                                              style:
                                              TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                      leading: Icon(Icons.person),
                                      title: Text(
                                        snapshot.data!['name'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      "something went wrong while fetching this data",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 15),
                                    ),
                                  );
                                }
                              }

                              return Center(
                                child: Text(
                                  'no requests yet 3',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );

                            });
                      });
                }
              }

              List<Widget> cars = [];
              //
              // print(snapshot.data!['name']);
              // print("CALLED HERE with widgets");

            }
          } // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: Text("looking"),
          );
        },

// Future that needs to be resolved
// inorder to display something on the Canvas
      ),
    );
  }
}

//
// FutureBuilder<DocumentSnapshot?>(
// future: firestoreInstance
//     .collection("users")
// .doc(snapshot.data!['requests'][index])
// .get(),
// builder: (ctx, snapshot) {
// print("snapshot called");
//
// if (snapshot.connectionState == ConnectionState.done) {
//
// print("connection state called called");
// if(snapshot.data!.exists==false)
// {
// print("nuller");
// return Center(
// child: Text(
// 'no requests yet',
// style: TextStyle(fontSize: 18),
// ),
// );
// }
//
// else if(snapshot.hasData)
// {
// return ListTile(
// leading: Icon(Icons.person),
// title: Text(snapshot.data!['name'],
// style: TextStyle(
// color: Colors.green,fontSize: 15),),
// );
// }
//
// return
// ListTile(
// leading: Icon(Icons.cancel_outlined,color: Colors.red,),
// title: Text("something went wrong while fetching this data",
// style: TextStyle(
// color: Colors.green,fontSize: 15),),
// );
//
//
//
// }
// return
// ListTile(
// leading: Icon(Icons.cancel_outlined,color: Colors.red,),
// title: Text("something went wrong while fetching this data",
// style: TextStyle(
// color: Colors.green,fontSize: 15),),
// );
// }
//
//
//
// );
