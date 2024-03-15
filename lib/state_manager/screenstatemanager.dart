import 'package:calculator/function/evaluation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator/data/buttonclass.dart';







void load(List<String> state){
    save = state;
  }

  void dump(List<String> state){
    save = [];
  }

  void conclude(List<String> state, String ans){
    save = [...state, '=', ans];
  }

List<String>save = [];
class ScreenState extends StateNotifier<List<String>>{
  ScreenState() : super([]);

  
  

  bool errorNotPresent(String inputType){
    if(evaluate(state, inputType) == "Error"){
      return false;
    }
    return true;
  }

  void buttonReact(Button B, String inputType){


    

    if (B.type == ButtonClass.valuenentry){
      bool tenExpo = false;
      bool eExpo = false;
      if(B.letter == "10^"){
        tenExpo = true;
      }
      if(B.letter == "eˣ"){
        eExpo = true;
      }
      if(
        state.isNotEmpty 
        && (state[state.length - 1].contains(RegExp(r'[0-9]')) || state[state.length-1].contains("π") || state[state.length-1].contains("e")) 
        && ("102345678900.%arcsincarcosarctanlogln√πe".contains(B.letter) || tenExpo || eExpo)
        ){
            String fin = state.removeLast();
            if(
              (fin.contains("%") && !B.letter.contains("%")) || "arcsinarccosarctanlogln√".contains(B.letter) 
            )
            {
                state = [...state, fin, "×", B.letter];
            }
            else{
                if(tenExpo){
                  state = [...state, "${fin}10", "^"];
                }
                else if(eExpo){
                  state = [...state, "${fin}e", "^"];
                }
                else{
                  state = [...state, fin + B.letter];
                }
                
            }
            if("arcsinarccosarctanlogln√".contains(B.letter)){
              state = [...state, "("];
            }
        }
      else if(state.isNotEmpty && "+-×÷".contains(B.letter) && "+-×÷".contains(state[state.length-1])){
        if(B.letter == "-" && "×÷".contains(state[state.length-1])){
          state = [...state, B.letter];
        }
        else{
          state.removeAt(state.length-1);
          state = [...state, B.letter];
        }
      }
      else{
        if(tenExpo){
          state = [...state, "10", "^"];
        }
        else if(eExpo){
          state = [...state, "e", "^"];
        }
        else{
          state = [...state, B.letter];
          if("arcsinarccosarctanlogln√".contains(B.letter)){
            state = [...state, "("];
          }
        }
      }
    }
    else if(B.type == ButtonClass.alldeletion){
      state = [];
      dump(state);
    }
    else if(B.type == ButtonClass.deletion){
      if (state.isNotEmpty){      
        String prev = state.removeLast();
        if("0123456789.".contains(prev[0]) && prev.length > 1){
          state = [...state, prev.substring(0, prev.length-1)];
        }
        else{
        state = [...state];
        }
      }
    }
    else if(B.type == ButtonClass.evaluation){
      String evaluation = evaluate(state, inputType);
      if(evaluation != "Error"){
        state = [evaluation];
      }
    }
  }
}

final screenStateProvider = StateNotifierProvider<ScreenState,List<String>>((ref) => ScreenState());
