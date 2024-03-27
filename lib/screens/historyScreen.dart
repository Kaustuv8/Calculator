import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculator/data/history.dart';
import 'package:calculator/state_manager/errorstatemanager.dart';
import 'package:calculator/state_manager/screenstatemanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class historyScreen extends ConsumerStatefulWidget{
  const historyScreen({super.key});
  @override
  ConsumerState<historyScreen> createState() => _HistoryScreenState(); 

}

class _HistoryScreenState extends ConsumerState<historyScreen>{

  String getEquation(List<String> hist){
    String eq = "";
    for(final i in hist){
      eq+=" ${i.trim()} ";
    }
    return eq;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "History",
          style: TextStyle(
                  fontSize: 18,
                ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(final i in historyList)
              InkWell(
                onTap: (){
                  ref.watch(screenStateProvider.notifier).loadState(i);
                  ref.watch(errorTextProvider.notifier).giveAnswer(i.last);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromARGB(255, 44, 44, 44),
                    child: AutoSizeText(
                      getEquation(i),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height:100),
          ],
        )
      ),
    );
  }
} 