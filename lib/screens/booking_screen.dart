import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instacar3/services/car_owner_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

double height = 0;
double width = 0;


class CarBooking extends StatelessWidget {
GetCarOwnerValues value;
CarBooking(this.value);
List seats=["4","5","7","8"];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 500) / 2;
    final double itemWidth = (size.width) / 2;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(resizeToAvoidBottomInset: false,backgroundColor: Colors.transparent,
        body: Stack(
      children: [
        Container(decoration: const BoxDecoration(color: Color(0xff4376fb),

          borderRadius: BorderRadius.only(
            topRight: Radius.circular(35),
            topLeft: Radius.circular(35),
          ),
        ),),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  topLeft: Radius.circular(35),
                ),
              ),
              height: height * 0.8,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 20.0, bottom: 8),
                    child: Text(
                      "car specs",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 8),
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      CarSpecBox("car milage", value.milage, "km/l"),
                      CarSpecBox("km reading", value.kmreading, "km"),
                      CarSpecBox("no of seats", seats[int.parse(value.seatno)], "seats"),
                      CarSpecBox("car milage", value.milage, "L/100km")
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 22.0,
                      left: 20.0,
                    ),
                    child: Text(
                      "location info",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  ContainerBox(
                      value.district, value.city, Icons.location_on_sharp, 1),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 17.0,
                      left: 20.0,
                    ),
                    child: Text(
                      "payment method",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  ContainerBox(
                      "ernakulam", "piravom", FontAwesomeIcons.moneyBills, 0),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            width: 0.8,
                            color: Colors.white,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 5.0,
                                left: 0.0,
                              ),
                              child: Text(
                                "in-app payment coming soon..",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                    fontSize: 15),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.ccMastercard,
                                  color: Colors.red.shade400,
                                ),
                                SizedBox(width: 4),
                                FaIcon(
                                  FontAwesomeIcons.stripe,
                                  color: Color(0xff4576fd),
                                ),
                                SizedBox(width: 4),
                                FaIcon(
                                  FontAwesomeIcons.ccVisa,
                                  color: Colors.blue.shade900,
                                ),
                                SizedBox(width: 4),
                                FaIcon(
                                  FontAwesomeIcons.amazonPay,
                                  color: Color(0xffec9122),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text(
                              "total:",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                  fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              "rs${value.price}",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                     Request(value.uid)
                    ],
                  )
                ],
              ),
            )),
        Positioned(
            right: 14,
            top:2,
            child: Image.network(
              value.imageurl,
              width: 300,
            ))
      ,Positioned(left:28,
        top:22,
        child: Text(
            value.modelname,
            style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 20),
          ),
      ),],
    ));
  }
}

class CarSpecBox extends StatelessWidget {
  final String specName;
  final String specValue;
  final String specUnit;

  CarSpecBox(this.specName, this.specValue, this.specUnit);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          left: 18,
          top: 12,
        ),
        height: (height * 0.1) + 6,
        width: (width * 0.2) + 11,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            width: 0.8,
            color: Colors.grey.shade600,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 6, bottom: 5),
              child: Text(specName,
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                      fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 2,
              ),
              child: Text(specValue,
                  style: const TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 0.0),
              child: Text(specUnit,
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                      fontSize: 12)),
            )
          ],
        ));
  }
}

class ContainerBox extends StatelessWidget {
  String district;
  String city;
  IconData icon;
  int data;

  ContainerBox(this.district, this.city, this.icon, this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 18,
        top: 22,
      ),
      height: (height * 0.1) - 7,
      width: width * 0.9-10,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          width: 0.8,
          color: Colors.grey.shade600,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.only(
            left: 18,
          ),
          child: FaIcon(
            icon,
            color: Color(0xff4576fd),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              data == 1
                  ? "the car is situated at district $district, \ncity $city"
                  : "available payment method is cash \n on delivery",
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  fontSize: 14)),
        ),
      ]),
    );
  }
}






class Request  extends StatefulWidget {

  final String uid;
  Request(this.uid);
  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  final firestoreInstance = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseController = TextEditingController();
  final dobController= TextEditingController();
  final user = FirebaseAuth.instance.currentUser;


    void showmessage(String message,String hint)
    {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(message),
          content:  Text(hint,style:TextStyle(color:Colors.grey),),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );


    }

  String? get _licenseError{
    // at any time, we can get the text from _controller.value.text
    final licenseNo = licenseController.value.text;

    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (licenseNo.isEmpty) {
      return 'can\'t be empty';
    }
    else if((RegExp(r'^[0-9a-zA-Z]+$').hasMatch(licenseNo))==false)
      {
        return "use of wrong characters";
      }
    else if(licenseNo.length<10)
    {
      return "too short";
    }

    if (licenseNo.length > 15) {
      return 'too long';
    }

    // return null if the text is valid
    return null;
  }


  String? get _dobError{
    // at any time, we can get the text from _controller.value.text
    final dob = dobController.value.text;

    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (dob.isEmpty) {
      return 'can\'t be empty';
    }
    else if((RegExp(r'^[0-9 ]+$').hasMatch(dob))==false)
    {
      return "use of wrong characters";
    }
    else if(dob.length<10)
    {
      return "too short";
    }

    if (dob.length > 10) {
      return 'too long';
    }

    // return null if the text is valid
    return null;
  }




  String? get _nameErrorText {
    // at any time, we can get the text from _controller.value.text
    final name = nameController.value.text;

    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (name.isEmpty) {
      return 'can\'t be empty';
    }

    else if((RegExp(r'^[a-zA-Z ]+$').hasMatch(name))==false)
    {
      return "cant have numbers";
    }

    if (name.length > 15) {
      return 'too long';
    }

    // return null if the text is valid
    return null;
  }



  String? get _phoneErrorText {
    // at any time, we can get the text from _controller.value.text

    final phone=phoneController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (phone.isEmpty) {
      return 'can\'t be empty';
    }

    else if(double.tryParse(phone) == null)
    {
      return "cant have alphabets";
    }


    if (phone.length > 10) {
      return 'too long';
    }


    return null;
  }

  void onTap()
  {


    showDialog(barrierDismissible:false ,
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                //this right here
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(color: Colors.black, )),
                    height: 700.0,
                    width: 500.0,
                    child: Column(

                      children: <Widget>[

                        Align(alignment:Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left:16.0,top:30),
                            child: Text("enter credentials",style:TextStyle(color: Colors.black,fontSize: 30,fontFamily: 'Roboto')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            onChanged: (_) =>
                                setState(() {

                                }),
                            controller: nameController,
                            decoration: InputDecoration(
                              errorText: _nameErrorText,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0),
                              prefixIcon: const Icon(
                                Icons.person,
                              ),
                              focusColor: Colors.black26,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "name",
                              hintText: "name",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            onChanged: (_) =>
                                setState(() {

                                }),
                            controller: phoneController,
                            decoration: InputDecoration(
                              errorText: _phoneErrorText,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0),
                              prefixIcon: const Icon(
                                Icons.phone,
                              ),
                              focusColor: Colors.black26,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "phone number",
                              hintText: "phone number",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            onChanged: (_) =>
                                setState(() {

                                }),
                            controller: licenseController,
                            decoration: InputDecoration(
                              errorText: _licenseError,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0),
                              prefixIcon: const Icon(
                                Icons.credit_card,
                              ),
                              focusColor: Colors.black26,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "license",
                              hintText: "license",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            onChanged: (_) =>
                                setState(() {

                                }),
                            controller:dobController,
                            decoration: InputDecoration(
                              errorText: _dobError,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0),
                              prefixIcon: const Icon(
                                Icons.date_range,
                              ),
                              focusColor: Colors.black26,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "DOB",
                              hintText: "DOB",
                            ),
                          ),
                        ),



                        const Padding(
                            padding: EdgeInsets.only(top: 30.0)),
                        TextButton(
                           onPressed:
                             (_phoneErrorText==null && _nameErrorText==null && _licenseError==null && _dobError==null)?
                             (){

                             print("12345678");
                             print(widget.uid);
                             print(user);
                             if(widget.uid!=null  && user!=null)
                               {   Navigator.pop(context);
                                 print("called updating");
                               firestoreInstance.collection("users").doc(user!.uid).set(
                                   { "type":"user",
                                     "name" : nameController.text,
                                     "phone" : phoneController.text,
                                     "selected":"0",
                                     "dob":dobController.text,
                                     "license":licenseController.text
                                   }).then((_){
                                 // const snackBar = SnackBar(
                                 //   content: Text('sucessfully added user'),
                                 // );
                                 // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                               });
                                 firestoreInstance
                                     .collection("users")
                                     .doc(widget.uid)
                                     .update({"requests": FieldValue.arrayUnion([user!.uid]),}).then((_) {
                                   // const snackBar = SnackBar(
                                   //   content: Text('sucessfully added request'),
                                   // );
                                   // ScaffoldMessenger.of(context).showSnackBar(snackBar);


                                   showmessage("Sucess", "user created and request added sucessfully");
                                 });
                               }

                             }
                             :null,


                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  border: Border.all(color: Colors.blueAccent, width: 3)),
                                height: 40,
                                width: 100,
                                child: Center(
                                  child: const Text(
                                    'enter',
                                    style: TextStyle(color: Colors.blueAccent,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
  @override
  Widget build(BuildContext context) {
    return  Container(child: TextButton(
      onPressed: (){

      print("called!");



      final uid;
      if (user != null) {
        uid = user!.uid;

        firestoreInstance.collection("users").doc(uid).get().then((value){
          if(value.data()==null)
            {
              onTap();
            }
          else if(value.data()!=null)
            {

         if(value.data()!['type']=="carowner"){

           showmessage("car owners cant request job/car booking", "try again after deleting enlisted car after your use");
              }
              else if(value.data()!['selected']!="0")
                {
                  showmessage("yor are currently using a car ", "try again after you have terminated booked car/taken job");

                }

            else{
                firestoreInstance
                    .collection("users")
                    .doc(widget.uid)
                    .update({"requests": FieldValue.arrayUnion([user!.uid]),}).then((_) {
                  print("success! added to array 2");
                  const snackBar = SnackBar(
                    content: Text('sucessfully added request'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {

                  });
                });
              }





            }
        });






      }








    },
      child: Center(
        child: Text(  "request",
            style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 19)),
      ),
    ),
        margin: EdgeInsets.only(right: 15.0),
        height: 48,
        width: 110,
        decoration: BoxDecoration(
            color: Color(0xff4576fd),
            borderRadius: BorderRadius.circular(10)));
  }
}



