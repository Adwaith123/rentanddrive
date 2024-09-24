import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'register_screen.dart';
import 'enlist_car_screen.dart';
import 'package:instacar3/test_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instacar3/services/car_owner_values.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instacar3/screens/booking_screen.dart';
import 'requests_screen.dart';
import 'status.dart';
import 'package:instacar3/screens/search_screen.dart';
enum _SelectedTab { home, search, register, notification, status }
double height = 0;
double width = 0;

class ListingScreen extends StatefulWidget {
 final  String uid;
 ListingScreen(this.uid);
  // String uid;
  // ListingScreen(this.uid);

  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var _selectedTab = _SelectedTab.home;

 Future  retrieve() async  {
   QuerySnapshot snapshot=await firestoreInstance.collection("users").get();
   return snapshot;
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      if (_selectedTab == _SelectedTab.register) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Test()),
        );
      }
      else if (_selectedTab == _SelectedTab.search) {


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      }

      else if (_selectedTab == _SelectedTab.notification) {


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notifications()),
        );
      }

      else if (_selectedTab == _SelectedTab.status) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Status()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 1;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;
    final double itemHeight = ((size.height - kToolbarHeight - 92) / 2);
    final double itemWidth = ((size.width) / 2);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(borderRadius:15 ,
        dotIndicatorColor: Colors.white,
        marginR: EdgeInsets.only(left: 14, right: 14, bottom: 10),
        paddingR: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),

        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
// dotIndicatorColor: Colors.black,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.purple,
          ),

          /// Likes
          DotNavigationBarItem(
            icon: Icon(Icons.search),
            selectedColor: Colors.pink,
          ),

          /// Search
          DotNavigationBarItem(
            icon: Icon(Icons.app_registration),
            selectedColor: Colors.orange,
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            selectedColor: Colors.teal,
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.person),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      body:

      FutureBuilder<QuerySnapshot>(
        future: firestoreInstance.collection("users").where("type", isEqualTo: "carowner").where("selected", isEqualTo: "0").get(),
        builder: (ctx, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
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
              List<Widget> cars=[];

              print("CALLED HERE");

          snapshot.data!.docs.forEach((result) {

            final data=result.data() as Map<String,dynamic>;
            GetCarOwnerValues carvalue=GetCarOwnerValues.fromJson(data);

            cars.add(CarListingStack(carvalue,widget.uid));

          });
              return Padding(
                padding: const EdgeInsets.only(left:8.0,right:8,top:10),
                child: GridView.count(crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: (itemWidth / itemHeight),
                    crossAxisCount: 2,
                    children:cars),
              );
    }
          }// Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: CircularProgressIndicator(),
          );
        },

        // Future that needs to be resolved
        // inorder to display something on the Canvas

      ),
    );
  }
}


// GridView.count(
// childAspectRatio: (itemWidth / itemHeight),
// crossAxisCount: 2,
// children: [
// CarListingStack(),
// CarListingStack(),
// CarListingStack(),
// CarListingStack(),
// CarListingStack(),
// CarListingStack(),
// CarListingStack(),
// CarListingStack(),
// ])
class CarListingStack extends StatelessWidget {

  GetCarOwnerValues values;
  String id;
  CarListingStack(this.values,this.id);

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
            Container(child: Align(alignment: Alignment.bottomRight,child:Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.grey.shade600, Colors.grey.shade900]),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
               Icons.arrow_forward_ios_rounded,
                size: 40,
                color: Colors.white,
              ),
            )),
              // height: 240,
              // width: 180,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.grey.shade600, Colors.grey.shade900]),
                  borderRadius: BorderRadius.circular(25)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    values.modelname,
                    style:TextStyle(
                        color:values.uid==id?Colors.blueAccent:Colors.white,
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
               , ],
              ),

            ),
            Positioned(
                top: 65,
                child: Image.network(
                  values.imageurl,
                  width: 240,
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(alignment: Alignment.bottomLeft,child: Text(
                values.price,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),),
            )  ],
        ),
      ),
    );
  }
}


