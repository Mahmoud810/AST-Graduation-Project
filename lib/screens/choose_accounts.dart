import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/screens/sign_in.dart';

class ChooseAccounts extends StatelessWidget {
  const ChooseAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: Column(
    children: [
      SizedBox(height: 200,),
      Image.asset("assets/img.png" , width: 400, height: 250,),
      SizedBox(height: 10,),
      Text("No more skipping your meds", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
      Text("Get notified whenever you need to take your medsine.", style: TextStyle()),
      SizedBox(height: 100,),
      ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                               context,
                             MaterialPageRoute(
                               builder: (context) => SignIn()));
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign me up!",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Text("I already have an account",style: TextStyle(fontWeight: FontWeight.bold),)
      

    ],
   ),
    );
  }
}