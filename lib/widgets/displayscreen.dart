import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculator/state_manager/errorstatemanager.dart';
import 'package:calculator/state_manager/screenstatemanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends ConsumerWidget {
  @override
  
  Widget build(BuildContext context, WidgetRef ref) {
    Color textColor = ref.watch(textColorProvider);
    String errorText = ref.watch(errorTextProvider);
    List<String> displayScreenText = ref.watch(screenStateProvider);
    String obtainDisplay(){
      String display = "";
      for(final i in displayScreenText){
        display = display + i;
      }
      return display;
    }  
    return Column(
      children: [
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width * 97/100,
          height: MediaQuery.of(context).size.height*1/12,
          child: AutoSizeText(
            obtainDisplay(), 
            maxLines: 1,
            textAlign: TextAlign.right,
            style: TextStyle(
            color: textColor,
            fontSize: 32,
            ),
          ),
        ),
        Container(
          color: Colors.black,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1/12,
          child: Text(
            errorText,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 32,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}