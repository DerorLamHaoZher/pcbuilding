import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'viewsavedpcdetail.dart'; // Import the detail page

class ViewSavedPCPage extends StatelessWidget {
  const ViewSavedPCPage({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's UID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved PC Builds'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No saved builds found.'));
          }

          List<dynamic> savedBuilds = snapshot.data!['savedBuilds'] ?? [];
          return ListView.builder(
            itemCount: savedBuilds.length,
            itemBuilder: (context, index) {
              final build = savedBuilds[index];
              final totalPrice = _calculateTotalPrice(build['parts']);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(build['name']),
                  subtitle: Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                  onTap: () {
                    // Navigate to the detail page with the selected build
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewSavedPCDetailPage(savedBuild: build),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  double _calculateTotalPrice(Map<String, dynamic> parts) {
    double total = 0.0;

    // Iterate through each part in the parts map
    parts.forEach((key, value) {
      // Check if the value is a map and contains a 'price' field
      if (value is Map<String, dynamic> && value.containsKey('price')) {
        var priceValue = value['price'];
        // Check if the price is a string and convert it to double
        if (priceValue is String) {
          total += double.tryParse(priceValue) ?? 0.0; // Convert string to double
        } else if (priceValue is double) {
          total += priceValue; // Add directly if it's already a double
        }
      }
    });

    return total;
  }
}
