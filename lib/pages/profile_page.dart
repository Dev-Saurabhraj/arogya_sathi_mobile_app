import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/language_service.dart';

// Import your LanguageService
// import 'language_service.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String? userId;

  ProfilePage({this.userData, this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _currentUserData;
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers for editing
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUserData = widget.userData;
    if (widget.userId != null) {
      _loadUserData();
    }
    _populateControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _populateControllers() {
    if (_currentUserData != null) {
      _nameController.text = _currentUserData!['name'] ?? '';
      _phoneController.text = _currentUserData!['phone'] ?? '';
      _ageController.text = _currentUserData!['age']?.toString() ?? '';
      _pincodeController.text = _currentUserData!['pincode'] ?? '';
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
        _populateControllers();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _updateProfile(LanguageService languageService) async {
    if (widget.userId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'pincode': _pincodeController.text.trim(),
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(widget.userId)
          .update(updatedData);

      setState(() {
        _currentUserData = {..._currentUserData!, ...updatedData};
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(
                languageService.getText('success'),
                style: GoogleFonts.nunito(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Color(0xFF1976D2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${languageService.getText('error')}: ${e.toString()}',
                  style: GoogleFonts.nunito(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(// Light blue background
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(languageService),
              _buildProfileCard(languageService),
              _buildPreferencesCard(languageService),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LanguageService languageService) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                languageService.getText('profile'),
                style: GoogleFonts.nunito(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                languageService.getText('manageHealthInfo'), // Add to language service
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (!_isEditing) {
                _populateControllers(); // Reset controllers if canceling edit
              }
            },
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(LanguageService languageService) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFBBDEFB), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF1976D2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: Color(0xFF1976D2),
              ),
            ),

            SizedBox(height: 20),

            // Name
            _isEditing
                ? _buildEditField(
                languageService.getText('fullName'),
                _nameController,
                Icons.person
            )
                : Text(
              _currentUserData?['name'] ?? languageService.getText('user'),
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),

            SizedBox(height: 20),

            // Profile Information
            if (!_isEditing) ...[
              _buildInfoRow(
                  Icons.phone,
                  languageService.getText('mobileNumber'),
                  _currentUserData?['phone'] ?? 'N/A'
              ),
              _buildInfoRow(
                  Icons.cake,
                  languageService.getText('age'), // Add to language service if needed
                  '${_currentUserData?['age'] ?? 'N/A'} years'
              ),
              _buildInfoRow(
                  Icons.location_on,
                  languageService.getText('pincode'), // Add to language service if needed
                  _currentUserData?['pincode'] ?? 'N/A'
              ),
            ] else ...[
              _buildEditField(
                  languageService.getText('mobileNumber'),
                  _phoneController,
                  Icons.phone
              ),
              SizedBox(height: 15),
              _buildEditField(languageService.getText('age'), _ageController, Icons.cake),
              SizedBox(height: 15),
              _buildEditField(languageService.getText('pincode'), _pincodeController, Icons.location_on),
            ],

            SizedBox(height: 20),

            // Update Button (when editing)
            if (_isEditing) ...[
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF1976D2), width: 1),
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _updateProfile(languageService),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        languageService.getText('save'),
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.nunito(),
        prefixIcon: Icon(icon, color: Color(0xFF1976D2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFBBDEFB), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFBBDEFB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
        filled: true,
        fillColor: Color(0xFFF3F8FF),
      ),
      style: GoogleFonts.nunito(),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE1F5FE), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF1976D2)),
          SizedBox(width: 15),
          Text(
            '$label:',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                color: Colors.grey[800],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(LanguageService languageService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFBBDEFB), width: 1),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF1976D2)),
              SizedBox(width: 10),
              Text(
                languageService.getText('preferencesSettings'), // Add to language service if needed
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildPreferenceItem(
            Icons.notifications,
            languageService.getText('notifications'),
            languageService.getText('manageAlerts'), // Add to language service if needed
                () => _showComingSoon(languageService),
          ),
          _buildPreferenceItem(
            Icons.language,
            languageService.getText('language'), // Add to language service if needed
            languageService.getText('changeAppLanguage'), // Add to language service if needed
                () => _showLanguageDialog(languageService),
          ),
          _buildPreferenceItem(
            Icons.privacy_tip,
            languageService.getText('privacySettings'), // Add to language service if needed
            languageService.getText('controlYourData'), // Add to language service if needed
                () => _showComingSoon(languageService),
          ),
          _buildPreferenceItem(
            Icons.help,
            languageService.getText('help&Support'), // Add to language service if needed
            languageService.getText('getAssistance'), // Add to language service if needed
                () => _showComingSoon(languageService),
          ),
          _buildPreferenceItem(
            Icons.logout,
            languageService.getText('signOut'), // Add to language service if needed
            languageService.getText('logOutOfYourAccount'), // Add to language service if needed
                () => _showSignOutDialog(languageService),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : Color(0xFFF3F8FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isDestructive ? Colors.red[200]! : Color(0xFFE1F5FE),
              width: 1
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Color(0xFF1976D2),
              size: 24,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.grey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.language, color: Color(0xFF1976D2)),
              SizedBox(width: 10),
              Text(
                'Select Language',
                style: GoogleFonts.nunito(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Radio<bool>(
                  value: false,
                  groupValue: languageService.isHindi,
                  onChanged: (value) {
                    languageService.setLanguage(false);
                    Navigator.of(context).pop();
                  },
                  activeColor: Color(0xFF1976D2),
                ),
                title: Text(
                  'English',
                  style: GoogleFonts.nunito(),
                ),
                onTap: () {
                  languageService.setLanguage(false);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Radio<bool>(
                  value: true,
                  groupValue: languageService.isHindi,
                  onChanged: (value) {
                    languageService.setLanguage(true);
                    Navigator.of(context).pop();
                  },
                  activeColor: Color(0xFF1976D2),
                ),
                title: Text(
                  'हिंदी',
                  style: GoogleFonts.nunito(),
                ),
                onTap: () {
                  languageService.setLanguage(true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showComingSoon(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.construction, color: Color(0xFF1976D2)),
              SizedBox(width: 10),
              Text(
                languageService.getText('comingSoon'),
                style: GoogleFonts.nunito(),
              ),
            ],
          ),
          content: Text(
            languageService.getText('featureUnderDevelopment'),
            style: GoogleFonts.nunito(color: Colors.grey[600]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                languageService.getText('ok'),
                style: GoogleFonts.nunito(color: Color(0xFF1976D2)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSignOutDialog(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Sign Out', // Add to language service if needed
                style: GoogleFonts.nunito(),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to sign out?', // Add to language service if needed
            style: GoogleFonts.nunito(color: Colors.grey[600]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                languageService.getText('cancel'),
                style: GoogleFonts.nunito(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _auth.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${languageService.getText('signOutError')}: ${e.toString()}',
                        style: GoogleFonts.nunito(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Sign Out', // Add to language service if needed
                style: GoogleFonts.nunito(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}