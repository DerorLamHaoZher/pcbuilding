import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PC Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyBuildPCPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyBuildPCPage extends StatefulWidget {
  const MyBuildPCPage({super.key, required this.title});

  final String title;

  @override
  State<MyBuildPCPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyBuildPCPage> {
  // List to store PC parts fetched from scraper
  List<Map<String, String>> pcParts = [];

  // Fetch PC parts from the scraper API
  Future<void> fetchPCParts() async {
    try {
      // Update the URL to match your Flask API
      final response = await http.get(Uri.parse('http://192.168.0.196:5000/scrape'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          pcParts = data.map((part) {
            return {
              'name': part['product_name']?.toString() ?? 'Unknown Product',
              'price': part['price']?.toString() ?? 'Price not available',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load PC parts');
      }
    } catch (e) {
      print('Error fetching PC parts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPCParts(); // Fetch the data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF08FFA2),
              Color(0xFF08BAFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            // Custom AppBar
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
                    'PC BMA',
                    style: TextStyle(
                      color: Color(0xFF010B73),
                      fontSize: 30.0,
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
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // First Section: Upper Left (Image)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/your_image.png'), // Replace with your image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),

                // Second Section: Upper Right (TextButton)
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Button 1'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Button 2'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),

            // Third Section: Center Middle (Empty for future use)
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.transparent,
                child: const Center(
                  child: Text('Center Section (Future Use)'),
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // Fourth Section: Scrollable List of PC Parts
            Expanded(
              flex: 4,
              child: pcParts.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
                  : SingleChildScrollView(
                child: Column(
                  children: pcParts.map((part) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Part Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(part['name'] ?? 'Unknown Part', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10.0),

                          // Part Price
                          Row(
                            children: [
                              Text('Price: \$${part['price'] ?? 'N/A'}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
