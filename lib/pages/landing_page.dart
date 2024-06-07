import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xoxo/utils/colors.dart';

import '../services/auth_service.dart';
import '../utils/dialog_helper.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1),
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth*0.6,
                height: screenHeight*0.3,
                child: Image.asset("assets/png/LandingImageB.png"),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("We're thrilled to have you join the XoXo community."
                    " Our app is designed to help you and your partner stay connected,"
                    " improve your communication, and deepen your relationship.", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),textAlign: TextAlign.center,),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () async{
                    DialogHelper.showProgressDialog(context, message: ("Just a sec"));
                    await AuthService().signInWithGoogle();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: screenWidth*0.3,
                    height: screenHeight*0.07,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Get started", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
