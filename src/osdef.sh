#! /bin/sh

CPP="gcc -E"

if [ ! -z $1 ]; then
	outfile=$1
else
	outfile=./osdef.h
fi
srcdir=`dirname $0`

rm -f core*

sed < ${srcdir}/osdef.h.in -n -e '/^extern/s@.*[)* 	][)* 	]*\([^ *]*\) __P.*@/[)*, 	]\1[ 	(]/i\\\
\\/\\[^a-zA-Z_\\]\1 __P\\/d@p' > osdef1.sed
cat << EOF > osdef0.c
#include "config.h"
#include <sys/types.h>
#include <stdio.h>
#include <signal.h>
#include <sys/stat.h>
#include <pwd.h>
#ifdef SHADOWPW
#include <shadow.h>
#endif
#include <sys/ioctl.h>
#ifdef linux
#include <string.h>
#include <stdlib.h>
#endif
#ifndef NAMEDPIPE
#include <sys/socket.h>
#endif
#ifdef SYSLOG
#include <syslog.h>
#endif
#include "os.h"
#if defined(UTMPOK) && !defined(HAVE_GETUTENT)
#include <ttyent.h>
#endif
EOF
cat << EOF > osdef2.sed
1i\\
/*
1i\\
 * This file is automagically created from osdef.sh -- DO NOT EDIT
1i\\
 */
EOF
$CPP -I.. -I${srcdir} osdef0.c | sed -n -f osdef1.sed >> osdef2.sed
sed -f osdef2.sed < ${srcdir}/osdef.h.in > ${outfile}
rm osdef0.c osdef1.sed osdef2.sed

if test -f core*; then
  file core*
  echo "  Sorry, your sed is broken. Call the system administrator."
  echo "  Meanwhile, you may try to compile screen with an empty ${outfile} file."
  echo "  But if your compiler needs to have all functions declared, you should"
  echo "  retry 'make' now and only remove offending lines from ${outfile} later."
  exit 1
fi
if eval test "`diff ${outfile} ${srcdir}/osdef.h.in | wc -l`" -eq 4; then
  echo "  Hmm, sed is very pessimistic about your system header files."
  echo "  But it did not dump core -- strange! Let's continue carefully..."
  echo "  If this fails, you may want to remove offending lines from osdef.h"
  echo "  or try with an empty osdef.h file, if your compiler can do without"
  echo "  function declarations."
fi
