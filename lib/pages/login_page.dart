import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/language_toggel_widget.dart';
import '../services/language_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          body: Container(
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
                child: Column(
                  children: [
                    _buildModernHeader(languageService),
                    SizedBox(height: 10),
                    _buildLoginForm(languageService),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernHeader(LanguageService languageService) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        children: [
          // Top controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Government badge
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
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'भारत सरकार',
                      style: GoogleFonts.notoSansDevanagari(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Language toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.lightBlue[100]!,
                    width: 1,
                  ),
                ),
                child: LanguageToggleWidget(),
              ),
            ],
          ),

          SizedBox(height: 40),

          // App branding section
          Column(
            children: [
              // App icon
              Text(
                languageService.getText('appTitle'),
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.lightBlue[900],
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.lightBlue[200]!,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  size: 40,
                  color: Colors.lightBlue[600],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(LanguageService languageService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.lightBlue[100]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Form Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightBlue[600],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  languageService.getText('formTitle'),
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Form Fields
          Padding(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text
                  Text(
                    languageService.getText('welcomeMessage') ?? 'Welcome! Please enter your details to continue.',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.lightBlue[700],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24),

                  // Name field
                  Text(
                    languageService.getText('fullName'),
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.lightBlue[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.lightBlue[800],
                    ),
                    decoration: InputDecoration(
                      hintText: languageService.getText('enterFullName') ?? 'Enter your full name',
                      hintStyle: GoogleFonts.nunito(
                        color: Colors.lightBlue[400],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: Colors.lightBlue[600],
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.lightBlue[200]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.lightBlue[200]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.lightBlue[600]!,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageService.getText('nameError');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Phone field
                  Text(
                    languageService.getText('mobileNumber'),
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.lightBlue[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.lightBlue[800],
                    ),
                    decoration: InputDecoration(
                      hintText: languageService.getText('enterMobileNumber') ?? 'Enter your mobile number',
                      hintStyle: GoogleFonts.nunito(
                        color: Colors.lightBlue[400],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: Colors.lightBlue[600],
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.lightBlue[200]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.lightBlue[200]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.lightBlue[600]!,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageService.getText('mobileError');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32),

                  // Submit button
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[600],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.lightBlue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageService.getText('submit'),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Footer text
                  Center(
                    child: Text(
                      languageService.getText('secureLogin') ?? 'Your data is secure with us',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.lightBlue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }
}