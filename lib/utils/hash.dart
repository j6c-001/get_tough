
// djb2 http://www.cse.yorku.ca/~oz/hash.html
int idHash(String s)
{
  int hash = 5381;
  int c;

  for (int i= 0; i< s.length; i++) {
    c = s.codeUnitAt(i);
    hash = (hash *33) ^ c;
  }

return hash;
}