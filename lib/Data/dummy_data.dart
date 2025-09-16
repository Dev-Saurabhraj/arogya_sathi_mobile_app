import 'package:cloud_firestore/cloud_firestore.dart';

final dummyUsers = [
  {
    'name': 'Ramesh Kumar',
    'phone': '+919876543210',
    'age': 45,
    'pincode': '201001',
    'vaccinationId': 'AR12345678',
  },
  {
    'name': 'Pooja Devi',
    'phone': '+919988776655',
    'age': 32,
    'pincode': '201001',
    'vaccinationId': 'AR12345679',
  },
  {
    'name': 'Sunil Yadav',
    'phone': '+919000112233',
    'age': 55,
    'pincode': '201002',
    'vaccinationId': 'AR12345680',
  },
  {
    'name': 'Anjali Gupta',
    'phone': '+918765432109',
    'age': 28,
    'pincode': '201003',
    'vaccinationId': 'AR12345681',
  },
  {
    'name': 'Arjun Singh',
    'phone': '+918012345678',
    'age': 61,
    'pincode': '201004',
    'vaccinationId': 'AR12345682',
  },
  {
    'name': 'Meena Kumari',
    'phone': '+917654321098',
    'age': 19,
    'pincode': '201005',
    'vaccinationId': 'AR12345683',
  },
  {
    'name': 'Vijay Sharma',
    'phone': '+919123456789',
    'age': 40,
    'pincode': '201006',
    'vaccinationId': 'AR12345684',
  },
  {
    'name': 'Kavita Mishra',
    'phone': '+919345678901',
    'age': 35,
    'pincode': '201007',
    'vaccinationId': 'AR12345685',
  },
  {
    'name': 'Sanjay Kumar',
    'phone': '+919876543211',
    'age': 50,
    'pincode': '201008',
    'vaccinationId': 'AR12345686',
  },
  {
    'name': 'Priya Singh',
    'phone': '+919988776654',
    'age': 25,
    'pincode': '201009',
    'vaccinationId': 'AR12345687',
  },
];

final dummyVaccinations = {
  'AR12345678': [
    {
      'name': 'Polio',
      'date': Timestamp.fromDate(DateTime(2023, 1, 15)),
      'hospital': 'Muradnagar Health Center',
      'isCompleted': true,
    },
    {
      'name': 'Tetanus',
      'date': Timestamp.fromDate(DateTime(2024, 6, 20)),
      'hospital': 'District Hospital',
      'isCompleted': false,
      'nextDoseDate': Timestamp.fromDate(DateTime(2025, 6, 20)),
    },
  ],
  'AR12345679': [
    {
      'name': 'Polio',
      'date': Timestamp.fromDate(DateTime(2023, 1, 15)),
      'hospital': 'Muradnagar Health Center',
      'isCompleted': true,
    },
    {
      'name': 'Measles',
      'date': Timestamp.fromDate(DateTime(2024, 2, 10)),
      'hospital': 'CHC, Muradnagar',
      'isCompleted': true,
    },
  ],
  'AR12345680': [
    {
      'name': 'COVID-19 Booster',
      'date': Timestamp.fromDate(DateTime(2023, 10, 5)),
      'hospital': 'District Hospital',
      'isCompleted': true,
    },
  ],
  'AR12345681': [
    {
      'name': 'Typhoid',
      'date': Timestamp.fromDate(DateTime(2024, 11, 22)),
      'hospital': 'Private Clinic',
      'isCompleted': false,
      'nextDoseDate': Timestamp.fromDate(DateTime(2025, 11, 22)),
    },
  ],
  'AR12345682': [
    {
      'name': 'Pneumonia',
      'date': Timestamp.fromDate(DateTime(2024, 5, 1)),
      'hospital': 'District Hospital',
      'isCompleted': true,
    },
  ],
  'AR12345683': [
    {
      'name': 'Hepatitis B',
      'date': Timestamp.fromDate(DateTime(2024, 3, 18)),
      'hospital': 'Muradnagar Health Center',
      'isCompleted': true,
    },
  ],
  'AR12345684': [
    {
      'name': 'Tetanus',
      'date': Timestamp.fromDate(DateTime(2023, 8, 30)),
      'hospital': 'District Hospital',
      'isCompleted': true,
    },
  ],
  'AR12345685': [
    {
      'name': 'Typhoid',
      'date': Timestamp.fromDate(DateTime(2024, 9, 12)),
      'hospital': 'CHC, Muradnagar',
      'isCompleted': true,
    },
  ],
  'AR12345686': [
    {
      'name': 'Polio',
      'date': Timestamp.fromDate(DateTime(2022, 1, 20)),
      'hospital': 'Muradnagar Health Center',
      'isCompleted': true,
    },
    {
      'name': 'Tetanus',
      'date': Timestamp.fromDate(DateTime(2024, 5, 15)),
      'hospital': 'District Hospital',
      'isCompleted': true,
    },
  ],
  'AR12345687': [
    {
      'name': 'Hepatitis A',
      'date': Timestamp.fromDate(DateTime(2023, 7, 5)),
      'hospital': 'Private Clinic',
      'isCompleted': true,
    },
  ],
};

final dummyOutbreaks = [
  {
    'title': 'Dengue Outbreak',
    'location': 'Near main market, Muradnagar',
    'date': Timestamp.fromDate(DateTime(2025, 9, 10)),
    'severity': 'High',
  },
  {
    'title': 'Viral Fever Cases Rise',
    'location': 'Khaspur Village',
    'date': Timestamp.fromDate(DateTime(2025, 9, 8)),
    'severity': 'Medium',
  },
  {
    'title': 'Chikungunya Alert',
    'location': 'District Hospital Area',
    'date': Timestamp.fromDate(DateTime(2025, 9, 5)),
    'severity': 'High',
  },
  {
    'title': 'Typhoid Cases Detected',
    'location': 'Shiv Vihar, Muradnagar',
    'date': Timestamp.fromDate(DateTime(2025, 8, 28)),
    'severity': 'Medium',
  },
  {
    'title': 'Seasonal Flu Advisory',
    'location': 'All over the district',
    'date': Timestamp.fromDate(DateTime(2025, 8, 20)),
    'severity': 'Low',
  },
  {
    'title': 'Swine Flu (H1N1) Alert',
    'location': 'Outskirts of town',
    'date': Timestamp.fromDate(DateTime(2025, 8, 15)),
    'severity': 'High',
  },
  {
    'title': 'Gastroenteritis Outbreak',
    'location': 'Bhagat Singh Colony',
    'date': Timestamp.fromDate(DateTime(2025, 8, 10)),
    'severity': 'Medium',
  },
  {
    'title': 'Jaundice Cases Reported',
    'location': 'Rural areas near river',
    'date': Timestamp.fromDate(DateTime(2025, 8, 5)),
    'severity': 'Low',
  },
  {
    'title': 'Food Poisoning Alert',
    'location': 'Main Market Area',
    'date': Timestamp.fromDate(DateTime(2025, 7, 30)),
    'severity': 'Low',
  },
  {
    'title': 'Malaria Cases Spike',
    'location': 'Near swampy areas',
    'date': Timestamp.fromDate(DateTime(2025, 7, 25)),
    'severity': 'Medium',
  },
];