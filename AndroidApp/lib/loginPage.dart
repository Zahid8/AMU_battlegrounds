import 'package:e_commerce_user/registerPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  List<bool> obText = [true, true];
  bool flag =false;

  Container rowConstructor(String a, IconData icon, IconData icon2,
      TextEditingController control, int i) {
    return Container(
      padding: EdgeInsets.only(bottom: 3.0),
      child: Row(
        children: [
          Container(
            child: Tab(
              icon: Icon(
                icon,
                size: 20.0,
                color: Color(0xff8a8a8a),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(left: 10.0, right: 5.0),
              child: TextField(
                controller: control,
                obscureText: icon2 == Icons.light ? false : obText[i],
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: a,
                    hintStyle: TextStyle(
                        color: Color(0xff717171),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w200
                    )),
              ),
            ),
          ),
          icon2 == Icons.light
              ? Text("")
              : IconButton(
            onPressed: () {
//                     print("hello");
              setState(() {
//                       print(obText[i]);
                if (obText[i] == true) {
                  obText[i] = false;
                } else {
                  obText[i] = true;
                }
//                       print(obText);
              });
            },
            icon: Icon(
              obText[i] == true
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 16.0,
              color: Color(0xff8a8a8a),
            ),
          )
        ],
      ),
      margin: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD0C9C9)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flag){
      return RegisterPage();
    }
    return Column(
      children: [
        Flexible(
          child: ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 50, top: 40.0),
              child: Text("Login to get started",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff717171),
                      fontSize: 17.0)),
            ),
            Container(
              margin: EdgeInsets.only(left: 48.0, top: 20.0, bottom: 35.0),
              child: Text(
                "Experience the all new App!",
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Color(0xff717171),
                    fontSize: 16.0),
              ),
            ),
            rowConstructor(
                "Email-Id", Icons.email_outlined, Icons.light, _email, -1),
            rowConstructor("Password", Icons.lock_rounded,
                Icons.visibility_outlined, _password, 0),

              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: 20.0),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      flag=true;
                    });
                },
                  child: Text("Sign up",style: TextStyle(
                    color: Color(0xfff3aa4e),
                  ),),
                ),
              ),
            ]
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xffF3F0F0),
          ),
          child: TextButton(
            onPressed: _emailLogin,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xfff3aa4e),
                  // borderRadius: BorderRadius.circular(15.0)),
            ),
              child: Center(
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
    ]
    );
  }

  Future<void> _emailLogin()async{
    try {
      await auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code),backgroundColor: Colors.blueAccent,));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code),backgroundColor: Colors.blueAccent,));
      }else if(e.code=='network-request-failed') {
        // print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("check your internet connection"),backgroundColor: Colors.blueAccent,));
      }else{
        // print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("check your email address"),backgroundColor: Colors.blueAccent,));
      }
    }
  }
}
