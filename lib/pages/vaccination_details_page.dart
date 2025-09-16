import 'package:arogya_sathi_2/constant/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/language_service.dart';

class VaccinationDetailsPage extends StatefulWidget {
  final String userId;

  const VaccinationDetailsPage({super.key, required this.userId});

  @override
  _VaccinationDetailsPageState createState() => _VaccinationDetailsPageState();
}

class _VaccinationDetailsPageState extends State<VaccinationDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          languageService.getText('vaccinationDetails'),
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2), // Light Blue
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(widget.userId)
                .collection('vaccinations')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      SizedBox(height: 16),
                      Text(
                        languageService.getText('error'),
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Colors.red[300],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.vaccines_outlined, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No vaccination records found',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<DocumentSnapshot> vaccinations = snapshot.data!.docs;

              // Sort by priority and status
              vaccinations.sort((a, b) {
                Map<String, int> priorityOrder = {
                  'urgent': 0,
                  'high': 1,
                  'medium': 2,
                  'low': 3,
                };

                Map<String, int> statusOrder = {
                  'overdue': 0,
                  'due': 1,
                  'upcoming': 2,
                  'completed': 3,
                };

                int priorityComparison = priorityOrder[a['priority']]!
                    .compareTo(priorityOrder[b['priority']]!);

                if (priorityComparison != 0) return priorityComparison;

                return statusOrder[a['status']]!
                    .compareTo(statusOrder[b['status']]!);
              });

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(languageService),
                  ),
                  SliverToBoxAdapter(
                    child: _buildQuickActions(languageService),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        languageService.getText('vaccinationRecords'), // Add to language service if needed
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        var vaccination = vaccinations[index];
                        return _buildVaccinationCard(vaccination, languageService);
                      },
                      childCount: vaccinations.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: Consumer<LanguageService>(
        builder: (context, languageService, child) => FloatingActionButton.extended(
          onPressed: () => _showVaccinationIdCard(context, languageService),
          backgroundColor: Color(0xFF1976D2),
          icon: Icon(Icons.credit_card, color: Colors.white),
          label: Text(
            languageService.getText('viewIdCard'),
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LanguageService languageService) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)], // Light Blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(color: Colors.white);
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF1976D2),
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?['name'] ?? 'User Name',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ID: ${userData?['idNumber'] ?? 'N/A'}',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.cake, color: Colors.white.withOpacity(0.9), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'DOB: ${userData?['dateOfBirth'] ?? 'N/A'}',
                    style: GoogleFonts.nunito(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(LanguageService languageService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              languageService.getText('schedule'),
              Icons.schedule,
              Color(0xFF2196F3), // Light Blue
                  () => _showScheduleDialog(languageService),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              languageService.getText('reminders'),
              Icons.notifications,
              Color(0xFFFF9800), // Orange
                  () => _showRemindersDialog(languageService),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              languageService.getText('export'),
              Icons.download,
              Color(0xFF4CAF50), // Green
                  () => _exportData(languageService),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: box_decoration,
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationCard(DocumentSnapshot vaccination, LanguageService languageService) {
    var data = vaccination.data() as Map<String, dynamic>;
    String status = data['status'];
    String name = data['name'];
    String? nextDueDate = data['nextDueDate'];
    List doses = data['doses'] ?? [];

    Color statusColor = _getStatusColor(status);
    IconData statusIcon = _getStatusIcon(status);
    String statusText = _getStatusText(status, languageService);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          name,
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (nextDueDate != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${languageService.getText('next')} : $nextDueDate',
                    style: GoogleFonts.nunito(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (doses.isNotEmpty) ...[
                  Text(
                    languageService.getText('doseHistory'),
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  ...doses.map<Widget>((dose) => _buildDoseInfo(dose)).toList(),
                ] else ...[
                  Text(
                    languageService.getText('noDosesRecorded'),
                    style: GoogleFonts.nunito(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showDoseDetails(vaccination, languageService),
                      icon: Icon(Icons.info_outline, size: 16),
                      label: Text(
                        languageService.getText('details'),
                        style: GoogleFonts.nunito(),
                      ),
                    ),
                    if (status != 'completed') ...[
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _scheduleVaccination(vaccination, languageService),
                        icon: Icon(Icons.schedule, size: 16),
                        label: Text(
                          languageService.getText('schedule'),
                          style: GoogleFonts.nunito(),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statusColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseInfo(Map<String, dynamic> dose) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dose ${dose['doseNumber']}',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                dose['date'],
                style: GoogleFonts.nunito(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            dose['vaccine'],
            style: GoogleFonts.nunito(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
          Text(
            dose['location'],
            style: GoogleFonts.nunito(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'due':
        return Color(0xFF1976D2); // Light Blue
      case 'overdue':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'due':
        return Icons.schedule;
      case 'overdue':
        return Icons.warning;
      case 'upcoming':
        return Icons.upcoming;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status, LanguageService languageService) {
    switch (status) {
      case 'completed':
        return languageService.getText('completed');
      case 'due':
        return languageService.getText('dueNow'); // Add to language service if needed
      case 'overdue':
        return languageService.getText('overdue'); // Add to language service if needed
      case 'upcoming':
        return languageService.getText('upcoming');
      default:
        return 'Unknown';
    }
  }

  void _showVaccinationIdCard(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(widget.userId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>?;

            return Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ID Card Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'VACCINATION ID CARD',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          languageService.getText('ministryText'),
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ID Card Body
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF1976D2).withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF1976D2),
                                size: 32,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData?['name'] ?? 'N/A',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    'ID: ${userData?['idNumber'] ?? 'N/A'}',
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),

                        _buildIdCardField('Date of Birth', userData?['dateOfBirth'] ?? 'N/A'),
                        _buildIdCardField('Phone', userData?['phone'] ?? 'N/A'),
                        _buildIdCardField('Address', userData?['address'] ?? 'N/A'),

                        SizedBox(height: 16),

                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFE1F5FE), // Light blue background
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code, color: Colors.grey[600]),
                              SizedBox(width: 8),
                              Text(
                                'QR Code: ${userData?['idNumber'] ?? 'N/A'}',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getText('close'),
              style: GoogleFonts.nunito(color: Color(0xFF1976D2)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shareIdCard(languageService);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1976D2),
              foregroundColor: Colors.white,
            ),
            child: Text(
              languageService.getText('share'),
              style: GoogleFonts.nunito(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCardField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.nunito(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                color: Colors.grey[800],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageService.getText('schedule'),
          style: GoogleFonts.nunito(),
        ),
        content: Text(
          languageService.getText('featureUnderDevelopment'),
          style: GoogleFonts.nunito(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getText('ok'),
              style: GoogleFonts.nunito(),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemindersDialog(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageService.getText('reminders'),
          style: GoogleFonts.nunito(),
        ),
        content: Text(
          languageService.getText('featureUnderDevelopment'),
          style: GoogleFonts.nunito(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getText('ok'),
              style: GoogleFonts.nunito(),
            ),
          ),
        ],
      ),
    );
  }

  void _exportData(LanguageService languageService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageService.getText('featureUnderDevelopment'),
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }

  void _showDoseDetails(DocumentSnapshot vaccination, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Vaccination Details',
          style: GoogleFonts.nunito(),
        ),
        content: Text(
          'Detailed vaccination information will be shown here.',
          style: GoogleFonts.nunito(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getText('close'),
              style: GoogleFonts.nunito(),
            ),
          ),
        ],
      ),
    );
  }

  void _scheduleVaccination(DocumentSnapshot vaccination, LanguageService languageService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageService.getText('featureUnderDevelopment'),
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }

  void _shareIdCard(LanguageService languageService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageService.getText('featureUnderDevelopment'),
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }
}