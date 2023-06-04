import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vriddhi_0/global_listeners/user_data.dart';
class UpdateProfilePhoto{

  static Future<void> setProfilePhoto(File imageFile,BuildContext context) async {

      // Read the image file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Encode the image bytes as base64 string
      String base64Image = base64Encode(imageBytes);

      // Update the user's profile image in Firestore
      User user = FirebaseAuth.instance.currentUser!;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profileImage': base64Image,
        });
        Provider.of<UserData>(context, listen: false).setPhotoUrl(base64Image);
      }
    }
}