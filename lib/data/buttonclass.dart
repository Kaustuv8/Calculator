

enum ButtonClass {
  valuenentry,
  deletion,
  alldeletion,
  evaluation,
  valuemod
}
class Button{
  Button({required this.letter, required this.type});
  String letter;
  ButtonClass type;
}