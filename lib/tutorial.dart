import 'package:flutter/material.dart';
import 'buildpc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyTutorialPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyTutorialPage extends StatefulWidget {
  const MyTutorialPage({super.key, required this.title});

  final String title;

  @override
  State<MyTutorialPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyTutorialPage> with SingleTickerProviderStateMixin {
 

  final List<Map<String, dynamic>> pcParts = [
    {
      'image': 'lib/assets/images/Motherboard.png',
      'description': 'Motherboard is a printed circuit board (PCB), it allows communication between many of the crucial electronic components of a system like CPU, RAM, GPU and other else ',
      'name': 'Motherboard',
      
    },
    {
      'image': 'lib/assets/images/CPU.png',
      'description': 'CPU (Central Processor Unit) is a PC part that responsible to process all of the task in a computer.',
      'name': 'CPU',
      'position': Offset(0.4, 0.1), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/RAM.png',
      'description': 'Memory as knows as RAM (Random Access Memory) a temporary memory bank where your computer stores data it needs to retrieve quickly. Since it is a volatile hardware so the data will gone once PC is off.',
      'name': 'RAM',
      'position': Offset(0.5, 0.6), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/GPU.png',
      'description': 'GPU (Graphic Processor Unit) is a PC parts responsible for rendering and displaying images, videos, and animations on your computer monitor.',
      'name': 'GPU',
      'position': Offset(0.1, 0.5), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/Storage.png',
      'description': 'Storage as known as ROM (Read Only Memory) that enable to keep and read data if needed. Since it is a non volatile hardware so the data will be keep in it after the PC is off. Now days there are two type of storage, the old, slower one called hard disk drive and the faster, newer one called Solid state drive.',
      'name': 'ROM',
      'position': Offset(0.3, 0.6), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/PSU.png',
      'description': 'Power Supply Unit is a PC part that converts alternating current (AC) to direct current (DC) because all PC parts inside a computer requires DC power to operate. High performance PC parts might require greater wattage PSU (Power Supply Unit).',
      'name': 'PSU',
      'position': Offset(0.2, 0.1), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/CPU-Cooler.png',
      'description': 'CPU cooler is a PC part with heat sink that to draw heat away from the system CPU to prevent CPU overheating. Other PC parts do not generate too much heat so they do not equip with coolers (except for GPU, it already come with the heat sink that specific design for the certain GPU model).',
      'name': 'CPU-Cooler',
      'position': Offset(0.5, 0.8), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/Case-Fan.png',
      'description': 'Case fan also help to remove all PC parts ’s heat by sucking out hot air from the case. It also create better air passage inside the case to maintain PC parts in operating temperature.',
      'name': 'Case-Fan',
      'position': Offset(0.7, 0.5), // Use factors for responsive positioning
    },
    {
      'image': 'lib/assets/images/Case.png',
      'description': 'Computer Case is a outer shell of a PC that fixed PC component like Motherboard, case fan, hard disk drive and other else to prevent damage while moving the PC.',
      'name': 'Case',
      'position': Offset(0.3, 0.5), // Use factors for responsive positioning
    },
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateLeft() {
    setState(() {
      currentIndex = (currentIndex - 1 + pcParts.length) % pcParts.length;
    });
  }

  void _navigateRight() {
    setState(() {
      currentIndex = (currentIndex + 1) % pcParts.length;
    });
  }

  // Add responsive helper methods
  double _responsivePadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.03;
  }

  double _responsiveFontSize(BuildContext context, double baseSize) {
    return baseSize * MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF08FFA2), Color(0xFF08BAFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03), // Responsive padding
            child: Column(
              children: [
                // Header
                _buildHeader(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                // Main Content
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03 * 2,
        vertical: MediaQuery.of(context).size.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tutorial',
            style: TextStyle(
              color: const Color(0xFF010B73),
              fontSize: _responsiveFontSize(context, 32.0),
              fontFamily: 'bombardment',
              shadows: const [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black38,
                  offset: Offset(1.5, 1.5),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
            
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                } // Navigate back to the previous screen},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03), // Responsive padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure space between elements
        children: [
          // Image and Indicator Section
          AspectRatio(
            aspectRatio: 1, // Maintain square aspect ratio
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  pcParts[currentIndex]['image']!,
                  height: 440.0,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          SizedBox(height: 16.0), // Add a gap of 16 pixels between the image and the description

          // Description Section
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03), // Responsive padding
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Text(
                  pcParts[currentIndex]['description']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _responsiveFontSize(context, 16.0),
                    fontFamily: 'nasalization',
                    height: 1.5,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
              ),
            ),
          ),

          // Navigation Controls with Page Indicator
          Column(
            children: [
              // Page Indicator
              Text(
                '${currentIndex + 1} of ${pcParts.length}',
                style: TextStyle(
                  fontSize: _responsiveFontSize(context, 14.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'nasalization',
                ),
              ),
              const SizedBox(height: 10.0), // Space between indicator and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left Arrow Button
                  ElevatedButton(
                    onPressed: _navigateLeft,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                    child: const Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyBuildPCPage(title: 'Build PC page'),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      foregroundColor: Colors.black, // Text color
                      textStyle: const TextStyle(
                        fontFamily: 'nasalization',
                        fontSize: 25.0, // Adjust font size
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF08FFA2), // Start color for gradient
                            Color(0xFF08BAFF), // End color for gradient
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0), // Rounded corners
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'nasalization',
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  // Right Arrow Button
                  ElevatedButton(
                    onPressed: _navigateRight,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
