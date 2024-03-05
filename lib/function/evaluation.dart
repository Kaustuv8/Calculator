import 'dart:math';


double precedence(String s){
  switch(s){
    case "+":  
    case "-":
      return 1;
    case "×":
    case "÷":
      return 2;
    case "^":
      return 3;
    default:
      return -1;
  }
}

bool isSpecialCharacter(String s){
  if("()sincostanlogln".contains(s)){
    return true;
  }
  return false;
}

bool isOperator(String s){
  if("+-×÷^".contains(s)){
    return true;
  }
  return false;
}



List<String> givePostFix(List<String> expression){
  List<String> postFixExp = [];
  List<String> stack = [];
  //Manages placement of decimal point
  if(
    expression.isNotEmpty 
    && expression[0] == "." 
    && expression[1].contains(RegExp(r'[0-9]'))){
      expression.remove(expression[0]);
      expression[0] = ".${expression[0]}";
  }
  //

  for(int i = 0; i<expression.length; i++){
    //manages negative sign by turning numbers into negative wherever appropriate
    if(i==0 && expression[i] == "-" && "123456789.".contains(expression[i+1])){
      expression.remove("-");
      expression[0] = "-${expression[0]}";
    }
    if(expression[i] == "-"){
      expression.remove("-");
      expression[i] = "-${expression[i]}";
      if(!"×÷".contains(expression[i-1])){
        expression.insert(i, "+");
      }
    }
    //Manges placement of multiplication symbol 
    if( 
      i!=0 && i<expression.length-1 && ((expression[i-1] == ')' && !isOperator(expression[i]) && expression[i] != ")")||
      (
        !isOperator(expression[i-1])
        && !"sincostanlogln".contains(expression[i-1]) 
        && expression[i] == '('
        && expression[i-1] != '('
      )
      )){
      expression.insert(i, "×");
    }
    if( 
      i!= 0 
      && expression[i] == "."
      && isOperator(expression[i-1])
      && expression[i+1].contains(RegExp(r'[0-9]'))
    ){
      expression.removeAt(i);
      expression[i] = ".${expression[i]}";
    }
  }
  for(final i  in expression){
    if(isOperator(i)){
      if(stack.isEmpty || precedence(stack[stack.length-1]) < precedence(i)){
      stack.add(i);
      }
      else{
        while(stack.isNotEmpty && precedence(stack[stack.length-1]) >= precedence(i)){
          postFixExp.add(stack.removeLast());
        }
        stack.add(i);
      }
    }

    else if(isSpecialCharacter(i)){
      if("(sincostanlogln".contains(i)){
        stack.add(i);
      }
      if(i == ')'){
        while(stack[stack.length - 1] != '('){
          postFixExp.add(stack.removeLast());
          if(stack.isEmpty){
            return [];
          }//if
        }//while
        stack.removeLast();
        if("sincostanlogln".contains(stack[stack.length - 1])){
          postFixExp.add(stack.removeLast());
        }
      }           
    }//else if 
    else{
      postFixExp.add(i);
    }//final else  
  }
  while(stack.isNotEmpty){
    postFixExp.add(stack.removeLast());
  }
  print(postFixExp);
  return postFixExp;
}

String evaluate(List<String> expression, String inputType){
  print("Expression before evaluation : ${expression}");
  if(expression.isNotEmpty && "÷+-×sincostanlogln".contains(expression[expression.length-1])){
    return "Error";
  }
  List<String> PostFixExp = givePostFix(expression);
  if(PostFixExp.isEmpty){
    return "Error";
  }
  List<double> stack = [];
  for(final i in PostFixExp){
    if(i.contains(RegExp(r'[0-9]')) || i[i.length-1] == "%"){
      if(i[i.length-1] == "%"){
        if(i.length == 1){
          return "Error";
        }
        stack.add(double.parse(i.substring(0,i.length-1)) / 100);
      }
      else {
      stack.add(double.parse(i));
      }
    }
    else{
      if(stack.isEmpty){
        return "Error";
      }
      if(i == "+"){
        stack.add(stack.removeLast() + stack.removeLast());
      }
      if(i == "-"){
        double prev = stack.removeLast();
        stack.add(stack.removeLast() - prev);
      }
      if(i == "×"){
        stack.add(stack.removeLast() * stack.removeLast());
      }
      if(i == "÷"){
        double prev = stack.removeLast();
        double secondprev = stack.removeLast();
        if(prev == 0){
          return "Error";
        }
        stack.add(secondprev / prev);
      }
      if(i == "sin"){
        double prev = stack.removeLast();
        if(inputType == "rad"){
          stack.add(sin(prev));
        }
        else{
          stack.add(sin(prev * 180 / pi));
        }
      }
      if(i == "cos"){
        double prev = stack.removeLast();
        if(inputType == "rad"){
          stack.add(cos(prev));
        }
        else{
          stack.add(cos(prev * 180 / pi));
        }
      }
      if(i == "tan"){
        double prev = stack.removeLast();
        if(inputType == "rad"){
          stack.add(tan(prev));
        }
        else{
          stack.add(tan(prev * 180 / pi));
        }
      }
      if(i == "log"){
        double prev = stack.removeLast();
        if(prev == 0){
          return "Error";
        }
        stack.add(log(prev) / log(10));
      }
      if(i == "ln"){
        double prev = stack.removeLast();
        if(prev == 0){
          return "Error";
        }
        stack.add(log(prev));
      }
    }
  }
  if (stack.length != 1){
    return "Error";
  }
  final String answer = stack.removeLast().toString().trim();
  if(double.parse(answer) == 0){
      return "0";
    }
  if(double.parse(answer).floor() == double.parse(answer)){
    for(int pos = 0;;pos++){
      if(answer[pos] == "."){
        return answer.substring(0,pos);
      }
    }
  }
  else{
    return answer;
  }
}
