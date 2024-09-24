import "package:flutter/material.dart";
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

 int color=0;
  final  _auth =FirebaseAuth.instance;
  bool isSigningin=false;
  late String eMail;
  late String password;
  bool animationOff=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset:false,
        body: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width:double.infinity),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Image.asset(
                "images/logo1.png",
                width: 250,
              ),
            ),
            Center(
                child: Material(
                  elevation: 15,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    height: 365,
                    width: 305,
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: animationOff==false?Container(margin:EdgeInsets.only(top:10,left:10,),
                                height:30,width:70,
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700
                                    ,
                                  ),
                                  child: AnimatedTextKit(pause: const Duration(milliseconds: 5),isRepeatingAnimation: false,
                                    onFinished: (){
                                      setState(() {
                                        animationOff=true;
                                      });

                                    },
                                    animatedTexts: [
                                      ScaleAnimatedText('sign up'),
                                      ScaleAnimatedText('an'),
                                      ScaleAnimatedText('app'),
                                      ScaleAnimatedText('build'),
                                      ScaleAnimatedText('to'),
                                      ScaleAnimatedText('deliver'),
                                    ],
                                    onTap: () {
                                      print("Tap Event");
                                    },
                                  ),
                                ),
                              ):
                              Padding(
                                padding: const EdgeInsets.only(top:10.0,left:14),
                                child: Text(
                                  "sign up.",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0,right: 14.0),
                              child:
                              Container(height:34,width: 60,color: color==0?Colors.grey:Colors.blueAccent,
                              child: TextButton(onPressed: (){
                                isSigningin=isSigningin==true?false:true;
                                color=color==0?1:0;
                                setState(() {

                                });
                              },child: Text("log in",style: TextStyle(color:Colors.white),),),),
                            ), ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
                          child: TextField( onChanged: (value) {

                            eMail=value;
                          },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                              focusColor: Colors.black26,
                              border: OutlineInputBorder(),
                              labelText: 'User Name',
                              hintText: 'Enter Your Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                          child: TextField(   onChanged: (value) {
                            //Do something with the user input.
                            password=value;
                          },
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.key,
                              ),
                              focusColor: Colors.black26,
                              border: OutlineInputBorder(),
                              labelText: 'password',
                              hintText: 'Enter Your password',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:30.0),
                          child: Container(child: TextButton(onPressed:
                              () async {
                         if(isSigningin==false)
                           {
                             try{

                               final _newUser= await _auth.createUserWithEmailAndPassword(email: eMail, password: password);
                               if(_newUser!=null)
                               {
                                 final  user =_auth.currentUser;

                                 if(user!=null)
                                 {
                                   final uid = user.uid;
                                   print(uid);
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => ListingScreen(uid)),
                                   );
                                 }
                               }
                             }
                             catch(e)
                             {  print("the error is");
                               print(e);
                              SnackBar snackBar = SnackBar(
                                 content: Text(e==null?"an error occured":e.toString()),
                               );
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                             }
                           }
                          else{

                           try{

                             final _newUser= await _auth.signInWithEmailAndPassword(email: eMail, password: password);
                             if(_newUser!=null)
                             {
                               final  user =_auth.currentUser;

                               if(user!=null)
                               {
                                 final uid = user.uid;
                                 print(uid);
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => ListingScreen(uid)),
                                 );
                               }
                             }
                           }
                           catch(e)
                           {
                             print("the error is");
                             print(e);
                             SnackBar snackBar = SnackBar(
                               content: Text(e==null?"an error occured":e.toString()),
                             );
                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                           }
                         }


                          },
                            child: Center(child: Text("get started",
                              style: TextStyle(color: Colors.white,
                                  fontSize: 15, fontWeight: FontWeight.bold),)),
                          ),
                            width: 260,
                            height: 43,
                            decoration: BoxDecoration(  boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.shade100,
                                blurRadius: 7.0,
                                spreadRadius: 1.0,
                                offset: Offset(1.0, 1.0), // shadow direction: bottom right
                              )
                            ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:15.0,left:41),
                          child: Row(
                            children: [
                              Text("already have an account?"),

                              TextButton(style:TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,),onPressed: (){}, child: Text("log in"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Column(children: [Text("also find us on ",style:TextStyle(color: Colors.grey.shade900)),
                SizedBox(height:8),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialmediaBox("facebook.png"),SizedBox(width:8),
                      SocialmediaBox("google1.png"),SizedBox(width:8),
                      SocialmediaBox("twitter.png"),
                    ],
                  ),
                ) , ],),
            ) ],
        ));
  }
}


class SocialmediaBox extends StatelessWidget {
  String logo;
  SocialmediaBox(this.logo);

  @override
  Widget build(BuildContext context) {
    return Container(height:39,width:65,decoration: BoxDecoration( border: Border.all(
      color: Colors.grey.shade300,
      width: 2.5,
    ),borderRadius:BorderRadius.circular(11.0)),child: Image.asset("images/$logo") ,);
  }
}

