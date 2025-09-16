import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../services/language_service.dart';
// Import your language service
// import 'language_service.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Speech to Text
  late stt.SpeechToText _speech;
  bool _isListening = false;

  // Text to Speech
  late FlutterTts _flutterTts;
  bool _isSpeaking = false;

  // Language Service (assuming you have it imported)
   final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();
    _addWelcomeMessage();
  }

  void _initializeSpeech() async {
    _speech = stt.SpeechToText();
    await _speech.initialize();
  }

  void _initializeTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("hi-IN"); // Default to Hindi
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'text': _getText('chatbotWelcome'),
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    });
  }

  // Mock language service getText method
  String _getText(String key) {
    final bool isHindi = _languageService.isHindi; // Replace with _languageService.isHindi

    final Map<String, Map<String, String>> texts = {
      'hindi': {
        'chatbotWelcome': 'नमस्ते! मैं आरोग्य हूँ, आपका स्वास्थ्य सहायक। आज मैं आपकी कैसे मदद कर सकता हूँ?',
        'askHealthQuestion': 'स्वास्थ्य प्रश्न पूछें...',
        'listening': 'सुन रहा हूँ...',
        'commonQueries': 'सामान्य प्रश्न',
        'vaccinationInfo': 'टीकाकरण की जानकारी',
        'symptomChecker': 'लक्षण चेकर',
        'emergencyContacts': 'आपातकालीन संपर्क',
        'healthTips': 'स्वास्थ्य सुझाव',
      },
      'english': {
        'chatbotWelcome': 'Hello! I am Arogya, your health assistant. How can I help you today?',
        'askHealthQuestion': 'Ask a health question...',
        'listening': 'Listening...',
        'commonQueries': 'Common Queries',
        'vaccinationInfo': 'Vaccination Info',
        'symptomChecker': 'Symptom Checker',
        'emergencyContacts': 'Emergency Contacts',
        'healthTips': 'Health Tips',
      },
    };

    return texts[isHindi ? 'hindi' : 'english']?[key] ?? key;
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    // Generate bot response
    String botResponse = _generateResponse(text.toLowerCase());

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          'text': botResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
    });
  }

  String _generateResponse(String input) {
    final bool isHindi = _languageService.isHindi; // Replace with _languageService.isHindi

    if (isHindi) {
      // Hindi responses
      if (input.contains('टीका') || input.contains('वैक्सीन')) {
        return 'टीकाकरण आपको और आपके समुदाय को गंभीर बीमारियों से बचाने में मदद करता है। कोविड-19, पोलियो, और अन्य टीके उपलब्ध हैं।';
      } else if (input.contains('बुखार') || input.contains('फीवर')) {
        return 'बुखार के लिए डॉक्टर से सलाह लेना सबसे अच्छा है। तुरंत राहत के लिए ठंडी पट्टी का उपयोग करें और पानी पिएं।';
      } else if (input.contains('सिरदर्द')) {
        return 'सिरदर्द के लिए आराम करें, पानी पिएं, और अगर दर्द बना रहता है तो डॉक्टर से मिलें।';
      } else if (input.contains('आपातकाल') || input.contains('emergency')) {
        return 'आपातकालीन स्थिति में 108 डायल करें। स्वास्थ्य मंत्रालय हेल्पलाइन: 1075';
      } else if (input.contains('नमस्ते') || input.contains('hello')) {
        return 'नमस्ते! मैं आपकी स्वास्थ्य संबंधी किसी भी समस्या में मदद करने के लिए यहाँ हूँ।';
      }
      return 'आपके प्रश्न के लिए धन्यवाद। एक स्वास्थ्य विशेषज्ञ जल्द ही आपसे संपर्क करेगा।';
    } else {
      // English responses
      if (input.contains('vaccination') || input.contains('vaccine')) {
        return 'Vaccinations help protect you and your community from serious diseases. COVID-19, Polio, and other vaccines are available.';
      } else if (input.contains('fever')) {
        return 'For fever, it\'s best to consult a doctor. You can try a cold compress and drink plenty of water for immediate relief.';
      } else if (input.contains('headache')) {
        return 'For headaches, try to rest, stay hydrated, and if pain persists, consult a healthcare provider.';
      } else if (input.contains('emergency')) {
        return 'In case of emergency, dial 108. Health Ministry Helpline: 1075';
      } else if (input.contains('hello') || input.contains('hi')) {
        return 'Hello! I\'m here to help you with any health-related concerns you may have.';
      }
      return 'Thank you for your question. A health expert will get back to you soon.';
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startListening() async {
    if (!_isListening && _speech.isAvailable) {
      setState(() => _isListening = true);
      String currentLanguage = true ? 'hi_IN' : 'en_US'; // Replace with language service
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        },
        localeId: currentLanguage,
      );
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _speak(String text) async {
    if (!_isSpeaking) {
      setState(() => _isSpeaking = true);
      String language = true ? 'hi-IN' : 'en-US'; // Replace with language service
      await _flutterTts.setLanguage(language);
      await _flutterTts.speak(text);

      _flutterTts.setCompletionHandler(() {
        setState(() => _isSpeaking = false);
      });
    }
  }

  void _addQuickQuery(String query) {
    _textController.text = query;
    _handleSubmitted(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue[50]!,
              Colors.lightBlue[100]!,
              Colors.white,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue[300]!, Colors.lightBlue[600]!],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue[200]!, width: 1),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  _getText('Arogya Sathi'),
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                    child: Icon(Icons.person, color: Colors.lightBlue[600], size: 24),)
              ),
            ),

            // Quick Actions
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getText('commonQueries'),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickActionChip(_getText('vaccinationInfo'), Icons.vaccines),
                        _buildQuickActionChip(_getText('symptomChecker'), Icons.health_and_safety),
                        _buildQuickActionChip(_getText('emergencyContacts'), Icons.emergency),
                        _buildQuickActionChip(_getText('healthTips'), Icons.tips_and_updates),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Input Area
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border(
                  top: BorderSide(color: Colors.lightBlue[200]!, width: 1),
                ),
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _addQuickQuery(label),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.lightBlue[300]!, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.lightBlue[600]),
              SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.lightBlue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.lightBlue[600],
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.lightBlue[600]
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                border: Border.all(
                  color: isUser ? Colors.lightBlue[600]! : Colors.lightBlue[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  if (!isUser) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _speak(message['text']),
                          child: Icon(
                            _isSpeaking ? Icons.volume_up : Icons.volume_off,
                            size: 16,
                            color: Colors.lightBlue[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.lightBlue[100],
              child: Icon(Icons.person, size: 16, color: Colors.lightBlue[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.lightBlue[300]!, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              style: GoogleFonts.nunito(),
              decoration: InputDecoration(
                hintText: _getText('askHealthQuestion'),
                hintStyle: GoogleFonts.nunito(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              maxLines: null,
            ),
          ),
          // Mic Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: _isListening ? _stopListening : _startListening,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isListening ? Colors.red[100] : Colors.lightBlue[50],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isListening ? Colors.red[300]! : Colors.lightBlue[300]!,
                    width: 1,
                  ),
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red[600] : Colors.lightBlue[600],
                  size: 20,
                ),
              ),
            ),
          ),
          // Send Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _handleSubmitted(_textController.text),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[600],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.lightBlue[600]!, width: 1),
                ),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }
}