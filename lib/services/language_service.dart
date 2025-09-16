import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  bool _isHindi = true;
  bool get isHindi => _isHindi;
  String get currentLanguage => _isHindi ? 'hindi' : 'english';

  final Map<String, Map<String, String>> _allTexts = {
    'hindi': {
      // App Info
      'appTitle': 'आरोग्य साथी',
      'govText': 'भारत सरकार',
      'ministryText': 'स्वास्थ्य और परिवार कल्याण मंत्रालय',
      'healthCompanion': 'आपका स्वास्थ्य साथी',

      // Login Page
      'formTitle': 'लॉगिन / रजिस्ट्रेशन फॉर्म',
      'fullName': 'पूरा नाम',
      'mobileNumber': 'मोबाइल नंबर',
      'submit': 'सबमिट करें',

      // Navigation
      'dashboard': 'डैशबोर्ड',
      'profile': 'प्रोफाइल',
      'vaccines': 'टीके',
      'outbreaks': 'फैलाव',
      'chatbot': 'चैटबॉट',

      // Home Page
      'welcomeMessage': 'स्वागत है',
      'user': 'उपयोगकर्ता',
      'welcomeToDashboard': 'आपके स्वास्थ्य डैशबोर्ड में आपका स्वागत है',
      'healthOverview': 'स्वास्थ्य सारांश',
      'quickActions': 'त्वरित कार्य',

      // Greetings
      'goodMorning': 'शुभ प्रभात',
      'goodAfternoon': 'नमस्कार',
      'goodEvening': 'शुभ संध्या',

      // Stats Cards
      'upToDate': 'अद्यतन',
      'complete': 'पूर्ण',
      'monitor': 'निगरानी',
      'available': 'उपलब्ध',
      'aiChat': 'एआई चैट',

      // Quick Actions
      'emergencyHelpline': 'आपातकालीन हेल्पलाइन',
      'findHospital': 'निकटतम अस्पताल खोजें',
      'getDirections': 'दिशा निर्देश पाएं',
      'healthChatSupport': 'स्वास्थ्य चैट सहायता',
      'available24x7': '24/7 उपलब्ध',

      // Vaccination Page
      'vaccinationDetails': 'टीकाकरण विवरण',
      'vaccinationStatus': 'टीकाकरण की स्थिति',
      'completed': 'पूर्ण',
      'pending': 'बकाया',
      'upcoming': 'आगामी',
      'viewIdCard': 'आईडी कार्ड देखें',
      'schedule': 'शेड्यूल',
      'reminders': 'रिमाइंडर',
      'export': 'निर्यात',

      'vaccinationRecords': 'टीकाकरण रिकॉर्ड',
      'doseHistory':'खुराक का इतिहास',
      'noDosesRecorded':  'अभी तक कोई खुराक दर्ज नहीं',
      'details':  'विवरण',
      'dueNow': 'अभी देय',
      'overdue': 'अतिदेय',
      'next':  'अगला',
      'share': 'भेजें',

      // Outbreak specific texts
      'noActiveOutbreaks': 'आपके क्षेत्र में कोई सक्रिय प्रकोप नहीं',
      'description': 'विवरण',
      'precautions': 'सावधानियां',
      'affected': 'प्रभावित',
      'moreDetails': 'अधिक विवरण',
      'outbreakDetails': 'प्रकोप का विवरण',
      'emergencyContact': 'आपातकालीन संपर्क',
      'healthMinistryHelpline': 'स्वास्थ्य मंत्रालय हेल्पलाइन',
      'symptomsAdvice': 'यदि आप लक्षण अनुभव करते हैं, तो तुरंत स्थानीय स्वास्थ्य अधिकारियों से संपर्क करें या निकटतम स्वास्थ्य सुविधा में जाएं।',

      // Health Records
      'healthRecords': 'स्वास्थ्य रिकॉर्ड',
      'appointments': 'अपॉइंटमेंट',
      'notifications': 'सूचनाएं',

      // Dialogs & Messages
      'comingSoon': 'जल्दी आ रहा है!',
      'featureUnderDevelopment': 'यह सुविधा विकसित की जा रही है और अगले अपडेट में उपलब्ध होगी।',
      'signOutError': 'साइन आउट में त्रुटि',

      // Common
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफल',
      'cancel': 'रद्द करें',
      'ok': 'ठीक है',
      'close': 'बंद करें',
      'save': 'सेव करें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      'yes': 'हाँ',
      'no': 'नहीं',
      'age':  'आयु',
      'pincode': 'पिन कोड',
      'language':  'भाषा',
      'signOut':  'साइन आउट',
      'manageHealthInfo':  'अपनी स्वास्थ्य जानकारी प्रबंधित करें',
      'preferencesSettings':  'प्राथमिकताएं और सेटिंग्स',
      'manageAlerts': 'अपने अलर्ट प्रबंधित करें',
      'changeAppLanguage': 'अपने एप्लीकेशन भाषा बदलें',
      'controlYourData': 'अपने डेटा प्रबंधित करें',
      'privacySettings' : 'गोपनीय सेटिंग',
      'help&Support': 'मदद और सहायता',
      'getAssistance': 'मदद के साथ सहायता',
      'logOutOfYourAccount': 'अपना खाता से लॉग आउट करें',
    },
    'english': {
      // Greetings

      'manageAlerts': 'Manage Alerts',
      'changeAppLanguage': 'Change App Language',
      'controlYourData': 'Control Your Data',
      'privacySettings' : 'Privacy Settings',
      'help&Support': 'Help & Support',
      'getAssistance': 'Get Assistance',
      'logOutOfYourAccount': 'Log out of you account',
      'manageHealthInfo': 'Manage your health information',
      'preferencesSettings': 'Preferences & Settings',
      'signOut': 'Sign Out',
      'language': 'Language',
      'age': 'Age',
      'pincode': 'Pincode',

      // out break page
      'noActiveOutbreaks': 'No active outbreaks in your area',
      'description': 'Description',
      'precautions': 'Precautions',
      'affected': 'Affected',
      'moreDetails': 'More Details',
      'outbreakDetails': 'Outbreak Details',
      'emergencyContact': 'Emergency Contact',
      'healthMinistryHelpline': 'Health Ministry Helpline',
      'symptomsAdvice': 'If you experience symptoms, immediately contact local health authorities or visit the nearest healthcare facility.',

      //vaccination details
      'vaccinationRecords': 'Vaccination Records',
      'doseHistory': 'Dose History',
      'noDosesRecorded': 'No doses recorded yet',
      'details': 'Details',
      'dueNow': 'Due Now',
      'overdue': 'Overdue',
      'next': 'Next',
      'share': 'Share',
      // App Info
          'appTitle': 'Arogya Sathi',
      'govText': 'Government of India',
      'ministryText': 'Ministry of Health and Family Welfare',
      'healthCompanion': 'Your Health Companion',

      // Login Page
      'formTitle': 'Login / Registration Form',
      'fullName': 'Full Name',
      'mobileNumber': 'Mobile Number',
      'submit': 'SUBMIT',

      // Navigation
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'vaccines': 'Vaccines',
      'outbreaks': 'Outbreaks',
      'chatbot': 'Chatbot',

      // Home Page
      'welcomeMessage': 'Welcome',
      'user': 'User',
      'welcomeToDashboard': 'Welcome to your health dashboard',
      'healthOverview': 'Health Overview',
      'quickActions': 'Quick Actions',

      // Greetings
      'goodMorning': 'Good Morning',
      'goodAfternoon': 'Good Afternoon',
      'goodEvening': 'Good Evening',

      // Stats Cards
      'upToDate': 'Up to date',
      'complete': 'Complete',
      'monitor': 'Monitor',
      'available': 'Available',
      'aiChat': 'AI Chat',

      // Quick Actions
      'emergencyHelpline': 'Emergency Helpline',
      'findHospital': 'Find Nearest Hospital',
      'getDirections': 'Get directions',
      'healthChatSupport': 'Health Chat Support',
      'available24x7': 'Available 24/7',

      // Vaccination Page
      'vaccinationDetails': 'Vaccination Details',
      'vaccinationStatus': 'Vaccination Status',
      'completed': 'Completed',
      'pending': 'Pending',
      'upcoming': 'Upcoming',
      'viewIdCard': 'View ID Card',
      'schedule': 'Schedule',
      'reminders': 'Reminders',
      'export': 'Export',

      // Health Records
      'healthRecords': 'Health Records',
      'appointments': 'Appointments',
      'notifications': 'Notifications',

      // Dialogs & Messages
      'comingSoon': 'Coming Soon!',
      'featureUnderDevelopment': 'This feature is under development and will be available in the next update.',
      'signOutError': 'Error signing out',

      // Common
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'ok': 'OK',
      'close': 'Close',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'yes': 'Yes',
      'no': 'No',
    },
  };

  String getText(String key) {
    return _allTexts[currentLanguage]?[key] ?? key;
  }

  Future<void> toggleLanguage() async {
    _isHindi = !_isHindi;
    await _saveLanguagePreference();
    notifyListeners();
  }

  Future<void> setLanguage(bool isHindi) async {
    if (_isHindi != isHindi) {
      _isHindi = isHindi;
      await _saveLanguagePreference();
      notifyListeners();
    }
  }

  Future<void> loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isHindi = prefs.getBool('isHindi') ?? true;
    notifyListeners();
  }

  Future<void> _saveLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isHindi', _isHindi);
  }
}