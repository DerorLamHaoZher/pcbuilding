import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'viewsavedpcdetail.dart'; // Import the detail page
// Import for min function
// Import for date formatting

class ViewSavedPCPage extends StatelessWidget {
  const ViewSavedPCPage({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's UID

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.10), // Adjust padding as needed
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF08FFA2),
              Color(0xFF08BAFF), // Light green color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60.0), // Space above the custom app bar
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Builds',
                    style: TextStyle(
                      color: Color(0xFF010B73),
                      fontSize: 30.0, // Adjust title font size
                      fontFamily: 'bombardment',
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0), // Space between app bar and content

            // Remaining UI components
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('No saved builds found.'));
                  }

                  List<dynamic> savedBuilds = snapshot.data!['savedBuilds'] ?? [];

                  // Filter out builds without a valid createdAt timestamp
                  savedBuilds = savedBuilds.where((build) => build['createdAt'] != null).toList();

                  // Sort builds by createdAt timestamp (ascending order)
                  savedBuilds.sort((a, b) {
                    // Replace the dash with a space for parsing
                    String dateA = a['createdAt'].replaceAll(' – ', ' ');
                    String dateB = b['createdAt'].replaceAll(' – ', ' ');

                    return DateTime.parse(dateB).compareTo(DateTime.parse(dateA)); // Sort ascending
                  });

                  return ListView.builder(
                    itemCount: savedBuilds.length,
                    itemBuilder: (context, index) {
                      final build = savedBuilds[index];
                      final totalPrice = _calculateTotalPrice(build['parts']);

                      // Read createdAt as a string
                      String createdAtString = build['createdAt']; // Directly use the string

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            build['name'],
                            style: const TextStyle(fontFamily: 'nasalization', fontSize: 17),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns the subtitle to the start
                            children: [
                              const SizedBox(height: 8.0), // Add gap between title and subtitle
                              Text(
                                'Total Price: RM${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontFamily: 'nasalization', fontSize: 12),
                              ),
                              Text(
                                'Created At: $createdAtString',
                                style: const TextStyle(fontFamily: 'nasalization', fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to the detail page with the selected build
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewSavedPCDetailPage(savedBuild: build),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Show confirmation dialog before deleting
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Delete Build',
                                      style: TextStyle(fontFamily: 'Nasalization'),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete the build "${build['name']}"?',
                                      style: const TextStyle(fontFamily: 'Nasalization'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontFamily: 'Nasalization',
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(fontFamily: 'Nasalization'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
