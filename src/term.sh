#!/bin/sh

if [ ! -z $1 ]; then
	outfile=$1
else
	outfile=./term.h
fi
srcdir=`dirname $0`

LC_ALL=C
export LC_ALL

rm -f ${outfile}
cat << EOF > ${outfile}
/*
 * This file is automagically created from term.c -- DO NOT EDIT
 */

#define T_FLG 0
#define T_NUM 1
#define T_STR 2

struct term {
	char *tcname;
	int type;
};

union tcu {
	int flg;
	int num;
	char *str;
};
EOF

#
# SCO-Unix sufferers may need to use the following lines:
# perl -p < ${srcdir}/term.c \
#  -e 's/"/"C/ if /"[A-Z]."/;' \
#  -e 'y/[a-z]/[A-Z]/ if /"/;' \
#
sed < ${srcdir}/term.c \
  -e '/"[A-Z]."/s/"/"C/' \
  -e '/"/y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' \
| awk '
/^  [{] ".*KMAPDEF[(].*$/{
  if (min == 0) min = s
  max = s;
}
/^  [{] ".*KMAPADEF[(].*$/{
  if (amin == 0) amin = s
  amax = s;
}
/^  [{] ".*KMAPMDEF[(].*$/{
  if (mmin == 0) mmin = s
  mmax = s;
}
/^  [{] ".*$/{
a=substr($2,2,length($2)-3);
b=substr($3,3,3);
if (nolist == 0) {
    printf "#define d_%s  d_tcs[%d].%s\n",a,s,b
    printf "#define D_%s (D_tcs[%d].%s)\n",a,s,b
  }
s++;
}
/\/* define/{
printf "#define %s %d\n",$3,s
}
/\/* nolist/{
nolist = 1;
}
/\/* list/{
nolist = 0;
}
END {
  printf "\n#ifdef MAPKEYS\n"
  printf "#  define KMAPDEFSTART %d\n", min
  printf "#  define NKMAPDEF %d\n", max-min+1
  printf "#  define KMAPADEFSTART %d\n", amin
  printf "#  define NKMAPADEF %d\n", amax-amin+1
  printf "#  define KMAPMDEFSTART %d\n", mmin
  printf "#  define NKMAPMDEF %d\n", mmax-mmin+1
  printf "#endif\n"
}
' | sed -e s/NUM/num/ -e s/STR/str/ -e s/FLG/flg/ \
>> ${outfile}

chmod a-w ${outfile}

