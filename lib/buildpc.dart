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
      home: const MyBuildPCPage(title: 'PC Part Selector'),
    );
  }
}

class MyBuildPCPage extends StatefulWidget {
  const MyBuildPCPage({super.key, required this.title});

  final String title;

  @override
  State<MyBuildPCPage> createState() => _MyBuildPCPageState();
}

class _MyBuildPCPageState extends State<MyBuildPCPage> {
  List<Map<String, String>> pcParts = [];
  Map<String, String> selectedCPU = {};
  Map<String, String> selectedMotherboard = {};
  Map<String, String> selectedRAM = {};
  Map<String, String> selectedGPU = {};
  Map<String, String> selectedROM = {};
  Map<String, String> selectedPSU = {};
  Map<String, String> selectedCase = {};
  Map<String, String> selectedCaseFan = {};
  Map<String, String> selectedCooler = {};

  bool isLoading = false;
  Map<String, String> searchQueries = {
    'CPU': '',
    'Motherboard': '',
    'RAM': '',
    'GPU': '',
    'ROM': '',
    'PSU': '',
    'Case': '',
    'Case Fan': '',
    'CPU Cooler': '',
  };

  TextEditingController searchController = TextEditingController();

  // Fetch PC parts from the scraper API
  Future<void> fetchPCParts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://192.168.0.196:5000/scrape'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          pcParts = data.map((part) {
            return {
              'name': part['product_name']?.toString() ?? 'Unknown Product',
              'price': part['price']?.toString() ?? 'Price not available',
              'description': 'Sample description for ${part['product_name'] ?? "this product"}',
              'image': part['image']?.toString() ?? 'assets/sample_image.png',
              'category': part['category']?.toString() ?? 'Unknown',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load PC parts');
      }
    } catch (e) {
      print('Error fetching PC parts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter parts by category and search query
  List<Map<String, String>> filterParts(String category, String searchQuery) {
    return pcParts.where((part) {
      return (part['category']?.toLowerCase() == category.toLowerCase()) &&
          (part['name']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  // Searchable Dropdown Widget with Quantity Selector
  Widget buildSelector(
      String label,
      String category,
      Map<String, String> selectedPart,
      Function(Map<String, String>) onSelected,
      ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Label
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: 'Nasalization',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),

          // Searchable Dropdown
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search $label',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                searchQueries[category] = query;
              });
            },
          ),
          const SizedBox(height: 10.0),

          // Dropdown List (filtered)
          DropdownButton<String>(
            isExpanded: true,
            hint: Text('Select $label'),
            value: selectedPart.isEmpty ? null : selectedPart['name'],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedPart['name'] = newValue;
                  selectedPart['category'] = category;
                  // Update other part details as needed (price, description, etc.)
                });
              }
            },
            items: filterParts(category, searchQueries[category]!).map<DropdownMenuItem<String>>((part) {
              return DropdownMenuItem<String>(
                value: part['name'],
                child: Text(part['name']!),
              );
            }).toList(),
          ),
          const SizedBox(height: 10.0),

          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity:',
                style: TextStyle(
                  fontFamily: 'Nasalization',
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    // Update quantity logic here
                  });
                },
              ),
              Text(
                '1', // This can be dynamic based on selected quantity
                style: const TextStyle(fontSize: 16.0),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    // Update quantity logic here
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPCParts(); // Fetch the data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10.10),
            decoration: const BoxDecoration(
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

                // PC Part Selectors
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildSelector('CPU', 'CPU', selectedCPU, (value) => selectedCPU = value),
                        buildSelector('Motherboard', 'Motherboard', selectedMotherboard, (value) => selectedMotherboard = value),
                        buildSelector('RAM', 'RAM', selectedRAM, (value) => selectedRAM = value),
                        buildSelector('GPU', 'GPU', selectedGPU, (value) => selectedGPU = value),
                        buildSelector('ROM', 'ROM', selectedROM, (value) => selectedROM = value),
                        buildSelector('PSU', 'PSU', selectedPSU, (value) => selectedPSU = value),
                        buildSelector('Case', 'Case', selectedCase, (value) => selectedCase = value),
                        buildSelector('Case Fan', 'Case Fan', selectedCaseFan, (value) => selectedCaseFan = value),
                        buildSelector('CPU Cooler', 'CPU Cooler', selectedCooler, (value) => selectedCooler = value),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading screen
          if (isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Fetching data...',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
