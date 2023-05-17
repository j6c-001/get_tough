import 'package:get_tough/enumerations/fight_range.dart';

class RangeModifier {
  double inside = 0;
  double short = 0;
  double mid = 0;

  double value(EFightRange range) {
    switch(range) {
      case EFightRange.INSIDE: return inside;
      case EFightRange.SHORT: return short;
      case EFightRange.MID: return mid;
    }
  }
}
