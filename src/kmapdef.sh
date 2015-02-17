#!/bin/sh

if [ ! -z $1 ]; then
	outfile=$1
else
	outfile=./kmapdef.c
fi
srcdir=`dirname $0`


rm -f ${outfile}
cat << EOF > ${outfile}
/*
 * This file is automagically created from term.c -- DO NOT EDIT
 */

#include "config.h"

#ifdef MAPKEYS

EOF

awk < ${srcdir}/term.c '
/^  [{] ".*KMAP.*$/{
  for (i = 0; i < 3; i++) {
    q = $(5+i)
    if (substr(q, 1, 5) == "KMAPD") {
      if (min == 0) min = s
      max = s
      arr[s] = substr(q, 9, length(q)-9)
    }
    if (substr(q, 1, 5) == "KMAPA") {
      if (amin == 0) amin = s
      amax = s
      anarr[s] = substr(q, 10, length(q)-10)
    }
    if (substr(q, 1, 5) == "KMAPM") {
      if (mmin == 0) mmin = s
      mmax = s
      mnarr[s] = substr(q, 10, length(q)-10)
    }
  }
}
/^  [{] ".*$/{
  s++;
}
END {
  printf "char *kmapdef[] = {\n"
  for (s = min; s <= max; s++) {
    if (arr[s])
      printf "%s", arr[s]
    else
      printf "0"
    if (s < max)
      printf ",\n"
    else
      printf "\n"
  }
  printf "};\n\n"
  printf "char *kmapadef[] = {\n"
  for (s = amin; s <= amax; s++) {
    if (anarr[s])
      printf "%s", anarr[s]
    else
      printf "0"
    if (s < amax)
      printf ",\n"
    else
      printf "\n"
  }
  printf "};\n\n"
  printf "char *kmapmdef[] = {\n"
  for (s = mmin; s <= mmax; s++) {
    if (mnarr[s])
      printf "%s", mnarr[s]
    else
      printf "0"
    if (s < mmax)
      printf ",\n"
    else
      printf "\n"
  }
  printf "};\n\n#endif\n"
}
' >> ${outfile}

chmod a-w ${outfile}

