
T getEnum<T extends Enum>(Iterable<T> values, String s) {
  final l = values.where((ct)=>ct.name.toUpperCase() == s.toUpperCase().replaceAll(' ', '_'));
  if (l.length == 1) {
    return l.first;
  }
  return values.first;
}