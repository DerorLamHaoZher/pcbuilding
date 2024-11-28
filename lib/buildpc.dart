import 'package:flutter/material.dart';
import 'services/api_service.dart';

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
  Map<String, String> selectedOthers = {};

  bool isLoading = false;
  Map<String, TextEditingController> searchControllers = {};
  Map<String, bool> isDropdownOpen = {};
  Map<String, List<Map<String, String>>> filteredResults = {};
  Map<String, int> quantities = {};
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    
    for (var category in ['CPU', 'Motherboard', 'RAM', 'GPU', 'ROM', 'PSU', 'Case', 'Case Fan', 'CPU Cooler', 'Others']) {
      searchControllers[category] = TextEditingController();
      isDropdownOpen[category] = false;
      filteredResults[category] = [];
      quantities[category] = 1;
    }

    _loadPcParts();
  }

  Future<void> _loadPcParts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final parts = await ApiService.fetchPcParts();
      setState(() {
        pcParts = parts.map((part) => part.map(
          (key, value) => MapEntry(key, value.toString()),
        )).toList();
        isLoading = false;
      });
    } catch (e) {
      ('Error loading PC parts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshPcParts() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      final result = await ApiService.refreshPcParts();
      
      if (result['status'] == 'success') {
        // After successful refresh, reload the parts
        await _loadPcParts();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Successfully refreshed PC parts data'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(result['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Error in _refreshPcParts: $e'); // Debug logging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing data: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  List<Map<String, String>> filterParts(String category, String searchQuery) {
    if (searchQuery.isEmpty) {
      return pcParts.where((part) {
        final partCategory = part['category']?.toLowerCase() ?? '';
        return partCategory == category.toLowerCase();
      }).toList();
    }
    
    return pcParts.where((part) {
      final partCategory = part['category']?.toLowerCase() ?? '';
      final partName = (part['product_name'] ?? '').toLowerCase();
      
      return partCategory == category.toLowerCase() && 
             partName.contains(searchQuery.toLowerCase());
    }).toList();
  }

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
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: 'Nasalization',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchControllers[category],
                    decoration: InputDecoration(
                      hintText: 'Search $label',
                      hintStyle: const TextStyle(
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onTap: () {
                      setState(() {
                        isDropdownOpen[category] = true;
                        filteredResults[category] = filterParts(category, searchControllers[category]!.text);
                      });
                    },
                    onChanged: (query) async {
                      setState(() {
                        isDropdownOpen[category] = true;
                      });
                      
                      if (query.length >= 2) { // Only search if query is at least 2 characters
                        try {
                          final results = await ApiService.fetchPcParts(
                            category: category,
                            searchQuery: query,
                          );
                          
                          setState(() {
                            filteredResults[category] = results.map((part) => 
                              part.map((key, value) => MapEntry(key, value.toString()))
                            ).toList();
                          });
                        } catch (e) {
                          ('Error searching parts: $e');
                          // Fallback to local filtering if API call fails
                          setState(() {
                            filteredResults[category] = filterParts(category, query);
                          });
                        }
                      } else {
                        // Use local filtering for short queries
                        setState(() {
                          filteredResults[category] = filterParts(category, query);
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(isDropdownOpen[category]! ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      isDropdownOpen[category] = !isDropdownOpen[category]!;
                      if (isDropdownOpen[category]!) {
                        filteredResults[category] = filterParts(category, searchControllers[category]!.text);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          if (isDropdownOpen[category]!)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.only(top: 4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: filteredResults[category]!.isEmpty
                  ? const ListTile(
                      title: Text('No items found'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredResults[category]!.length,
                      itemBuilder: (context, index) {
                        final part = filteredResults[category]![index];
                        return ListTile(
                          title: Text(part['product_name'] ?? ''),
                          subtitle: Text('RM${part['price'] ?? ''}'),
                          onTap: () {
                            setState(() {
                              onSelected(part);
                              searchControllers[category]!.text = part['product_name'] ?? '';
                              isDropdownOpen[category] = false;
                            });
                          },
                        );
                      },
                    ),
            ),

          if (selectedPart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Selected: ${selectedPart['name']} - ${selectedPart['price']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

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
                    if (quantities[category]! > 1) {
                      quantities[category] = quantities[category]! - 1;
                    }
                  });
                },
              ),
              Text(
                '${quantities[category]}',
                style: const TextStyle(fontSize: 16.0),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantities[category] = quantities[category]! + 1;
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
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: isRefreshing ? Colors.grey : Colors.blue,
                            ),
                            onPressed: isRefreshing ? null : _refreshPcParts,
                            tooltip: 'Refresh PC Parts Data',
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),

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
                        buildSelector('Others', 'Others', selectedOthers, (value) => selectedOthers = value),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isLoading || isRefreshing)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    isRefreshing ? 'Refreshing... it takes serveral minutes' : 'Loading...',
                    style: const TextStyle(
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

  @override
  void dispose() {
    for (var controller in searchControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}


