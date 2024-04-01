import 'package:flutter/material.dart';

import '../../modals/add_restaurant.dart';

class UploadDetails extends StatefulWidget {
  const UploadDetails({super.key});

  @override
  State<UploadDetails> createState() => _UploadDetailsState();
}

class _UploadDetailsState extends State<UploadDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPLOAD DETAILS'),
      ),
      body: Center(
        child: Text('Press the Floating Action Button to add a restaurant'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRestaurantModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddRestaurantModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddRestaurantModal();
      },
    );
  }
}
