import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class GoogleAuthServices{
  final BuildContext context;

  GoogleAuthServices(this.context);
  Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    print("Checking user phone number ${ await getPhoneNumberFromEmail(authResult.user!.email)}");
    final isUserRegistered = await isUserRegisteredInFirestore(authResult as User);
    if (isUserRegistered) {
        // User is registered, allow them to sign in
        
      } else {
        
        addNewUserDocument(authResult);
        // User is not registered, you can handle this case (e.g., show an error message)
        print("User is not registered");
        // You can also sign the user out if they are not registered
        // await FirebaseAuth.instance.signOut();
      }
    return user;
    
  } catch (error) {
    print("Google Sign-In Error: $error");
    return null;
  }
  
}

Future<bool> isUserRegisteredInFirestore(User user) async {
    final userCollection = FirebaseFirestore.instance.collection("Users");
    final userDoc = await userCollection.doc(user.uid).get();

    return userDoc.exists;
  }
}

Future<String?> getPhoneNumberFromEmail(String? email) async {
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final querySnapshot = await userCollection.where('email', isEqualTo: email).get();

  if (querySnapshot.docs.isNotEmpty) {
    final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
    final phoneNumber = userData['usernumber'] as String?;
    return phoneNumber;
  }

  return null; // User not found or phone number is not available.
}


Future<void> addNewUserDocument(UserCredential? userCredential) async {
  // print(userCredential!.user!.email);
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userCredential.user!.displayName,
      });
    }
  }


