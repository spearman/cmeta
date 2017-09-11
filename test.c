#include <stdio.h>

macro MYMAC ($a : ident) {
}

MYMAC(a);

int main () {
  puts ("main...");
  puts ("...main");
}
