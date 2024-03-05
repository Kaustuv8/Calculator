import 'package:calculator/data/buttonList.dart';
import 'package:calculator/data/buttonclass.dart';
import 'package:calculator/function/evaluation.dart';
import 'package:calculator/state_manager/errorstatemanager.dart';
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
  final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 59, 57, 57),
    ),
  );

  List<Button>giveList(int choice){
    if(choice == 1){
      return buttonList;
    }
    return buttonList2;
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
                for (final i in giveList(layoutSelector))
                  InkWell(
                    onTap: () {
                      ref.read(errorTextProvider.notifier).removeError();
                      ref.read(textColorProvider.notifier).turnWhite();
                      if(i.type == ButtonClass.evaluation){
                        conclude(ref.read(screenStateProvider), evaluate(ref.read(screenStateProvider)));
                        print(save); 
                        if(!ref.read(screenStateProvider.notifier).errorNotPresent()){
                          ref.read(errorTextProvider.notifier).giveError();
                          ref.read(textColorProvider.notifier).turnRed();
                        }
                      }
                      ref.read(screenStateProvider.notifier).buttonReact(i);
                    },
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
                      child: Text(
                        i.letter,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 255, 255)
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