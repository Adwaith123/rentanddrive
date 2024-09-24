import 'package:flutter/material.dart';
import 'package:number_selection/number_selection.dart';
import 'package:instacar3/services/image_uploader.dart';
import "dart:io";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
String name = "name";
String district = "district";
String city = "city";
String noOfSeats = "0";
String intent="0";
String milage="1";
String kmReading="km reading";
String price="price";
String fuelType="0";
String modelName="model name";
List <String> requests=[];
String  selected  = "0";
String phoneNumber="phone number";



double height = 0;
double width = 0;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


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



  void _create() async {
    try {
      print("create called");
      final user = FirebaseAuth.instance.currentUser;
      final uid;
      if (user != null) {
        uid = user.uid;
        if (imageAvailable == true) {
          print("image available part called");
      await image.uploadmage(_image,uid).catchError((error){
            const snackBar =SnackBar(
            content: Text('something wrong with your uploading image'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);});
          print("called after image ");

          FirebaseStorage storage = FirebaseStorage.instance;
          String url =await storage.ref(uid).getDownloadURL().catchError((error){
            const snackBar =SnackBar(
              content: Text('something wrong with  getting  image url'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);});
          print("@#@%%#@%%@#@#+$url");

          if(url!=null){
            await firestore.collection('users').doc(uid).set({
              'phone':phoneNumber,
              'date': DateTime.now(),
              'type':"carowner",
              'uid':uid,
              'firstname': name,
              'district': district,
              'city': city,
              "seatno":selectedfield.toString(),
              "fueltype":fuelType,
              "intent":intent,
              "milage":milage,
              "kmreading":kmReading,
              "price":price,
              "imageurl":url,
              "requests":requests,
              "selected":selected,
              "modelname":modelName

            }).then((value){

              const snackBar =SnackBar(
                content: Text('registered successfully'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            }).catchError((error){
              const snackBar =SnackBar(
                content: Text('something went wrong uploading data'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);});
          }

        } else {
          print("image not selected");
        }
      } else {
        print("uid=null");
      }
    } catch (e) {
      print(e);
    }
  }

  bool imageAvailable=false;
  GetImage image = GetImage();
  File? _image;
  int selectedfield=1;

  List seatFieldNo = [1, 0, 0, 0];
  final nameController = TextEditingController();
  final placeController = TextEditingController();
  final priceController = TextEditingController();


  void onTap(int selectedFieldNo) {
    for (int i = 0; i < seatFieldNo.length; i++) {
      if (i == selectedFieldNo) {
        seatFieldNo[i] = 1;
        selectedfield=i;
      } else
        seatFieldNo[i] = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8,top:2,bottom:2),
                        child: ShowDialog(height*0.1+28, (width*0.5+10),"name","string"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          ShowDialog((height*0.1+28)/2,(width*0.37)+3 ,"district","string"),
                          Container(
                              color: Colors.white, width: 0, height: 5),
                          ShowDialog((height*0.1+28)/2,(width*0.37)+3,"city","string")
                        ]),
                      )
                    ],
                  ),
                  Container(
                    height: height*0.1+18,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SelectSeatnumber("4", onTap, seatFieldNo[0], 0),
                        SelectSeatnumber("5", onTap, seatFieldNo[1], 1),
                        SelectSeatnumber("7", onTap, seatFieldNo[2], 2),
                        SelectSeatnumber("8", onTap, seatFieldNo[3], 3)
                      ],
                    ),
                  ),
                  Row(
                    children: [FuelType(), Intent()],
                  ),
                  Row(
                    children: [
                      Expanded(child: MilageSelector()),
                      Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0,bottom:5),
                                child: ShowDialog(height*0.1-11, width*0.5,"km reading","number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ShowDialog(height*0.1-11, width*0.5,"model name","stringnumber"),
                              ),
                            ],
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                border:
                                Border.all(
                                    color: Colors.blueAccent, width: 3)),
                            height:height*0.18-6,
                            width:width*0.45-10,
                            child: imageAvailable == false
                                ? Image.asset("images/taxi.png"):Image.file(_image!),

                          ),
                          Container(
                              width:width*0.45-10,
                              height: height*0.07-6,
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  border: Border.all(
                                      color: Colors.greenAccent, width: 3)),
                              child: TextButton(onPressed: () async {
                                final img = await GetImage().getImage();
                                if (img != null) {
                                  setState(() {
                                    _image = img;
                                    imageAvailable = true;
                                  });
                                } else {
                                  print("image not available null");
                                }
                              },
                                  child: Text("upload image",
                                      style: TextStyle(
                                          color: Colors.greenAccent))))
                        ],
                      ),
                      Column(children: [Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: ShowDialog(height*0.1-11, width*0.5-10,"price","number"),
                      )
                        ,Padding(
                          padding: const EdgeInsets.only(left: 13.0,top:7),
                          child: ShowDialog(height*0.1-20, width*0.5-10,"phone number","number"),
                        )
                      ,   Container(margin:EdgeInsets.only(left:10,top:8),height:height*0.1-11,width: width*0.5-10,decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10)),
                          child: TextButton(onPressed:(){


                            if(name=="name")
                              {
                                const snackBar = SnackBar(
                                  content: Text('something wrong with your entered name'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                           else if(district=="district")
                            {
                              const snackBar = SnackBar(
                                content: Text('something wrong with your entered district'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(city=="city")
                            {
                              const snackBar = SnackBar(
                                content: Text('something wrong with your entered city'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(kmReading=="km reading")
                            {
                              const snackBar = SnackBar(
                                content: Text('something wrong with your entered km reading'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(price=="price")
                            {
                              const snackBar = SnackBar(
                                content: Text('something wrong with your entered price'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(modelName=="model name")
                            {
                              const snackBar = SnackBar(
                                content: Text('something wrong with your entered car model name'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(phoneNumber=="phone number")
                            {
                              const snackBar = SnackBar(
                                content: Text('something wrong with your entered phone number'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }






                            else{
                              print("$name \t $district \t $city \t $selectedfield \t $intent \t $milage \t $kmReading \t $price \t $fuelType \t $modelName");

                              final firestoreInstance = FirebaseFirestore.instance;
                              final use = FirebaseAuth.instance.currentUser;

                              final uid;
                              if (use!= null) {
                                uid = use.uid;

                                firestoreInstance.collection("users").doc(uid).get().then((value){
                                  if(value.data()==null)
                                  {
                                    _create();
                                  }
                                  else if(value.data()!=null)
                                  {
                                    showmessage("already registered as user/car owner", "you either already have registered a car or is registered as a user delete registered info in status and try agian");

                                  }
                                });



                              }

                            }

                          },child: Text("register",style: TextStyle(color: Colors.white),),),)],),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SelectSeatnumber extends StatelessWidget {
  final int field;
  final int fieldSelected;
  Function onTap;
  final String seatNo;

  SelectSeatnumber(this.seatNo, this.onTap, this.fieldSelected, this.field);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 85,
      width: 85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(color: Colors.blueAccent, width: 3)),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          onTap(field);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.event_seat_outlined,
                size: 40,
                color: fieldSelected == 1 ? Colors.blueAccent : Colors.grey,
              ),
            ),
            Text(
              "seats $seatNo",
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 13,
                  color: fieldSelected == 1 ? Colors.blueAccent : Colors.grey,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class FuelType extends StatefulWidget {
  @override
  State<FuelType> createState() => _FuelTypeState();
}

class _FuelTypeState extends State<FuelType> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(height:height*0.18-6,
      width:width*0.45-6.4,
      margin: EdgeInsets.only(top: 10, left: 11),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(color: Colors.blueAccent, width: 3)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              height: 110,
              // width: 85,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  selected = 0;
                  fuelType="0";
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add_box_rounded,
                        size: 40,
                        color: selected == 0 ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                    Text(
                      "petrol",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 13,
                          color: selected == 0 ? Colors.blueAccent : Colors.grey,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 110,
              // width: 85,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  selected = 1;
                  fuelType="1";
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.indeterminate_check_box_sharp,
                        size: 40,
                        color: selected == 1 ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                    Text(
                      "diesel",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 13,
                          color: selected == 1 ? Colors.blueAccent : Colors.grey,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Intent extends StatefulWidget {
  const Intent({Key? key}) : super(key: key);

  @override
  _IntentState createState() => _IntentState();
}

class _IntentState extends State<Intent> {
  int intentSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:height*0.18-6,
      width:width*0.5,
      margin: EdgeInsets.only(top: 10, left: 11),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(color: Colors.blueAccent, width: 3)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              height: 110,
              // width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  intentSelected = 0;
                  intent="0";
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.car_rental,
                        size: 40,
                        color:
                        intentSelected == 0 ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                    Text(
                      "rent car",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 13,
                          color: intentSelected == 0
                              ? Colors.blueAccent
                              : Colors.grey,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 110,
              // width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  intentSelected = 1;
                  intent="1";
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.work,
                        size: 40,
                        color:
                        intentSelected == 1 ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                    Text(
                      "hire driver",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 13,
                          color: intentSelected == 1
                              ? Colors.blueAccent
                              : Colors.grey,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MilageSelector extends StatelessWidget {
  const MilageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.18-4,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(color: Colors.blueAccent, width: 3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 13.0, top: 10),
            child: Text("milage",
                style: TextStyle(
                  color: Colors.blueAccent,
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 28, right: 10, bottom: 10, top: 4),
            height: 70,
            width: 130,
            child: NumberSelection(
              theme: NumberSelectionTheme(
                  draggableCircleColor: Colors.white,
                  iconsColor: Colors.blueAccent,
                  numberColor: Colors.blueAccent,
                  backgroundColor: Colors.blueAccent,
                  outOfConstraintsColor: Colors.deepOrange),
              initialValue: 1,
              minValue: 1,
              maxValue: 40,
              direction: Axis.horizontal,
              withSpring: true,
              onChanged: (int value) {
                milage="$value";
              } ,
              enableOnOutOfConstraintsAnimation: true,
              onOutOfConstraints: () =>
                  print("This value is too high or too low"),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowDialog extends StatefulWidget {
  // const ShowDialog({Key? key}) : super(key: key);
  // TextEditingController _controller;
final String name;
final String type;
  final double height, width;

  ShowDialog(this.height, this.width,this.name,this.type);

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {




  TextEditingController _controller = TextEditingController();
 String getName()
{
  if(widget.name=="name")
    {return name;}
  else if(widget.name=="district")
    {return district;}
  else if(widget.name=="city")
   { return city;}
  else if(widget.name=="km reading")
    {return kmReading;}
  else if(widget.name=="model name")
  {return modelName;}
  else if(widget.name=="phone number")
  {return phoneNumber;}
  else
   { return price;}


 }




  void setName(String receivedName)
  {
    if(widget.name=="name")
    {name=receivedName;}
    else if(widget.name=="district")
    {district=receivedName;}
    else if(widget.name=="city")
    { city=receivedName;}
    else if(widget.name=="km reading")
    {kmReading=receivedName;}
    else if(widget.name=="model name")
    { modelName=receivedName;}
    else if(widget.name=="phone number")
      {
        phoneNumber=receivedName;
      }
    else
    { price=receivedName;}


  }


  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (text.isEmpty) {
      return 'can\'t be empty';
    }
    if(widget.type=="stringnumber"&& (RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(text))==false)
      {
        return "cant have special characters";
      }


    if(widget.type=="number" && double.tryParse(text) == null)
    {
      return "cant have alphabets";
    }
    else if(widget.type=="string" && (RegExp(r'^[a-zA-Z ]+$').hasMatch(text))==false)
      {
           return "cant have numbers";
      }

    if (text.length > 10) {
      return 'too long';
    }

    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            border: Border.all(color: Colors.blueAccent, width: 3)),
        // margin: EdgeInsets.all(8),
        height: widget.height,
        width: widget.width,
        child: TextButton(
          onPressed: () {
            showDialog(barrierDismissible:false ,
                context: context,
                builder: (BuildContext context) =>
                    StatefulBuilder(builder: (context, StateSetter setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        //this right here
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              border: Border.all(color: Colors.blueAccent, width: 3)),
                          height: 250.0,
                          width: 300.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Align(alignment:Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:16.0,top:5),
                                  child: Text(widget.name,style:TextStyle(color: Colors.blueAccent,fontSize: 30)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextField(
                                  onChanged: (_) =>
                                      setState(() {
                                        print(
                                            _controller.value.text.isNotEmpty);
                                      }),
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    errorText: _errorText,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                    ),
                                    focusColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    labelText: widget.name,
                                    hintText: widget.name,
                                  ),
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(top: 30.0)),
                              TextButton(
                                  onPressed: _errorText == null
                                      ? () {
                                    setName(_controller.value.text);


                                    print("called");

                                    Navigator.of(context).pop();
                                  }
                                      : null,
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
                      );
                    })).then((_) {
              setState(() {});
            });
          },
          child: Text(getName()),
        ));
  }
}

// Padding(
// padding: const EdgeInsets.only(
// top: 12.0, left: 30, right: 30, bottom: 10),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.only(bottom: 7.0, left: 17),
// child: const Text(" name",
// style: TextStyle(fontFamily: "Roboto", fontSize: 18)),
// ),
// TextFormField(
// controller: nameController,
// validator: (value) {
// if (value != null) {
// if (value.isEmpty) {
// return 'Please enter valid phone number';
// }
// }
//
// return null;
// },
// decoration: InputDecoration(
// contentPadding:
// const EdgeInsets.symmetric(vertical: 15.0),
// prefixIcon: const Icon(
// Icons.person,
// ),
// focusColor: Colors.black26,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20.0),
// ),
// labelText: 'User Name',
// hintText: 'Enter Your Name',
// ),
// ),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 12.0, left: 30, right: 30,bottom:15),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.only(bottom: 7.0, left: 17),
// child: Text("phone number",
// style: TextStyle(fontFamily: "Roboto", fontSize: 18)),
// ),
// TextFormField(
// controller: placeController,
// validator: (value) {
// if (value != null) {
// if (value.isEmpty) {
// return 'Please enter valid phone number';
// }
// }
//
// return null;
// },
// decoration: InputDecoration(
// contentPadding:
// const EdgeInsets.symmetric(vertical: 15.0),
// prefixIcon: Icon(
// Icons.person,
// ),
// focusColor: Colors.black26,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(30.0),
// ),
// labelText: 'User Name',
// hintText: 'Enter Your Name',
// ),
// ),
// ],
// ),
// ),
