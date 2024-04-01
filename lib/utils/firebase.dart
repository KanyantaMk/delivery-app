import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/retauarant.dart';
import '../models/user.dart';
import 'local_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<User?> fetchUserDetails(String userId) async {
    Object? cachedUserDetails = await LocalStorage.getListValue('userDetails');
    if (cachedUserDetails != null) {
      if (cachedUserDetails.runtimeType == String) {
        // Parse the JSON string if it's not already a map
        cachedUserDetails = json.decode(cachedUserDetails as String);
      }
      // Use cachedUserDetails as a Map<String, dynamic> here
      print('Returning user details from cache');
      return User.fromJson(cachedUserDetails as Map<String, dynamic>);
    }

    // Fetch user details from Firebase if not found in cache
    try {
      print('Fetching user details from Firebase for userId: $userId');
      DocumentSnapshot document = await _firestore.collection('users').doc(userId).get();

      if (document.exists) {
        Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
        print('Fetched userData from Firebase: $userData');

        // Update userId in user data
        userData['userId'] = userId;

        // Save user details to local storage
        await LocalStorage.saveListValue('userDetails', userData);

        return User.fromJson(userData);
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      await _firestore.collection('restaurants').doc(restaurant.id).set({
        'name': restaurant.name,
        'address': restaurant.address,
        'image': restaurant.image,
        'phone_number': restaurant.phoneNumber,
        'rating' : '',
        'food_type' : restaurant.foodType
      });
      print('Restaurant added successfully!');
    } catch (e) {
      print('Error adding restaurant: $e');
    }
  }

  Future<String> uploadImage(String imagePath, String fileName) async {
    try {
      Reference reference = _storage.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(File(imagePath));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // Return empty string if there's an error
    }
  }

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('restaurants').get();
      List<Map<String, dynamic>> menuItemsArr = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> restaurantData = doc.data() as Map<String, dynamic>;
        menuItemsArr.add(restaurantData);
      });

      return menuItemsArr;
    } catch (e) {
      print('Error getting restaurant menu items: $e');
      return []; // Return empty list if there's an error
    }
  }
}
