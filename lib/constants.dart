import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
      hintStyle: TextStyle(
        color: Color(0xffBC9B9B),
        shadows: [
          Shadow(
            offset: Offset(2,2),
            blurRadius: 2,
          ),
        ]
      ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    //  when the TextFormField in unfocused
    ) ,
    focusColor: Colors.greenAccent,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffB0FACF)),
    //  when the TextFormField in focused
    ) ,
);
