import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instacar3/services/car_owner_values.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instacar3/screens/booking_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String city="ernakulam";

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (text.isEmpty) {
      return 'can\'t be empty';
    } else if ((RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(text)) == false) {
      return "cant have special characters";
    } else if ((RegExp(r'^[a-zA-Z ]+$').hasMatch(text)) == false) {
      return "cant have numbers";
    }

    if (text.length > 15) {
      return 'too long';
    }

    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 92) / 2;
    final double itemWidth = (size.width) / 2;
    return Scaffold(resizeToAvoidBottomInset:false,
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10,
            top: 35,
            bottom: 10,
          ),
          child: TextField(
            onSubmitted: (_) {
              if (_errorText == null) {
                city=_controller.text;
                print(city);
                setState(() {

                });
              } else {
                const snackBar = SnackBar(
                  content: Text('something wrong with entered data '),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              prefixIcon: const Icon(
                Icons.search,
              ),
              focusColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: "city",
              hintText: "search by city name",
            ),
          ),
        ),
        Container(width:double.infinity,height:size.height*0.5,
          child: FutureBuilder<QuerySnapshot>(
            future: firestoreInstance
                .collection("users")
                .where("city", isEqualTo: city)
                .where("selected", isEqualTo: "0")
                .get(),
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
               print("called");
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occured',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  List<Widget> cars = [];

                  print("CALLED HERE");

                  snapshot.data!.docs.forEach((result) {
                    final data = result.data() as Map<String, dynamic>;
                    GetCarOwnerValues carvalue = GetCarOwnerValues.fromJson(data);

                    cars.add(CarListingStack(carvalue));
                  });
                  return GridView.count(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount: 2,
                      children: cars);
                }
              } // Displaying LoadingSpinner to indicate waiting state
              return Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
          ),
        ),
      ],
    ));
  }
}



class CarListingStack extends StatelessWidget {

  GetCarOwnerValues values;
  CarListingStack(this.values);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),onPressed: (){
        showMaterialModalBottomSheet(backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Container(height:height*0.9,
              child: CarBooking(values),),
          ),
        );
      },
        child: Stack(
          children: [
            Container(
              height: 240,
              width: 180,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.red.shade400, Colors.red.shade900]),
                  borderRadius: BorderRadius.circular(25)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    values.modelname,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    values.city,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    values.intent == "0" ? Icons.car_rental : Icons.work,
                    size: 23,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Positioned(
                top: 65,
                child: Image.network(
                  values.imageurl,
                  width: 240,
                ))
          ],
        ),
      ),
    );
  }
}

