import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your LanguageService
import '../services/language_service.dart';

class OutbreaksPage extends StatefulWidget {
  @override
  _OutbreaksPageState createState() => _OutbreaksPageState();
}

class _OutbreaksPageState extends State<OutbreaksPage> {
  List<Map<String, dynamic>> outbreaks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  void _loadDummyData() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        outbreaks = [
          {
            'title': 'Dengue Fever Alert',
            'titleHindi': 'डेंगू बुखार चेतावनी',
            'location': 'Delhi, India',
            'locationHindi': 'दिल्ली, भारत',
            'severity': 'High',
            'severityHindi': 'उच्च',
            'description': 'Increased cases of dengue fever reported in the area. Take precautionary measures.',
            'descriptionHindi': 'क्षेत्र में डेंगू बुखार के मामले बढ़े हैं। सावधानी बरतें।',
            'date': DateTime.now(),
            'affectedCount': 156,
            'precautions': [
              'Use mosquito repellent',
              'Remove stagnant water',
              'Wear full sleeves'
            ],
            'precautionsHindi': [
              'मच्छर भगाने वाली दवा का प्रयोग करें',
              'ठहरे हुए पानी को हटाएं',
              'पूरी बाजू के कपड़े पहनें'
            ],
            'severity_level': 3,
            'isActive': true,
          },
          {
            'title': 'Chikungunya Outbreak',
            'titleHindi': 'चिकनगुनिया का प्रकोप',
            'location': 'Mumbai, India',
            'locationHindi': 'मुंबई, भारत',
            'severity': 'Medium',
            'severityHindi': 'मध्यम',
            'description': 'Several cases of chikungunya reported. Symptoms include fever and joint pain.',
            'descriptionHindi': 'चिकनगुनिया के कई मामले सामने आए हैं। लक्षणों में बुखार और जोड़ों में दर्द शामिल है।',
            'date': DateTime.now().subtract(Duration(days: 2)),
            'affectedCount': 89,
            'precautions': [
              'Maintain hygiene',
              'Avoid crowded places',
              'Consult doctor if symptoms appear'
            ],
            'precautionsHindi': [
              'स्वच्छता बनाए रखें',
              'भीड़भाड़ वाली जगहों से बचें',
              'लक्षण दिखने पर डॉक्टर से सलाह लें'
            ],
            'severity_level': 2,
            'isActive': true,
          },
          {
            'title': 'Malaria Cases Rising',
            'titleHindi': 'मलेरिया के मामले बढ़ रहे हैं',
            'location': 'Kolkata, India',
            'locationHindi': 'कोलकाता, भारत',
            'severity': 'Low',
            'severityHindi': 'कम',
            'description': 'Slight increase in malaria cases due to monsoon season.',
            'descriptionHindi': 'मानसून के कारण मलेरिया के मामलों में मामूली वृद्धि।',
            'date': DateTime.now().subtract(Duration(days: 5)),
            'affectedCount': 34,
            'precautions': [
              'Use bed nets',
              'Eliminate breeding sites',
              'Seek medical help for fever'
            ],
            'precautionsHindi': [
              'मच्छरदानी का प्रयोग करें',
              'प्रजनन स्थलों को समाप्त करें',
              'बुखार के लिए चिकित्सा सहायता लें'
            ],
            'severity_level': 1,
            'isActive': true,
          },
          {
            'title': 'Seasonal Flu Alert',
            'titleHindi': 'मौसमी फ्लू अलर्ट',
            'location': 'Pune, India',
            'locationHindi': 'पुणे, भारत',
            'severity': 'Medium',
            'severityHindi': 'मध्यम',
            'description': 'Common flu cases increasing with weather change.',
            'descriptionHindi': 'मौसम बदलने के साथ सामान्य फ्लू के मामले बढ़ रहे हैं।',
            'date': DateTime.now().subtract(Duration(days: 1)),
            'affectedCount': 78,
            'precautions': [
              'Wash hands frequently',
              'Wear masks in public',
              'Get adequate rest'
            ],
            'precautionsHindi': [
              'बार-बार हाथ धोएं',
              'सार्वजनिक स्थानों पर मास्क पहनें',
              'पर्याप्त आराम करें'
            ],
            'severity_level': 2,
            'isActive': true,
          },
          {
            'title': 'Food Poisoning Cases',
            'titleHindi': 'खाद्य विषाक्तता के मामले',
            'location': 'Bangalore, India',
            'locationHindi': 'बेंगलुरु, भारत',
            'severity': 'High',
            'severityHindi': 'उच्च',
            'description': 'Multiple food poisoning cases reported from local street vendors.',
            'descriptionHindi': 'स्थानीय स्ट्रीट वेंडरों से खाद्य विषाक्तता के कई मामले सामने आए हैं।',
            'date': DateTime.now().subtract(Duration(hours: 6)),
            'affectedCount': 45,
            'precautions': [
              'Eat from trusted sources',
              'Check food freshness',
              'Drink clean water only'
            ],
            'precautionsHindi': [
              'भरोसेमंद स्रोतों से खाना खाएं',
              'भोजन की ताजगी जांचें',
              'केवल साफ पानी पिएं'
            ],
            'severity_level': 3,
            'isActive': true,
          },
        ];
        isLoading = false;
      });
    });
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
      case 'उच्च':
        return Colors.red;
      case 'medium':
      case 'मध्यम':
        return Colors.orange;
      case 'low':
      case 'कम':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(int severityLevel) {
    switch (severityLevel) {
      case 3:
        return Icons.warning;
      case 2:
        return Icons.info;
      case 1:
        return Icons.notifications;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} minutes ago';
      }
      return '${diff.inHours} hours ago';
    } else if (diff.inDays == 1) {
      return '1 day ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF90CAF9),
              Color(0xFFBBDEFB),
              Colors.white,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.lightBlue[800],
              elevation: 0,
              title: Text(
                languageService.getText('outbreaks'),
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => _loadDummyData(),
                ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                ),
              )
                  : outbreaks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.health_and_safety, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      languageService.getText('noActiveOutbreaks'),
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: outbreaks.length,
                itemBuilder: (context, index) {
                  return _buildOutbreakCard(outbreaks[index], languageService);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutbreakCard(Map<String, dynamic> outbreak, LanguageService languageService) {
    String title = languageService.isHindi ?
    (outbreak['titleHindi'] ?? outbreak['title']) : outbreak['title'];
    String location = languageService.isHindi ?
    (outbreak['locationHindi'] ?? outbreak['location']) : outbreak['location'];
    String severity = languageService.isHindi ?
    (outbreak['severityHindi'] ?? outbreak['severity']) : outbreak['severity'];
    String description = languageService.isHindi ?
    (outbreak['descriptionHindi'] ?? outbreak['description']) : outbreak['description'];

    List<String> precautions = languageService.isHindi ?
    List<String>.from(outbreak['precautionsHindi'] ?? outbreak['precautions']) :
    List<String>.from(outbreak['precautions']);

    Color severityColor = _getSeverityColor(severity);
    IconData severityIcon = _getSeverityIcon(outbreak['severity_level'] ?? 1);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: severityColor.withOpacity(0.3), width: 1),
          ),
          child: Icon(severityIcon, color: severityColor, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: GoogleFonts.nunito(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    severity,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  _formatDate(outbreak['date'] as DateTime),
                  style: GoogleFonts.nunito(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50]!.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Color(0xFF1976D2)),
                          SizedBox(width: 8),
                          Text(
                            languageService.getText('description'),
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1976D2),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.nunito(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50]!.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield, size: 16, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            languageService.getText('precautions'),
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ...precautions.map((precaution) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                precaution,
                                style: GoogleFonts.nunito(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50]!.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            '${outbreak['affectedCount']} ${languageService.getText('affected')}',
                            style: GoogleFonts.nunito(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showMoreDetails(outbreak, languageService),
                      icon: Icon(Icons.info_outline, size: 16),
                      label: Text(
                        languageService.getText('moreDetails'),
                        style: GoogleFonts.nunito(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreDetails(Map<String, dynamic> outbreak, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.health_and_safety, color: Color(0xFF1976D2)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                languageService.getText('outbreakDetails'),
                style: GoogleFonts.nunito(),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${languageService.getText('emergencyContact')}: 102',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${languageService.getText('healthMinistryHelpline')}: 1075',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Text(
                languageService.getText('symptomsAdvice'),
                style: GoogleFonts.nunito(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getText('close'),
              style: GoogleFonts.nunito(color: Color(0xFF1976D2)),
            ),
          ),
        ],
      ),
    );
  }
}