import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/core/core/utils/extensions/app_common.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          
            //height: 300,
            color: AppColors.appColor,
          ),

          Positioned.fill(
            top: 180,
            child: Container(
          
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                     const TextField(
                      decoration: InputDecoration(
                        labelText: "Email address",
                        hintText: "Enter your email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                   
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: Icon(Icons.visibility_off_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forget password?",
                          style: TextStyle(color:AppColors.appColor),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (v) {}),
                         Text("Remember me"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

 const SizedBox(height: 25),

     
                    const Row(
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Or Login with"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 20),

               
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/facebook.png'),
                        const SizedBox(width: 20),
                     Image.asset('assets/goggle.png'),
                        const SizedBox(width: 20),
                       Image.asset('assets/apple.png'),
                      ],
                    ),
                    SizedBox(height: 10,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Don't have account? "),
                        Text(
                          "Sign Up",  //عايزه اعملها زرار
                          style: TextStyle(
                            color: AppColors.appColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Sign in to Your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
                    
         
      
    
      
       }
}
      
      
      
      
      
      
      
      