
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool flag=false;
  List<bool> obText = [true, true];

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
      return LoginPage();
    }
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 50, top: 40.0),
          child: Text("Register in to get started",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color(0xff717171),
                  fontSize: 17.0)),
        ),
        Container(
          margin: EdgeInsets.only(left: 48.0, top: 20.0, bottom: 15.0),
          child: Text(
            "Experience the all new App!",
            style: TextStyle(
                fontWeight: FontWeight.w200,
                color: Color(0xff717171),
                fontSize: 16.0),
          ),
        ),
        rowConstructor("Name", Icons.person_outline, Icons.light, _user, -1),
        rowConstructor(
            "Email-Id", Icons.email_outlined, Icons.light, _email, -1),
        rowConstructor("Mobile Number", Icons.phone, Icons.light, _phone, -1),
        rowConstructor("Password", Icons.lock_rounded,
            Icons.visibility_outlined, _password, 0),
        rowConstructor("Confirm password", Icons.lock_rounded,
            Icons.visibility_outlined, _confirmPassword, 1),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
          child: TextButton(
            onPressed: _emailRegister,
            child: Container(

              height: 50.0,
              decoration: BoxDecoration(
                  color: Color(0xfff3aa4e),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Center(
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Already have an account?",
            style: TextStyle(color: Color(0xff717171), fontSize: 13.0),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  flag=!flag;
                });
              },
              child: Text(
                "LOGIN",
                style: TextStyle(color: Colors.black, fontSize: 13.0),
              )),
        ]),
      ],
    );
  }
  Future<void> _emailRegister() async{
    if(_password.text==_confirmPassword.text){
      try {
        await auth.createUserWithEmailAndPassword(
            email: _email.text,
            password: _password.text
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code),backgroundColor: Colors.blueAccent,));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code),backgroundColor: Colors.blueAccent,));
        }else if(e.code=='network-request-failed') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("check your internet connection"),backgroundColor: Colors.blueAccent,));
        }else{
          // print(e.code);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("check your email address"),backgroundColor: Colors.blueAccent,));
        }
      } catch (e) {
        print(e);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password does not match"),backgroundColor: Colors.blueAccent,));
    }
  }

}