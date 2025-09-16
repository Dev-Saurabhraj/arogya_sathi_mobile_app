import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/language_service.dart';

class LanguageToggleWidget extends StatelessWidget {
  final bool showInHeader;

  const LanguageToggleWidget({Key? key, this.showInHeader = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF4682B4)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (!languageService.isHindi) {
                    languageService.toggleLanguage();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: languageService.isHindi ? Color(0xFF4682B4) : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      bottomLeft: Radius.circular(3),
                    ),
                  ),
                  child: Text(
                    'हिंदी',
                    style: TextStyle(
                      color: languageService.isHindi ? Colors.white : Color(0xFF4682B4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 25,
                color: Color(0xFF4682B4),
              ),
              GestureDetector(
                onTap: () {
                  if (languageService.isHindi) {
                    languageService.toggleLanguage();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: !languageService.isHindi ? Color(0xFF4682B4) : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: !languageService.isHindi ? Colors.white : Color(0xFF4682B4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
