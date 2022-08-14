import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showShareDialog(context, screenWidth,String temp) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            '$temp',
            style: GoogleFonts.aladin(
              color: Colors.white,
            ),
          ),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: screenWidth * 0.1,
              ),
              Flexible(
                child: Text(
                  'Please Wait For A While....',
                  style: GoogleFonts.aladin(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
