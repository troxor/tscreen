#! /bin/sh

AWK=awk
CC=cc
LC_ALL=C
export LC_ALL

if [ ! -z $1 ]; then
	outfile=$1
else
	outfile=./comm.h
fi
srcdir=`dirname $0`

rm -f ${outfile}
cat << EOF > ${outfile}
/*
 * This file is automagically created from comm.c -- DO NOT EDIT
 */

struct comm {
	char *name;
	int flags;
#ifdef MULTIUSER
	AclBits userbits[ACL_BITS_PER_CMD];
#endif
};

#define ARGS_MASK	(3)

#define ARGS_0	(0)
#define ARGS_1	(1)
#define ARGS_2	(2)
#define ARGS_3	(3)

#define ARGS_PLUS1	(1<<2)
#define ARGS_PLUS2	(1<<3)
#define ARGS_PLUS3	(1<<4)
#define ARGS_ORMORE	(1<<5)

#define NEED_FORE	(1<<6)	/* this command needs a fore window */
#define NEED_DISPLAY	(1<<7)	/* this command needs a display */
#define NEED_LAYER	(1<<8)	/* this command needs a layer */

#define ARGS_01		(ARGS_0 | ARGS_PLUS1)
#define ARGS_02		(ARGS_0 | ARGS_PLUS2)
#define ARGS_12		(ARGS_1 | ARGS_PLUS1)
#define ARGS_23		(ARGS_2 | ARGS_PLUS1)
#define ARGS_24		(ARGS_2 | ARGS_PLUS2)
#define ARGS_34		(ARGS_3 | ARGS_PLUS1)
#define ARGS_012	(ARGS_0 | ARGS_PLUS1 | ARGS_PLUS2)
#define ARGS_0123	(ARGS_0 | ARGS_PLUS1 | ARGS_PLUS2 | ARGS_PLUS3)
#define ARGS_123	(ARGS_1 | ARGS_PLUS1 | ARGS_PLUS2)
#define ARGS_124	(ARGS_1 | ARGS_PLUS1 | ARGS_PLUS3)
#define ARGS_1234	(ARGS_1 | ARGS_PLUS1 | ARGS_PLUS2 | ARGS_PLUS3)

struct action {
	int nr;
	char **args;
	int *argl;
};

#define RC_ILLEGAL -1
EOF
$AWK < ${srcdir}/comm.c >> ${outfile} '
/^  [{] ".*/	{   if (old > $2) {
		printf("***ERROR: %s <= %s !!!\n\n", $2, old);
		exit 1;
	    }
	old = $2;
	}
'
# Preprocess comm.c into a temporary source file,...
$CC -E -I. -I.. -I${srcdir} ${srcdir}/comm.c > comm.cpp
#  ... extract the comm(and) names by stripping off the C array syntax,
#  translate to uppercase,
#  and make them into #defines, numbered sequentially
sed < comm.cpp \
  -n \
  -e '/^ {"/s/^ {"\([^"]*\)".*/\1/p' \
| tr [a-z] [A-Z] | \
$AWK '
/.*/ {	printf "#define RC_%s %d\n",$0,i++;
     }
END  {	printf "\n#define RC_LAST %d\n",i-1;
     }
' >> ${outfile}
chmod a-w ${outfile}
rm -f comm.cpp
