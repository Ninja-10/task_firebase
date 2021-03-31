
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isVerificationCompleted;

  User getUser() => FirebaseAuth.instance.currentUser;

  bool isSignIn() => FirebaseAuth.instance.currentUser != null;

  bool get isVerificationCompleted => _isVerificationCompleted;

  Future signOut() {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> sendOtp(
      {String phoneNumber,
      Duration timeOut,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout}) {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        timeout: timeOut,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  Future<UserCredential> verifyLogin(String verificationId, String smsCode) {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return FirebaseAuth.instance.signInWithCredential(credential);
  }


  Future<bool> isPhoneNumberExist(String phoneNumber) async {
    var snapshot = await _firestore
        .collection("users")
        .where("phone", isEqualTo: phoneNumber)
        .get();
    return snapshot.docs.length > 0;
  }


}