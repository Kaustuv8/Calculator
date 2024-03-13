import 'package:calculator/data/buttonList.dart';
import 'package:calculator/data/buttonclass.dart';
import 'package:calculator/function/evaluation.dart';
import 'package:calculator/state_manager/errorstatemanager.dart';
import 'package:calculator/state_manager/radDegreeSelector.dart';
import 'package:calculator/state_manager/screenstatemanager.dart';
import 'package:flutter/material.dart';
import 'package:calculator/widgets/displayscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  
  runApp(const ProviderScope(child: CalculatorMenu()));
}

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
    return MaterialApp(
      home: Scaffold(
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
                icon: const Icon(
                  Icons.square_rounded)
                ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.scale,
                  color: Colors.white,),
                onPressed: () {},)
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
                      if(i.type == ButtonClass.evaluation){
                        conclude(
                          ref.read(screenStateProvider), 
                          evaluate(
                            ref.read(screenStateProvider), 
                            ref.read(radDegSelectorProvider),
                          ),
                        );
                        print(save); 
                        if(!ref.read(screenStateProvider.notifier).errorNotPresent(inputType)){
                          ref.read(errorTextProvider.notifier).giveError();
                          ref.read(textColorProvider.notifier).turnRed();
                        }
                      }
                      ref.read(screenStateProvider.notifier).buttonReact(i, ref.read(radDegSelectorProvider));
                    },
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
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
        ),
    );
  }
}