import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import your API service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  static const String lowSpec = 'Low Spec';
  static const String midSpec = 'Med Spec';
  static const String highSpec = 'High Spec';

  // Intel Low Spec
  static const String lowIntelCpuQuery = 'i3';
  static const double lowMaxIntelCpuPrice = 400.0;
  static const String lowIntelMotherboardQuery = 'h510m';
  static const String lowIntelRamQuery = '8gb ddr4';
  static const String lowIntelRomQuery = '256gb ssd';
  static const double lowMaxIntelPsuPrice = 200.0;
  static const double lowMaxIntelGpuPrice = 1500.0;

  // AMD Low Spec
  static const String lowAmdCpuQuery = 'ryzen'; // Below price 700
  static const double lowMaxAmdCpuPrice = 700.0;
  static const String lowAmdMotherboardQuery = 'A520';
  static const String lowAmdRamQuery = '8gb ddr4';
  static const String lowAmdRomQuery = '256gb ssd';
  static const double lowMaxAmdPsuPrice = 200.0;
  static const double lowMaxAmdGpuPrice = 1500.0;

  // Intel Mid Spec
  static const String midIntelCpuQuery = '12400f';
  static const String midIntelMotherboardQuery = 'b760m';
  static const String midIntelRamQuery = '16gb ddr5';
  static const String midIntelRomQuery = '1tb ssd';
  static const double midMinIntelPsuPrice = 200.0;
  static const double midMaxIntelPsuPrice = 460.0;
  static const double midMinIntelGpuPrice = 1000.0;
  static const double midMaxIntelGpuPrice = 2500.0;

  // AMD Mid Spec
  static const String midAmdCpuQuery = 'ryzen'; // Price 500 to 1000
  static const double midMinAmdCpuPrice = 500.0;
  static const double midMaxAmdCpuPrice = 1000.0;
  static const String midAmdMotherboardQuery = 'b550';
  static const String midAmdRamQuery = '16gb ddr4';
  static const String midAmdRomQuery = '1tb';
  static const double midMinAmdPsuPrice = 200.0;
  static const double midMaxAmdPsuPrice = 460.0;
  static const double midMinAmdGpuPrice = 1000.0;
  static const double midMaxAmdGpuPrice = 2500.0;

  // Intel High Spec
  static const String highIntelCpuQuery = '14900k';
  static const String highIntelMotherboardQuery = 'z790';
  static const String highIntelRamQuery = '32gb ddr5';
  static const String highIntelRomQuery = '2tb ssd';
  static const double highMinIntelPsuPrice = 500.0;
  static const double highMaxIntelPsuPrice = 700.0;
  static const double highMinIntelGpuPrice = 2000.0;
  static const double highMaxIntelGpuPrice = 14000.0;

  // AMD High Spec
  static const String highAmdCpuQuery = '5900'; 
  static const String highAmdMotherboardQuery = 'x570'; // If not available, auto select b550
  static const String fallbackAmdMotherboardQuery = 'b550'; // Fallback motherboard
  static const String highAmdRamQuery = '32gb';
  static const String highAmdRomQuery = '2tb';
  static const double highMinAmdPsuPrice = 500.0;
  static const double highMaxAmdPsuPrice = 700.0;
  static const double highMinAmdGpuPrice = 2000.0;
  static const double highMaxAmdGpuPrice = 14000.0;

  String _selectedSpec = lowSpec;
  bool _isIntel = true;
  bool _isAMD = false;
  List<Map<String, dynamic>> _recommendedParts = [];
  bool isLoading = false;
  double totalPrice = 0.0;
  final TextEditingController _buildNameController = TextEditingController();

  void _generateBuild() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> allParts = await ApiService.fetchPcParts();
      List<Map<String, dynamic>> selectedParts = [];

      if (_selectedSpec == lowSpec) {
        if (_isIntel) {
          selectedParts = await _selectLowIntelSpecParts(allParts);
        } else if (_isAMD) {
          selectedParts = await _selectLowAmdSpecParts(allParts);
        }
      } else if (_selectedSpec == midSpec) {
        if (_isIntel) {
          selectedParts = await _selectMidIntelSpecParts(allParts);
        } else if (_isAMD) {
          selectedParts = await _selectMidAmdSpecParts(allParts);
        }
      } else if (_selectedSpec == highSpec) {
        if (_isIntel) {
          selectedParts = await _selectHighIntelSpecParts(allParts);
        } else if (_isAMD) {
          selectedParts = await _selectHighAmdSpecParts(allParts);
        }
      }

      totalPrice = _calculateTotalPrice(selectedParts);

      setState(() {
        _recommendedParts = selectedParts;
        isLoading = false;
      });
    } catch (e) {
      print('Error generating build: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _selectLowIntelSpecParts(List<Map<String, dynamic>> allParts) async {
    List<Map<String, dynamic>> selectedParts = [];
    selectedParts.add(await _selectRandomPart(allParts, 'CPU', lowIntelCpuQuery, maxPrice: lowMaxIntelCpuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'Motherboard', lowIntelMotherboardQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'RAM', lowIntelRamQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'ROM', lowIntelRomQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'PSU', '', maxPrice: lowMaxIntelPsuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'GPU', '', maxPrice: lowMaxIntelGpuPrice));
    return selectedParts;
  }

  Future<List<Map<String, dynamic>>> _selectLowAmdSpecParts(List<Map<String, dynamic>> allParts) async {
    List<Map<String, dynamic>> selectedParts = [];
    selectedParts.add(await _selectRandomPart(allParts, 'CPU', lowAmdCpuQuery, maxPrice: lowMaxAmdCpuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'Motherboard', lowAmdMotherboardQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'RAM', lowAmdRamQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'ROM', lowAmdRomQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'PSU', '', maxPrice: lowMaxAmdPsuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'GPU', '', maxPrice: lowMaxAmdGpuPrice));
    return selectedParts;
  }

  Future<List<Map<String, dynamic>>> _selectMidIntelSpecParts(List<Map<String, dynamic>> allParts) async {
    List<Map<String, dynamic>> selectedParts = [];
    selectedParts.add(await _selectRandomPart(allParts, 'CPU', midIntelCpuQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'Motherboard', midIntelMotherboardQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'RAM', midIntelRamQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'ROM', midIntelRomQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'PSU', '', maxPrice: midMaxIntelPsuPrice, minPrice: midMinIntelPsuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'GPU', '', maxPrice: midMaxIntelGpuPrice, minPrice: midMinIntelGpuPrice));
    return selectedParts;
  }

  Future<List<Map<String, dynamic>>> _selectMidAmdSpecParts(List<Map<String, dynamic>> allParts) async {
    List<Map<String, dynamic>> selectedParts = [];
    selectedParts.add(await _selectRandomPart(allParts, 'CPU', midAmdCpuQuery, maxPrice: midMaxAmdCpuPrice, minPrice: midMinAmdCpuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'Motherboard', midAmdMotherboardQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'RAM', midAmdRamQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'ROM', midAmdRomQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'PSU', '', maxPrice: midMaxAmdPsuPrice, minPrice: midMinAmdPsuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'GPU', '', maxPrice: midMaxAmdGpuPrice, minPrice: midMinAmdGpuPrice));
    return selectedParts;
  }

  Future<List<Map<String, dynamic>>> _selectHighIntelSpecParts(List<Map<String, dynamic>> allParts) async {
    List<Map<String, dynamic>> selectedParts = [];
    selectedParts.add(await _selectRandomPart(allParts, 'CPU', highIntelCpuQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'Motherboard', highIntelMotherboardQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'RAM', highIntelRamQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'ROM', highIntelRomQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'PSU', '', maxPrice: highMaxIntelPsuPrice, minPrice: highMinIntelPsuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'GPU', '', maxPrice: highMaxIntelGpuPrice, minPrice: highMinIntelGpuPrice));
    return selectedParts;
  }

  Future<List<Map<String, dynamic>>> _selectHighAmdSpecParts(List<Map<String, dynamic>> allParts) async {
    List<Map<String, dynamic>> selectedParts = [];
    
    // Try to select the X570 motherboard first
    var motherboard = await _selectRandomPart(allParts, 'Motherboard', highAmdMotherboardQuery);
    
    // If the selected motherboard is not the expected one, try to select the fallback
    if (motherboard['product_name'] != null && !motherboard['product_name'].toLowerCase().contains('x570')) {
      motherboard = await _selectRandomPart(allParts, 'Motherboard', fallbackAmdMotherboardQuery);
    }

    selectedParts.add(await _selectRandomPart(allParts, 'CPU', highAmdCpuQuery));
    selectedParts.add(motherboard);
    selectedParts.add(await _selectRandomPart(allParts, 'RAM', highAmdRamQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'ROM', highAmdRomQuery));
    selectedParts.add(await _selectRandomPart(allParts, 'PSU', '', maxPrice: highMaxAmdPsuPrice, minPrice: highMinAmdPsuPrice));
    selectedParts.add(await _selectRandomPart(allParts, 'GPU', '', maxPrice: highMaxAmdGpuPrice, minPrice: highMinAmdGpuPrice));
    return selectedParts;
  }

  double _calculateTotalPrice(List<Map<String, dynamic>> parts) {
    return parts.fold(0.0, (sum, part) {
      double price = double.tryParse(part['price'].toString()) ?? 0.0;
      return sum + price;
    });
  }

  Future<Map<String, dynamic>> _selectRandomPart(List<Map<String, dynamic>> parts, String category, String query, {double? maxPrice, double? minPrice}) async {
    final filteredParts = parts.where((part) {
      final matchesCategory = part['category']?.toLowerCase() == category.toLowerCase();
      final matchesQuery = query.split(' ').every((q) => part['product_name']?.toLowerCase().contains(q.toLowerCase()) ?? false);
      final matchesPrice = (maxPrice == null || (part['price'] != null && double.tryParse(part['price'].toString())! <= maxPrice)) &&
                           (minPrice == null || (part['price'] != null && double.tryParse(part['price'].toString())! >= minPrice));
      return matchesCategory && matchesQuery && matchesPrice;
    }).toList();

    if (filteredParts.isNotEmpty) {
      filteredParts.shuffle(); // Randomize the list
      return filteredParts.first; // Return a random part
    }

    return {'product_name': 'No suitable part found', 'price': '0.0'};
  }

  Future<void> _saveBuild() async {
    // Check if any parts are selected
    if (_recommendedParts.isEmpty) { // Assuming _recommendedParts holds the selected parts
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one part before saving.')),
        );
      }
      return; // Exit the method if no parts are selected
    }

    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser?.uid ?? ''; // Ensure the user is logged in
    if (uid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in. Cannot save build.')),
        );
      }
      return; // Exit if the user is not logged in
    }

    // Prompt user for build name
    String? buildName = await _showBuildNameDialog();
    if (buildName == null || buildName.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Build name cannot be empty.')),
        );
      }
      return; // Exit if the build name is empty
    }

    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    
    // Create a map of selected parts with appropriate types
    Map<String, dynamic> selectedParts = {};

    // Add selected parts to the map
    for (var part in _recommendedParts) {
      if (part['category'] != null && part['product_name'] != null) {
        selectedParts[part['category']] = part;
      }
    }

    // Convert price strings to double if necessary and then to string
    selectedParts.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('price')) {
        // Convert price to double and then to string
        double price = double.tryParse(value['price'] ?? '0') ?? 0;
        value['price'] = price.toString(); // Convert to string
      }
    });

    try {
      await userDoc.set({
        'savedBuilds': FieldValue.arrayUnion([
          {'name': buildName, 'parts': selectedParts}
        ])
      }, SetOptions(merge: true));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Build saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving build: $e')),
        );
      }
    }
  }

  Future<String?> _showBuildNameDialog() async {
    String? buildName;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Build Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Build Name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                buildName = controller.text;
                Navigator.of(context).pop(buildName);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return buildName;
  }

  @override
  void dispose() {
    _buildNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildAppBar(),
            const SizedBox(height: 30.0),
            _buildSpecAndPlatform(),
            const SizedBox(height: 20),
            _buildGenerateButton(),
            const SizedBox(height: 30.0),
            _buildTotalPriceDisplay(),
            const SizedBox(height: 20.0),
            _buildPartsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
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
            'Recommended Build',
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
    );
  }

  Widget _buildSpecAndPlatform() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Spec Dropdown on the left
          Expanded(
            child: DropdownButton<String>(
              value: _selectedSpec,
              items: [lowSpec, midSpec, highSpec]
                  .map((spec) => DropdownMenuItem(
                        value: spec,
                        child: Text(spec),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpec = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 20), // Spacing between dropdown and switch
          // Platform Toggle Switch with Images
          Row(
            children: [
              // AMD Logo
              Image.asset(
                'lib/assets/images/AMD-logo.png', // Path to AMD logo
                width: 60, // Adjust width as needed
                height: 60, // Adjust height as needed
              ),
              const SizedBox(width: 10), // Spacing between image and switch
              Switch(
                value: _isIntel,
                onChanged: (value) {
                  setState(() {
                    _isIntel = value;
                    _isAMD = !value; // Ensure only one is selected
                  });
                },
                activeColor: Colors.blue, // Color when Intel is selected
                inactiveThumbColor: Colors.red, // Color when AMD is selected
                inactiveTrackColor: Colors.red.withOpacity(0.5), // Track color when AMD is selected
              ),
              const SizedBox(width: 10), // Spacing between switch and image
              // Intel Logo
              Image.asset(
                'lib/assets/images/intel-logo.png', // Path to Intel logo
                width: 60, // Adjust width as needed
                height: 60, // Adjust height as needed
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
      children: [
        // Generate Build Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF08FFA2),
                Color(0xFF08BAFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
          child: TextButton(
            onPressed: _generateBuild,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              textStyle: const TextStyle(
                fontFamily: 'nasalization',
                fontSize: 15.0,
              ),
            ),
            child: const Text('Generate Build'),
          ),
        ),
        const SizedBox(width: 30), // Space between buttons
        // Save Build Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF08FFA2),
                Color(0xFF08BAFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
          child: TextButton(
            onPressed: _saveBuild, // Show dialog to enter build name
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              textStyle: const TextStyle(
                fontFamily: 'nasalization',
                fontSize: 15.0,
              ),
            ),
            child: const Text('Save Build'),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPriceDisplay() {
    return Text(
      'Total Price: RM$totalPrice',
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPartsList() {
    return Expanded(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010B73)),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: _recommendedParts.length,
                itemBuilder: (context, index) {
                  final part = _recommendedParts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0), // Space between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    elevation: 5, // Shadow effect
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Padding inside the card
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  part['product_name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF010B73), // Distinct color for the title
                                  ),
                                ),
                                const SizedBox(height: 5.0), // Space between title and subtitle
                                Text(
                                  'Price: RM${part['price'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Optionally, you can add an icon or button here
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              // Handle info button press
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}


