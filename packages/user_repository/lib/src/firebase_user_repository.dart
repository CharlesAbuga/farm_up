import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  // TODO: implement user
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(id: user.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<MyUser> getMyUser(String myUserId) {
    try {
      return userCollection
          .doc(myUserId)
          .snapshots()
          .map((snapshot) => MyUser.fromEntity(
                MyUserEntity.fromDocument(snapshot.data()!),
              ));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<MyUser>> getAllUsers() {
    try {
      return userCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return MyUser.fromEntity(
            MyUserEntity.fromDocument(doc.data()),
          );
        }).toList();
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await userCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());

      rethrow;
    }
  }

  @override
  Future<void> updateUserData(MyUser user) async {
    try {
      await userCollection.doc(user.id).update(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await _firebaseAuth.signInWithProvider(googleAuthProvider);
      String? name = userCredential.user!.displayName;
      String? email = userCredential.user!.email;

      MyUser myUser = MyUser.empty.copyWith(name: name, email: email);
      await setUserData(myUser);
    } on FirebaseException catch (e) {
      log(e.toString());
      print(e.message);
      rethrow;
    }
  }
}
