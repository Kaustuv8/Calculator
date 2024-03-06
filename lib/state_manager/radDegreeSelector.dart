import 'package:calculator/data/buttonclass.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';


class radDegSelector extends StateNotifier<String>{
  radDegSelector(): super("rad");


  void switchState(){
    if(state == "rad"){
      state = "deg";
    }
    else{
      state = "rad";
    }
  }

  Color giveColor(Button B){
    if(state == B.letter){
      return Colors.red;
    }
    else{
      return Colors.white;
    }
  }

}

final radDegSelectorProvider = StateNotifierProvider<radDegSelector,String>((ref) => radDegSelector());