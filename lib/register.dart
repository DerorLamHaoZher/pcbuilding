import 'package:flutter/material.dart';
import 'package:pc_bma/services/auth_service.dart';
import 'menu.dart';

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
      home: const MyRegisterPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key, required this.title});

  final String title;

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await AuthService().signup(email: email, password: password);
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const MyMenuPage(title: '')),
      );
    } catch (e) {
      // Display error message if signup fails
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF08FFA2), Color(0xFF08BAFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'PC Building Mobile Application',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'bombardment',
                    color: Color(0xFF010B73),
                    shadows: [
                      Shadow(blurRadius: 4.0, color: Colors.black, offset: Offset(2.0, 2.0)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Make PC building much easier!',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontFamily: 'Caveat',
                    color: Color(0xFFFFFFFF),
                    shadows: [
                      Shadow(blurRadius: 4.0, color: Colors.black, offset: Offset(2.0, 2.0)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFFFFF), Color(0xFFBDBCBC)],
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
                    onPressed: _register,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                      textStyle: const TextStyle(
                        fontFamily: 'nasalization',
                        fontSize: 25.0,
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

