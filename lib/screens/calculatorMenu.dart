import 'package:calculator/data/buttonList.dart';
import 'package:calculator/data/buttonclass.dart';
import 'package:calculator/data/history.dart';
import 'package:calculator/function/evaluation.dart';
import 'package:calculator/screens/historyScreen.dart';
import 'package:calculator/state_manager/errorstatemanager.dart';
import 'package:calculator/state_manager/radDegreeSelector.dart';
import 'package:calculator/state_manager/screenstatemanager.dart';
import 'package:flutter/material.dart';
import 'package:calculator/widgets/displayscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class CalculatorMenu extends ConsumerStatefulWidget {
  const CalculatorMenu({super.key});
  @override
  ConsumerState<CalculatorMenu> createState() => _CalculatorMenuState();
}

class _CalculatorMenuState extends ConsumerState<CalculatorMenu> {
  Color textColor = Colors.white;
  int layoutSelector = 1;
  String inputType = "rad";
  bool inverseButtons = false;

  final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 59, 57, 57),
    ),
  );

  void changeType(String B){
  if (B == "deg"){
    inputType = "deg";
  }
  else{
    inputType = "rad";
  }
}

  List<Button>giveList(int choice, bool inverseButtons){
    if(choice == 1){
      return buttonList;
    }
    if(inverseButtons){
      return inverseButtonList;
    }
    return buttonList2;
  }

  Color giveButtonColour(Button B){
    if(B.type == ButtonClass.evaluation){
      return Colors.blueAccent;
    }
    if("12345678900.".contains(B.letter) && B.type == ButtonClass.valuenentry){
      return const Color.fromARGB(255, 62, 61, 61);
    }
    return const Color.fromARGB(255, 37, 36, 36); 
  }

  Color giveLetterColour(Button B){
    if(B.type == ButtonClass.valuemod){
      if(inputType == "rad"){
        if(B.letter == "rad"){
          return Colors.red;
        }
        else{
          return Colors.white;
        }
      }
    else{
      if(B.letter == "rad"){
        return Colors.white;
      }
      else{
        return Colors.red;
      }
    }
  }
  
  return Colors.white;
}

  int giveCrossAxisCount (int choice){
    if(choice == 1){
      return 4;
    }
    return 5;
  }


  

  @override


  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: ListTile(
              leading: IconButton(
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    layoutSelector*=-1;
                  });
                },
                icon: layoutSelector == 1?
                const Icon(Icons.open_in_full):
                const Icon(Icons.close_fullscreen),
                ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (
                        (context) => ( historyScreen()
                        )
                      )
                    )
                  );
                },
              )
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 0,
                width: 0,
                child: Text(ref.watch(radDegSelectorProvider))),
               DisplayScreen(),
               const SizedBox(height: 20,),
               GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: giveCrossAxisCount(layoutSelector),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                children: [
                for (final i in giveList(layoutSelector, inverseButtons))
                  InkWell(
                    onTap: () {
                      if(i.type == ButtonClass.layoutmod){
                        setState(() {
                          inverseButtons = !inverseButtons;
                        }); 
                      }
                      if(i.type == ButtonClass.valuemod){
                        if(ref.read(radDegSelectorProvider) != i.letter){
                          ref.read(radDegSelectorProvider.notifier).switchState();
                        }
                      }
                      ref.read(errorTextProvider.notifier).removeError();
                      ref.read(textColorProvider.notifier).turnWhite();
                      if(i.type == ButtonClass.evaluation && ref.read(screenStateProvider).isNotEmpty){
                        String answer = evaluate(ref.read(screenStateProvider), ref.read(radDegSelectorProvider));
                        if(answer=="Error"){
                          ref.read(errorTextProvider.notifier).giveError();
                          ref.read(textColorProvider.notifier).turnRed();
                        }
                        else{
                          ref.read(textColorProvider.notifier).turnWhite();
                          ref.read(errorTextProvider.notifier).giveAnswer(answer);
                          conclude(
                          ref.read(screenStateProvider), 
                          answer,
                        );
                          historyList = [...historyList, save];
                          print(historyList);
                        }
                      }
                      ref.read(screenStateProvider.notifier).buttonReact(i, ref.read(radDegSelectorProvider));
                    },
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: giveButtonColour(i),
                      child: Text(
                        i.letter,
                        style: TextStyle(
                          fontSize: 24,
                          color: ref.read(radDegSelectorProvider.notifier).giveColor(i),
                        ),
                      ),
                    ),
                  ),
                ],
               ),
            ]
          ),
        );
  }
}