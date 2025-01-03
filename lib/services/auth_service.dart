import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }

      throw message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user
      User? user = userCredential.user;

      // Log the user's display name
      if (user != null) {
        print('User logged in: ${user.displayName ?? user.email}'); // Debug message
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred, unknown email or password entered';

      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }

      throw message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw 'An error occurred while logging out: $e';
    }
  }
}
