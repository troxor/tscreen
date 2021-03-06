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

#include "config.h"
#include "screen.h"
#include "extern.h"

#ifdef HAVE_UTEMPTER
#include <utempter.h>
#endif


extern struct display *display;
#ifdef CAREFULUTMP
extern struct win *windows;
#endif
extern struct win *fore;
extern char *LoginName;
extern int real_uid, eff_uid;


/*
 *  UTNOKEEP: A (ugly) hack for apollo that does two things:
 *    1) Always close and reopen the utmp file descriptor. (I don't know
 *       for what reason this is done...)
 *    2) Implement an unsorted utmp file much like HAVE_GETUTENT.
 *  (split into UT_CLOSE and UT_UNSORTED)
 */


#ifdef UTNOKEEP
#define UT_CLOSE
#define UT_UNSORTED
#endif

#ifdef UT_CLOSE
#undef UT_CLOSE
#define UT_CLOSE endutent()
#else
#define UT_CLOSE
#endif


/*
 *  we have a suid-root helper app that changes the utmp for us
 *  (won't work for login-slots)
 */
#if defined(HAVE_UTEMPTER)
#define UTMP_HELPER
#endif



#ifdef UTMPOK


static slot_t TtyNameSlot __P((char *));
static void makeuser __P((struct utmpx *, char *, char *, int));
static void makedead __P((struct utmpx *));
static int pututslot __P((slot_t, struct utmpx *, char *, struct win *));
static struct utmpx *getutslot __P((slot_t));
#ifndef HAVE_GETUTENT
static struct utmpx *getutent __P((void));
static void endutent __P((void));
static int initutmp __P((void));
static void setutent __P((void));
#endif


static int utmpok;
static char UtmpName[] = UTMPFILE;
#ifndef UTMP_HELPER
static int utmpfd = -1;
#endif


#if defined(HAVE_GETUTENT) && ! defined(__CYGWIN__)
extern struct utmpx *getutxline(), *pututxline();
#endif				/* HAVE_GETUTENT */

#if !defined(HAVE_GETUTENT) && !defined(UT_UNSORTED)
#include <ttyent.h>
#endif				/* !HAVE_GETUTENT && !UT_UNSORTED */

#undef  D_loginhost
#define D_loginhost D_utmp_logintty.ut_host


#endif				/* UTMPOK */


/*
 * SlotToggle - modify the utmp slot of the fore window.
 *
 * how > 0	do try to set a utmp slot.
 * how = 0	try to withdraw a utmp slot.
 *
 * w_slot = -1  window not logged in.
 * w_slot = 0   window not logged in, but should be logged in. 
 *              (unable to write utmp, or detached).
 */

#ifndef UTMPOK
void SlotToggle(how)
int how;
{
	debug1("SlotToggle (!UTMPOK) %d\n", how);
#ifdef UTMPFILE
	Msg(0, "Unable to modify %s.\n", UTMPFILE);
#else
	Msg(0, "Unable to modify utmp-database.\n");
#endif
}
#endif



#ifdef UTMPOK

void SlotToggle(how)
int how;
{
	debug1("SlotToggle %d\n", how);
	if (fore->w_type != W_TYPE_PTY) {
		Msg(0, "Can only work with normal windows.\n");
		return;
	}
	if (how) {
		debug(" try to log in\n");
		if ((fore->w_slot == (slot_t) - 1)
		    || (fore->w_slot == (slot_t) 0)) {
#ifdef UTMP_USRLIMIT
			if (CountUsers() >= UTMP_USRLIMIT) {
				Msg(0, "User limit reached.");
				return;
			}
#endif
			if (SetUtmp(fore) == 0)
				Msg(0, "This window is now logged in.");
			else
				Msg(0,
				    "This window should now be logged in.");
			WindowChanged(fore, 'f');
		} else
			Msg(0, "This window is already logged in.");
	} else {
		debug(" try to log out\n");
		if (fore->w_slot == (slot_t) - 1)
			Msg(0, "This window is already logged out\n");
		else if (fore->w_slot == (slot_t) 0) {
			debug
			    ("What a relief! In fact, it was not logged in\n");
			Msg(0, "This window is not logged in.");
			fore->w_slot = (slot_t) - 1;
		} else {
			RemoveUtmp(fore);
			if (fore->w_slot != (slot_t) - 1)
				Msg(0, "What? Cannot remove Utmp slot?");
			else
				Msg(0,
				    "This window is no longer logged in.");
#ifdef CAREFULUTMP
			CarefulUtmp();
#endif
			WindowChanged(fore, 'f');
		}
	}
}


#ifdef CAREFULUTMP

/* CAREFULUTMP: goodie for paranoid sysadmins: always leave one
 * window logged in
 */
void CarefulUtmp()
{
	struct win *p;

	if (!windows)		/* hopeless */
		return;
	debug("CarefulUtmp counting slots\n");
	for (p = windows; p; p = p->w_next)
		if (p->w_ptyfd >= 0 && p->w_slot != (slot_t) - 1)
			return;	/* found one, nothing to do */

	debug("CarefulUtmp: no slots, log one in again.\n");
	for (p = windows; p; p = p->w_next)
		if (p->w_ptyfd >= 0)	/* no zombies please */
			break;
	if (!p)
		return;		/* really hopeless */
	SetUtmp(p);
	Msg(0, "Window %d is now logged in.\n", p->w_number);
}
#endif				/* CAREFULUTMP */


void InitUtmp()
{
	debug1("InitUtmp testing '%s'...\n", UtmpName);
#ifndef UTMP_HELPER
	if ((utmpfd = open(UtmpName, O_RDWR)) == -1) {
		if (errno != EACCES)
			Msg(errno, "%s", UtmpName);
		debug("InitUtmp failed.\n");
		utmpok = 0;
		return;
	}
#ifdef HAVE_GETUTENT
	close(utmpfd);		/* it was just a test */
	utmpfd = -1;
#endif				/* HAVE_GETUTENT */
#endif				/* UTMP_HELPER */
	utmpok = 1;
}


#ifdef UTMP_USRLIMIT
int CountUsers()
{
	struct utmpx *ut;
	int UserCount;

	debug1("CountUsers() - utmpok=%d\n", utmpok);
	if (!utmpok)
		return 0;
	UserCount = 0;
	setutent();
	while (ut = getutent())
		if (SLOT_USED(ut))
			UserCount++;
	UT_CLOSE;
	return UserCount;
}
#endif				/* UTMP_USRLIMIT */



/*
 * the utmp entry for tty is located and removed.
 * it is stored in D_utmp_logintty.
 */
void RemoveLoginSlot()
{
	struct utmpx u, *uu;

	ASSERT(display);
	debug("RemoveLoginSlot: removing your logintty\n");
	D_loginslot = TtyNameSlot(D_usertty);
	if (D_loginslot == (slot_t) 0 || D_loginslot == (slot_t) - 1)
		return;
#ifdef UTMP_HELPER
	if (eff_uid)		/* helpers can't do login slots. sigh. */
#else
	if (!utmpok)
#endif
	{
		D_loginslot = 0;
		debug("RemoveLoginSlot: utmpok == 0\n");
	} else {

		if ((uu = getutslot(D_loginslot)) == 0) {
			debug("Utmp slot not found -> not removed");
			D_loginslot = 0;
		} else {
			D_utmp_logintty = *uu;
			u = *uu;
			makedead(&u);
			if (pututslot
			    (D_loginslot, &u, (char *) 0,
			     (struct win *) 0) == 0)
				D_loginslot = 0;
		}
		UT_CLOSE;
	}
#ifdef HAVE_GETUTENT
	debug1(" slot %s zapped\n", (char *) D_loginslot);
#else
	debug1(" slot %d zapped\n", (int) D_loginslot);
#endif
	if (D_loginslot == (slot_t) 0) {
		/* couldn't remove slot, do a 'mesg n' at least. */
		struct stat stb;
		char *tty;
		debug("couln't zap slot -> do mesg n\n");
		D_loginttymode = 0;
		if ((tty = ttyname(D_userfd)) && stat(tty, &stb) == 0
		    && (int) stb.st_uid == real_uid
		    && ((int) stb.st_mode & 0777) != 0666) {
			D_loginttymode = (int) stb.st_mode & 0777;
			chmod(D_usertty, stb.st_mode & 0600);
		}
	}
}

/*
 * D_utmp_logintty is reinserted into utmp
 */
void RestoreLoginSlot()
{
	char *tty;

	debug("RestoreLoginSlot()\n");
	ASSERT(display);
	if (utmpok && D_loginslot != (slot_t) 0
	    && D_loginslot != (slot_t) - 1) {
		debug1(" logging you in again (slot %p)\n", D_loginslot);
		if (pututslot
		    (D_loginslot, &D_utmp_logintty, D_loginhost,
		     (struct win *) 0) == 0)
			Msg(errno, "Could not write %s", UtmpName);
	}
	UT_CLOSE;
	D_loginslot = (slot_t) 0;
	if (D_loginttymode && (tty = ttyname(D_userfd)))
		chmod(tty, D_loginttymode);
}



/*
 * Construct a utmp entry for window wi.
 * the hostname field reflects what we know about the user (display)
 * location. If d_loginhost is not set, then he is local and we write
 * down the name of his terminal line; else he is remote and we keep
 * the hostname here. The letter S and the window id will be appended.
 * A saved utmp entry in wi->w_savut serves as a template, usually.
 */

int SetUtmp(wi)
struct win *wi;
{
	register slot_t slot;
	struct utmpx u;
	int saved_ut;
	char *p;
	char host[sizeof(D_loginhost) + 15];

	wi->w_slot = (slot_t) 0;
	if (!utmpok || wi->w_type != W_TYPE_PTY)
		return -1;
	if ((slot = TtyNameSlot(wi->w_tty)) == (slot_t) 0) {
		debug1("SetUtmp failed (tty %s).\n", wi->w_tty);
		return -1;
	}
#ifdef HAVE_GETUTENT
	debug2("SetUtmp %d will get slot %d...\n", wi->w_number, (char) *slot);
#else
	debug2("SetUtmp %d will get slot %d...\n", wi->w_number, (int) slot);
#endif

	bzero((char *) &u, sizeof(u));
	if ((saved_ut =
	     bcmp((char *) &wi->w_savut, (char *) &u, sizeof(u))))
		/* restore original, of which we will adopt all fields but ut_host */
		bcopy((char *) &wi->w_savut, (char *) &u, sizeof(u));

	if (!saved_ut)
		makeuser(&u, stripdev(wi->w_tty), LoginName, wi->w_pid);

	host[sizeof(host) - 15] = '\0';
	if (display) {
		strncpy(host, D_loginhost, sizeof(host) - 15);
		if (D_loginslot != (slot_t) 0
		    && D_loginslot != (slot_t) - 1 && host[0] != '\0') {
			/*
			 * we want to set our ut_host field to something like
			 * ":ttyhf:s.0" or
			 * "faui45:s.0" or
			 * "132.199.81.4:s.0" (even this may hurt..), but not
			 * "faui45.informati"......:s.0
			 * HPUX uses host:0.0, so chop at "." and ":" (Eric Backus)
			 */
			for (p = host; *p; p++)
				if ((*p < '0' || *p > '9') && (*p != '.'))
					break;
			if (*p) {
				for (p = host; *p; p++)
					if (*p == '.'
					    || (*p == ':' && p != host)) {
						*p = '\0';
						break;
					}
			}
		} else {
			strncpy(host + 1, stripdev(D_usertty),
				sizeof(host) - 15 - 1);
			host[0] = ':';
		}
	} else
		strncpy(host, "local", sizeof(host) - 15);

	sprintf(host + strlen(host), ":S.%d", wi->w_number);
	debug1("rlogin hostname: '%s'\n", host);

	strncpy(u.ut_host, host, sizeof(u.ut_host));

	if (pututslot(slot, &u, host, wi) == 0) {
		Msg(errno, "Could not write %s", UtmpName);
		UT_CLOSE;
		return -1;
	}
	debug("SetUtmp successful\n");
	wi->w_slot = slot;
	bcopy((char *) &u, (char *) &wi->w_savut, sizeof(u));
	UT_CLOSE;
	return 0;
}

/*
 * if slot could be removed or was 0,  wi->w_slot = -1;
 * else not changed.
 */

int RemoveUtmp(wi)
struct win *wi;
{
	struct utmpx u, *uu;
	slot_t slot;

	slot = wi->w_slot;
	debug1("RemoveUtmp slot=%p\n", slot);
	if (!utmpok)
		return -1;
	if (slot == (slot_t) 0 || slot == (slot_t) - 1) {
		wi->w_slot = (slot_t) - 1;
		return 0;
	}
	bzero((char *) &u, sizeof(u));
	if ((uu = getutslot(slot)) == 0) {
		Msg(0, "Utmp slot not found -> not removed");
		return -1;
	}
	bcopy((char *) uu, (char *) &wi->w_savut, sizeof(wi->w_savut));
	u = *uu;
	makedead(&u);
	if (pututslot(slot, &u, (char *) 0, wi) == 0) {
		Msg(errno, "Could not write %s", UtmpName);
		UT_CLOSE;
		return -1;
	}
	debug("RemoveUtmp successfull\n");
	wi->w_slot = (slot_t) - 1;
	UT_CLOSE;
	return 0;
}



/*********************************************************************
 *
 *  routines using the getut* api
 */

#ifdef HAVE_GETUTENT

#define SLOT_USED(u) (u->ut_type == USER_PROCESS)

static struct utmpx *getutslot(slot)
slot_t slot;
{
	struct utmpx u;
	bzero((char *) &u, sizeof(u));
	strncpy(u.ut_line, slot, sizeof(u.ut_line));
	setutent();
	return getutxline(&u);
}

static int pututslot(slot, u, host, wi)
slot_t slot;
struct utmpx *u;
char *host;
struct win *wi;
{
#ifdef HAVE_UTEMPTER
	if (eff_uid && wi->w_ptyfd != -1) {
		/* sigh, linux hackers made the helper functions void */
		if (SLOT_USED(u))
			addToUtmp(wi->w_tty, host, wi->w_ptyfd);
		else
			removeLineFromUtmp(wi->w_tty, wi->w_ptyfd);
		return 1;	/* pray for success */
	}
#endif
	setutent();
#ifndef __CYGWIN__
	return pututxline(u) != 0;
#else
	return 1;
#endif
}

static void makedead(u)
struct utmpx *u;
{
	u->ut_type = DEAD_PROCESS;
#if !defined(linux) && !defined(__CYGWIN__)
	u->ut_exit.e_termination = 0;
	u->ut_exit.e_exit = 0;
#endif
	u->ut_user[0] = 0;	/* for Digital UNIX, kilbi@rad.rwth-aachen.de */
}

static void makeuser(u, line, user, pid)
struct utmpx *u;
char *line, *user;
int pid;
{
	time_t now;
	u->ut_type = USER_PROCESS;
	strncpy(u->ut_user, user, sizeof(u->ut_user));
	/* Now the tricky part... guess ut_id */
#if defined(linux)
	strncpy(u->ut_id, line + 3, sizeof(u->ut_id));
#else				/* linux */
	strncpy(u->ut_id, line + strlen(line) - 2, sizeof(u->ut_id));
#endif				/* linux */
	strncpy(u->ut_line, line, sizeof(u->ut_line));
	u->ut_pid = pid;
	/* must use temp variable because of NetBSD/sparc64, where
	 * ut_xtime is long(64) but time_t is int(32) */
	(void) time(&now);
	u->ut_tv.tv_sec = now;
}

static slot_t TtyNameSlot(nam)
char *nam;
{
	return stripdev(nam);
}


#else				/* HAVE_GETUTENT */

/*********************************************************************
 *
 *  getut emulation for systems lacking the api
 */

static struct utmpx uent;

#define SLOT_USED(u) (u.ut_name[0] != 0)

static int initutmp()
{
	if (utmpfd >= 0)
		return 1;
	return (utmpfd = open(UtmpName, O_RDWR)) >= 0;
}

static void setutent()
{
	if (utmpfd >= 0)
		(void) lseek(utmpfd, (off_t) 0, 0);
}

static void endutent()
{
	if (utmpfd >= 0)
		close(utmpfd);
	utmpfd = -1;
}

static struct utmpx *getutent()
{
	if (utmpfd < 0 && !initutmp())
		return 0;
	if (read(utmpfd, &uent, sizeof(uent)) != sizeof(uent))
		return 0;
	return &uent;
}

static struct utmpx *getutslot(slot)
slot_t slot;
{
	if (utmpfd < 0 && !initutmp())
		return 0;
	lseek(utmpfd, (off_t) (slot * sizeof(struct utmpx)), 0);
	if (read(utmpfd, &uent, sizeof(uent)) != sizeof(uent))
		return 0;
	return &uent;
}

static int pututslot(slot, u, host, wi)
slot_t slot;
struct utmpx *u;
char *host;
struct win *wi;
{
	if (utmpfd < 0 && !initutmp())
		return 0;
	lseek(utmpfd, (off_t) (slot * sizeof(*u)), 0);
	if (write(utmpfd, u, sizeof(*u)) != sizeof(*u))
		return 0;
	return 1;
}


static void makedead(u)
struct utmpx *u;
{
#ifdef UT_UNSORTED
	bzero(u->ut_name, sizeof(u->ut_name));
	bzero(u->ut_host, sizeof(u->ut_host));
#else
	bzero((char *) u, sizeof(*u));
#endif
}


static void makeuser(u, line, user, pid)
struct utmpx *u;
char *line, *user;
int pid;
{
	time_t now;
	strncpy(u->ut_line, line, sizeof(u->ut_line));
	strncpy(u->ut_user, user, sizeof(u->ut_user));
	(void) time(&now);
	u->ut_tv.tv_sec = now;
}

static slot_t TtyNameSlot(nam)
char *nam;
{
	slot_t slot;
	char *line;
#ifndef UT_UNSORTED
	struct ttyent *tp;
#endif

	line = stripdev(nam);
#ifdef UT_UNSORTED
	setutent();
	if (utmpfd < 0)
		return -1;
	for (slot = 0; getutent(); slot++)
		if (strcmp(uent.ut_line, line) == 0)
			break;
	UT_CLOSE;
#else
	slot = 1;
	setttyent();
	while ((tp = getttyent()) != 0 && strcmp(line, tp->ty_name) != 0)
		slot++;
#endif
	return slot;
}

#endif				/* HAVE_GETUTENT */

#endif				/* UTMPOK */

