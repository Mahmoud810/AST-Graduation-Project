import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/screens/choose_accounts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: AppColors.appColor, // لون أخضر فاتح زي التصميم
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                  ),
                ),
              ),
            ),

            // اللوجو والنصوص
            Column(
              children: [
              /*  Image.asset(
                  img, 
                  height: 100,
                ),*/
                const SizedBox(height: 20),
                const Text(
                  "Olivia Pharmacy",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:AppColors.appColor, //  
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "The best way to quickly way order\nmedicine anywhere",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

         
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                               context,
                             MaterialPageRoute(
                               builder: (context) => ChooseAccounts ()));
                    // هنا تحطي التنقل لصفحة تانية
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
