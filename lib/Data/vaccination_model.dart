class Vaccination {
  final String name;
  final DateTime date;
  final String hospital;
  final bool isCompleted;
  final DateTime? nextDoseDate;

  Vaccination({
    required this.name,
    required this.date,
    required this.hospital,
    this.isCompleted = false,
    this.nextDoseDate,
  });


  factory Vaccination.fromFirestore(Map<String, dynamic> data) {
    return Vaccination(
      name: data['name'] ?? '',
      date: (data['date'] as dynamic).toDate(),
      hospital: data['hospital'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      nextDoseDate: (data['nextDoseDate'] as dynamic?)?.toDate(),
    );
  }
}