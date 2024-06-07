import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  Map<String, dynamic>? _userData;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  signInWithGoogle() async{
   try{
     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

     final credential = GoogleAuthProvider.credential(
         accessToken: gAuth.accessToken,
         idToken: gAuth.idToken
     );

     await FirebaseAuth.instance.signInWithCredential(credential);

     var uid =FirebaseAuth.instance.currentUser?.uid;
     var email =FirebaseAuth.instance.currentUser?.email;
     _firestore.collection('users').doc(uid).set({
       'uid' : uid,
       'email': email
     });

     return;

   }catch(e){
     var message = e.toString();
     print("this is the error: $message");
   }
  }
}