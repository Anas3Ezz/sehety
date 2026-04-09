import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Collection reference ──────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // ── Add User ──────────────────────────────────────────────────────────────────

  /// Called right after Firebase Auth creates the account.
  /// Uses the uid as the document ID so lookups are always O(1).
  Future<void> addUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  // ── Get User ──────────────────────────────────────────────────────────────────

  /// Fetches a single user document by uid.
  /// Returns null if the document doesn't exist.
  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromMap(doc.data()!);
  }

  // ── Update User ───────────────────────────────────────────────────────────────

  /// Merges the provided fields into the existing document.
  /// Only the provided fields are updated, the rest stay untouched.
  Future<void> updateUser(String uid, Map<String, dynamic> fields) async {
    await _usersCollection.doc(uid).update(fields);
  }

  // ── Delete User ───────────────────────────────────────────────────────────────

  Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }
}
