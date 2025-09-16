class User {
  final String uid;
  final String name;
  final String phone;
  final int age;
  final String pincode;
  final String vaccinationId;

  User({
    required this.uid,
    required this.name,
    required this.phone,
    required this.age,
    required this.pincode,
    required this.vaccinationId,
  });

  factory User.fromFirestore(Map<String, dynamic> data, String uid) {
    return User(
      uid: uid,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      age: data['age'] ?? 0,
      pincode: data['pincode'] ?? '',
      vaccinationId: data['vaccinationId'] ?? 'NA',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'age': age,
      'pincode': pincode,
      'vaccinationId': vaccinationId,
    };
  }
}