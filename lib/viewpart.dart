import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'productdetail.dart';

class ViewParts extends StatefulWidget {
  const ViewParts({super.key});

  @override
  State<ViewParts> createState() => _ViewPartsState();
}

class _ViewPartsState extends State<ViewParts> {
  List<Map<String, dynamic>> pcParts = [];
  bool isLoading = false;
  String searchQuery = '';
  String? selectedCategory;
  String sortBy = 'name';
  bool isSortByNameAscending = true;
  bool isSortByPriceAscending = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadPcParts();
    
    // Set default sorting
    sortBy = 'name'; // Default sort by name
    isSortByNameAscending = true; // A to Z
    isSortByPriceAscending = false; // High to low
  }

  Future<void> _loadPcParts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final parts = await ApiService.fetchPcParts();
      setState(() {
        pcParts = parts;

        // Sort the parts initially
        pcParts.sort((a, b) => a['product_name'].compareTo(b['product_name'])); // Sort A to Z
        pcParts.sort((a, b) => a['price'].compareTo(b['price'])); // Sort High to Low

        isLoading = false;
      });

      // Show a message when done scraping
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data scraping completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error loading PC parts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshPcParts() async {
    setState(() {
      isRefreshing = true;
    });

    // Show loading indicator and message
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(), // Loading indicator
              const SizedBox(width: 20), // Space between the indicator and text
              const Expanded(
                child: Text('Refreshing... It may take several minutes.'),
              ),
            ],
          ),
        );
      },
    );

    try {
      final result = await ApiService.refreshPcParts(); // Fetch live data

      if (result['status'] == 'success') {
        await _loadPcParts(); // Reload parts after successful refresh
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Successfully refreshed PC parts data'),
            backgroundColor: Colors.green,
          ));
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
      Navigator.of(context).pop(); // Close the loading dialog
      setState(() {
        isRefreshing = false; // Reset refreshing state
      });
    }
  }

  List<Map<String, dynamic>> _filterParts(String query) {
    return pcParts.where((part) {
      final productName = part['product_name'].toString().toLowerCase();
      final matchesSearch = productName.contains(query.toLowerCase());
      final matchesCategory = selectedCategory == null || 
                            part['category'] == selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredParts = _filterParts(searchQuery);

    return Scaffold(
      body: Container(
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
          children: [
            const SizedBox(height: 60.0),
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
                    'PC Parts',
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
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Main Content Area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF08FFA2),
                            Color(0xFF08BAFF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'nasalization',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search parts...',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'nasalization',
                          ),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF08FFA2),
                            Color(0xFF08BAFF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'nasalization',
                            ),
                          ),
                          value: selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                          items: [
                            'All',
                            'CPU',
                            'GPU',
                            'RAM',
                            'Motherboard',
                            'PSU',
                            'Case',
                            'CPU Cooler',
                            'ROM',
                            'Case Fan'
                          ].map((category) {
                            return DropdownMenuItem(
                              value: category == 'All' ? null : category,
                              child: Text(
                                category,
                                style: const TextStyle(
                                  fontFamily: 'nasalization',
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sort Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF08FFA2),
                                  Color(0xFF08BAFF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0.5,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: TextButton.icon(
                              icon: const Icon(Icons.sort_by_alpha, color: Colors.black),
                              label: Text(
                                isSortByNameAscending ? 'Sort by Name A-Z' : 'Sort by Name Z-A',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'nasalization',
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  sortBy = 'name';
                                  isSortByNameAscending = !isSortByNameAscending;
                                  pcParts.sort((a, b) => isSortByNameAscending
                                      ? a['product_name'].compareTo(b['product_name'])
                                      : b['product_name'].compareTo(a['product_name']));
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF08FFA2),
                                  Color(0xFF08BAFF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0.5,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: TextButton.icon(
                              icon: const Icon(Icons.monetization_on, color: Colors.black),
                              label: Text(
                                isSortByPriceAscending ? 'Sort by Price High to Low' : 'Sort by Price Low to High',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'nasalization',
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  sortBy = 'price';
                                  isSortByPriceAscending = !isSortByPriceAscending;
                                  pcParts.sort((a, b) => isSortByPriceAscending
                                      ? a['price'].compareTo(b['price'])
                                      : b['price'].compareTo(a['price']));
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Parts List
                    Expanded(
                      child: isLoading 
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010B73)),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredParts.length,
                            itemBuilder: (context, index) {
                              final part = filteredParts[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF08FFA2),
                                      Color(0xFF08BAFF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 0.5,
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(part['category']),
                                      color: const Color(0xFF010B73),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        part['product_name'] ?? 'Unknown Product',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'nasalization',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            part['category'] ?? 'Uncategorized',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'nasalization',
                                            ),
                                          ),
                                          Text(
                                            'RM${part['price'] ?? 'N/A'}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'nasalization',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _navigateToProductDetail(part);
                                  },
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'cpu':
        return Icons.memory;
      case 'motherboard':
        return Icons.developer_board;
      case 'ram':
        return Icons.storage;
      case 'gpu':
        return Icons.videogame_asset;
      case 'psu':
        return Icons.power;
      case 'case':
        return Icons.computer;
      case 'cpu cooler':
        return Icons.ac_unit;
      case 'rom':
        return Icons.storage;
      case 'case fan':
        return Icons.cyclone;
      default:
        return Icons.devices_other;
    }
  }

  void _navigateToProductDetail(Map<String, dynamic> part) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: part),
      ),
    );
  }
}
