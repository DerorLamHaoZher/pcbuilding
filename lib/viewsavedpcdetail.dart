import 'package:flutter/material.dart';



class ViewSavedPCDetailPage extends StatelessWidget {
  final Map<String, dynamic> savedBuild;

  const ViewSavedPCDetailPage({super.key, required this.savedBuild});

  @override
  Widget build(BuildContext context) {
    final parts = savedBuild['parts'] as Map<String, dynamic>?;

    print('Parts data: $parts');

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
                    'Saved Build Details',
                    style: TextStyle(
                      color: Color(0xFF010B73),
                      fontSize: 21.0,
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

            // Edit Build Button
            

            // Body content
            parts != null && parts.isNotEmpty
                ? Expanded(
                    child: ListView(
                      children: parts.entries.map((entry) {
                        final partDetails = entry.value;

                        if (partDetails['product_name'] != null && partDetails['product_name'].isNotEmpty) {
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                partDetails['product_name'],
                                style: const TextStyle(
                                  fontFamily: 'nasalization',
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Category: ${partDetails['category'] ?? 'Unknown Category'}',
                                    style: const TextStyle(
                                      fontFamily: 'nasalization',
                                    ),
                                  ),
                                  Text(
                                    'Price: RM${double.tryParse(partDetails['price'] ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(
                                      fontFamily: 'nasalization',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }).toList(),
                    ),
                  )
                : const Center(child: Text('No parts available for this build.')),
          ],
        ),
      ),
    );
  }
}
