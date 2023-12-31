import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/UserModel.dart';
import 'package:frontend/services/app_logger.dart';
import 'package:frontend/views/Ui/mainscreen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  //create fb instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user from UID
  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //create the stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //Sign in anon
  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final _authAccount = await account.authentication;
        final _credential = GoogleAuthProvider.credential(
            idToken: _authAccount.idToken,
            accessToken: _authAccount.accessToken);
        await _auth.signInWithCredential(_credential);
        //await saveUser(account);
        navigateToHomePage();
      }
    } on Exception catch (error) {
      AppLogger.e(error);
      print(error);
    }
  }

  void navigateToHomePage() {
    Get.offAllNamed(MainScreen.rountName);
  }

  Future<void> signOut() async {
    AppLogger.d('Sign out');
    try {
      await _auth.signOut();
      navigateToHomePage();
      print("log out 2");
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
      print("log out no");
    }
  }

  // signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   try {
  //     final GoogleSignInAccount? googleUser =
  //         await GoogleSignIn(scopes: <String>["email"]).signIn();

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (err) {
  //     print("Error signing in with Google: $err");
  //     return null;
  //   }
  // }

//   Future<UserModel?> signInWithGoogle() async {
//   try {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn(
//         scopes: <String>["email"]).signIn();

//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     // Sign in with the credential
//     final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

//     // Extract the user from the result
//     final User? user = authResult.user;

//     // Return a UserModel
//     return _userWithFirebaseUserUid(user);
//   } catch (err) {
//     print("Error signing in with Google: $err");
//     return null;
//   }
// }

  //register using email and pwd
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //sign in using email and pwd
  Future signinUsingEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //sign in using gmail

  //signout
  // Future signOut() async {
  //   try {
  //     return await _auth.signOut();
  //   } catch (err) {
  //     print(err.toString());
  //     return null;
  //   }
  // }
}
