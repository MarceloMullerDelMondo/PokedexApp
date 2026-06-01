import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirestoreService._();

  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Nenhum usuario autenticado.');
    }
    return user.uid;
  }

  static DocumentReference<Map<String, dynamic>> get userDoc {
    return _db.collection('users').doc(currentUserId);
  }

  static CollectionReference<Map<String, dynamic>> get pokemons {
    return userDoc.collection('pokemons');
  }

  static DocumentReference<Map<String, dynamic>> get trainerProfile {
    return userDoc.collection('config').doc('treinador');
  }
}
