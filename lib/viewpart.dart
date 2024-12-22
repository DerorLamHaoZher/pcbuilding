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

  @override
  void initState() {
    super.initState();
    _loadPcParts();
  }

  Future<void> _loadPcParts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final parts = await ApiService.fetchPcParts();
      setState(() {
        pcParts = parts;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading PC parts: $e');
      setState(() {
        isLoading = false;
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
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
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
                              label: const Text(
                                'Sort by Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'nasalization',
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  sortBy = 'name';
                                  pcParts.sort((a, b) => 
                                    a['product_name'].compareTo(b['product_name']));
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
                              label: const Text(
                                'Sort by Price',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'nasalization',
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  sortBy = 'price';
                                  pcParts.sort((a, b) => 
                                    a['price'].compareTo(b['price']));
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
                                  title: Text(
                                    part['product_name'] ?? 'Unknown Product',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'nasalization',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    part['category'] ?? 'Uncategorized',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'nasalization',
                                    ),
                                  ),
                                  trailing: Text(
                                    'RM${part['price'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'nasalization',
                                      fontWeight: FontWeight.bold,
                                    ),
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
