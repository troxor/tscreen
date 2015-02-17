/* vim: set syntax=c: */

/* Copyright (c) 1993-2002
 *      Juergen Weigert (jnweiger@immd4.informatik.uni-erlangen.de)
 *      Michael Schroeder (mlschroe@immd4.informatik.uni-erlangen.de)
 * Copyright (c) 1987 Oliver Laumann
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program (see the file COPYING); if not, see
 * http://www.gnu.org/licenses/, or contact Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02111-1301  USA
 *
 ****************************************************************
 * $Id$ FAU
 */

#cmakedefine ETCTSCREENRC "@ETCTSCREENRC@"
#cmakedefine SCREENENCODINGS "@SCREENENCODINGS@"
#cmakedefine VERSION "@VERSION_STRING@"

#cmakedefine DEBUG

/*
 * Maximum of simultaneously allowed windows per screen session.
 */
#cmakedefine MAXWIN @MAXWIN@

/*
 * Length of longest username.
 */
#cmakedefine MAX_USERNAME_LEN @MAX_USERNAME_LEN@


/*
 * Define SOCKDIR to be the directory to contain the named sockets
 * screen creates. This should be in a common subdirectory, such as
 * /usr/local or /tmp. It makes things a little more secure if you
 * choose a directory which is not writable by everyone or where the
 * "sticky" bit is on, but this isn't required.
 * If SOCKDIR is not defined screen will put the named sockets in
 * the user's home directory. Notice that this can cause you problems
 * if some user's HOME directories are AFS- or NFS-mounted. Especially
 * AFS is unlikely to support named sockets.
 *
 * Screen will name the subdirectories "S-$USER" (e.g /tmp/S-davison).
 */
#cmakedefine SOCKDIR "@SOCKDIR@"


/*
 * Screen can look for the environment variable $SYSTSCREENRC and -if it
 * exists- load the file specified in that variable as global screenrc.
 * If you want to enable this feature, define ALLOW_SYSSCREENRC to one (1).
 * Otherwise ETCSCREENRC is always loaded.
 */
#cmakedefine ALLOW_SYSSCREENRC

/*
 * Define CHECKLOGIN to force Screen users to enter their Unix password
 * in addition to the screen password.
 *
 * Define SYSLOG if you have logging facilities. Currently
 * syslog() will be used to trace ``su'' commands only.
 */
#cmakedefine CHECKLOGIN
#cmakedefine SYSLOG


/*
 * define PTYMODE if you do not like the default of 0622, which allows
 * public write to your pty.
 * define PTYGROUP to some numerical group-id if you do not want the
 * tty to be in "your" group.
 * Note, screen is unable to change mode or group of the pty if it
 * is not installed with sufficient privilege. (e.g. set-uid-root)
 */
#cmakedefine PTYMODE @PTYMODE@
#cmakedefine PTYGROUP @PTYGROUP@

/*
 * If screen is NOT installed set-uid root, screen can provide tty
 * security by exclusively locking the ptys.  While this keeps other
 * users from opening your ptys, it also keeps your own subprocesses
 * from being able to open /dev/tty.  Define LOCKPTY to add this
 * exclusive locking.
 */
#cmakedefine LOCKPTY

/*
 * If you'd rather see the status line on the first line of your
 * terminal rather than the last, define TOPSTAT.
 */
#cmakedefine TOPSTAT

/*
 * here come the erlangen extensions to screen:
 * define LOCK if you want to use a lock program for a screenlock.
 * define PASSWORD for secure reattach of your screen.
 * define AUTO_NUKE to enable Tim MacKenzies clear screen nuking
 * define PSEUDOS to allow window input/output filtering
 * define MULTI to allow multiple attaches.
 * define MULTIUSER to allow other users attach to your session
 *                  (if they are in the acl, of course)
 * define MAPKEYS to include input keyboard translation.
 * define FONT to support ISO2022/alternet charset support
 * define DW_CHARS to include support for double-width character
 *        sets.
 * define ENCODINGS to include support for encodings like euc or big5.
 *        Needs FONT to work.
 * define UTF8 if you want support for UTF-8 encoding.
 *        Needs FONT and ENCODINGS to work.
 * define BUILTIN_TELNET to add telnet support to screen.
 *        Syntax: screen //telnet host [port]
 * define RXVT_OSC if you want support for rxvts special
 *        change fgcolor/bgcolor/bgpicture sequences
 */
#define LOCK
#define PASSWORD
#define AUTO_NUKE
#define PSEUDOS
#define MULTI
#define MULTIUSER
#define MAPKEYS
#define ENCODINGS
#define UTF8
#define BLANKER_PRG

/* #undef BUILTIN_TELNET */
/* #undef RXVT_OSC */

#cmakedefine COLORS256


#cmakedefine UTMPFILE "@UTMPFILE@"
/*
 * If screen is installed with permissions to update /var/run/utmp (such
 * as if it is installed set-uid root), define UTMPOK.
 */
#cmakedefine UTMPOK

/* Set LOGINDEFAULT to one (1)
 * if you want entries added to /var/run/utmp by default, else set it to
 * zero (0).
 * LOGINDEFAULT will be one (1) whenever LOGOUTOK is undefined!
 */
#cmakedefine UTMP_LOGINDEFAULT	1

/* Set LOGOUTOK to one (1)
 * if you want the user to be able to log her/his windows out.
 * (Meaning: They are there, but not visible in /var/run/utmp).
 * Disabling this feature only makes sense if you have a secure /var/run/utmp
 * database.
 * Negative examples: suns usually have a world writable utmp file,
 * xterm will run perfectly without s-bit.
 *
 * If LOGOUTOK is undefined and UTMPOK is defined, all windows are
 * initially and permanently logged in.
 */
#cmakedefine UTMP_LOGOUTOK 1

/*
 * Set CAREFULUTMP to one (1) if you want that users have at least one
 * window per screen session logged in.
 */
#cmakedefine CAREFULUTMP


/*
 * If UTMPOK is defined and your system (incorrectly) counts logins by
 * counting non-null entries in /var/run/utmp (instead of counting non-null
 * entries with no hostname that are not on a pseudo tty), define USRLIMIT
 * to have screen put an upper limit on the number of entries to write
 * into /var/run/utmp.  This helps to keep you from exceeding a limited-user
 * license.
 */
#cmakedefine USRLIMIT @UTMP_USRLIMIT@

/*
 * to lower the interrupt load on the host machine, you may want to
 * adjust the VMIN and VTIME settings used for plain tty windows.
 * See the termio(4) manual page (Non-Canonical Mode Input Processing)
 * for details.
 * if undefined, VMIN=1, VTIME=0 is used as a default - this gives you
 * best user responsiveness, but highest interrupt frequency.
 * (Do not bother, if you are not using plain tty windows.)
 */
#cmakedefine TTYVMIN @TTYVMIN@
#cmakedefine TTYVTIME @TTYVTIME@

/*
 * looks like the above values are ignored by setting FNDELAY.
 * This is default for all pty/ttys, you may disable it for
 * ttys here. After playing with it for a while, one may find out
 * that this feature may cause screen to lock up.
 */
#ifdef bsdi
# define TTY_DISABLE_FNBLOCK /* select barfs without it ... */
#endif


/*
 * Define USE_LOCALE if you want screen to use the locale names
 * for the name of the month and day of the week.
 */
#cmakedefine USE_LOCALE

/*
 * Define USE_PAM if your system supports PAM (Pluggable Authentication
 * Modules) and you want screen to use it instead of calling crypt().
 * (You may also need to add -lpam to LIBS in the Makefile.)
 */
#cmakedefine USE_PAM

/**********************************************************************
 *
 *	End of User Configuration Section
 *
 *      Rest of this file is modified by 'configure'
 *      Change at your own risk!
 *
 */

#cmakedefine OSX

/*
 * Define POSIX if your system supports IEEE Std 1003.1-1988 (POSIX).
 */
#define POSIX 1

/*
 * Define BSDJOBS if you have BSD-style job control (both process
 * groups and a tty that deals correctly with them).
 */
#define BSDJOBS 1

/*
 * Define TERMIO if you have struct termio instead of struct sgttyb.
 * This is usually the case for SVID systems, where BSD uses sgttyb.
 * POSIX systems should define this anyway, even though they use
 * struct termios.
 */
#define TERMIO 1

/*
 * Define CYTERMIO if you have cyrillic termio modes.
 */
/* #undef CYTERMIO */

/*
 * Define TERMINFO if your machine emulates the termcap routines
 * with the terminfo database.
 * Thus the .tscreenrc file is parsed for
 * the command 'terminfo' and not 'termcap'.
 */
#define TERMINFO 1

/*
 * Define SYSV if your machine is SYSV complient (Sys V, HPUX, A/UX)
 */
#ifndef SYSV
/* #define SYSV 0 */
#endif

/*
 * Define USESIGSET if you have sigset for BSD 4.1 reliable signals.
 */
/* #undef USESIGSET */

/*
 * Define SYSVSIGS if signal handlers must be reinstalled after
 * they have been called.
 */
/* #undef SYSVSIGS */

/*
 * Define BSDWAIT if your system defines a 'union wait' in <sys/wait.h>
 *
 * Only allow BSDWAIT i.e. wait3 on nonposix systems, since
 * posix implies wait(3) and waitpid(3). vdlinden@fwi.uva.nl
 *
 */
#ifndef POSIX
#define BSDWAIT 1
#endif

/*
 * If your system has getutent(), pututline(), etc. to write to the
 * utmp file, define HAVE_GETUTENT.
 */
#cmakedefine HAVE_GETUTENT 1

/*
 * Define if you have the utempter utmp helper program
 */
#cmakedefine HAVE_UTEMPTER 1

/*
 * If your system has the calls setreuid() and setregid(),
 * define HAVE_SETREUID. Otherwise screen will use a forked process to
 * safely create output files without retaining any special privileges.
 */
#cmakedefine HAVE_SETRESUID 1
#cmakedefine HAVE_SETREUID 1

/*
 * If your system supports BSD4.4's seteuid() and setegid(), define
 * HAVE_SETEUID.
 */
/* #undef HAVE_SETEUID */

/*
 * If you want the "time" command to display the current load average
 * define LOADAV. Maybe you must install screen with the needed
 * privileges to read /dev/kmem.
 * Note that NLIST_ stuff is only checked, when getloadavg() is not available.
 */

#define LOADAV_NUM 3
#define LOADAV_TYPE double
#define LOADAV_SCALE 1
#define LOADAV_GETLOADAVG 1
/* #undef LOADAV_UNIX */
/* #undef LOADAV_AVENRUN */
/* #undef LOADAV_USE_NLIST64 */

/*
 * If the select return value doesn't treat a descriptor that is
 * usable for reading and writing as two hits, define SELECT_BROKEN.
 */
/* #undef SELECT_BROKEN */

/*
 * Define this if your system supports named pipes.
 */
/* #undef NAMEDPIPE */

/*
 * Define this if your system exits select() immediatly if a pipe is
 * opened read-only and no writer has opened it.
 */
/* #undef BROKEN_PIPE */

/*
 * Define this if the unix-domain socket implementation doesn't
 * create a socket in the filesystem.
 */
/* #undef SOCK_NOT_IN_FS */

/*
 * If your system has setenv() and unsetenv() define USESETENV
 */
#cmakedefine HAVE_SETENV

/*
 * If setenv() takes 3 arguments define HAVE_SETENV_3
 */
#cmakedefine HAVE_SETENV_3

/*
 * If your system does not come with a setenv()/putenv()/getenv()
 * functions, you may bring in our own code by defining NEEDPUTENV.
 */
/* #undef NEEDPUTENV */

/*
 * If the passwords are stored in a shadow file and you want the
 * builtin lock to work properly, define SHADOWPW.
 */
#cmakedefine SHADOWPW

/*
 * define HAVE_NL_LANGINFO if your system has the nl_langinfo() call
 * and <langinfo.h> defines CODESET.
 */
#cmakedefine HAVE_NL_LANGINFO

/*
 * define HAVE_SVR4_PTYS if you have a /dev/ptmx character special
 * device and support the ptsname(), grantpt(), unlockpt() functions.
 */
#define HAVE_SVR4_PTYS 1

/*
 * define PTYRANGE0 and or PTYRANGE1 if you want to adapt screen
 * to unusual environments. E.g. For SunOs the defaults are "qpr" and
 * "0123456789abcdef". For SunOs 4.1.2
 * #define PTYRANGE0 "pqrstuvwxyzPQRST"
 * is recommended by Dan Jacobson.
 */
#define PTYRANGE0 "abcdepqrstuvwxyz"
#define PTYRANGE1 "0123456789abcdef"


/* Define to 1 if you have the `alphasort' function. */
#cmakedefine HAVE_ALPHASORT 1

/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.   */
#cmakedefine HAVE_DIRENT_H 1

/* Define to 1 if you have the `fchmod' function. */
#cmakedefine HAVE_FCHMOD 1

/* Define to 1 if you have the `fchown' function. */
#cmakedefine HAVE_FCHOWN 1

/* Define to 1 if you have the `getcwd' function. */
#cmakedefine HAVE_GETCWD 1

/* Define to 1 if you have the `getpt' function. */
#cmakedefine HAVE_GETPT 1

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H 1

/* Define to 1 if you have the `lstat' function. */
#cmakedefine HAVE_LSTAT 1

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H 1

/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
#cmakedefine HAVE_NDIR_H 1

/* Define to 1 if you have the `openpty' function. */
#cmakedefine HAVE_OPENPTY 1

/* Define to 1 if you have the `rename' function. */
#cmakedefine HAVE_RENAME 1

/* Define to 1 if you have the `scandir' function. */
#cmakedefine HAVE_SCANDIR 1

/* Define to 1 if you have the `setlocale' function. */
#cmakedefine HAVE_SETLOCALE 1

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H 1

/* Define to 1 if you have the `strerror' function. */
#cmakedefine HAVE_STRERROR 1

/* Define to 1 if you have the `strftime' function. */
#cmakedefine HAVE_STRFTIME 1

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H 1

/* Define to 1 if you have the <stropts.h> header file. */
#cmakedefine HAVE_STROPTS_H 1

/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.   */
#cmakedefine HAVE_SYS_DIR_H 1

/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.   */
#cmakedefine HAVE_SYS_NDIR_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H 1

/* Define to 1 if you have the `utimes' function. */
#cmakedefine HAVE_UTIMES 1

/* Define to 1 if you have the `vsnprintf' function. */
#cmakedefine HAVE_VSNPRINTF 1

/* Define to 1 if you have the `_exit' function. */
#cmakedefine HAVE__EXIT 1

/* Define to the address where bug reports for this package should be sent. */
#cmakedefine PACKAGE_BUGREPORT "@PACKAGE_URL@/issues/list"

/* Define to the full name of this package. */
#cmakedefine PACKAGE_NAME "@APPLICATION_NAME@"

/* Define to the full name and version of this package. */
#cmakedefine PACKAGE_STRING "@APPLICATION_NAME@ @VERSION_STRING@"

/* Define to the one symbol short name of this package. */
#cmakedefine PACKAGE_TARNAME "@APPLICATION_NAME-@VERSION@.tar.gz"

/* Define to the home page for this package. */
#cmakedefine PACKAGE_URL "@PACKAGE_URL@"

/* Define to the version of this package. */
#cmakedefine PACKAGE_VERSION "@VERSION@"
