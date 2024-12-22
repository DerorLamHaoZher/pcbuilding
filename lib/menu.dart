import 'package:flutter/material.dart';
import 'tutorial.dart';
import 'viewpart.dart';
import 'recommend.dart';
import 'package:pc_bma/services/auth_service.dart';
import 'viewsavedpc.dart';
import 'main.dart';

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
      home: const MyMenuPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyMenuPage extends StatefulWidget {
  const MyMenuPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyMenuPage> createState() => _MyMenuPageState();
}

class _MyMenuPageState extends State<MyMenuPage> {
  final AuthService _authService = AuthService();

  void _logout() async {
    try {
      await _authService.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'logout')),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
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
        padding: const EdgeInsets.all(10.10), // Adjust padding as needed
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF08FFA2),
              Color(0xFF08BAFF), // Light green color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          children: [
            const SizedBox(height: 60.0),
            // New Container to replace the AppBar
            Container(
              padding: const EdgeInsets.all(16.0), // Padding for the app bar
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(30.0),
                // Rounded bottom corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Shadow color
                    spreadRadius: 0.5, // Spread of the shadow
                    blurRadius: 5, // Blur intensity
                    offset: const Offset(0, 3), // Shadow position offset (x, y)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PC BMA', // Replace with your app title
                    style: TextStyle(
                      color:  Color(0xFF010B73),
                      fontSize: 30.0, // Adjust title font size
                      fontFamily: 'bombardment',
                      shadows: [
                        Shadow(
                          blurRadius: 2.0, // shadow blur
                          color: Colors.black, // shadow color
                          offset: Offset(1.0, 1.0), // how much shadow will be shown
                        ),
                      ],
                    ),
                  ),
                  // Optionally add an action icon
                  IconButton(
                    icon: const Icon(Icons.logout), // Replace with your desired icon
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _logout();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10.10), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Shadow color
                        spreadRadius: 0.5, // Spread of the shadow
                        blurRadius: 5, // Blur intensity
                        offset: const Offset(3, 3), // Shadow position offset (x, y)
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Buttons
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF08FFA2),
                                Color(0xFF08BAFF), // End color for gradient
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5), // Shadow color
                                spreadRadius: 0.5, // Spread of the shadow
                                blurRadius: 5, // Blur intensity
                                offset: const Offset(3, 3), // Shadow position offset (x, y)
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const MyTutorialPage(title: 'tutorial page')),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, // Text color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 30.0), // Adjust padding
                              textStyle: const TextStyle(
                                fontFamily: 'nasalization',
                                fontSize: 25.0, // Adjust font size
                              ),
                            ),
                            child: const Text('PC Building'),
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // Additional buttons...
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF08FFA2),
                                Color(0xFF08BAFF), // End color for gradient
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5), // Shadow color
                                spreadRadius: 0.5, // Spread of the shadow
                                blurRadius: 5, // Blur intensity
                                offset: const Offset(3, 3), // Shadow position offset (x, y)
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ViewSavedPCPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, // Text color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 30.0), // Adjust padding
                              textStyle: const TextStyle(
                                fontFamily: 'nasalization',
                                fontSize: 25.0, // Adjust font size
                              ),
                            ),
                            child: const Text('View Saved Build'),
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // More buttons...
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF08FFA2),
                                Color(0xFF08BAFF), // End color for gradient
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5), // Shadow color
                                spreadRadius: 0.5, // Spread of the shadow
                                blurRadius: 5, // Blur intensity
                                offset: const Offset(3, 3), // Shadow position offset (x, y)
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewParts(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, // Text color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 30.0), // Adjust padding
                              textStyle: const TextStyle(
                                fontFamily: 'nasalization',
                                fontSize: 25.0, // Adjust font size
                              ),
                            ),
                            child: const Text('View PC Parts'),
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // Another button...
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF08FFA2),
                                Color(0xFF08BAFF), // End color for gradient
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5), // Shadow color
                                spreadRadius: 0.5, // Spread of the shadow
                                blurRadius: 5, // Blur intensity
                                offset: const Offset(3, 3), // Shadow position offset (x, y)
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecommendPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, // Text color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 30.0), // Adjust padding
                              textStyle: const TextStyle(
                                fontFamily: 'nasalization',
                                fontSize: 25.0, // Adjust font size
                              ),
                            ),
                            child: const Text(
                              'Recommended Build',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),


      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
