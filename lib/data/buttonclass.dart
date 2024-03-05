

enum ButtonClass {
  valuenentry,
  deletion,
  alldeletion,
  evaluation,
  valuemod,
  layoutmod
}
class Button{
  Button({required this.letter, required this.type});
  String letter;
  ButtonClass type;
}