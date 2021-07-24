import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'registerPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'resultPage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   int i=0;
   int count=0;

   String text="About Page";

  Widget bodyConstructor(){
    if (i==1){
      text="Result page";
      print("1");
      return ResultPage(key: Key(count.toString()),);
    }

    text ="About page";
    return AboutDialog(
      applicationIcon: FlutterLogo(),
      applicationName: "A.B.D.C : Automatic BrainTumor Detection using ConvNets",
      applicationVersion: "1.0.0",
      children: [
        Row(
            children:[
              Expanded(
                child: Text("Developed by"),
              ),
            ]
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    auth
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        setState(() {
          // auth.currentUser=null;
        });
      } else {
        setState(() {
          // i=0;
        });
      }
    });
    if (auth.currentUser==null){
      return MaterialApp(
          theme: ThemeData.light().copyWith(
            // backgroundColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
          ),
          home: SafeArea(
            child:  Scaffold(
              body: Container(
                margin: EdgeInsets.only(top:30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(10.0)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white,
                  //     /// changes position of shadow
                  //   ),
                  // ],
                ),
                child: RegisterPage(),
              ),
            ),
          )
      );
    }
    return MaterialApp(
        theme: ThemeData.light().copyWith(
          // backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SafeArea(
          child:  Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Color(0xFFF6BA67),
              // unselectedItemColor: Colors.grey,
              currentIndex: i,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.info),label: "About",backgroundColor: Color(0xFFF6BA67)),
                BottomNavigationBarItem(icon: Icon(Icons.add_a_photo),label: "Upload new image",backgroundColor: Color(0xFFF6BA67)),
                BottomNavigationBarItem(icon: Icon(Icons.logout_rounded),label: "Log out",backgroundColor: Color(0xFFF6BA67)),
              ],
              onTap: (index){
                setState(() {
                  i=index;
                  if(index==1){
                    count+=1;
                  }
                  if(index==2){
                    auth.signOut();
                  }
                });
              },
            ),
            body: bodyConstructor(),
            appBar: AppBar(
              title: Text(text,style: TextStyle(
                color: Colors.white,
              ),),
              backgroundColor: Color(0xfff3aa4e),
            ),
          ),
        )
    );
  }
}


