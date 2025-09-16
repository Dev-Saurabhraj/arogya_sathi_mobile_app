// Check this line! Make sure 'arogya_sathi_2' matches your project name.
import 'package:arogya_sathi_2/data/user_model.dart';
import 'package:arogya_sathi_2/data/vaccination_model.dart';
import 'package:arogya_sathi_2/data/dummy_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addDummyData() async {
    // Add dummy users
    for (var userData in dummyUsers) {
      final docRef = _db.collection('users').doc();
      await docRef.set(userData);
      final userId = docRef.id;

      // Add dummy vaccination data for this user
      if (dummyVaccinations.containsKey(userData['vaccinationId'])) {
        final batch = _db.batch();
        for (var vacData in dummyVaccinations[userData['vaccinationId']]!) {
          final vacRef = _db.collection('vaccinations').doc();
          batch.set(vacRef, {'userId': userId, ...vacData});
        }
        await batch.commit();
      }
    }

    // Add dummy outbreak data
    for (var outbreakData in dummyOutbreaks) {
      await _db.collection('outbreaks').add(outbreakData);
    }

    print('Dummy data added to Firebase successfully.');
  }

  Future<User?> getUserDetails(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<Vaccination>> getVaccinationDetails(String userId) async {
    final snapshot = await _db.collection('vaccinations').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Vaccination.fromFirestore(doc.data())).toList();
  }

  Future<List<Map<String, dynamic>>> getOutbreakData() async {
    final snapshot = await _db.collection('outbreaks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}