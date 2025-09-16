import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'vaccination_details_page.dart';
import 'outbreak_page.dart';
import '../ChatBot/chatBot_page.dart';
import '../services/language_service.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic>? userData;

  HomePage({required this.userId, this.userData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 0;
  Map<String, dynamic>? _currentUserData;
  bool _isLoading = false;
  TextStyle _getTextStyle(LanguageService languageService, {
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
  }) {
    if (languageService.isHindi) {
      return GoogleFonts.notoSansDevanagari(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );
    } else {
      return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentUserData = widget.userData;
    if (widget.userId != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        setState(() {
          _currentUserData = doc.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  List<Widget> get _widgetOptions => <Widget>[
    _buildDashboard(),
    VaccinationDetailsPage(userId: widget.userId),
    ProfilePage(userData: _currentUserData, userId: widget.userId),
    OutbreaksPage(),
    ChatBotPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: Colors.lightBlue[50],
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.lightBlue[100]!, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: languageService.getText('dashboard'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.vaccines_outlined),
                  activeIcon: Icon(Icons.vaccines),
                  label: languageService.getText('vaccines'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: languageService.getText('profile'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.public_outlined),
                  activeIcon: Icon(Icons.public),
                  label: languageService.getText('outbreaks'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined),
                  activeIcon: Icon(Icons.chat),
                  label: languageService.getText('chatbot'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.lightBlue[600],
              unselectedItemColor: Colors.grey[400],
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboard() {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue[100]!,
                Colors.lightBlue[50]!,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildHeader(languageService),
                  SizedBox(height: 30),
                  // _buildWelcomeSection(languageService),
                  // SizedBox(height: 40),
                  _buildHealthOverview(languageService),
                  SizedBox(height: 40),
                  _buildQuickActions(languageService),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(LanguageService languageService) {
    String userName = _currentUserData?['name'] ?? languageService.getText('user');
    String greeting = _getGreeting(languageService);

    return Container(
      padding: EdgeInsets.fromLTRB(4, 20, 4, 16),
      child: Column(
        children: [
          // Top row with controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // App logo/brand area
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[600],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.health_and_safety_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                    languageService.getText('appTitle'),
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Right controls
              Row(
                children: [
                  // Notification bell


                  SizedBox(width: 12),

                  // Language toggle
                  GestureDetector(
                    onTap: () => languageService.toggleLanguage(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.lightBlue[100]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.language_rounded,
                            size: 18,
                            color: Colors.lightBlue[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            languageService.isHindi ? 'EN' : 'हिं',
                            style: GoogleFonts.nunito(
                              color: Colors.lightBlue[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // Logout button
                  GestureDetector(
                    onTap: _isLoading ? null : _signOut,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.lightBlue[100]!,
                          width: 1,
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.lightBlue[600],
                          strokeWidth: 2,
                        ),
                      )
                          : Icon(
                        Icons.logout_rounded,
                        color: Colors.lightBlue[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Welcome section
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          greeting,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: Colors.lightBlue[600],
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          _getGreetingIcon(),
                          color: Colors.amber[600],
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      userName,
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        color: Colors.lightBlue[900],
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      return Icons.wb_sunny_outlined;
    } else {
      return Icons.nights_stay_rounded;
    }
  }

  Widget _buildHealthOverview(LanguageService languageService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics_outlined, color: Colors.lightBlue[700], size: 28),
            SizedBox(width: 8),
            Text(
              languageService.getText('healthOverview'),
              style:  GoogleFonts.nunitoSans( textStyle: TextStyle(
                fontSize: 20,
                color: Colors.lightBlue[800],
                fontWeight: FontWeight.w700,
              ),)
            ),
          ],
        ),
        SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              Icons.vaccines_outlined,
              languageService.getText('vaccines'),
              languageService.getText('upToDate'),
              Colors.green[400]!,
                  () => setState(() => _selectedIndex = 1),
            ),
            _buildStatCard(
              Icons.person_outline,
              languageService.getText('profile'),
              languageService.getText('complete'),
              Colors.blue[400]!,
                  () => setState(() => _selectedIndex = 2),
            ),
            _buildStatCard(
              Icons.public_outlined,
              languageService.getText('outbreaks'),
              languageService.getText('monitor'),
              Colors.orange[400]!,
                  () => setState(() => _selectedIndex = 3),
            ),
            _buildStatCard(
              Icons.chat_outlined,
              languageService.getText('aiChat'),
              languageService.getText('available'),
              Colors.purple[400]!,
                  () => setState(() => _selectedIndex = 4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.lightBlue[100]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style:  GoogleFonts.nunitoSans( textStyle: TextStyle(
                fontSize: 14,
                color: Colors.lightBlue[800],
                fontWeight: FontWeight.w700,
              ),)
            ),
            Text(
              subtitle,
              style:  GoogleFonts.nunitoSans( textStyle: TextStyle(
                fontSize: 12,
                color: Colors.lightBlue[600],
                fontWeight: FontWeight.w600,
              ),)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(LanguageService languageService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flash_on_outlined, color: Colors.lightBlue[700], size: 20),
            SizedBox(width: 8),
            Text(
              languageService.getText('quickActions'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.lightBlue[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildActionItem(
          Icons.phone_outlined,
          languageService.getText('emergencyHelpline'),
          '108',
              () => _showComingSoon(languageService),
        ),
        SizedBox(height: 16),
        _buildActionItem(
          Icons.location_on_outlined,
          languageService.getText('findHospital'),
          languageService.getText('getDirections'),
              () => _showComingSoon(languageService),
        ),
        SizedBox(height: 16),
        _buildActionItem(
          Icons.chat_outlined,
          languageService.getText('healthChatSupport'),
          languageService.getText('available24x7'),
              () => setState(() => _selectedIndex = 4),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.lightBlue[100]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.lightBlue[600], size: 22),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.lightBlue[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.lightBlue[600],
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.lightBlue[400]),
          ],
        ),
      ),
    );
  }

  String _getGreeting(LanguageService languageService) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return languageService.getText('goodMorning');
    } else if (hour < 17) {
      return languageService.getText('goodAfternoon');
    } else {
      return languageService.getText('goodEvening');
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      final languageService = Provider.of<LanguageService>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${languageService.getText('signOutError')}: ${e.toString()}'),
          backgroundColor: Colors.lightBlue[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showComingSoon(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.lightBlue[100]!, width: 1),
          ),
          title: Row(
            children: [
              Icon(Icons.construction_outlined, color: Colors.lightBlue[600]),
              SizedBox(width: 12),
              Text(
                languageService.getText('comingSoon'),
                style: _getTextStyle(
                  languageService,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.lightBlue[800]!,
                ),
              ),
            ],
          ),
          content: Text(
            languageService.getText('featureUnderDevelopment'),
            style: _getTextStyle(
              languageService,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.lightBlue[700]!,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                languageService.getText('ok'),
                style: TextStyle(color: Colors.lightBlue[600]),
              ),
            ),
          ],
        );
      },
    );
  }
}