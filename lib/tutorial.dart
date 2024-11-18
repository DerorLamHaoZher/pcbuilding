import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyTutorialPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyTutorialPage extends StatefulWidget {
  const MyTutorialPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyTutorialPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyTutorialPage> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  // List of PC parts with their images and descriptions
  final List<Map<String, dynamic>> pcParts = [
    {
      'image': 'lib/assets/images/parts.png',  // Replace with your image paths
      'description': 'This is the CPU (Central Processing Unit), the brain of your PC.',
      'name': 'CPU',
      'position': const Offset(200, 50), // Adjust for each PC part's position
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'This is the GPU (Graphics Processing Unit), responsible for rendering graphics.',
      'name': 'GPU',
      'position': Offset(200, 150),
    },
    {
      'image': 'lib/assets/images/parts.png',
      'description': 'This is the RAM (Random Access Memory), for temporary data storage.',
      'name': 'RAM',
      'position': Offset(150, 100),
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
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
            // AppBar-like container
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
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Settings action
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Main content with Stack to show the image and breathing circle
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display the PC part image with the breathing effect
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Image of the selected PC part
                          Image.asset(
                            pcParts[currentIndex]['image']!,
                            height: 440.0,
                            fit: BoxFit.contain,
                          ),
                          // Pulsating circle effect
                          ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.5).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: Container(
                              width: 30.0,
                              height: 20.0,
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
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Description of the selected PC part
                      Text(
                        pcParts[currentIndex]['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'nasalization',
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Navigation buttons (left and right)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _navigateLeft,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ),
                            child: const Icon(
                              Icons.arrow_left,
                              color: Colors.white,
                              size: 30.0,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
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