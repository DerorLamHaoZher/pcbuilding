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
  late AnimationController _animationController;

  final List<Map<String, dynamic>> pcParts = [
    {
      'image': 'lib/assets/images/parts.png',  // Replace with your image paths
      'description': 'Motherboard is a printed circuit board (PCB), it allows communication between many of the crucial electronic components of a system like CPU, RAM, GPU and other else ',
      'name': 'Motherboard',
      'position': const Offset(160, 200), // Adjust for each PC part's position
    },
    {
      'image': 'lib/assets/images/parts.png',  // Replace with your image paths
      'description': 'CPU (Central Processor Unit) is a PC part that responsible to process all of the task in a computer.',
      'name': 'CPU',
      'position': const Offset(160, 15), // Adjust for each PC part's position
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'Memory as knows as RAM (Random Access Memory) a temporary memory bank where your computer stores data it needs to retrieve quickly. Since it is a volatile hardware so the data will gone once PC is off.',
      'name': 'RAM',
      'position': const Offset(150, 310),
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'GPU (Graphic Processor Unit) is a PC parts responsible for rendering and displaying images, videos, and animations on your computer monitor.',
      'name': 'GPU',
      'position': const Offset(20, 200),
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'Storage as known as ROM (Read Only Memory) that enable to keep and read data if needed. Since it is a non volatile hardware so the data will be keep in it after the PC is off. Now days there are two type of storage, the old, slower one called hard disk drive and the faster, newer one called Solid state drive.',
      'name': 'ROM',
      'position': const Offset(70, 310),
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'Power Supply Unit is a PC part that converts alternating current (AC) to direct current (DC) because all PC parts inside a computer requires DC power to operate. High performance PC parts might require greater wattage PSU (Power Supply Unit).',
      'name': 'PSU',
      'position': const Offset(55, 15),
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'CPU cooler is a PC part with heat sink that to draw heat away from the system CPU to prevent CPU overheating. Other PC parts do not generate too much heat so they do not equip with coolers (except for GPU, it already come with the heat sink that specific design for the certain GPU model).',
      'name': 'CPU-Cooler',
      'position': const Offset(90, 380),
    },
    {
      'image': 'lib/assets/images/case.png',
      'description': 'Case fan also help to remove all PC parts ’s heat by sucking out hot air from the case. It also create better air passage inside the case to maintain PC parts in operating temperature.',
      'name': 'Case-Fan',
      'position': const Offset(250, 190),
    },
    {
      'image': 'lib/assets/images/case.png',
      'description': 'Computer Case is a outer shell of a PC that fixed PC component like Motherboard, case fan, hard disk drive and other else to prevent damage while moving the PC.',
      'name': 'Case',
      'position': const Offset(130, 190),
    },
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Breathing effect
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            pcParts[currentIndex]['image']!,
                            height: 440.0,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            left: pcParts[currentIndex]['position']!.dx,
                            top: pcParts[currentIndex]['position']!.dy,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 1.0, end: 1.5).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    pcParts[currentIndex]['name']!,
                                    style: const TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                      fontFamily: 'nasalization',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 100.0,
                        child: SingleChildScrollView(
                          child: Text(
                            pcParts[currentIndex]['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'nasalization',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        '${currentIndex + 1} of ${pcParts.length}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'nasalization',
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the left and right buttons
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
