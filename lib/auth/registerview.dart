import 'package:Octua/arm.dart';
import 'package:Octua/auth/loginview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = new GlobalKey<FormState>();

  String _feedback = '';
  bool checkValue = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  signUpEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_statements
      userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: Text(
                'Register',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 46,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Email'),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Email cannot be blank';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Center(
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Password'),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Password cannot be blank';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Container(
                child: new Material(
                  child: new InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await signUpEmail(
                          _emailController.text,
                          _passwordController.text,
                        );
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ArmView()));
                      }
                    },
                    child: new Container(
                      child: Center(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  color: Colors.transparent,
                ),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.deepOrange[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  _feedback,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 15.5),
                ),
              ),
            ),
          ],
        ),floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignInView()));
        },
        backgroundColor: Colors.deepOrange[300],child: Icon(Icons.swap_calls),),);
  }
}
