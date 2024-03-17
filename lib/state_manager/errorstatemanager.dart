import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class errorText extends StateNotifier<String>{
  errorText(): super("");
  
  void giveError(){
    state = "Error";
  }


  void removeError(){
    state = "";
  }

  void giveAnswer(String ans){
    state = ans;
  }
}

class textColor extends StateNotifier<Color>{
  textColor(): super(Colors.white);

  void turnRed(){
    state = Colors.red;
  }

  void turnWhite(){
    state = Colors.white;
  }

}

final errorTextProvider = StateNotifierProvider<errorText, String>((ref) => errorText());
final textColorProvider = StateNotifierProvider<textColor, Color>((ref) => textColor());