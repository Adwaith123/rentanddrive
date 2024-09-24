import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_screen.dart';
import "package:instacar3/services/car_owner_values.dart";
import "package:instacar3/parsing/user_parsing.dart";



enum _CurrentUser{carOwner,User}
class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {

  final user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;



  Future<void> _signOut() async {


    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      RegisterScreen()), (Route<dynamic> route) => false);
    });
  }


  Future<void> _deleteInfo() async {
    if(user!=null)
      {


        firestoreInstance.collection("users").doc(user!.uid).get().then((value){
          if(value.data()==null)
          {
            SnackBar snackBar = SnackBar(
              content: Text("no data to delete"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

          }
          else if(value.data()!=null)
          {

            if(value.data()!['selected']!="0"){
              SnackBar snackBar = SnackBar(
                content: Text("delete any current renting/job and try again"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            }
            else if(value.data()!['selected']=="0")
            {


              firestoreInstance.collection("users").doc(user!.uid).delete().then((_) {
                print("success!");

                SnackBar snackBar = SnackBar(
                  content: Text(" sucessfully deleted"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });

            }

          }
        });

      }

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height;
    return Scaffold(backgroundColor:Colors.grey.shade300,body:
    Column(children: [
      Padding(
        padding: const EdgeInsets.only(left:14.0,right: 0,top:24,bottom:8 ),
        child: Text("status",style: TextStyle(color: Colors.black,fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 30),),
      )
      ,
      FutureBuilder<DocumentSnapshot?>(
        future:firestoreInstance.collection("users").doc(user!.uid).get() ,
        builder: (ctx, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {

            if(snapshot.data!.exists==false)
            {
              print("nuller");
              return Center(
                child: Text(
                  'no status yet 1',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            else if (snapshot.hasData) {


             if(snapshot.data!['selected']=="0")
               {
                 return Center(
                   child: Text(
                     'no status yet 2',
                     style: TextStyle(fontSize: 18),
                   ),
                 );
               }


             else if(snapshot.data!['type']=="user" )
              {
                UserValues values=UserValues.fromJson(snapshot.data!.data() as Map<String,dynamic>);
                return StatusBuilder(type: _CurrentUser.User,uservalues: values,id: values.selected,carValue: null);
                // return  Center(
                //   child: Text(
                //     'accepted',
                //     style: TextStyle(fontSize: 18),
                //   ),
                // );

              }
              else{
               GetCarOwnerValues carvalue=GetCarOwnerValues.fromJson(snapshot.data!.data()  as Map<String,dynamic>);
               return StatusBuilder(type: _CurrentUser.carOwner,carValue: carvalue,id: carvalue.selected,uservalues: null,);



              }

              List<Widget> cars=[];
              //
              // print(snapshot.data!['name']);
              // print("CALLED HERE with widgets");

            }
          }// Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: Text("something went wrong3"),
          );
        },

// Future that needs to be resolved
// inorder to display something on the Canvas

      ),





     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Container(child: TextButton(
           onPressed:(){
             _signOut();

           },child: Row(
             children: [
               Icon(Icons.power_settings_new,color:Colors.red),
               Text("logout"),
             ],
           ))),
     ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(child: TextButton(
            onPressed:(){
              _deleteInfo();

            },child: Row(
          children: [
            Icon(Icons.delete_rounded,color:Colors.grey.shade400),
            Text("delete info"),
          ],
        ))),
      )],
    ));
  }
}




class StatusBuilder extends StatelessWidget {

_CurrentUser type;
String id;
UserValues? uservalues;
GetCarOwnerValues? carValue;






  final user = FirebaseAuth.instance.currentUser;

  final firestoreInstance = FirebaseFirestore.instance;


StatusBuilder({required this.type, required this.id,required this.uservalues,required this.carValue});




  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<DocumentSnapshot?>(
      future:firestoreInstance.collection("users").doc(id).get() ,
      builder: (ctx, snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {

          if(snapshot.data!.exists==false)
          {
            print("nuller");
            return Center(
              child: Text(
                'no status yet4',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          else if (snapshot.hasData) {


            if(type==_CurrentUser.carOwner )
            {


              uservalues=UserValues.fromJson(snapshot.data!.data() as Map<String,dynamic>);
              return  Con(uservalues: uservalues!,carValue: carValue!,user: _CurrentUser.carOwner,);
            }
            else{

              carValue=GetCarOwnerValues.fromJson(snapshot.data!.data() as Map<String,dynamic>);
              return  Con(uservalues: uservalues!,carValue: carValue!,user: _CurrentUser.User,);


            }

          }
        }// Displaying LoadingSpinner to indicate waiting state
        return Center(
          child: Text("something went wrong"),
        );
      },

// Future that needs to be resolved
// inorder to display something on the Canvas

    );
  }
}


class Con extends StatelessWidget {
  UserValues uservalues;
  GetCarOwnerValues carValue;
  _CurrentUser user;
  Con({required this.carValue,required this.uservalues,required this.user});
  final firestoreInstance = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return
      Center(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 11.0, top: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(user==_CurrentUser.carOwner?
                            "car rented to ${uservalues.name}":"car taken from ${carValue.name}",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        ),Text("---------",
                            style: TextStyle(
                                color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: Text(
                            "at 22-03-2022",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,left:10,top:9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user==_CurrentUser.carOwner?
                                "${uservalues.name} contact detail":"${carValue.name} contact detail",

                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.dashed,
                                      fontSize: 15,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800),
                                ),
                                Text(
                                  "the app only connects users with the car owner contact each other to finalise agreement",
                                  softWrap: true,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.dashed,
                                      fontSize: 10,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: Text(
                            "detail",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        )
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,left:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "phone number",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        ),Text("----------",
                            style: TextStyle(
                                color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: Text(
                              user==_CurrentUser.carOwner?
                              "${uservalues.phoneNumber}":"no contact detail",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,left:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "type",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),

                        ),
                        Text("---------------------------",
                            style: TextStyle(
                                color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: Text(
                         carValue.intent=='0'?"rent":"driver",

                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,left:10,right:5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "agreed amount",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),

                        ),
                        Text("-----------------",
                            style: TextStyle(
                                color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: Text(
                            "${carValue.price}/d",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                        )
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0,left:10,right:5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(user==_CurrentUser.carOwner?
                            "delete renting/job":"delete job/ taking car",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 15,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),

                        ),
                        Text("------------",
                            style: TextStyle(
                                color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: TextButton( onPressed: ()
                            {

                               String userUid=carValue.selected;
                               String carOwnerUid=carValue.uid;




                             try{
                               firestoreInstance
                                   .collection("users")
                                   .doc(carOwnerUid)
                                   .update({"selected":"0"}).then((_) {
                                 print("success deleted selected of car owner!");


                                firestoreInstance
                                    .collection("users")
                                    .doc(userUid)
                                    .update({"selected": "0"}).then((_) {
                                  print("success! deleted selected of user");


                                  SnackBar snackBar = SnackBar(
                                    content: Text("successfully deleted"),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }).catchError((e){
                                  print("caught error at  user selected update");
                                  SnackBar snackBar = SnackBar(
                                    content: Text(e==null?"an error occured":e.toString()),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                });



                               }).catchError((e){
                                 print("caught error at owner selected update");
                                 SnackBar snackBar = SnackBar(
                                   content: Text(e==null?"an error occured":e.toString()),
                                 );
                                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                               });
                             }
                             catch(e)
                              {

                                print("cvhgwdfuyedfuy####called exeption");

                                SnackBar snackBar = SnackBar(
                                  content: Text(e==null?"an error occured":e.toString()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              }






                            },
                            child: Text(
                              "delete",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 10.0,left:10,right:5),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 8.0),
                  //         child: Text(
                  //         "delete registered info",
                  //           style: TextStyle(
                  //               decoration: TextDecoration.underline,
                  //               decorationStyle: TextDecorationStyle.dashed,
                  //               fontSize: 15,
                  //               fontFamily: "Roboto",
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.grey.shade800),
                  //         ),
                  //
                  //       ),
                  //       Text("----------------------",
                  //           style: TextStyle(
                  //               color: Colors.grey.shade400)),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 8.0, right: 10),
                  //         child: TextButton( onPressed: ()
                  //         {
                  //
                  //         },
                  //           child: Text(
                  //             "delete",
                  //             style: TextStyle(
                  //                 decoration: TextDecoration.underline,
                  //                 decorationStyle: TextDecorationStyle.dashed,
                  //                 fontSize: 15,
                  //                 fontFamily: "Roboto",
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.red),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ]),
            height: height * 0.50,
            width: width * 0.9),
      );
  }
}








