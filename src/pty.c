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
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>

#include "config.h"
#include "screen.h"

#include <sys/ioctl.h>

#include "extern.h"

/*
 * if no PTYRANGE[01] is in the config file, we pick a default
 */
#ifndef PTYRANGE0
#define PTYRANGE0 "qpr"
#endif
#ifndef PTYRANGE1
#define PTYRANGE1 "0123456789abcdef"
#endif

extern int eff_uid;

/* used for opening a new pty-pair: */
static char PtyName[32], TtyName[32];

static void initmaster __P((int));

int pty_preopen = 0;

/*
 *  Open all ptys with O_NOCTTY, just to be on the safe side
 *  (RISCos mips breaks otherwise)
 */
#ifndef O_NOCTTY
#define O_NOCTTY 0
#endif

/***************************************************************/

static void initmaster(f)
int f;
{
#ifdef POSIX
	tcflush(f, TCIOFLUSH);
#else
#ifdef TIOCFLUSH
	(void) ioctl(f, TIOCFLUSH, (char *) 0);
#endif
#endif
#ifdef LOCKPTY
	(void) ioctl(f, TIOCEXCL, (char *) 0);
#endif
}

void InitPTY(f)
int f;
{
	if (f < 0)
		return;
}

/***************************************************************/

#if defined(HAVE_SVR4_PTYS) && !defined(PTY_DONE)
#define PTY_DONE
int OpenPTY(ttyn)
char **ttyn;
{
	register int f;
	char *m, *ptsname();
	int unlockpt __P((int)), grantpt __P((int));
#if defined(HAVE_GETPT) && defined(linux)
	int getpt __P((void));
#endif
	void(*sigcld) __P(SIGPROTOARG);

	strcpy(PtyName, "/dev/ptmx");
#if defined(HAVE_GETPT) && defined(linux)
	if ((f = getpt()) == -1)
#else
	if ((f = open(PtyName, O_RDWR | O_NOCTTY)) == -1)
#endif
		return -1;

	/*
	 * SIGCHLD set to SIG_DFL for grantpt() because it fork()s and
	 * exec()s pt_chmod
	 */
	sigcld = signal(SIGCHLD, SIG_DFL);
	if ((m = ptsname(f)) == NULL || grantpt(f) || unlockpt(f)) {
		signal(SIGCHLD, sigcld);
		close(f);
		return -1;
	}
	signal(SIGCHLD, sigcld);
	strncpy(TtyName, m, sizeof(TtyName));
	initmaster(f);
	*ttyn = TtyName;
	return f;
}
#endif

/***************************************************************/

#if defined(HAVE_OPENPTY) && !defined(PTY_DONE)
#define PTY_DONE
int OpenPTY(ttyn)
char **ttyn;
{
	int f, s;
	if (openpty(&f, &s, TtyName, NULL, NULL) != 0)
		return -1;
	close(s);
	initmaster(f);
	pty_preopen = 1;
	*ttyn = TtyName;
	return f;
}
#endif

/***************************************************************/

#ifndef PTY_DONE
int OpenPTY(ttyn)
char **ttyn;
{
	register char *p, *q, *l, *d;
	register int f;

	debug("OpenPTY: Using BSD style ptys.\n");
	strcpy(PtyName, PtyProto);
	strcpy(TtyName, TtyProto);
	for (p = PtyName; *p != 'X'; p++);
	for (q = TtyName; *q != 'X'; q++);
	for (l = PTYRANGE0; (*p = *l) != '\0'; l++) {
		for (d = PTYRANGE1; (p[1] = *d) != '\0'; d++) {
			debug1("OpenPTY tries '%s'\n", PtyName);
			if ((f = open(PtyName, O_RDWR | O_NOCTTY)) == -1)
				continue;
			q[0] = *l;
			q[1] = *d;
			if (eff_uid && access(TtyName, R_OK | W_OK)) {
				close(f);
				continue;
			}
			initmaster(f);
			*ttyn = TtyName;
			return f;
		}
	}
	return -1;
}
#endif
