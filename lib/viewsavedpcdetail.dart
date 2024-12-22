import 'package:flutter/material.dart';



class ViewSavedPCDetailPage extends StatelessWidget {
  final Map<String, dynamic> savedBuild;

  const ViewSavedPCDetailPage({super.key, required this.savedBuild});

  @override
  Widget build(BuildContext context) {
    final parts = savedBuild['parts'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(savedBuild['name'] ?? 'Saved Build'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: parts != null && parts.isNotEmpty
          ? ListView(
              children: parts.entries.map((entry) {
                final partDetails = entry.value;

                if (partDetails['product_name'] != null && partDetails['product_name'].isNotEmpty) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(partDetails['product_name']),
                      subtitle: Text(
                        'Category: ${partDetails['category'] ?? 'Unknown Category'}\n'
                        'Price: \$${double.tryParse(partDetails['price'] ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }).toList(),
            )
          : const Center(child: Text('No parts available for this build.')),
    );
  }
}
