import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery/models/retauarant.dart';
import 'package:food_delivery/utils/firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddRestaurantModal extends StatefulWidget {
  // final void Function(String, String, String, String) onSave;
  //
  // const AddRestaurantModal({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddRestaurantModalState createState() => _AddRestaurantModalState();
}

class _AddRestaurantModalState extends State<AddRestaurantModal> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _foodTypeController = TextEditingController();
  String _imagePath = '';
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Restaurant Name'),
            ),
            TextField(
              controller: _foodTypeController,
              decoration: InputDecoration(
                labelText: 'Food Type',
                hintText: 'E.g Fast foods',
              ),
            ),

            SizedBox(height: 10.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 10.0),
            SizedBox(height: 10.0),
            _imagePath.isNotEmpty
                ? Image.file(File(_imagePath))
                : Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveRestaurant(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveRestaurant(BuildContext context) async{
    // Get values from text controllers
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String foodType = _foodTypeController.text.trim();

    // Validate input
    if (name.isNotEmpty && address.isNotEmpty && _imagePath.isNotEmpty && phoneNumber.isNotEmpty) {
      // Here you can perform save operation, for example, adding the restaurant to Firestore
      // After saving, you can close the modal

      String imageUrl = await FirebaseService().uploadImage(_imagePath, 'restaurant_images/$name');
      var uuid = Uuid();
      String randomId = uuid.v4(); // Generate a random UUID

      Restaurant restaurant = Restaurant(
        id: randomId,
        name: name,
        address: address,
        image: imageUrl,
        phoneNumber: phoneNumber,
        foodType: foodType
      );

      // Create an instance of FirebaseService
      FirebaseService firebaseService = FirebaseService();

      // Add the restaurant to Firestore
      await firebaseService.addRestaurant(restaurant);

      Navigator.of(context).pop();
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }
}