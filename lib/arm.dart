import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArmView extends StatefulWidget {
  @override
  _ArmViewState createState() => _ArmViewState();
}

class _ArmViewState extends State<ArmView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          SizedBox(height: 10,),
          Center(
            child: Text("Octua",
                style: TextStyle(
                  color: Colors.black,fontSize: 50,fontWeight: FontWeight.w300
                )),
          ),
          GestureDetector(
            onTap: (){

            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[100]
              ),
              child: Center(
                child: Text("Arm",
                  style: TextStyle(
                    color: Colors.white,fontSize: 50,fontWeight: FontWeight.w300
                  )),
              ),
              height: MediaQuery.of(context).size.width*0.45,
              width: MediaQuery.of(context).size.width*0.45,
            ),
          ),
          GestureDetector(
            onTap: (){
              
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrangeAccent[100]
              ),
              child: Center(
                child: Text("Alert",
                  style: TextStyle(
                    color: Colors.white,fontSize: 50,fontWeight: FontWeight.w300
                  )),
              ),
              height: MediaQuery.of(context).size.width*0.45,
              width: MediaQuery.of(context).size.width*0.45,
            ),
          ),
          GestureDetector(
            onTap: (){
              
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink[100]
              ),
              child: Center(
                child: Text("Log",
                  style: TextStyle(
                    color: Colors.white,fontSize: 50,fontWeight: FontWeight.w300
                  )),
              ),
              height: MediaQuery.of(context).size.width*0.45,
              width: MediaQuery.of(context).size.width*0.45,
            ),
          )
        ],
      ),
    );
  }
}
