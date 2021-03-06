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
 */

#include <sys/types.h>
#include <sys/stat.h>		/* mkdir() declaration */
#include <signal.h>

#include "config.h"
#include "screen.h"
#include "extern.h"

extern struct layer *flayer;

extern int eff_uid, real_uid;
extern int eff_gid, real_gid;
extern struct mline mline_old;
extern struct mchar mchar_blank;
extern unsigned char *null, *blank;

#ifdef HAVE_FDWALK
static int close_func __P((void *, int));
#endif

char *SaveStr(str)
register const char *str;
{
	register char *cp;

	if ((cp = malloc(strlen(str) + 1)) == NULL)
		Panic(0, "%s", strnomem);
	else
		strcpy(cp, str);
	return cp;
}

char *SaveStrn(str, n)
register const char *str;
int n;
{
	register char *cp;

	if ((cp = malloc(n + 1)) == NULL)
		Panic(0, "%s", strnomem);
	else {
		bcopy((char *) str, cp, n);
		cp[n] = 0;
	}
	return cp;
}

/* cheap strstr replacement */
char *InStr(str, pat)
char *str;
const char *pat;
{
	int npat = strlen(pat);
	for (; *str; str++)
		if (!strncmp(str, pat, npat))
			return str;
	return 0;
}

#ifndef HAVE_STRERROR
char *strerror(err)
int err;
{
	extern int sys_nerr;
	extern char *sys_errlist[];

	static char er[20];
	if (err > 0 && err < sys_nerr)
		return sys_errlist[err];
	sprintf(er, "Error %d", err);
	return er;
}
#endif

void centerline(str, y)
char *str;
int y;
{
	int l, n;

	ASSERT(flayer);
	n = strlen(str);
	if (n > flayer->l_width - 1)
		n = flayer->l_width - 1;
	l = (flayer->l_width - 1 - n) / 2;
	LPutStr(flayer, str, n, &mchar_blank, l, y);
}

void leftline(str, y)
char *str;
int y;
{
	int l, n;
	struct mchar mchar_dol;

	mchar_dol = mchar_blank;
	mchar_dol.image = '$';

	ASSERT(flayer);
	l = n = strlen(str);
	if (n > flayer->l_width - 1)
		n = flayer->l_width - 1;
	LPutStr(flayer, str, n, &mchar_blank, 0, y);
	if (n != l)
		LPutChar(flayer, &mchar_dol, n, y);
}


char *Filename(s)
char *s;
{
	register char *p = s;

	if (p)
		while (*p)
			if (*p++ == '/')
				s = p;
	return s;
}

char *stripdev(nam)
char *nam;
{
	if (nam == NULL)
		return NULL;
	if (strncmp(nam, "/dev/", 5) == 0)
		return nam + 5;
	return nam;
}


/*
 *    Signal handling
 */

#ifdef POSIX
void(*xsignal(sig, func))
#ifndef __APPLE__
    __P(SIGPROTOARG)
#else
    ()
#endif
int sig;
void(*func) __P(SIGPROTOARG);
{
	struct sigaction osa, sa;
	sa.sa_handler = func;
	(void) sigemptyset(&sa.sa_mask);
#ifdef SA_RESTART
	sa.sa_flags = (sig == SIGCHLD ? SA_RESTART : 0);
#else
	sa.sa_flags = 0;
#endif
	if (sigaction(sig, &sa, &osa))
		return (void(*)__P(SIGPROTOARG)) - 1;
	return osa.sa_handler;
}

#endif				/* POSIX */


/*
 *    uid/gid handling
 */

#ifdef HAVE_SETEUID

void xseteuid(euid)
int euid;
{
	if (seteuid(euid) == 0)
		return;
	seteuid(0);
	if (seteuid(euid))
		Panic(errno, "seteuid");
}

void xsetegid(egid)
int egid;
{
	if (setegid(egid))
		Panic(errno, "setegid");
}

#else				/* HAVE_SETEUID */
#ifdef HAVE_SETREUID

void xseteuid(euid)
int euid;
{
	int oeuid;

	oeuid = geteuid();
	if (oeuid == euid)
		return;
	if ((int) getuid() != euid)
		oeuid = getuid();
	if (setreuid(oeuid, euid))
		Panic(errno, "setreuid");
}

void xsetegid(egid)
int egid;
{
	int oegid;

	oegid = getegid();
	if (oegid == egid)
		return;
	if ((int) getgid() != egid)
		oegid = getgid();
	if (setregid(oegid, egid))
		Panic(errno, "setregid");
}

#endif				/* HAVE_SETREUID */
#endif				/* HAVE_SETEUID */



void bclear(p, n)
char *p;
int n;
{
	bcopy((char *) blank, p, n);
}


void Kill(pid, sig)
int pid, sig;
{
	if (pid < 2)
		return;
	(void) kill(pid, sig);
}


void closeallfiles(except)
int except;
{
	int f;
#if defined(SYSV) && defined(NOFILE) && !defined(ISC)
		f = NOFILE;
#else				/* SYSV && !ISC */
		f = getdtablesize();
#endif				/* SYSV && !ISC */
	while (--f > 2)
		if (f != except)
			close(f);
}


/*
 *  Security - switch to real uid
 */

#ifndef USE_SETEUID
static int UserPID;
static void(*Usersigcld) __P(SIGPROTOARG);
#endif
static int UserSTAT;

int UserContext()
{
#ifndef USE_SETEUID
	if (eff_uid == real_uid && eff_gid == real_gid)
		return 1;
	Usersigcld = signal(SIGCHLD, SIG_DFL);
	debug("UserContext: forking.\n");
	switch (UserPID = fork()) {
	case -1:
		Msg(errno, "fork");
		return -1;
	case 0:
		signal(SIGHUP, SIG_DFL);
		signal(SIGINT, SIG_IGN);
		signal(SIGQUIT, SIG_DFL);
		signal(SIGTERM, SIG_DFL);
#ifdef BSDJOBS
		signal(SIGTTIN, SIG_DFL);
		signal(SIGTTOU, SIG_DFL);
#endif
		setuid(real_uid);
		setgid(real_gid);
		return 1;
	default:
		return 0;
	}
#else
	xseteuid(real_uid);
	xsetegid(real_gid);
	return 1;
#endif
}

void UserReturn(val)
int val;
{
#ifndef USE_SETEUID
	if (eff_uid == real_uid && eff_gid == real_gid)
		UserSTAT = val;
	else
		_exit(val);
#else
	xseteuid(eff_uid);
	xsetegid(eff_gid);
	UserSTAT = val;
#endif
}

int UserStatus()
{
#ifndef USE_SETEUID
	int i;
#ifdef BSDWAIT
	union wait wstat;
#else
	int wstat;
#endif

	if (eff_uid == real_uid && eff_gid == real_gid)
		return UserSTAT;
	if (UserPID < 0)
		return -1;
	while ((errno = 0, i = wait(&wstat)) != UserPID)
		if (i < 0 && errno != EINTR)
			break;
	(void) signal(SIGCHLD, Usersigcld);
	if (i == -1)
		return -1;
	return WEXITSTATUS(wstat);
#else
	return UserSTAT;
#endif
}

#ifndef HAVE_RENAME
int rename(old, new)
char *old;
char *new;
{
	if (link(old, new) < 0)
		return -1;
	return unlink(old);
}
#endif


int AddXChar(buf, ch)
char *buf;
int ch;
{
	char *p = buf;

	if (ch < ' ' || ch == 0x7f) {
		*p++ = '^';
		*p++ = ch ^ 0x40;
	} else if (ch >= 0x80) {
		*p++ = '\\';
		*p++ = (ch >> 6 & 7) + '0';
		*p++ = (ch >> 3 & 7) + '0';
		*p++ = (ch >> 0 & 7) + '0';
	} else
		*p++ = ch;
	return p - buf;
}

int AddXChars(buf, len, str)
char *buf, *str;
int len;
{
	char *p;

	if (str == 0) {
		*buf = 0;
		return 0;
	}
	len -= 4;		/* longest sequence produced by AddXChar() */
	for (p = buf; p < buf + len && *str; str++) {
		if (*str == ' ')
			*p++ = *str;
		else
			p += AddXChar(p, *str);
	}
	*p = 0;
	return p - buf;
}


#ifdef DEBUG
void opendebug(new, shout)
int new, shout;
{
	char buf[256];

#ifdef _MODE_T
	mode_t oumask = umask(0);
#else
	int oumask = umask(0);
#endif

	ASSERT(!dfp);

	(void) mkdir(DEBUGDIR, 0777);
	sprintf(buf, shout ? "%s/TSCREEN.%d" : "%s/tscreen.%d", DEBUGDIR,
		getpid());
	if (!(dfp = fopen(buf, new ? "w" : "a")))
		dfp = stderr;
	else
		(void) chmod(buf, 0666);

	(void) umask(oumask);
	debug("opendebug: done.\n");
}
#endif				/* DEBUG */

void sleep1000(msec)
int msec;

{
	struct timeval t;

	t.tv_sec = (long) (msec / 1000);
	t.tv_usec = (long) ((msec % 1000) * 1000);
	select(0, (fd_set *) 0, (fd_set *) 0, (fd_set *) 0, &t);
}


/*
 * This uses either setenv() or putenv(). If it is putenv() we cannot dare
 * to free the buffer after putenv(), unless it it the one found in putenv.c
 */
void xsetenv(var, value)
char *var;
char *value;
{
#ifndef HAVE_SETENV
	char *buf;
	int l;

	if ((buf = (char *) malloc((l = strlen(var)) +
				   strlen(value) + 2)) == NULL) {
		Msg(0, "%s", strnomem);
		return;
	}
	strcpy(buf, var);
	buf[l] = '=';
	strcpy(buf + l + 1, value);
	putenv(buf);
#ifdef NEEDPUTENV
	/*
	 * we use our own putenv(), knowing that it does a malloc()
	 * the string space, we can free our buf now.
	 */
	free(buf);
#else				/* NEEDSETENV */
	/*
	 * For all sysv-ish systems that link a standard putenv()
	 * the string-space buf is added to the environment and must not
	 * be freed, or modified.
	 * We are sorry to say that memory is lost here, when setting
	 * the same variable again and again.
	 */
#endif				/* NEEDSETENV */
#else
	setenv(var, value, 1);
#endif				/* HAVE_SETENV */
}

#ifdef TERMINFO
/*
 * This is a replacement for the buggy _delay function from the termcap
 * emulation of libcurses, which ignores ospeed.
 */
int _delay(delay, outc)
register int delay;
int (*outc) __P((int));
{
	int pad;
	extern short ospeed;
	static short osp2pad[] = {
		0, 2000, 1333, 909, 743, 666, 500, 333, 166, 83, 55, 41,
		20, 10, 5, 2, 1, 1
	};

	if (ospeed <= 0
	    || ospeed >= (int) (sizeof(osp2pad) / sizeof(*osp2pad)))
		return 0;
	pad = osp2pad[ospeed];
	delay = (delay + pad / 2) / pad;
	while (delay-- > 0)
		(*outc) (0);
	return 0;
}

#ifdef linux

/* stupid stupid linux ncurses! It won't to padding with
 * zeros but sleeps instead. This breaks CalcCost, of course.
 * Also, the ncurses wait functions use a global variable
 * to store the current outc function. Oh well...
 */

int (*save_outc) __P((int));

#undef tputs

void xtputs(str, affcnt, outc)
char *str;
int affcnt;
int (*outc) __P((int));
{
	extern int tputs __P((const char *, int, int (*)(int)));
	save_outc = outc;
	tputs(str, affcnt, outc);
}

int _nc_timed_wait(mode, ms, tlp)
int mode, ms, *tlp;
{
	_delay(ms * 10, save_outc);
	return 0;
}

#endif				/* linux */

#endif				/* TERMINFO */



#define xva_arg(s, t, tn) va_arg(s, t)
#define xva_list va_list

