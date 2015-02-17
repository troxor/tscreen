.\" vi:set wm=5
.TH TSCREEN 1 "Aug 2010"
.if n .ds Q \&"
.if n .ds U \&"
.if t .ds Q ``
.if t .ds U ''
.UC 4
.SH NAME
tscreen \- screen manager with VT100/ANSI terminal emulation


.SH SYNOPSIS
.B tscreen
[
.B \-\fIoptions\fP
] [
.B \fIcmd\fP
[
.B \fIargs\fP
] ]
.br
.B tscreen \-r
[[\fIpid\fP\fB.\fP]\fItty\fP[\fB.\fP\fIhost\fP]]
.br
.B tscreen \-r
\fIsessionowner\fP\fB/\fP[[\fIpid\fP\fB.\fP]\fItty\fP[\fB.\fP\fIhost\fP]]
.ta .5i 1.8i


.SH DESCRIPTION
\fItscreen\fP is a full-screen window manager that
multiplexes a physical terminal between several processes (typically
interactive shells).
Each virtual terminal provides the functions
of a DEC VT100 terminal and, in addition, several control functions
from the ISO 6429 (ECMA 48, ANSI X3.64) and ISO 2022 standards
(e.\|g. insert/delete line and support for multiple character sets).
There is a scrollback history buffer for each virtual terminal and a
copy-and-paste mechanism that allows moving text regions between
windows.
.PP
When \fItscreen\fP is called, it creates a single window with a shell in it (or the specified
command) and then gets out of your way so that you can use the program as you
normally would.
Then, at any time, you can create new (full-screen) windows with other programs
in them (including more shells), kill existing windows, view a list of
windows, turn output logging on and off, copy-and-paste text between
windows, view the scrollback history, switch between windows
in whatever manner you wish, etc. All windows run their programs completely
independent of each other. Programs continue to run when their window
is currently not visible and even when the whole \fItscreen\fP session is
detached from the user's terminal.  When a program terminates,\fItscreen\fP
(per default) kills the window that contained it.
If this window was in the foreground, the display switches to the previous
window; if none are left, \fItscreen\fP exits.
.PP
Everything you type is sent to the program running in the current window.
The only exception to this is the one keystroke that is used to initiate
a command to the window manager.
By default, each command begins with a control-a (abbreviated C-a from
now on), and is followed by one other keystroke.
The command character and all the key bindings can be fully customized
to be anything you like, though they are always two characters in length.
.PP
\fItscreen\fP does not understand the prefix \*QC-\*U to mean control.
Please use the caret notation (\*Q^A\*U instead of \*QC-a\*U) as arguments
to e.g. the \fIescape\fP command or the \fI-e\fP option. \fItscreen\fP
will also print out control characters in caret notation.
.PP
The standard way to create a new window is to type \*QC-a c\*U.
This creates a new window running a shell and switches to that
window immediately, regardless of the state of the process running
in the current window.
Similarly, you can create a new window with a custom command in it by
first binding the command to a keystroke (in your .tscreenrc file or at the
\*QC-a :\*U command line) and
then using it just like the \*QC-a c\*U command.
In addition, new windows can be created by running a command like:
.IP
tscreen emacs prog.c
.PP
from a shell prompt within a previously created window.
This will not run another copy of
.IR tscreen ,
but will instead supply the command name and its arguments to the window
manager (specified in the $STY environment variable) who will use it to
create the new window.
The above example would start the emacs editor (editing prog.c) and switch
to its window.
.PP
If \*Q/var/run/utmp\*U is writable by
.IR tscreen ,
an appropriate record will be written to this file for each window, and
removed when the window is terminated.
This is useful for working with \*Qtalk\*U, \*Qscript\*U, \*Qshutdown\*U,
\*Qrsend\*U, \*Qsccs\*U and other similar programs that use the utmp
file to determine who you are. As long as
\fItscreen\fP
is active on your terminal,
the terminal's own record is removed from the utmp file. See also \*QC-a L\*U.


.SH GETTING STARTED
Before you begin to use \fItscreen\fP you'll need to make sure you have correctly selected your terminal type,
just as you would for any other termcap/terminfo program.
(You can do this by using
.IR tset
for example.)
.PP
If you're impatient and want to get started without doing a lot more reading,
you should remember this one command:  \*QC-a ?\*U.
Typing these two characters will display a list of the available
\fItscreen\fP
commands and their bindings. Each keystroke is discussed in
the section \*QDEFAULT KEY BINDINGS\*U. The manual section \*QCUSTOMIZATION\*U
deals with the contents of your .tscreenrc.
.PP
If your terminal is a \*Qtrue\*U auto-margin terminal (it doesn't allow
the last position on the screen to be updated without scrolling the
screen) consider using a version of your terminal's termcap that has
automatic margins turned \fIoff\fP. This will ensure an accurate and
optimal update of the screen in all circumstances. Most terminals
nowadays have \*Qmagic\*U margins (automatic margins plus usable last
column). This is the VT100 style type and perfectly suited for
.IR tscreen .
If all you've got is a \*Qtrue\*U auto-margin terminal
\fItscreen\fP
will be content to use it, but updating a character put into the last
position on the screen may not be possible until the screen scrolls or
the character is moved into a safe position in some other way. This
delay can be shortened by using a terminal with insert-character
capability.


.SH "COMMAND-LINE OPTIONS"
tscreen has the following command-line options:
.TP 5
.B \-a
include \fIall\fP capabilities (with some minor exceptions) in each
window's termcap, even if
\fItscreen\fP
must redraw parts of the display in order to implement a function.
.TP 5
.B \-A
Adapt the sizes of all windows to the size of the current terminal.
By default,
\fItscreen\fP
tries to restore its old window sizes when attaching to resizable terminals
(those with \*QWS\*U in its description, e.g. suncmd or some xterm).
.TP 5
.BI "\-c " file
override the default configuration file from \*Q$HOME/.tscreenrc\*U
to \fIfile\fP.
.TP 5
.BR \-d | \-D " [" \fIpid.tty.host ]
does not start
.IR tscreen ,
but detaches the elsewhere running
\fItscreen\fP
session. It has the same effect as typing \*QC-a d\*U from
.IR tscreen 's
controlling terminal. \fB\-D\fP is the equivalent to the power detach key.
If no session can be detached, this option is ignored. In combination with the
\fB\-r\fP/\fB\-R\fP option more powerful effects can be achieved:
.TP 8
.B \-d \-r
Reattach a session and if necessary detach it first.
.TP 8
.B \-d \-R
Reattach a session and if necessary detach or even create it first.
.TP 8
.B \-d \-RR
Reattach a session and if necessary detach or create it. Use the first
session if more than one session is available.
.TP 8
.B \-D \-r
Reattach a session. If necessary detach and logout remotely first.
.TP 8
.B \-D \-R
Attach here and now. In detail this means: If a session is running, then
reattach. If necessary detach and logout remotely first.
If it was not running create it and notify the user. This is the
author's favorite.
.TP 8
.B \-D \-RR
Attach here and now. Whatever that means, just do it.
.IP "" 5
Note: It is always a good idea to check the status of your sessions by means of
\*Qtscreen \-list\*U.
.TP 5
.BI "\-e " xy
specifies the command character to be \fIx\fP and the character generating a
literal command character to \fIy\fP (when typed after the command character).
The default is \*QC-a\*U and `a', which can be specified as \*Q-e^Aa\*U.
When creating a
\fItscreen\fP
session, this option sets the default command character. In a multiuser
session all users added will start off with this command character. But
when attaching to an already running session, this option changes only
the command character of the attaching user.
This option is equivalent to either the commands \*Qdefescape\*U or
\*Qescape\*U respectively.
.TP 5
.BR \-f\fP ", " \-fn ", and " \-fa
turns flow-control on, off, or \*Qautomatic switching mode\*U.
This can also be defined through the \*Qdefflow\*U .tscreenrc command.
.TP 5
.BI "\-h " num
Specifies the history scrollback buffer to be \fInum\fP lines high.
.TP 5
.B \-i
will cause the interrupt key (usually C-c) to interrupt the display
immediately when flow-control is on.
See the \*Qdefflow\*U .tscreenrc command for details.
The use of this option is discouraged.
.TP 5
.BR \-l " and " \-ln
turns login mode on or off (for utmp updating).
This can also be defined through the \*Qdeflogin\*U .tscreenrc command.
.TP 5
.BR \-ls " and " \-list
does not start
.IR tscreen ,
but prints a list of
\fIpid.tty.host\fP
strings identifying your
\fItscreen\fP
sessions.
Sessions marked `detached' can be resumed with \*Qtscreen -r\*U. Those marked
`attached' are running and have a controlling terminal. If the session runs in
multiuser mode, it is marked `multi'. Sessions marked as `unreachable' either
live on a different host or are `dead'.
An unreachable session is considered dead, when its name
matches either the name of the local host, or the specified parameter, if any.
See the \fB-r\fP flag for a description how to construct matches.
Sessions marked as `dead' should be thoroughly checked and removed.
Ask your system administrator if you are not sure. Remove sessions with the
\fB-wipe\fP option.
.TP 5
.B \-L
tells
\fItscreen\fP
to turn on automatic output logging for the windows.
.TP 5
.B \-m
causes
\fItscreen\fP
to ignore the $STY environment variable. With \*Qtscreen -m\*U creation of
a new session is enforced, regardless whether
\fItscreen\fP
is called from within another
\fItscreen\fP
session or not. This flag has a special meaning in connection
with the `-d' option:
.TP 8
.B \-d \-m
Start
\fItscreen\fP
in \*Qdetached\*U mode. This creates a new session but doesn't
attach to it. This is useful for system startup scripts.
.TP 8
.B \-D \-m
This also starts tscreen in \*Qdetached\*U mode, but doesn't fork
a new process. The command exits if the session terminates.
.TP 5
.B \-O
selects a more optimal output mode for your terminal rather than true VT100
emulation (only affects auto-margin terminals without `LP').
This can also be set in your .tscreenrc by specifying `OP' in a \*Qtermcap\*U
command.
.TP 5
.BI "\-p " number_or_name
Preselect a window. This is useful when you want to reattach to a
specific window or you want to send a command via the \*Q-X\*U
option to a specific window. As with tscreen's select command, \*Q-\*U
selects the blank window. As a special case for reattach, \*Q=\*U
brings up the windowlist on the blank window.
.TP 5
.B \-q
Suppress printing of error messages. In combination with \*Q-ls\*U the exit
value is as follows: 9 indicates a directory without sessions. 10
indicates a directory with running but not attachable sessions. 11 (or more)
indicates 1 (or more) usable sessions.
In combination with \*Q-r\*U the exit value is as follows: 10 indicates that
there is no session to resume. 12 (or more) indicates that there are 2 (or
more) sessions to resume and you should specify which one to choose.
In all other cases \*Q-q\*U has no effect.
.TP 5
.BR \-r " [" \fIpid.tty.host ]
.PD 0
.TP 5
.BR \-r " \fIsessionowner/[" \fIpid.tty.host ]
.PD
resumes a detached
\fItscreen\fP
session.  No other options (except combinations with \fB\-d\fP/\fB\-D\fP) may
be specified, though an optional prefix of [\fIpid.\fP]\fItty.host\fP
may be needed to distinguish between multiple detached
\fItscreen\fP
sessions.  The second form is used to connect to another user's tscreen session
which runs in multiuser mode. This indicates that tscreen should look for
sessions in another user's directory. This requires setuid-root.
.TP 5
.B \-R
attempts to resume the first detached
\fItscreen\fP
session it finds.  If successful, all other command-line options are ignored.
If no detached session exists, starts a new session using the specified
options, just as if
.B \-R
had not been specified. The option is set by default if
\fItscreen\fP
is run as a login-shell (actually tscreen uses \*Q-xRR\*U in that case).
For combinations with the \fB\-d\fP/\fB\-D\fP option see there.
.TP 5
.B \-s
sets the default shell to the program specified, instead of the value
in the environment variable $SHELL (or \*Q/bin/sh\*U if not defined).
This can also be defined through the \*Qshell\*U .tscreenrc command.
.TP 5
.BI "\-S " sessionname
When creating a new session, this option can be used to specify a
meaningful name for the session. This name identifies the session for
\*Qtscreen -list\*U and \*Qtscreen -r\*U actions. It substitutes the
default [\fItty.host\fP] suffix.
.TP 5
.BI "\-t " name
sets the title (a.\|k.\|a.) for the default shell or specified program.
See also the \*Qshelltitle\*U .tscreenrc command.
.TP 5
.B \-U
Run tscreen in UTF-8 mode. This option tells tscreen that your terminal
sends and understands UTF-8 encoded characters. It also sets the default
encoding for new windows to `utf8'.
.TP 5
.B \-v
Print version number.
.TP 5
.BR \-wipe " [" \fImatch ]
does the same as \*Qtscreen -ls\*U, but removes destroyed sessions instead of
marking them as `dead'.
An unreachable session is considered dead, when its name matches either
the name of the local host, or the explicitly given parameter, if any.
See the \fB-r\fP flag for a description how to construct matches.
.TP 5
.B \-x
Attach to a not detached
\fItscreen\fP
session. (Multi display mode).
\fItscreen\fP
refuses to attach from within itself.
But when cascading multiple tscreens, loops are not detected; take care.
.TP 5
.B \-X
Send the specified command to a running tscreen session. You can use
the \fB-d\fP or \fB-r\fP option to tell tscreen to look only for
attached or detached tscreen sessions. Note that this command doesn't
work if the session is password protected.


.SH "DEFAULT KEY BINDINGS"
.ta 12n 26n
As mentioned, each
\fItscreen\fP
command consists of a
\*QC-a\*U followed by one other character.
For your convenience, all commands that are bound to lower-case letters are
also bound to their control character counterparts (with the exception
of \*QC-a a\*U; see below), thus, \*QC-a c\*U as well as \*QC-a C-c\*U can
be used to create a window. See section \*QCUSTOMIZATION\*U for a description
of the command.
.PP
.TP 26n
The following table shows the default key bindings:
.IP "\fBC-a '\fP	(select)"
Prompt for a window name or number to switch to.
.IP "\fBC-a ""\fP	(windowlist -b)"
Present a list of all windows for selection.
.IP "\fBC-a 0\fP	(select 0)"
.PD 0
.IP "\fB ... \fP	   ..."
.IP "\fBC-a 9\fP	(select 9)"
.IP "\fBC-a -\fP	(select -)"
.PD
Switch to window number 0 \- 9, or to the blank window.
.IP "\fBC-a tab\fP	(focus)"
.PD
Switch the input focus to the next region.
See also \fIsplit, remove, only\fP.
.IP "\fBC-a C-a\fP	(other)"
Toggle to the window displayed previously.
Note that this binding defaults to the command character typed twice,
unless overridden.  For instance, if you use the option \*Q\fB\-e]x\fP\*U,
this command becomes \*Q]]\*U.
.IP "\fBC-a a\fP	(meta)"
Send the command character (C-a) to window. See \fIescape\fP command.
.IP "\fBC-a A\fP	(title)"
Allow the user to enter a name for the current window.
.IP "\fBC-a b\fP"
.PD 0
.IP "\fBC-a C-b\fP	(break)"
.PD
Send a break to window.
.IP "\fBC-a B\fP	(pow_break)"
Reopen the terminal line and send a break.
.IP "\fBC-a c\fP"
.PD 0
.IP "\fBC-a C-c\fP	(tscreen)"
.PD
Create a new window with a shell and switch to that window.
.IP "\fBC-a C\fP	(clear)"
Clear the screen.
.IP "\fBC-a d\fP"
.PD 0
.IP "\fBC-a C-d\fP	(detach)"
.PD
Detach
\fItscreen\fP
from this terminal.
.IP "\fBC-a D D\fP	(pow_detach)"
Detach and logout.
.IP "\fBC-a f\fP"
.PD 0
.IP "\fBC-a C-f\fP	(flow)"
.PD
Toggle flow \fIon\fP, \fIoff\fP or \fIauto\fP.
.IP "\fBC-a F\fP	(fit)"
Resize the window to the current region size.
.IP "\fBC-a C-g\fP	(vbell)"
Toggles
\fItscreen's\fP
visual bell mode.
.IP "\fBC-a h\fP	(hardcopy)"
.PD
Write a hardcopy of the current window to the file \*Qhardcopy.\fIn\fP\*U.
.IP "\fBC-a H\fP	(log)"
Begins/ends logging of the current window to the file \*Qtscreenlog.\fIn\fP\*U.
.IP "\fBC-a i\fP"
.PD 0
.IP "\fBC-a C-i\fP	(info)"
.PD
Show info about this window.
.IP "\fBC-a k\fP"
.PD 0
.IP "\fBC-a C-k\fP	(kill)"
.PD
Destroy current window.
.IP "\fBC-a l\fP"
.PD 0
.IP "\fBC-a C-l\fP	(redisplay)"
.PD
Fully refresh current window.
.IP "\fBC-a L\fP	(login)"
Toggle this windows login slot. Available only if
\fItscreen\fP
is configured to update the utmp database.
.IP "\fBC-a m\fP"
.PD 0
.IP "\fBC-a C-m\fP	(lastmsg)"
.PD
Repeat the last 20 messages displayed in the message line.
.IP "\fBC-a M\fP	(monitor)"
Toggles monitoring of the current window.
.IP "\fBC-a space\fP"
.PD 0
.IP "\fBC-a n\fP"
.IP "\fBC-a C-n\fP	(next)"
.PD
Switch to the next window.
.IP "\fBC-a N\fP	(number)"
Show the number (and title) of the current window.
.IP "\fBC-a backspace\fP"
.PD 0
.IP "\fBC-a h\fP"
.IP "\fBC-a p\fP"
.IP "\fBC-a C-p\fP	(prev)"
.PD
Switch to the previous window (opposite of \fBC-a n\fP).
.IP "\fBC-a q\fP"
.PD 0
.IP "\fBC-a C-q\fP	(xon)"
.PD
Send a control-q to the current window.
.IP "\fBC-a Q\fP	(only)"
Delete all regions but the current one.
See also \fIsplit, vsplit, remove, focus\fP.
.IP "\fBC-a r\fP"
.PD 0
.IP "\fBC-a C-r\fP	(wrap)"
.PD
Toggle the current window's line-wrap setting (turn the current window's
automatic margins on and off).
.IP "\fBC-a s\fP"
.PD 0
.IP "\fBC-a C-s\fP	(xoff)"
.PD
Send a control-s to the current window.
.IP "\fBC-a S\fP	(split)"
Split the current region horizontally into top/bottom regions.
See also \fIvsplit, only, remove, focus\fP.
.IP "\fBC-a t\fP"
.PD 0
.IP "\fBC-a C-t\fP	(time)"
.PD
Show system information.
.IP "\fBC-a v\fP	(version)"
.PD
Display the version and compilation date.
.IP "\fBC-a C-v\fP	(digraph)"
.PD
Enter digraph.
.IP "\fBC-a w\fP"
.PD 0
.IP "\fBC-a C-w\fP	(windows)"
.PD
Show a list of window.
.IP "\fBC-a W\fP	(width)"
Toggle 80/132 columns.
.IP "\fBC-a x\fP"
.PD 0
.IP "\fBC-a C-x\fP	(lockscreen)"
.PD
Lock this terminal.
.IP "\fBC-a X\fP 	(remove)"
Kill the current region.
See also \fIsplit, vsplit, only, focus\fP.
.IP "\fBC-a z\fP"
.PD 0
.IP "\fBC-a C-z\fP	(suspend)"
.PD
Suspend
.IR tscreen .
Your system must support BSD-style job-control.
.IP "\fBC-a Z\fP	(reset)"
Reset the virtual terminal to its \*Qpower-on\*U values.
.IP "\fBC-a .\fP	(dumptermcap)"
Write out a \*Q.termcap\*U file.
.IP "\fBC-a ?\fP	(help)"
Show key bindings.
.IP "\fBC-a C-\e\fP	(quit)"
Kill all windows and terminate
.IR tscreen .
.IP "\fBC-a :\fP	(colon)"
Enter command line mode.
.IP "\fBC-a [\fP"
.PD 0
.IP "\fBC-a C-[\fP"
.IP "\fBC-a esc\fP	(copy)"
.PD
Enter copy/scrollback mode.
.IP "\fBC-a ]\fP	(paste .)"
.PD
Write the contents of the paste buffer to the stdin queue of the
current window.
.IP "\fBC-a {\fP
.PD 0
.IP "\fBC-a }\fP	(history)"
.PD
Copy and paste a previous (command) line.
.IP "\fBC-a >\fP	(writebuf)"
Write paste buffer to a file.
.IP "\fBC-a <\fP	(readbuf)"
Reads the tscreen-exchange file into the paste buffer.
.IP "\fBC-a =\fP	(removebuf)"
Removes the file used by \fBC-a <\fP and \fPC-a >\fP.
.IP "\fBC-a |\fP	(vsplit)"
Split the current region vertically into left/right regions.
See also \fIsplit, only, focus, remove\fP.
.IP "\fBC-a ,\fP	(license)"
Shows where
\fItscreen\fP
comes from, where it went to and why you can use it.
.IP "\fBC-a _\fP	(silence)"
Start/stop monitoring the current window for inactivity.
.IP "\fBC-a *\fP	(displays)"
Show a listing of all currently attached displays.


.SH CUSTOMIZATION
The \*Qsocket directory\*U defaults either to $HOME/.tscreen or simply to
@SOCKDIR@, chosen at compile-time. If \fItscreen\fP is installed setuid-root,
then the administrator should compile \fItscreen\fP with an adequate (not
NFS mounted) socket directory. If \fItscreen\fP is not running setuid-root,
the user can specify any mode 700 directory in the environment variable $TSCREENDIR.
.PP
When \fItscreen\fP is invoked, it executes initialization commands from the files
\*Q@SYSCONF_INSTALL_DIR@/tscreenrc\*U and \*Q$HOME/.tscreenrc\*U. These are the \*Qprogrammer's
defaults\*U that can be overridden in the following ways: for the
global tscreenrc file
\fItscreen\fP
searches for the environment variable $SYSTSCREENRC (this override feature
may be disabled at compile-time). The user specific
tscreenrc file is searched in $TSCREENRC, then $HOME/.tscreenrc.
The command line option \fB-c\fP takes
precedence over the above user tscreenrc files.
.PP
Commands in these files are used to set options, bind functions to
keys, and to automatically establish one or more windows at the
beginning of your
\fItscreen\fP
session.
Commands are listed one per line, with empty lines being ignored.
A command's arguments are separated by tabs or spaces, and may be
surrounded by single or double quotes.
A `#' turns the rest of the line into a comment, except in quotes.
Unintelligible lines are warned about and ignored.
Commands may contain references to environment variables. The
syntax is the shell-like "$VAR " or "${VAR}". Note that this causes
incompatibility with previous
\fItscreen\fP
versions, as now the '$'-character has to be protected with '\e' if no
variable substitution shall be performed. A string in single-quotes is also
protected from variable substitution.
.PP
An example configuration file is shipped with your tscreen distribution:
\*Qdata/tscreenrc\*U. It contains a number of useful examples for various commands.
.PP
Customization can also be done 'on-line'. To enter the command mode type
`C-a :'. Note that commands starting with \*Qdef\*U change default values,
while others change current settings.
.PP
The following commands are available:
.sp
.ne 3
.BI acladd " usernames"
.RI [ crypted-pw ]
.br
.BI addacl " usernames"
.PP
Enable users to fully access this tscreen session. \fIUsernames\fP can be one
user or a comma separated list of users. This command enables to attach to the
\fItscreen\fP
session and performs the equivalent of `aclchg \fIusernames\fP +rwx \&"#?\&"'.
executed. To add a user with restricted access, use the `aclchg' command below.
If an optional second parameter is supplied, it should be a crypted password
for the named user(s). `Addacl' is a synonym to `acladd'.
Multi user mode only.
.sp
.ne 3
.BI aclchg " usernames permbits list"
.br
.BI chacl " usernames permbits list"
.PP
Change permissions for a comma separated list of users. Permission bits are
represented as `r', `w' and `x'. Prefixing `+' grants the permission, `-'
removes it. The third parameter is a comma separated list of commands and/or
windows (specified either by number or title). The special list `#' refers to
all windows, `?' to all commands. if \fIusernames\fP consists of a single `*',
all known users are affected.
A command can be executed when the user has the `x' bit for it.
The user can type input to a window when he has its `w' bit set and no other
user obtains a writelock for this window.
Other bits are currently ignored.
To withdraw the writelock from another user in window 2:
`aclchg \fIusername\fP -w+w 2'.
To allow read-only access to the session: `aclchg \fIusername\fP
-w \&"#\&"'. As soon as a user's name is known to
\fItscreen\fP
he can attach to the session and (per default) has full permissions for all
command and windows. Execution permission for the acl commands, `at' and others
should also be removed or the user may be able to regain write permission.
Rights of the special username
.B nobody
cannot be changed (see the \*Qsu\*U command).
`Chacl' is a synonym to `aclchg'.
Multi user mode only.
.sp
.ne 3
.BI acldel " username"
.PP
Remove a user from
.IR tscreen 's
access control list. If currently attached, all the
user's displays are detached from the session. He cannot attach again.
Multi user mode only.
.sp
.ne 3
.BI aclgrp " username"
.RI [ groupname ]
.PP
Creates groups of users that share common access rights. The name of the
group is the username of the group leader. Each member of the group inherits
the permissions that are granted to the group leader. That means, if a user
fails an access check, another check is made for the group leader.
A user is removed from all groups the special value \*Qnone\*U is used for
.IR groupname .
If the second parameter is omitted all groups the user is in are listed.
.sp
.ne 3
.B aclumask
.RI [[ users ] +bits
.RI |[ users ] -bits " .... ]"
.br
.B umask
.RI [[ users ] +bits
.RI |[ users ] -bits " .... ]"
.PP
This specifies the access other users have to windows that will be created by
the caller of the command.
\fIUsers\fP
may be no, one or a comma separated list of known usernames. If no users are
specified, a list of all currently known users is assumed.
\fIBits\fP
is any combination of access control bits allowed defined with the
\*Qaclchg\*U command. The special username \*Q?\*U predefines the access
that not yet known users will be granted to any window initially.
The special username \*Q??\*U predefines the access that not yet known
users are granted to any command.
Rights of the special username
.B nobody
cannot be changed (see the \*Qsu\*U command).
`Umask' is a synonym to `aclumask'.
.sp
.ne 3
.BI activity " message"
.PP
When any activity occurs in a background window that is being monitored,
\fItscreen\fP
displays a notification in the message line.
The notification message can be re-defined by means of the \*Qactivity\*U
command.
Each occurrence of `%' in \fImessage\fP is replaced by
the number of the window in which activity has occurred,
and each occurrence of `^G' is replaced by the definition for bell
in your termcap (usually an audible bell).
The default message is
.sp
	'Activity in window %n'
.sp
Note that monitoring is off for all windows by default, but can be altered
by use of the \*Qmonitor\*U command (C-a M).
.sp
.ne 3
.BR alias " "\fIidentifier\fP "
.IR "command " [ args " ... ]"
.PP
Write aliases for existing commands. This primitive also allows you to
bind arguments, and essentially run mini-functions.
.sp
Example:
.sp
.nf
 #  Caption toggle
 alias caption_off  eval "caption splitonly"
 alias caption_on   eval "caption always"

 #  Disable both caption and status, and show a message.
 alias fullscreen   eval "status_off" "caption_off" "echo 'fullscreen'"
 alias captioned    eval "status_on"  "caption_on"  "echo 'captioned' "

 #  Bind these functions to keys
 bind f fullscreen
 bind F captioned

 #  Clear the scrollback history, and the current screen
 alias clearscrollback eval "scrollback 0" "clear" "scrollback 15000"
.fi
.sp
.ne 3
.BR "aliaslist"
.PP
Display the currently defined aliases
.sp
.ne 3
.BR "allpartial on" | off
.PP
If set to on, only the current cursor line is refreshed on window change.
This affects all windows and is useful for slow terminal lines. The
previous setting of full/partial refresh for each window is restored
with \*Qallpartial off\*U.  This is a global flag that immediately takes effect
on all windows overriding the \*Qpartial\*U settings. It does not change the
default redraw behavior of newly created windows.
.sp
.ne 3
.BR "altscreen on" | off
.PP
If set to on, "alternate screen" support is enabled in virtual terminals,
just like in xterm.  Initial setting is `off'.
.sp
.ne 3
.BR "at " "[\fIidentifier\fP][" "#\fP|\fP*\fP|\fP%\fP] "
.IR "command " [ args " ... ]"
.PP
Execute a command at other displays or windows as if it had been entered there.
\*QAt\*U changes the context (the `current window' or `current display'
setting) of the command. If the first parameter describes a
non-unique context, the command will be executed multiple times. If the first
parameter is of the form `\fIidentifier\fP*' then identifier is matched against
user names.  The command is executed once for each display of the selected
user(s). If the first parameter is of the form `\fIidentifier\fP%' identifier
is matched against displays. Displays are named after the ttys they
attach. The prefix `/dev/' or `/dev/tty' may be omitted from the identifier.
If \fIidentifier\fP has a `#' or nothing appended it is matched against
window numbers and titles. Omitting an identifier in front of the `#', `*' or
`%'-character selects all users, displays or windows because a prefix-match is
performed. Note that on the affected display(s) a short message will describe
what happened. Permission is checked for initiator of the \*Qat\*U command,
not for the owners of the affected display(s).
Note that the '#' character works as a comment introducer when it is preceded by
whitespace. This can be escaped by prefixing a '\e'.
Permission is checked for the initiator of the \*Qat\*U command, not for the
owners of the affected display(s).
.br
Caveat:
When matching against windows, the command is executed at least
once per window. Commands that change the internal arrangement of windows
(like \*Qother\*U) may be called again. In shared windows the command will
be repeated for each attached display. Beware, when issuing toggle commands
like \*Qlogin\*U!
Some commands (e.g. \*Qprocess\*U) require that
a display is associated with the target windows.  These commands may not work
correctly under \*Qat\*U looping over windows.
.sp
.ne 3
.BI "attrcolor " attrib
.RI [ "attribute/color-modifier" ]
.PP
This command can be used to highlight attributes by changing the color of
the text. If the attribute
\fIattrib\fP
is in use, the specified attribute/color modifier is also applied. If no
modifier is given, the current one is deleted. See the \*QSTRING ESCAPES\*U
chapter for the syntax of the modifier. tscreen understands two
pseudo-attributes, \*Qi\*U stands for high-intensity foreground
color and \*QI\*U for high-intensity background color.
.sp
Examples:
.IP
attrcolor b "R"
.PP
Change the color to bright red if bold text is to be printed.
.IP
attrcolor u "-u b"
.PP
Use blue text instead of underline.
.IP
attrcolor b ".I"
.PP
Use bright colors for bold text. Most terminal emulators do this
already.
.IP
attrcolor i "+b"
.PP
Make bright colored text also bold.
.sp
.ne 3
.BR "autodetach on" | off
.PP
Sets whether
\fItscreen\fP
will automatically detach upon hangup, which
saves all your running programs until they are resumed with a
.B "tscreen -r"
command.
When turned off, a hangup signal will terminate
\fItscreen\fP
and all the processes it contains. Autodetach is on by default.
.sp
.ne 3
.BR "autonuke on" | off
.PP
Sets whether a clear screen sequence should nuke all the output
that has not been written to the terminal. See also
\*Qobuflimit\*U.
.sp
.ne 3
.BI "backtick " id
\fIlifespan\fP
\fIautorefresh\fP
\fIcmd\fP
\fIargs...\fP
.br
.BI "backtick " id
.PP
Program the backtick command with the numerical id \fIid\fP.
The output of such a command is used for substitution of the
\*Q%`\*U string escape. The specified \fIlifespan\fP is the number
of seconds the output is considered valid. After this time, the
command is run again if a corresponding string escape is encountered.
The \fIautorefresh\fP parameter triggers an
automatic refresh for caption and hardstatus strings after the
specified number of seconds. Only the last line of output is used
for substitution.
.br
If both the \fIlifespan\fP and the \fIautorefresh\fP parameters
are zero, the backtick program is expected to stay in the
background and generate output once in a while.
In this case, the command is executed right away and tscreen stores
the last line of output. If a new line gets printed tscreen will
automatically refresh the hardstatus or the captions.
.br
The second form of the command deletes the backtick command
with the numerical id \fIid\fP.
.sp
.ne 3
.BR "bce " [ on | off ]
.PP
Change background-color-erase setting. If \*Qbce\*U is set to on, all
characters cleared by an erase/insert/scroll/clear operation
will be displayed in the current background color. Otherwise
the default background color is used.
.sp
.ne 3
.B bell_msg
.RI [ message ]
.PP
When a bell character is sent to a background window,
\fItscreen\fP
displays a notification in the message line.
The notification message can be re-defined by this command.
Each occurrence of `%' in \fImessage\fP is replaced by
the number of the window to which a bell has been sent,
and each occurrence of `^G' is replaced by the definition for bell
in your termcap (usually an audible bell).
The default message is
.sp
	'Bell in window %n'
.sp
An empty message can be supplied to the \*Qbell_msg\*U command to suppress
output of a message line (bell_msg "").
Without parameter, the current message is shown.
.sp
.ne 3
.BI "bind "
.RB [ -c
.IR class ]
\fIkey\fP
.RI [ command " [" args ]]
.PP
Bind a command to a key.
By default, most of the commands provided by
\fItscreen\fP
are bound to one or more keys as indicated in the \*QDEFAULT KEY BINDINGS\*U
section, e.\|g. the
command to create a new window is bound to \*QC-c\*U and \*Qc\*U.
The \*Qbind\*U command can be used to redefine the key bindings and to
define new bindings.
The \fIkey\fP argument is either a single character, a two-character sequence
of the form \*Q^x\*U (meaning \*QC-x\*U), a backslash followed by an octal
number (specifying the ASCII code of the character), or a backslash followed
by a second character, such as \*Q\e^\*U or \*Q\e\e\*U.
The argument can also be quoted, if you like.
If no further argument is given, any previously established binding
for this key is removed.
The \fIcommand\fP argument can be any command listed in this section.

If a command class is specified via the \*Q-c\*U option, the key
is bound for the specified class. Use the \*Qcommand\*U command
to activate a class. Command classes can be used to create multiple
command keys or multi-character bindings.
.PP
Some examples:
.PP
.nf
	bind ' ' windows
	bind ^k
	bind k
	bind K kill
	bind ^f tscreen telnet foobar
	bind \e033 tscreen -ln -t root -h 1000 9 su
.fi
.PP
would bind the space key to the command that displays a list
of windows (so that the command usually invoked by \*QC-a C-w\*U
would also be available as \*QC-a space\*U). The next three lines
remove the default kill binding from \*QC-a C-k\*U and \*QC-a k\*U.
\*QC-a K\*U is then bound to the kill command. Then it
binds \*QC-f\*U to the command \*Qcreate a window with a TELNET
connection to foobar\*U, and bind \*Qescape\*U to the command
that creates an non-login window with a.\|k.\|a. \*Qroot\*U in slot #9, with
a superuser shell and a scrollback buffer of 1000 lines.
.PP
.nf
	bind -c demo1 0 select 10
	bind -c demo1 1 select 11
	bind -c demo1 2 select 12
	bindkey "^B" command -c demo1
.fi
.PP
makes \*QC-b 0\*U select window 10, \*QC-b 1\*U window 11, etc.
.PP
.nf
	bind -c demo2 0 select 10
	bind -c demo2 1 select 11
	bind -c demo2 2 select 12
	bind - command -c demo2
.fi
.PP
makes \*QC-a - 0\*U select window 10, \*QC-a - 1\*U window 11, etc.
.sp
.ne 3
.BR "bindkey " "["-d "] [" -m "] [" -a "] [[" -k | -t "] \fIstring\fP [ \fIcmd args\fP ]]"
.PP
This command manages tscreen's input translation tables. Every
entry in one of the tables tells tscreen how to react if a certain
sequence of characters is encountered. There are three tables:
one that should contain actions programmed by the user, one for
the default actions used for terminal emulation and one for
tscreen's copy mode to do cursor movement. See section
\*QINPUT TRANSLATION\*U for a list of default key bindings.
.br
If the \fB-d\fP option is given, bindkey modifies the default table,
\fB-m\fP changes the copy mode table
and with neither option the user table is selected.
The argument \fIstring\fP is the sequence of characters to which an action is bound. This
can either be a fixed string or a termcap keyboard capability
name (selectable with the
.B -k
option).
.br
Some keys on a VT100 terminal can send a different
string if application mode is turned on (e.g the cursor keys).
Such keys have two entries in the translation table. You can
select the application mode entry by specifying the
.B -a
option.
.br
The
.B -t
option tells tscreen not to do inter-character timing. One cannot
turn off the timing if a termcap capability is used.
.br
\fICmd\fP
can be any of tscreen's commands with an arbitrary number of
.IR args .
If
\fIcmd\fP
is omitted the key-binding is removed from the table.
.br
Here are some examples of keyboard bindings:
.sp
.nf
        bindkey -d
.fi
Show all of the default key bindings. The application mode entries
are marked with [A].
.sp
.nf
        bindkey -k k1 select 1
.fi
Make the "F1" key switch to window one.
.sp
.nf
        bindkey -t foo stuff barfoo
.fi
Make "foo" an abbreviation of the word "barfoo". Timeout is disabled
so that users can type slowly.
.sp
.nf
        bindkey "\e024" mapdefault
.fi
This key-binding makes \*Q^T\*U an escape character for key-bindings. If
you did the above \*Qstuff barfoo\*U binding, you can enter the word
\*Qfoo\*U by typing \*Q^Tfoo\*U. If you want to insert a \*Q^T\*U
you have to press the key twice (i.e., escape the escape binding).
.sp
.nf
        bindkey -k F1 command
.fi
Make the F11 (not F1!) key an alternative tscreen
escape (besides ^A).
.sp
.ne 3
.B break
.RI [ duration ]
.PP
Send a break signal for \fIduration\fP*0.25 seconds to this window.
For non-Posix systems the time interval may be rounded up to full seconds.
Most useful if a character device is attached to the window rather than
a shell process (See also chapter \*QWINDOW TYPES\*U). The maximum duration of
a break signal is limited to 15 seconds.
.sp
.ne 3
.B blanker
.PP
Activate the screen blanker. First the screen is cleared. If no blanker
program is defined, the cursor is turned off, otherwise, the
program is started and it's output is written to the screen.
The screen blanker is killed with the first keypress, the read key
is discarded.
.br
This command is normally used together with the \*Qidle\*U command.
.sp
.ne 3
.B blankerprg
.RI [ "program args" ]
.PP
Defines a blanker program. Disables the blanker program if no
arguments are given.
.sp
.ne 3
.B breaktype
.RI [ tcsendbreak | TIOCSBRK
.RI | TCSBRK ]
.PP
Choose one of the available methods of generating a break signal for
terminal devices. This command should affect the current window only.
But it still behaves identical to \*Qdefbreaktype\*U. This will be changed in
the future.
Calling \*Qbreaktype\*U with no parameter displays the break method for the
current window.
.sp
.ne 3
.B bufferfile
.RI [ exchange-file ]
.PP
Change the filename used for reading and writing with the paste buffer.
If the optional argument to the \*Qbufferfile\*U command is omitted,
the default setting (\*Q/tmp/tscreen-exchange\*U) is reactivated.
The following example will paste the system's password file into
the
\fItscreen\fP
window (using the paste buffer, where a copy remains):
.PP
.nf
	C-a : bufferfile /etc/passwd
	C-a < C-a ]
	C-a : bufferfile
.fi
.sp
.ne 3
.BR "c1 " [ on | off ]
.PP
Change c1 code processing. \*QC1 on\*U tells tscreen to treat
the input characters between 128 and 159 as control functions.
Such an 8-bit code is normally the same as ESC followed by the
corresponding 7-bit code. The default setting is to process c1
codes and can be changed with the \*Qdefc1\*U command.
Users with fonts that have usable characters in the
c1 positions may want to turn this off.
.sp
.ne 3
.BR "caption always" | splitonly
.RI [ string ]
.br
.B "caption string"
.RI [ string ]
.PP
This command controls the display of the window captions. Normally
a caption is only used if more than one window is shown on the
display (split screen mode). But if the type is set to
.B always
tscreen shows a caption even if only one window is displayed. The default
is
.BR splitonly .
.P
The second form changes the text used for the caption. You can use
all escapes from the \*QSTRING ESCAPES\*U chapter. tscreen uses
a default of `%3n %t'.
.P
You can mix both forms by providing a string as an additional argument.
.sp
.ne 3
.BI "charset " set
.PP
Change the current character set slot designation and charset
mapping.  The first four character of
\fIset\fP
are treated as charset designators while the fifth and sixth
character must be in range '0' to '3' and set the GL/GR charset
mapping. On every position a '.' may be used to indicate that
the corresponding charset/mapping should not be changed
(\fIset\fP is padded to six characters internally by appending '.'
chars). New windows have "BBBB02" as default charset, unless a
\*Qencoding\*U command is active.
.br
The current setting can be viewed with the \*Qinfo\*U command.
.sp
.ne 3
.B chdir
.RI [ directory ]
.PP
Change the \fIcurrent directory\fP of
\fItscreen\fP
to the specified directory, expanding "~" appropriately. If called
without an argument, change to your home directory (the value of
the environment variable $HOME).

All windows that are created by means of the \*Qtscreen\*U command
from within \*Q.tscreenrc\*U or by means of \*QC-a : tscreen ...\*U
or \*QC-a c\*U use this as their default directory.
Without a chdir command, this would be the directory from which
\fItscreen\fP
was invoked.
Hardcopy and log files are always written to the \fIwindow's\fP default
directory, \fInot\fP the current directory of the process running in the
window.
You can use this command multiple times in your .tscreenrc to start various
windows in different default directories, but the last chdir value will
affect all the windows you create interactively.
.sp
.ne 3
.B clear
.PP
Clears the current window and saves its image to the scrollback buffer.
.sp
.ne 3
.B colon
.RI [ prefix ]
.PP
Allows you to enter \*Q.tscreenrc\*U command lines. Useful
for on-the-fly modification of key bindings,
specific window creation and changing settings. Note that the \*Qset\*U
keyword no longer exists! Usually commands affect the current window rather
than default settings for future windows. Change defaults with commands
starting with 'def...'.

If you consider this as the `Ex command mode' of
.IR tscreen ,
you may regard \*QC-a esc\*U (copy mode) as its `Vi command mode'.
.sp
.ne 3
.B command
.RB [ -c
.IR class ]
.PP
This command has the same effect as typing the tscreen escape
character (^A). It is probably only useful for key bindings.
If the \*Q-c\*U option is given, select the specified command
class.  See also \*Qbind\*U and \*Qbindkey\*U.
.sp
.ne 3
.BR "compacthist " [ on | off ]
.PP
This tells tscreen whether to suppress trailing blank lines when
scrolling up text into the history buffer.
.sp
.ne 3
.BR "console " [ on | off ]
.PP
Grabs or un-grabs the machines console output to a window.
.IR Note :
Only the owner of /dev/console can grab the console output.
This command is only available if the machine supports the ioctl TIOCCONS.
.sp
.ne 3
.B copy
.PP
Enter copy/scrollback mode. This allows you to copy text from the current
window and its history into the paste buffer. In this mode a vi-like
`full screen editor' is active:
.br
.IR "Movement keys" :
.br
.in +4n
.ti -2n
\fBh\fP, \fBj\fP, \fBk\fP, \fBl\fP move the cursor line by line or
column by column.
.br
.ti -2n
\fB0\fP, \fB^\fP and \fB$\fP move to the leftmost column, to the first or last
non-whitespace character on the line.
.br
.ti -2n
\fBH\fP, \fBM\fP and \fBL\fP move the cursor to the leftmost column
of the top, center or bottom line of the window.
.br
.ti -2n
\fB+\fP and \fB\-\fP positions one line up and down.
.br
.ti -2n
\fBG\fP moves to the specified absolute line (default: end of buffer).
.br
.ti -2n
\fB|\fP moves to the specified absolute column.
.br
.ti -2n
\fBw\fP, \fBb\fP, \fBe\fP move the cursor word by word.
.br
.ti -2n
\fBB\fP, \fBE\fP move the cursor WORD by WORD (as in vi).
.br
.ti -2n
.\"\fBf\fP,\fBt\fP, \fBF\fP, \fBT\fP move the cursor forward/backward to the next occurence of the target.
\fBf/F\fP, \fBt/T\fP move the cursor forward/backward to the next occurence of the target. (eg, '3fy' will
move the cursor to the 3rd 'y' to the right.)
.br
.ti -2n
\fB;\fP \fB,\fP Repeat the last f/F/t/T command in the same/opposite direction.
.br
.ti -2n
\fBC-u\fP and \fBC-d\fP scroll the display up/down by the specified amount of
lines while preserving the cursor position. (Default: half screen-full).
.br
.ti -2n
\fBC-b\fP and \fBC-f\fP scroll the display up/down a full screen.
.br
.ti -2n
\fBg\fP moves to the beginning of the buffer.
.br
.ti -2n
\fB%\fP jumps to the specified percentage of the buffer.
.br
.ti -4n

.IR Note :
.br
Emacs style movement keys can be customized by a .tscreenrc command.
(E.\|g. markkeys "h=^B:l=^F:$=^E") There is no simple method for a full
emacs-style keymap, as this involves multi-character codes.

.br
.ti -4n
.IR Marking :
.br
The copy range is specified by setting two marks. The text between these marks
will be highlighted. Press
.br
.ti -2n
\fBspace\fP to set the first or second mark
respectively.
.br
.ti -2n
\fBY\fP and \fBy\fP used to mark one whole line or to mark from
start of line.
.br
.ti -2n
\fBW\fP marks exactly one word.
.br
.ti -4n
.IR "Repeat count" :
.br
Any of these commands can be prefixed with a repeat count number by pressing
digits
.br
.ti -2n
\fB0\fP..\fB9\fP which
is taken as a repeat count.
.br
Example: \*QC-a C-[ H 10 j 5 Y\*U will copy lines
11 to 15 into the paste buffer.
.br
.ti -4n
.IR Searching :
.ti -2n
\fB/\fP \fIVi\fP-like search forward.
.ti -2n
\fB?\fP \fIVi\fP-like search backward.
.ti -2n
\fBC-a s\fP \fIEmacs\fP style incremental search forward.
.ti -2n
\fBC-r\fP \fIEmacs\fP style reverse i-search.
.ti -4n
.IR Specials :
.br
There are however some keys that act differently than in
.IR vi .
\fIVi\fP
does not allow one to yank rectangular blocks of text, but
\fItscreen\fP
does. Press
.br
.ti -2n
\fBc\fP or \fBC\fP to set the left or right margin respectively. If no repeat count is
given, both default to the current cursor position.
.br
Example: Try this on a rather full text screen:
\*QC-a [ M 20 l SPACE c 10 l 5 j C SPACE\*U.

This moves one to the middle line of the screen, moves in 20 columns left,
marks the beginning of the paste buffer, sets the left column, moves 5 columns
down, sets the right column, and then marks the end of
the paste buffer. Now try:
.br
\*QC-a [ M 20 l SPACE 10 l 5 j SPACE\*U

and notice the difference in the amount of text copied.
.br
.ti -2n
\fBJ\fP joins lines. It toggles between 4 modes: lines separated by a
newline character (012), lines glued seamless, lines separated by a single
whitespace and comma separated lines. Note that you can prepend the newline
character with a carriage return character, by issuing a \*Qcrlf on\*U.
.br
.ti -2n
\fBv\fP is for all the
\fIvi\fP
users with \*Q:set numbers\*U \- it toggles the left margin between column 9
and 1. Press
.br
.ti -2n
\fBa\fP before the final space key to toggle in append mode. Thus
the contents of the paste buffer will not be overwritten, but is appended to.
.br
.ti -2n
\fBA\fP toggles in append mode and sets a (second) mark.
.br
.ti -2n
\fB>\fP sets the (second) mark and writes the contents of the paste buffer to
the tscreen-exchange file (/tmp/tscreen-exchange per default) once copy-mode is
finished.
.br
This example demonstrates how to dump the whole scrollback buffer
to that file: \*QC-A [ g SPACE G $ >\*U.
.br
.ti -2n
\fBC-g\fP gives information about the current line and column.
.br
.ti -2n
\fBx\fP exchanges the first mark and the current cursor position. You
can use this to adjust an already placed mark.
.br
.ti -2n
\fB@\fP does nothing. Does not even exit copy mode.
.br
.ti -2n
All keys not described here exit copy mode.
.in -4n
.sp
.ne 3
.BR "crlf " [ on | off ]
.PP
This affects the copying of text regions with the `C-a [' command. If it is set
to `on', lines will be separated by the two character sequence `CR' - `LF'.
Otherwise (default) only `LF' is used.
When no parameter is given, the state is toggled.
.sp
.ne 3
.BR "debug on" | off
.PP
Turns runtime debugging on or off. If
\fItscreen\fP
has been compiled with option -DDEBUG debugging available and is turned on per
default. Note that this command only affects debugging output from the main
\*QTSCREEN\*U process correctly. Debug output from attacher processes can only
be turned off once and forever.
.sp
.ne 3
.BR "defautonuke on" | off
.PP
Same as the \fBautonuke\fP command except that the default setting for new displays is changed. Initial setting is `off'.
Note that you can use the special `AN' terminal capability if you
want to have a dependency on the terminal type.
.sp
.ne 3
.BR "defbce on" | off
.PP
Same as the \fBbce\fP command except that the default setting for new
windows is changed. Initial setting is `off'.
.sp
.ne 3
.B defbreaktype
.RI [ tcsendbreak | TIOCSBRK
.RI | TCSBRK ]
.PP
Choose one of the available methods of generating a break signal for
terminal devices. The preferred methods are
.IR tcsendbreak " and " TIOCSBRK .
The third,
.IR TCSBRK ,
blocks the complete
\fItscreen\fP
session for the duration
of the break, but it may be the only way to generate long breaks.
.IR Tcsendbreak " and " TIOCSBRK
may or may not produce long breaks with spikes (e.g. 4 per
second). This is not only system-dependent, this also differs between
serial board drivers.
Calling \*Qdefbreaktype\*U with no parameter displays the current setting.
.sp
.ne 3
.BR "defc1 on" | off
.PP
Same as the \fBc1\fP command except that the default setting for new
windows is changed. Initial setting is `on'.
.sp
.ne 3
.BR "defcharset " [ \fIset ]
.PP
Like the \fBcharset\fP command except that the default setting for
new windows is changed. Shows current default if called without
argument.
.sp
.ne 3
.BI "defescape " xy
.PP
Set the default command characters. This is equivalent to the
\*Qescape\*U except that it is useful multiuser sessions only. In a
multiuser session \*Qescape\*U changes the command character of the
calling user, where \*Qdefescape\*U changes the default command
characters for users that will be added later.
.sp
.ne 3
.BR "defflow on" | off | auto
.RB [ interrupt ]
.PP
Same as the \fBflow\fP command except that the default setting for new windows
is changed. Initial setting is `auto'.
Specifying \*Qdefflow auto interrupt\*U is the same as the command-line options
.B \-fa
and
.BR \-i .
.sp
.ne 3
.BR "defgr on" | off
.PP
Same as the \fBgr\fP command except that the default setting for new
windows is changed. Initial setting is `off'.
.sp
.ne 3
.BR "defhstatus " [ \fIstatus ]
.PP
The hardstatus line that all new windows will get is set to
\fIstatus\fR.\fP
This command is useful to make the hardstatus of every window
display the window number or title or the like.
\fIStatus\fP
may contain the same directives as in the window messages, but
the directive escape character is '^E' (octal 005) instead of '%'.
This was done to make a misinterpretation of program generated
hardstatus lines impossible.
If the parameter
\fIstatus\fP
is omitted, the current default string is displayed.
Per default the hardstatus line of new windows is empty.
.sp
.ne 3
.BI "defencoding " enc
.PP
Same as the \fBencoding\fP command except that the default setting for new
windows is changed. Initial setting is the encoding taken from the
terminal.
.sp
.ne 3
.BR "deflog on" | off
.PP
Same as the \fBlog\fP command except that the default setting for new windows
is changed. Initial setting is `off'.
.sp
.ne 3
.BR "deflogin on" | off
.PP
Same as the \fBlogin\fP command except that the default setting for new windows
is changed. This is initialized with `on' as distributed (see config.h.in).
.sp
.ne 3
.BI "defmode " mode
.PP
The mode of each newly allocated pseudo-tty is set to \fImode\fP.
\fIMode\fP is an octal number.
When no \*Qdefmode\*U command is given, mode 0622 is used.
.sp
.ne 3
.BR "defmonitor on" | off
.PP
Same as the \fBmonitor\fP command except that the default setting for new
windows is changed. Initial setting is `off'.
.sp
.ne 3
.B defnonblock
.BR on | off | \fInumsecs
.PP
Same as the \fBnonblock\fP command except that the default setting for
displays is changed. Initial setting is `off'.
.sp
.ne 3
.BI "defobuflimit " limit
.PP
Same as the \fBobuflimit\fP command except that the default setting for new displays is changed. Initial setting is 256 bytes.
Note that you can use the special 'OL' terminal capability if you
want to have a dependency on the terminal type.
.sp
.ne 3
.BI "defscrollback " num
.PP
Same as the \fBscrollback\fP command except that the default setting for new
windows is changed. Initial setting is 100.
.sp
.ne 3
.BI "defshell " command
.PP
Synonym to the \fBshell\fP command. See there.
.sp
.ne 3
.BR "defsilence on" | off
.PP
Same as the \fBsilence\fP command except that the default setting for new
windows is changed. Initial setting is `off'.
.sp
.ne 3
.BI "defslowpaste " msec"
.PP
Same as the \fBslowpaste\fP command except that the default setting for new
windows is changed. Initial setting is 0 milliseconds, meaning `off'.
.sp
.ne 3
.BR "defutf8 on" | off
.PP
Same as the \fButf8\fP command except that the default setting for new
windows is changed. Initial setting is `on' if tscreen was started with
\*Q-U\*U, otherwise `off'.
.sp
.ne 3
.BR "defwrap on" | off
.PP
Same as the \fBwrap\fP command except that the default setting for new
windows is changed. Initially line-wrap is on and can be toggled with the
\*Qwrap\*U command (\*QC-a r\*U) or by means of "C-a : wrap on|off".
.sp
.ne 3
.BR "defwritelock on" | off | auto
.PP
Same as the \fBwritelock\fP command except that the default setting for new
windows is changed. Initially writelocks will off.
.sp
.ne 3
.B detach
.RB [ -h ]
.PP
Detach the
\fItscreen\fP
session (disconnect it from the terminal and put it into the background).
This returns you to the shell where you invoked
.IR tscreen .
A detached
\fItscreen\fP
can be resumed by invoking
\fItscreen\fP
with the
.B \-r
option (see also section \*QCOMMAND-LINE OPTIONS\*U). The
.B \-h
option tells tscreen to immediately close the connection to the
terminal (\*Qhangup\*U).
.sp
.ne 3
.BR "digraph " [ \fIpreset ]
.PP
This command prompts the user for a digraph sequence. The next
two characters typed are looked up in a builtin table and the
resulting character is inserted in the input stream. For example,
if the user enters 'a"', an a-umlaut will be inserted. If the
first character entered is a 0 (zero),
\fItscreen\fP
will treat the following characters (up to three) as an octal
number instead.  The optional argument
\fIpreset\fP
is treated as user input, thus one can create an \*Qumlaut\*U key.
For example the command "bindkey ^K digraph '"'" enables the user
to generate an a-umlaut by typing CTRL-K a.
.sp
.ne 3
.B dinfo
.PP
Show what tscreen thinks about your terminal. Useful if you want to know
why features like color or the alternate charset don't work.
.sp
.ne 3
.B displays
.PP
Shows a tabular listing of all currently connected user front-ends (displays).
This is most useful for multiuser sessions.
.sp
.ne 3
.B dumptermcap
.PP
Write the termcap entry for the virtual terminal optimized for the currently
active window to the file \*Q.termcap\*U in the user's
\*Q$HOME/.tscreen\*U directory (or wherever
\fItscreen\fP
stores its sockets. See the \*QFILES\*U section below).
This termcap entry is identical to the value of the environment variable
$TERMCAP that is set up by
\fItscreen\fP
for each window. For terminfo based systems you will need to run a converter
like
.IR captoinfo
and then compile the entry with
.IR tic .
.sp
.ne 3
.BR "echo " [ -n ]
\fImessage\fP
.PP
The echo command may be used to annoy
\fItscreen\fP
users with a 'message of the
day'. Typically installed in a global tscreenrc.
The option \*Q-n\*U may be used to suppress the line feed.
See also \*Qsleep\*U.
Echo is also useful for online checking of environment variables.
.sp
.ne 3
.BI "encoding " enc
.RI [ enc ]
.PP
Tell
\fItscreen\fP
how to interpret the input/output. The first argument
sets the encoding of the current window. Each window can emulate
a different encoding. The optional second parameter overwrites
the encoding of the connected terminal. It should never be
needed as tscreen uses the locale setting to detect the encoding.
There is also a way to select a terminal encoding depending on
the terminal type by using the \*QKJ\*U termcap entry.

Supported encodings are eucJP, SJIS, eucKR, eucCN, Big5, GBK, KOI8-R,
CP1251, UTF-8, ISO8859-2, ISO8859-3, ISO8859-4, ISO8859-5, ISO8859-6,
ISO8859-7, ISO8859-8, ISO8859-9, ISO8859-10, ISO8859-15, jis.

See also \*Qdefencoding\*U, which changes the default setting of a new
window.
.sp
.ne 3
.BI "escape " xy
.PP
Set the command character to \fIx\fP and the character generating a literal
command character (by triggering the \*Qmeta\*U command) to \fIy\fP (similar
to the \-e option).
Each argument is either a single character, a two-character sequence
of the form \*Q^x\*U (meaning \*QC-x\*U), a backslash followed by an octal
number (specifying the ASCII code of the character), or a backslash followed
by a second character, such as \*Q\e^\*U or \*Q\e\e\*U.
The default is \*Q^Aa\*U.
.sp
.ne 3
.B eval
\fIcommand1\fP
.RI [ command2
.IR ... ]
.PP
Parses and executes each argument as separate command.
.sp
.ne 3
.B exec
.RI [[ fdpat ]
.IR "newcommand " [ "args ..." ]]
.PP
Run a unix subprocess (specified by an executable path \fInewcommand\fP and its
optional arguments) in the current window. The flow of data between
newcommands stdin/stdout/stderr, the process originally started in the window
(let us call it "application-process") and tscreen itself (window) is
controlled by the file descriptor pattern fdpat.
This pattern is basically a three character sequence representing stdin, stdout
and stderr of newcommand. A dot (.) connects the file descriptor
to
.IR tscreen .
An exclamation mark (!) causes the file
descriptor to be connected to the application-process. A colon (:) combines
both.
User input will go to newcommand unless newcommand receives the
application-process'
output (fdpats first character is `!' or `:') or a pipe symbol (|) is added
(as a fourth character) to the end of fdpat.
.br
Invoking `exec' without arguments shows name and arguments of the currently
running subprocess in this window. Only one subprocess a time can be running
in each window.
.br
When a subprocess is running the `kill' command will affect it instead of the
windows process.
.br
Refer to the postscript file `doc/fdpat.ps' for a confusing illustration
of all 21 possible combinations. Each drawing shows the digits 2,1,0
representing the three file descriptors of newcommand. The box marked
`W' is the usual pty that has the application-process on its slave side.
The box marked `P' is the secondary pty that now has
\fItscreen\fP
at its master side.
.sp
Abbreviations:
.br
Whitespace between the word `exec' and fdpat and the command
can be omitted. Trailing dots and a fdpat consisting only of dots can be
omitted. A simple `|' is synonymous for the pattern `!..|'; the word exec can
be omitted here and can always be replaced by `!'.
.sp
Examples:
.IP
exec ... /bin/sh
.br
exec /bin/sh
.br
!/bin/sh
.PP
Creates another shell in the same window, while the original shell is still
running. Output of both shells is displayed and user input is sent to the new
/bin/sh.
.IP
exec !.. stty 19200
.br
exec ! stty 19200
.br
!!stty 19200
.PP
Set the speed of the window's tty. If your stty command operates on stdout,
then add another `!'.
.IP
exec !..| less
.br
|less
.PP
This adds a pager to the window output. The special character `|' is needed to
give the user control over the pager although it gets its input from the
window's process. This works, because
\fIless\fP
listens on stderr (a behavior that
\fItscreen\fP
would not expect without the `|')
when its stdin is not a tty.
\fILess\fP
versions newer than 177 fail miserably here; good old
\fIpg\fP
still works.
.IP
!:sed -n s/.*Error.*/\e007/p
.PP
Sends window output to both, the user and the sed command. The sed inserts an
additional bell character (oct. 007) to the window output seen by
.IR tscreen .
This will cause "Bell in window x" messages, whenever the string "Error"
appears in the window.
.sp
.ne 3
.B fit
.PP
Change the window size to the size of the current region. This
command is needed because tscreen doesn't adapt the window size
automatically if the window is displayed more than once.
.sp
.ne 3
.B flow
.RB [ on | off | "auto\fR]\fP"
.PP
Sets the flow-control mode for this window.
Without parameters it cycles the current window's flow-control setting from
"automatic" to "on" to "off".
See the discussion on \*QFLOW-CONTROL\*U later on in this document for full
details and note, that this is subject to change in future releases.
Default is set by `defflow'.
.sp
.ne 3
.BR "focus " [ up | down | top | bottom ]
.PP
Move the input focus to the next region. This is done in a cyclic
way so that the top region is selected after the bottom one. If
no subcommand is given it defaults to `down'. `up' cycles in the
opposite order, `top' and `bottom' go to the top and bottom
region respectively. Useful bindings are (j and k as in vi)
.nf
    bind j focus down
    bind k focus up
    bind t focus top
    bind b focus bottom
.fi
Note that \fBk\fP is traditionally bound to the \fIkill\fP command.
.sp
.ne 3
.B "focusminsize "
.PP
Min size of focus FIXME
.sp
.ne 3
.BR "gr " [ on | off ]
.PP
Turn GR charset switching on/off. Whenever tscreen sees an input
character with the 8th bit set, it will use the charset stored in the
GR slot and print the character with the 8th bit stripped. The
default (see also \*Qdefgr\*U) is not to process GR switching because
otherwise the ISO88591 charset would not work.
.sp
.ne 3
.B "group "
.PP
group things FIXME
.sp
.ne 3
.B hardcopy
.RB [ -h ]
.RI [ file ]
.PP
Writes out the currently displayed image to the file \fIfile\fP,
or, if no filename is specified, to \fIhardcopy.n\fP in the
default directory, where \fIn\fP is the number of the current window.
This either appends or overwrites the file if it exists. See below.
If the option \fB-h\fP is specified, dump also the contents of the
scrollback buffer.
.sp
.ne 3
.BR "hardcopy_append on" | off
.PP
If set to "on",
\fItscreen\fP
will append to the "hardcopy.n" files created by the command \*QC-a h\*U,
otherwise these files are overwritten each time.
Default is `off'.
.sp
.ne 3
.BI "hardcopydir "directory
.PP
Defines a directory where hardcopy files will be placed. If unset, hardcopys
are dumped in
.IR tscreen 's
current working directory.
.sp
.ne 3
.BR "hardstatus " [ on | off ]
.br
.BR "hardstatus \fR[\fBalways\fR]\fBlastline" | message | ignore
.RI [ string ]
.br
.B "hardstatus string"
.RI [ string ]
.PP
This command configures the use and emulation of the terminal's
hardstatus line. The first form
toggles whether
\fItscreen\fP
will use the hardware status line to display messages. If the
flag is set to `off', these messages
are overlaid in reverse video mode at the display line. The default
setting is `on'.
.P
The second form tells
\fItscreen\fP
what to do if the terminal doesn't
have a hardstatus line (i.e. the termcap/terminfo capabilities
"hs", "ts", "fs" and "ds" are not set). If the type
\*Qlastline\*U is used,
\fItscreen\fP
will reserve the last line of the
display for
the hardstatus. \*Qmessage\*U uses
\fItscreen's\fP
message mechanism and
\*Qignore\*U tells
\fItscreen\fP
never to display the hardstatus.
If you prepend the word \*Qalways\*U to the type (e.g., \*Qalwayslastline\*U),
\fItscreen\fP
will use the type even if the terminal supports a hardstatus.
.P
The third form specifies the contents of the hardstatus line.  '%h' is
used as default string, i.e., the stored hardstatus of the current
window (settable via \*QESC]0;<string>^G\*U or \*QESC_<string>ESC\e\*U)
is displayed.  You can customize this to any string you like including
the escapes from the \*QSTRING ESCAPES\*U chapter. If you leave out
the argument
.IR string ,
the current string is displayed.
.P
You can mix the second and third form by providing the string as
additional argument.
.sp
.ne 3
.B height
.RB [ -w | -d ]
.RI [ lines " [" cols ]]
.PP
Set the display height to a specified number of lines. When no argument
is given it toggles between 24 and 42 lines display. You can also
specify a width if you want to change both values.
The
.B -w
option tells tscreen to leave the display size unchanged and just set
the window size,
.B -d
vice versa.
.sp
.ne 3
.B help
.RB [ -c
.IR class ]
.PP
Not really a online help, but
displays a help
\fItscreen\fP
showing you all the key bindings.
The first pages list all the internal commands followed by their current
bindings.
Subsequent pages will display the custom commands, one command per key.
Press space when you're done reading each page, or return to exit early.
All other characters are ignored. If the \*Q-c\*U option is given,
display all bound commands for the specified command class.
See also \*QDEFAULT KEY BINDINGS\*U section.
.sp
.ne 3
.B hide [WindowID]
.PP
Toggles hiding of the specified window. When hidden, the next/prev/other
window operations won't switch to it. If no window is specified the current
window will be toggled.
.sp
.ne 3
.B history
.PP
Usually users work with a shell that allows easy access to previous commands.
For example csh has the command \*Q!!\*U to repeat the last command executed.
\fItscreen\fP
allows you to have a primitive way of re-calling \*Qthe command that
started ...\*U: You just type the first letter of that command, then hit
`C-a {' and
\fItscreen\fP
tries to find a previous line that matches with the `prompt character'
to the left of the cursor. This line is pasted into this window's input queue.
Thus you have a crude command history (made up by the visible window and its
scrollback buffer).
.sp
.ne 3
.BI "hstatus " status
.PP
Change the window's hardstatus line to the string \fIstatus\fP.
.sp
.ne 3
.B idle
.RI [ timeout
.RI [ "cmd args" ]]
.PP
Sets a command that is run after the specified number of seconds
inactivity is reached. This command will normally be the \*Qblanker\*U
command to create a screen blanker, but it can be any tscreen command.
If no command is specified, only the timeout is set. A timeout of
zero (ot the special timeout \fBoff\fP) disables the timer.
If no arguments are given, the current settings are displayed.
.sp
.ne 3
.BR "if " "test arg "
.IR "string1 " [ "string2 ..." ]
.br
.BR "if " "arg1 op arg2"
.IR "string1 " [ "string2 ..." ]
.PP
Allows you to write conditional configuration files. If \fBtest\fP succeeds,
each of the named \fIstring\fPs will be executed via \fBeval\fP. The available
tests are:
.sp
Single-arg tests
.sp
.nf
  -a name        TRUE if the named alias exists
  -d path        TRUE if the path specified is a directory.
  -e path        TRUE if the path specified exists.
  -f path        TRUE if the path specified is a plain file.
  -x path        TRUE if the path specified is an executable file.
  -z path        TRUE if the path is greater than 0 characters long.
.if
.sp
.sp
Double arg tests
.sp
.nf
  val1 = val2    TRUE if val1 and val2 are equal.
  val1 == val2   TRUE if val1 and val2 are equal.
  val1 != val2   TRUE if val1 and val2 not equal.
  val1 -eq val2  TRUE if val1 and val2 are equal, numerically
  val1 -ne val2  TRUE if val1 and val2 are not equal, numerically

.if
.sp
Examples:
.sp
.nf
 #  If we have cmatrix then:
 #   After we're idle for more than 60 seconds :
 #    - find/create the window titled 'cmatrix'
 #    - run cmatrix in it.

 if -x /usr/bin/cmatrix 'idle 60 eval "tscreen -F -t cmatrix /usr/bin/cmatrix -f -o -u 10"'

 #  If the current username is 'skx' then we'll do something

 if $USER = skx "source ~/.tscreen.skx"

 #  If hostname is gold.my.flat do something ..

 if `hostname` = "gold.my.flat" "alias gold screen ssh skx@localhost"
.if
.ne 3
.BR "ignorecase " [ on | off ]
.PP
Tell tscreen to ignore the case of characters in searches. Default is
`off'.
.sp
.ne 3
.B info
.PP
Uses the message line to display some information about the current window:
the cursor position in the form \*Q(column,row)\*U starting with \*Q(1,1)\*U,
the terminal width and height plus the size of the scrollback buffer in lines,
like in \*Q(80,24)+50\*U, the current state of window XON/XOFF flow control
is shown like this (See also section FLOW CONTROL):

.nf
  +flow     automatic flow control, currently on.
  -flow     automatic flow control, currently off.
  +(+)flow  flow control enabled. Agrees with automatic control.
  -(+)flow  flow control disabled. Disagrees with automatic control.
  +(-)flow  flow control enabled. Disagrees with automatic control.
  -(-)flow  flow control disabled. Agrees with automatic control.
.fi

The current line wrap setting (`+wrap' indicates enabled, `\-wrap' not) is
also shown. The flags `ins', `org', `app', `log', `mon' or `nored' are
displayed when the window is in insert mode, origin mode,
application-keypad mode, has output logging,
activity monitoring or partial redraw enabled.

The currently active character set (\fIG0\fP, \fIG1\fP, \fIG2\fP,
or \fIG3\fP) and in square brackets the terminal character sets that are
currently designated as \fIG0\fP through \fIG3\fP is shown. If the window
is in UTF-8 mode, the string \*QUTF-8\*U is shown instead.

Additional modes depending on the type of the window are displayed at the end of the status line (See also chapter \*QWINDOW TYPES\*U).
.br
If the state machine of the terminal emulator is in a non-default state,
the info line is started with a string identifying the current state.
.br
For system information use the \*Qtime\*U command.
.sp
.ne 3
.B kanji
.PP
See \fBencoding\fP.
.sp
.ne 3
.B kill
.PP
Kill current window.
.br
If there is an `exec' command running then it is killed. Otherwise the process
(shell) running in the window receives a HANGUP condition,
the window structure is removed and
\fItscreen\fP
(your display) switches to another
window.  When the last window is destroyed,
\fItscreen\fP
exits.
After a kill
\fItscreen\fP
switches to the previously displayed window.
.br
Note:
\fIEmacs\fP
users should keep this command in mind, when killing a line.
It is recommended not to use \*QC-a\*U as the
\fItscreen\fP
escape key or to rebind kill to \*QC-a K\*U.
.sp
.ne 3
.B lastmsg
.PP
Redisplay the 20 most recent messages produced in the message/status area.
Useful if you're typing when a message appears, because  the message goes
away when you press a key (unless your terminal has a hardware status line).
Refer to the commands \*Qmsgwait\*U and \*Qmsgminwait\*U for fine tuning.
.sp
.ne 3
.BR "layout attach "  \fIstring | :last
.br
.BR "layout autosave " [ on | off ]
.br
.BR "layout new" | name | load | " save \fIstring"
.br
.BR "layout next" | prev
.PP
A layout stores the current setup of the display, i.e. all the
  slices and the window assignments.

      layout save Desktop1

  will save the current setup under the name "Desktop1". If you
  detach and reattach later on, the layout will automatically
  be restored. "Desktop1" will become the current layout.

      layout autosave off

  This turns the autosafe feature off. Layouts are automatically
  saved if autosave is on and the user detachs or switches to
  another layout.

      layout new Desktop2

  Create a new empty layout named "Desktop2".

      layout name "foo"

  Rename the current layout to "foo".

      layout next
      layout prev
      layout load "name"

  Load the next/prev layout / the layout named "name".

      layout attach :last
      layout attach "name"

  Set the layout used when somebody is attaching. Default is ":last",
  this is the layout that was current when the last detach was done.

  Besides the restoring of the screen on re-attach, layouts can be
  used to implement a kind of "virtual desktop" in screen. Say
  you put "layout save Desktop1" in your ~/.tscreenrc. If you
  need a new Desktop, do "^A:layout new Desktop2". You can then
  use "layout next" to switch between both layouts.
.sp
.ne 3
.B license
.PP
Display the disclaimer page. This is done whenever
\fItscreen\fP
is started without options, which should be often enough. See also
the \*Qstartup_message\*U command.
.sp
.ne 3
.B lockscreen
.PP
Lock this display.
Call a screenlock program (/usr/bin/lock or a builtin if no
other is available). tscreen does not accept any command keys until this program
terminates. Meanwhile processes in the windows may continue, as the windows
are in the `detached' state. The screenlock program may be changed through the
environment variable $LOCKPRG (which must be set in the shell from which
\fItscreen\fP
is started) and is executed with the user's uid and gid.
.br
Warning:
When you leave other shells unlocked and you have no password set on
.IR tscreen ,
the lock is void: One could easily re-attach from an unlocked
shell. This feature should rather be called `lockterminal'.
.sp
.ne 3
.BR "log " [ on | off ]
.PP
Start/stop writing output of the current window to a file
\*Qtscreenlog.\fIn\fP\*U in the window's default directory, where \fIn\fP
is the number of the current window. This filename can be changed with
the `logfile' command. If no parameter is given, the state
of logging is toggled. The session log is appended to the previous contents
of the file if it already exists. The current contents and the contents
of the scrollback history are not included in the session log.
Default is `off'.
.sp
.ne 3
.BI "logfile " filename
.br
.BI "logfile flush " secs
.PP
Defines the name the log files will get. "~" will be expanded appropriately
if included in \fIfilename\fP. The default is \*Qtscreenlog.%n\*U.
The second form changes the number of seconds
\fItscreen\fP
will wait before flushing the logfile buffer to the file-system. The
default value is 10 seconds.
.sp
.ne 3
.BR "login " [ on | off ]
.PP
Adds or removes the entry in the utmp database file for the current window.
This controls if the window is `logged in'.
When no parameter is given, the login state of the window is toggled.
Additionally to that toggle, it is convenient having a `log in' and a `log out'
key. E.\|g. `bind I login on' and `bind O login off' will map these
keys to be C-a I and C-a O.
The default setting (in config.h.in) should be \*Qon\*U for a
\fItscreen\fP
that runs under suid-root.
Use the \*Qdeflogin\*U command to change the default login state for new
windows. Both commands are only present when
\fItscreen\fP
has been compiled with utmp support.
.sp
.ne 3
.BR "logtstamp " [ on | off ]
.br
.B "logtstamp after"
.RI [ secs ]
.br
.B "logtstamp string"
.RI [ string ]
.PP
This command controls logfile time-stamp mechanism of
\fItscreen.\fP
If
time-stamps are turned \*Qon\*U,
\fItscreen\fP
adds a string containing
the current time to the logfile after two minutes of inactivity.
When output continues and more than another two minutes have passed,
a second time-stamp is added to document the restart of the
output. You can change this timeout with the second form
of the command. The third form is used for customizing the time-stamp
string (`-- %n:%t -- time-stamp -- %M/%d/%y %c:%s --\\n' by
default).
.sp
.ne 3
.B mapdefault
.PP
Tell
\fItscreen\fP
that the next input character should only be looked up
in the default bindkey table. See also \*Qbindkey\*U.
.sp
.ne 3
.B mapnotnext
.PP
Like mapdefault, but don't even look in the default bindkey table.
.sp
.ne 3
.B maptimeout
.RI [ timo ]
.PP
Set the inter-character timer for input sequence detection to a timeout
of
\fItimo\fP
ms. The default timeout is 300ms. Maptimeout with no arguments shows
the current setting.
See also \*Qbindkey\*U.
.sp
.ne 3
.BI "markkeys " string
.PP
This is a method of changing the keymap used for copy/history mode.
The string is made up of \fIoldchar\fP=\fInewchar\fP pairs which are
separated by `:'. Example: The string \*QB=^B:F=^F\*U will change the
keys `C-b' and `C-f' to the vi style binding (scroll up/down fill page).
This happens to be the default binding for `B' and `F'.
The command \*Qmarkkeys h=^B:l=^F:$=^E\*U would set the mode for an emacs-style
binding.
If your terminal sends characters, that cause you to abort copy mode,
then this command may help by binding these characters to do nothing.
The no-op character is `@' and is used like this: \*Qmarkkeys
@=L=H\*U if you do not want to use the `H' or `L' commands any longer.
As shown in this example, multiple keys can be assigned to one function in a
single statement.
.sp
.ne 3
.BI "maxwin " num
.PP
Set the maximum window number tscreen will create. Doesn't affect
already existing windows. The number may only be decreased.
.sp
.ne 3
.B meta
.PP
Insert the command character (C-a) in the current window's input stream.
.sp
.ne 3
.BR "monitor " [ on | off ]
.PP
Toggles activity monitoring of windows.
When monitoring is turned on and an affected window is switched into the
background, you will receive the activity notification message in the
status line at the first sign of output and the window will also be marked
with an `@' in the window-status display.
Monitoring is initially off for all windows.
.sp
.ne 3
.BI "msgminwait " sec
.PP
Defines the time
\fItscreen\fP
delays a new message when one message is currently displayed.
The default is 1 second.
.sp
.ne 3
.BI "msgwait " sec
.PP
Defines the time a message is displayed if
\fItscreen\fP
is not disturbed by other activity. The default is 5 seconds.
.sp
.ne 3
.BR "multiuser on" | off
.PP
Switch between singleuser and multiuser mode. Standard
\fItscreen\fP
operation is singleuser. In multiuser mode the commands `acladd',
`aclchg', `aclgrp' and `acldel'
can be used to enable (and disable) other users accessing this
\fItscreen\fP
session.
.sp
.ne 3
.B next
.PP
Switch to the next window.
This command can be used repeatedly to cycle through the list of windows.
.sp
.ne 3
.B nonblock
.RB [ on | off | \fInumsecs ]
.PP
Tell tscreen how to deal with user interfaces (displays) that cease to
accept output. This can happen if a user presses ^S or a TCP/modem
connection gets cut but no hangup is received. If nonblock is
\fBoff\fP (this is the default) tscreen waits until the display
restarts to accept the output. If nonblock is \fBon\fP, tscreen
waits until the timeout is reached (\fBon\fP is treated as 1s). If the
display still doesn't receive characters, tscreen will consider
it \*Qblocked\*U and stop sending characters to it. If at
some time it restarts to accept characters, tscreen will unblock
the display and redisplay the updated window contents.
.sp
.ne 3
.BR "number " [ \fIn ]
.PP
Change the current windows number. If the given number \fIn\fP is already
used by another window, both windows exchange their numbers. If no argument is
specified, the current window number (and title) is shown.
.sp
.ne 3
.BR "obuflimit " [ \fIlimit ]
.PP
If the output buffer contains more bytes than the specified limit, no
more data will be
read from the windows. The default value is 256. If you have a fast
display (like xterm), you can set it to some higher value. If no
argument is specified, the current setting is displayed.
.sp
.ne 3
.B only
.PP
Kill all regions but the current one.
.sp
.ne 3
.B other
.PP
Switch to the window displayed previously. If this window does no longer exist,
\fIother\fP has the same effect as \fInext\fP.
.sp
.ne 3
.BR "partial on" | off
.PP
Defines whether the display should be refreshed (as with \fIredisplay\fP) after
switching to the current window. This command only affects the current window.
To immediately affect all windows use the \fIallpartial\fP command.
Default is `off', of course.  This default is fixed, as there is currently no
\fIdefpartial\fP command.
.sp
.ne 3
.BR "password " [ \fIcrypted_pw ]
.PP
Present a crypted password in your \*Q.tscreenrc\*U file and
\fItscreen\fP
will ask
for it, whenever someone attempts to resume a detached. This is useful
if you have privileged programs running under
\fItscreen\fP
and you want to protect your session from reattach attempts by another user
masquerading as your uid (i.e. any superuser.)
If no crypted password is specified,
\fItscreen\fP
prompts twice for typing a
password and places its encryption in the paste buffer.
Default is `none', this disables password checking.
.sp
.ne 3
.BR paste
.RI [ registers " [" dest_reg ]]
.PP
Write the (concatenated) contents of the specified registers to the stdin queue
of the current window. The register '.' is treated as the
paste buffer. If no parameter is given the user is prompted for a single
register to paste.
The paste buffer can be filled with the \fIcopy\fP, \fIhistory\fP and
\fIreadbuf\fP commands.
Other registers can be filled with the \fIregister\fP, \fIreadreg\fP and
\fIpaste\fP commands.
If \fIpaste\fP is called with a second argument, the contents of the specified
registers is pasted into the named destination register rather than
the window. If '.' is used as the second argument, the displays paste buffer is
the destination.
Note, that \*Qpaste\*U uses a wide variety of resources: Whenever a second
argument is specified no current window is needed. When the source specification
only contains registers (not the paste buffer) then there need not be a current
display (terminal attached), as the registers are a global resource. The
paste buffer exists once for every user.
.sp
.ne 3
.BR "pastefont " [ on | off ]
.PP
Tell
\fItscreen\fP
to include font information in the paste buffer. The
default is not to do so. This command is especially useful for
multi character fonts like kanji.
.sp
.ne 3
.B pow_break
.PP
Reopen the window's terminal line and send a break condition. See `break'.
.sp
.ne 3
.B pow_detach
.PP
Power detach.
Mainly the same as \fIdetach\fP, but also sends a HANGUP signal to
the parent process of
.IR tscreen .
CAUTION: This will result in a logout, when
\fItscreen\fP
was started from your login shell.
.sp
.ne 3
.B pow_detach_msg
.RI [ message ]
.PP
The \fImessage\fP specified here is output whenever a `Power detach' was
performed. It may be used as a replacement for a logout message or to reset
baud rate, etc.
Without parameter, the current message is shown.
.sp
.ne 3
.B prev
.PP
Switch to the window with the next lower number.
This command can be used repeatedly to cycle through the list of windows.
.sp
.ne 3
.B printcmd
.RI [ cmd ]
.PP
If
\fIcmd\fP
is not an empty string,
\fItscreen\fP
will not use the terminal capabilities
\*Qpo/pf\*U if it detects an ansi print sequence
.BR "ESC [ 5 i" ,
but pipe the output into
.IR cmd .
This should normally be a command like \*Qlpr\*U or
\*Q'cat > /tmp/scrprint'\*U.
.B printcmd
without a command displays the current setting.
The ansi sequence
.B "ESC \e"
ends printing and closes the pipe.
.br
Warning: Be careful with this command! If other user have write
access to your terminal, they will be able to fire off print commands.
.sp
.ne 3
.BR process " [" \fIkey ]
.PP
Stuff the contents of the specified register into
.IR tscreen 's
input queue. If no argument is given you are prompted for a
register name. The text is parsed as if it had been typed in from the user's
keyboard. This command can be used to bind multiple actions to a single key.
.sp
.ne 3
.B quit
.PP
Kill all windows and terminate
.IR tscreen .
Note that on VT100-style terminals the keys C-4 and C-\e are identical.
This makes the default bindings dangerous:
Be careful not to type C-a C-4 when selecting window no. 4.
Use the empty bind command (as in \*Qbind '^\e'\*U) to remove a key binding.
.sp
.ne 3
.B readbuf
.RB [ -e
.IR encoding ]
.RI [ filename ]
.PP
Reads the contents of the specified file into the paste buffer.
You can tell tscreen the encoding of the file via the \fB-e\fP option.
If no file is specified, the tscreen-exchange filename is used.
See also \*Qbufferfile\*U command.
.sp
.ne 3
.B readreg
.RB [ -e
.IR encoding ]
.RI [ register " [" filename ]]
.PP
Does one of two things, dependent on number of arguments: with zero or one
arguments it it duplicates the paste buffer contents into the register specified
or entered at the prompt. With two arguments it reads the contents of the named
file into the register, just as \fIreadbuf\fP reads the tscreen-exchange file
into the paste buffer.
You can tell tscreen the encoding of the file via the \fB-e\fP option.
The following example will paste the system's password file into
the
\fItscreen\fP
window (using register p, where a copy remains):
.PP
.nf
	C-a : readreg p /etc/passwd
	C-a : paste p
.fi
.sp
.ne 3
.B redisplay
.PP
Redisplay the current window. Needed to get a full redisplay when in
partial redraw mode.
.sp
.ne 3
.B register
.RB [ -e
.IR encoding ]
\fI"key string"\fP
.PP
Save the specified \fIstring\fP to the register \fIkey\fP.
The encoding of the string can be specified via the \fB-e\fP option.
See also the \*Qpaste\*U command.
.sp
.ne 3
.B "remove"
.PP
Kill the current region. This is a no-op if there is only one region.
.sp
.ne 3
.B "removebuf"
.PP
Unlinks the tscreen-exchange file used by the commands \*Qwritebuf\*U and
\*Qreadbuf\*U.
.sp
.ne 3
.B "reset"
.PP
Reset the virtual terminal to its \*Qpower-on\*U values. Useful when strange
settings (like scroll regions or graphics character set) are left over from
an application.
.sp
.ne 3
.B "resize"
.PP
Resize the current region. The space will be removed from or added to
the region below or if there's not enough space from the region above.
.IP
resize +N	increase current region height by N
.IP
resize -N	decrease current region height by N
.IP
resize  N	set current region height to N
.IP
resize  =	make all windows equally high
.IP
resize  max	maximize current region height
.IP
resize  min	minimize current region height
.PP
.sp
.ne 3
.B "screen \fP[\fI-opts\fP] [\fIn\fP] [\fIcmd\fP [\fIargs\fP]]"
.PP
Establish a new window.
The flow-control options (\fB\-f\fP, \fB\-fn\fP and \fB\-fa\fP),
title (a.\|k.\|a.) option (\fB\-t\fP), login options (\fB-l\fP and \fB-ln\fP)
, terminal type option (\fB-T\fP <term>), the all-capability-flag (\fB-a\fP)
and scrollback option (\fB-h\fP <num>) may be specified with each command.
The option (\fB-M\fP) turns monitoring on for this window.
The option (\fB-L\fP) turns output logging on for this window.
The option (\fB-F\fP), which means "find existing window" will find
the named window and switch to it. If nonexistant, create it.
.sp
If an optional number \fIn\fP in the range 0..9 is given, the window
number \fIn\fP is assigned to the newly created window (or, if this
number is already in-use, the next available number).
.sp
If a command is specified after \*Qtscreen\*U, this command (with the given
arguments) is started in the window; otherwise, a shell is created.
Thus, if your \*Q.tscreenrc\*U contains the lines
.sp
.nf
	# example for .tscreenrc:
	screen 1
	screen -fn -t foobar -L 2 telnet foobar
.fi
.sp
\fItscreen\fP
creates a shell window (in window #1) and a window with a TELNET connection
to the machine foobar (with no flow-control using the title \*Qfoobar\*U
in window #2) and will write a logfile (\*Qtscreenlog.2\*U) of the telnet
session.
Note, that unlike previous versions of
\fItscreen\fP
no additional default window is created when \*Qtscreen\*U commands are
included in your \*Q.tscreenrc\*U file. When the initialization is completed,
\fItscreen\fP
switches to the last window specified in your .tscreenrc file or, if none,
opens a default window #0.
.br
tscreen has built in some functionality of \*Qcu\*U and \*Qtelnet\*U.
See also chapter \*QWINDOW TYPES\*U.
.sp
.ne 3
.B "scrollback \fP\fInum\fP"
.PP
Set the size of the scrollback buffer for the current windows to \fInum\fP
lines. The default scrollback is 100 lines.
See also the \*Qdefscrollback\*U command and use \*QC-a i\*U to view the
current setting.
.sp
.ne 3
.BR "select " [ \fIWindowID ]
.PP
Switch to the window identified by \fIWindowID\fP.
This can be a prefix of a window title (alphanumeric window name) or a
window number.
The parameter is optional and if omitted, you get prompted for an identifier.
When a new window is established, the first available number
is assigned to this window.
Thus, the first window can be activated by \*Qselect 0\*U.
The number of windows is limited at compile-time by the MAXWIN
configuration parameter.
There are two special WindowIDs, \*Q-\*U selects the
internal blank window and \*Q.\*U selects the current window. The
latter is useful if used with tscreen's \*Q-X\*U option.
.sp
.ne
.BR "sessionname " [ \fIname ]
.PP
Rename the current session. Note, that for \*Qtscreen -list\*U the
name shows up with the process-id prepended. If the argument \*Qname\*U
is omitted, the name of this session is displayed. Caution: The $STY
environment variables still reflects the old name. This may result in
confusion.
The default is constructed from the tty and host names.
.sp
.ne 3
.B "setenv "
.RI [ var " [" string ]]
.PP
Set the environment variable \fIvar\fP to value \fIstring\fP.
If only \fIvar\fP is specified, the user will be prompted to enter a value.
If no parameters are specified, the user will be prompted for both variable
and value. The environment is inherited by all subsequently forked shells.
.sp
.ne 3
.BR "setsid " [ on | off ]
.PP
Normally tscreen uses different sessions and process groups for
the windows. If setsid is turned \fIoff\fP, this is not done
anymore and all windows will be in the same process group as the
tscreen backend process. This also breaks job-control, so be careful.
The default is \fIon\fP, of course. This command is probably useful
only in rare circumstances.
.sp
.ne 3
.B "shell \fIcommand\fP"
.PP
Set the command to be used to create a new shell.
This overrides the value of the environment variable $SHELL.
This is useful if you'd like to run a tty-enhancer which is expecting to
execute the program specified in $SHELL. If the command begins with
a '-' character, the shell will be started as a login-shell.
.sp
.ne 3
.B "shelltitle \fItitle\fP"
.PP
Set the title for all shells created during startup or by
the C-A C-c command.
For details about what a title is, see the discussion
entitled \*QTITLES (naming windows)\*U.
.sp
.ne 3
.BR "silence " [ on | off "|\fIsec\fP]"
.PP
Toggles silence monitoring of windows.
When silence is turned on and an affected window is switched into the
background, you will receive the silence notification message in the
status line after a specified period of inactivity (silence). The default
timeout can be changed with the `silencewait' command or by specifying a
number of seconds instead of `on' or `off'.
Silence is initially off for all windows.
.sp
.ne 3
.BI "silencewait " sec
.PP
Define the time that all windows monitored for silence should wait before
displaying a message. Default 30 seconds.
.sp
.ne
.B "sleep \fP\fInum\fP"
.PP
This command will pause the execution of a .tscreenrc file for \fInum\fP seconds.
Keyboard activity will end the sleep.
It may be used to give users a chance to read the messages output by \*Qecho\*U.
.sp
.ne 3
.B "slowpaste \fImsec\fP"
.PP
Define the speed at which text is inserted into the current window by the
paste ("C-a ]") command.
If the slowpaste value is nonzero text is written character by character.
\fItscreen\fP
will make a pause of \fImsec\fP milliseconds after each single character write
to allow the application to process its input. Only use slowpaste if your
underlying system exposes flow control problems while pasting large amounts of
text.
.sp
.ne 3
.B sorendition
.RB [ "\fIattr\fR " [ \fIcolor ]]
.PP
Change the way
\fItscreen\fP
does highlighting for text marking and printing messages.
See the \*QSTRING ESCAPES\*U chapter for the syntax of the modifiers.
The default is currently \*Q=s dd\*U (standout, default colors).
.sp
.ne 3
.B "source "
.RI [ file | directory ]
.PP
Read and execute commands from file \fIfile\fP or directory \fIdirectory\fP.
Source commands may be nested to a maximum recursion level of ten. If
\fIfile\fP is not an absolute path and tscreen is already processing a
source command, the parent directory of the running source command file
is used to search for the new command file before tscreen's current directory.

If \fIfile\fP includes a trailing "|" character, it will be executed instead of
read.

If a directory is given, include each file therein, ignoring dotfiles and files
ending in a tilde (~).
.sp
Example:
.sp
.nf
 source ~/.tscreenrc.skx

 source ~/.tscreenrc.d/

 if -x ~/.tscreenrc.dynamic 'source ~/.tscreenrc.dynamic|'
.if
.sp
.sp
Note that termcap/terminfo/termcapinfo commands only work at
startup and reattach time, so they must be reached via the
default tscreenrc files to have an effect.
.sp
.ne 3
.B split
.PP
Split the current region into two new ones. All regions on the
display are resized to make room for the new region. The blank
window is displayed on the new region. Use the \*Qremove\*U or the
\*Qonly\*U command to delete regions.
Use \*Qfocus\*U to toggle between regions.
.sp
.ne 3
.B "startup_message on\fP|\fBoff"
.PP
Select whether you want to see the copyright notice during startup.
Default is `on', as you probably noticed.
.sp
.ne 3
.BI "stuff " string
.PP
Stuff the string \fIstring\fP in the input buffer of the current window.
This is like the \*Qpaste\*U command but with much less overhead.
You cannot paste
large buffers with the \*Qstuff\*U command. It is most useful for key
bindings. See also \*Qbindkey\*U.
.sp
.ne 3
.B su
.RB [ username " [" password
.RB [ password2 ]]
.PP
Substitute the user of a display. The command prompts for all parameters that
are omitted. If passwords are specified as parameters, they have to be
specified un-crypted. The first password is matched against the systems
passwd database, the second password is matched against the
\fItscreen\fP password as set with the commands \*Qacladd\*U or \*Qpassword\*U.
\*QSu\*U may be useful for the
\fItscreen\fP
administrator to test multiuser setups.

When the identification fails, the user has access to the commands available
for user
.BR nobody .
These are \*Qdetach\*U, \*Qlicense\*U, \*Qversion\*U, \*Qhelp\*U and
\*Qdisplays\*U.
.sp
.ne 3
.B "suspend"
.PP
Suspend \fItscreen\fP. The windows are in the `detached' state while tscreen
is suspended. This feature relies on the shell being able to do job control.
.sp
.ne 3
.B "term \fIterm\fP"
.PP
In each window's environment \fItscreen\fP opens, the $TERM variable is set
to \*Qtscreen\*U by default. When no description for \*Qtscreen\*U is
installed in the local termcap or terminfo data base, you set $TERM to \- say \-
\*Qvt100\*U. This won't do much harm, as \fItscreen\fP is VT100/ANSI compatible.
The use of the \*Qterm\*U command is discouraged for non-default purpose.
That is, one may want to specify special $TERM settings (e.g. vt100) for the
next \*Qtscreen rlogin othermachine\*U command. Use the command \*Qtscreen -T vt100
rlogin othermachine\*U rather than setting and resetting the default.
.sp
.ne 3
.BI termcap " term terminal-tweaks " [ window-tweaks ]
.br
.BI terminfo " term terminal-tweaks " [ window-tweaks ]
.br
.BI termcapinfo " term terminal-tweaks " [ window-tweaks ]
.PP
Use this command to modify your terminal's termcap entry without going
through all the hassles involved in creating a custom termcap entry.
Plus, you can optionally customize the termcap generated for the windows.
You have to place these commands in one of the tscreenrc startup files, as
they are meaningless once the terminal emulator is booted.
.br
If your system works uses the terminfo database rather than termcap,
\fItscreen\fP
will understand the `terminfo' command, which has the same effects as the
`termcap' command.  Two separate commands are provided, as there are subtle
syntactic differences, e.g. when parameter interpolation (using `%') is
required. Note that termcap names of the capabilities have to be used
with the `terminfo' command.
.br
In many cases, where the arguments are valid in both terminfo and termcap
syntax, you can use the command `termcapinfo', which is just a shorthand
for a pair of `termcap' and `terminfo' commands with identical arguments.
.PP
The first argument specifies which terminal(s) should be affected by this
definition.
You can specify multiple terminal names by separating them with `|'s.
Use `*' to match all terminals and `vt*' to match all terminals that begin
with \*Qvt\*U.
.PP
Each \fItweak\fP argument contains one or more termcap defines (separated
by `:'s) to be inserted at the start of the appropriate termcap entry,
enhancing it or overriding existing values.
The first tweak modifies your terminal's termcap, and contains definitions
that your terminal uses to perform certain functions.
Specify a null string to leave this unchanged (e.\|g. '').
The second (optional) tweak modifies all the window termcaps, and should
contain definitions that
\fItscreen\fP
understands (see the \*QVIRTUAL TERMINAL\*U
section).
.PP
Some examples:
.IP
termcap xterm*  LP:hs@
.PP
Informs
\fItscreen\fP
that all terminals that begin with `xterm' have firm auto-margins that
allow the last position on the screen to be updated (LP), but they don't
really have a status line (no 'hs' \- append `@' to turn entries off).
Note that we assume `LP' for all terminal names that start with \*Qvt\*U,
but only if you don't specify a termcap command for that terminal.
.IP
termcap vt*  LP
.br
termcap vt102|vt220  Z0=\eE[?3h:Z1=\eE[?3l
.PP
Specifies the firm-margined `LP' capability for all terminals that begin with
`vt', and the second line will also add the escape-sequences to switch
into (Z0) and back out of (Z1) 132-character-per-line mode if this is
a VT102 or VT220.
(You must specify Z0 and Z1 in your termcap to use the width-changing
commands.)
.IP
termcap vt100  ""  l0=PF1:l1=PF2:l2=PF3:l3=PF4
.PP
This leaves your vt100 termcap alone and adds the function key labels to
each window's termcap entry.
.IP
termcap h19|z19  am@:im=\eE@:ei=\eEO  dc=\eE[P
.PP
Takes a h19 or z19 termcap and turns off auto-margins (am@) and enables the
insert mode (im) and end-insert (ei) capabilities (the `@' in the `im'
string is after the `=', so it is part of the string).
Having the `im' and `ei' definitions put into your terminal's termcap will
cause
\fItscreen\fP
to automatically advertise the character-insert capability in
each window's termcap.
Each window will also get the delete-character capability (dc) added to its
termcap, which
\fItscreen\fP
will translate into a line-update for the terminal
(we're pretending it doesn't support character deletion).
.PP
If you would like to fully specify each window's termcap entry, you should
instead set the $TSCREENCAP variable prior to running
.IR tscreen .
See the discussion on the \*QVIRTUAL TERMINAL\*U in this manual, and the termcap(5)
man page for more information on termcap definitions.
.sp
.ne 3
.BR "time " [ \fIstring ]
.PP
Uses the message line to display the time of day, the host name, and the load
averages over 1, 5, and 15 minutes (if this is available on your system).
For window specific information use \*Qinfo\*U.

If a string is specified, it changes the format of the time report like it is
described in the \*QSTRING ESCAPES\*U chapter. tscreen uses a default of
"%c:%s %M %d %H%? %l%?".
.sp
.ne 3
.BR "title " [ \fIwindowtitle ]
.PP
Set the name of the current window to \fIwindowtitle\fP. If no name is
specified, \fItscreen\fP prompts for one. This command was known as `aka' in previous
releases.
.sp
.ne 3
.B unaliasall
.PP
Removes all currently defined aliases.
.sp
.ne 3
.B unbindall
.PP
Unsets all current bindings, nicely neutering tscreen.
.sp
.ne 3
.BI "unsetenv " var
.PP
Unset an environment variable.
.sp
.ne 3
.BR utf8 " [" on | off ]
.PP
Change the encoding used in the current window. If utf8 is enabled, the
strings sent to the window will be UTF-8 encoded and vice versa. Omitting the
parameter toggles the setting. If a second parameter is given, the display's
encoding is also changed (this should rather be done with tscreen's \*Q-U\*U
option).
See also \*Qdefutf8\*U, which changes the default setting of a new
window.
.sp
.ne 3
.BR vbell " [" on | off ]
.PP
Sets the visual bell setting for this window. Omitting the parameter
toggles the setting. If vbell is switched on, but your terminal does not
support a visual bell, a `vbell-message' is displayed in the status line when
the bell character (^G) is received.
Visual bell support of a terminal is defined by the termcap variable `vb'
(terminfo: 'flash').
.br
Per default, vbell is off, thus the audible bell is used.
See also `bell_msg'.
.sp
.ne 3
.BR vbell_msg " [" message ]
.PP
Sets the visual bell message. \fImessage\fP is printed to the status line if
the window receives a bell character (^G), vbell is set to \*Qon\*U, but the
terminal does not support a visual bell.
The default message is \*QWuff, Wuff!!\*U.
Without parameter, the current message is shown.
.sp
.ne 3
.BI "vbellwait " sec
.PP
Define a delay in seconds after each display of
.IR tscreen 's
visual bell message. The default is 1 second.
.sp
.ne 3
.BR verbose " [" on | off ]
.PP
If verbose is switched on, the command name is echoed, whenever a window
is created (or resurrected from zombie state). Default is off.
Without parameter, the current setting is shown.
.sp
.ne 3
.B version
.PP
Print the current version and the compile date in the status line.
.sp
.ne 3
.BI "wall " "message"
.PP
Write a message to all displays. The message will appear in the terminal's
status line.
.sp
.ne 3
.BR "width " [ \-w | \-d "] [\fIcols\fP [\fIlines\fP]]"
.PP
Toggle the window width between 80 and 132 columns or set it to \fIcols\fP
columns if an argument is specified.
This requires a capable terminal and the termcap entries \*QZ0\*U and \*QZ1\*U.
See the \*Qtermcap\*U command for more information. You can also specify
a new height if you want to change both values.
The
.B -w
option tells tscreen to leave the display size unchanged and just set
the window size,
.B -d
vice versa.
.sp
.ne 3
.BR "windowlist " [ -b | -m ]
.br
.BR "windowlist " [ -b "] [" -m ]
.br
.BR "windowlist string " "[\fIstring\fP]"
.br
.BR "windowlist title " "[\fItitle\fP]"
.PP
Display all windows in a table for visual window selection. The
desired window can be selected via the standard movement keys (see
the \*Qcopy\*U command) and activated via the return key.
If the
.B -b
option is given, tscreen will switch to the blank window before
presenting the list, so that the current window is also selectable.
The
.B -m
option changes the order of the windows, instead of sorting by
window numbers tscreen uses its internal most-recently-used list.

The table format can be changed with the \fBstring\fP and
\fBtitle\fP option, the title is displayed as table heading, while
the lines are made by using the string setting. The default
setting is \*QNum Name%=Flags\*U for the title and \*Q%3n %t%=%f\*U
for the lines.
See the \*QSTRING ESCAPES\*U chapter for more codes (e.g. color
settings).
.sp
.ne 3
.B windows
.PP
Uses the message line to display a list of all the windows.
Each window is listed by number with the name of process that has been
started in the window (or its title);
the current window is marked with a `*';
the previous window is marked with a `-';
all the windows that are \*Qlogged in\*U are marked with a `$';
a background window that has received a bell is marked with a `!';
a background window that is being monitored and has had activity occur
is marked with an `@';
a window which has output logging turned on is marked with `(L)';
windows occupied by other users are marked with `&';
hidden windows are marked with `^';

windows in the zombie state are marked with `Z'.
If this list is too long to fit on the terminal's status line only the
portion around the current window is displayed.
.sp
.ne 3
.BR "wrap " [ on | off ]
.PP
Sets the line-wrap setting for the current window.
When line-wrap is on, the second consecutive printable character output at
the last column of a line will wrap to the start of the following line.
As an added feature, backspace (^H) will also wrap through the left margin
to the previous line.
Default is `on'.
.sp
.ne 3
.BR "writebuf " [ -e " \fIencoding\fP ] [ \fIfilename\fP ]"
.PP
Writes the contents of the paste buffer to the specified file, or the public accessible tscreen-exchange
file if no filename is given. This is thought of as a primitive means of communication between
\fItscreen\fP
users on the same host. If an encoding is specified the paste buffer
is recoded on the fly to match the encoding.
The filename can be set with the \fIbufferfile\fP
command and defaults to \*Q/tmp/tscreen-exchange\*U.
.sp
.ne 3
.BR "writelock " [ on | "off\fR|\fBauto\fR]"
.PP
In addition to access control lists, not all users may be able to write to
the same window at once. Per default, writelock is in `auto' mode and
grants exclusive input permission to the user who is the first to switch
to the particular window. When he leaves the window, other users may obtain
the writelock (automatically). The writelock of the current window is disabled
by the command \*Qwritelock off\*U. If the user issues the command
\*Qwritelock on\*U he keeps the exclusive write permission while switching
to other windows.
.sp
.ne 3
.B xoff
.br
.B xon
.PP
Insert a CTRL-s / CTRL-q character to the stdin queue of the
current window.
.sp
.ne 3
.BR "zombie " [\fIkeys\fP [ onerror ] ]
.br
.BR "defzombie " [\fIkeys\fP]
.PP
Per default \fItscreen\fP windows are removed from the window list as soon as
the windows process (e.g. shell) exits. When a string of two keys is
specified to the zombie command, `dead' windows will remain in the list.
The \fBkill\fP command may be used to remove such a window. Pressing the
first key in the dead window has the same effect. When pressing the second
key, \fItscreen\fP will attempt to resurrect the window. The process that was
initially running in the window will be launched again. Calling \fBzombie\fP
without parameters will clear the zombie setting, thus making windows disappear
when their process exits.

As the zombie-setting is manipulated globally for all windows, this command
should only be called \fBdefzombie\fP. Until we need this as a per window
setting, the commands \fBzombie\fP and \fBdefzombie\fP are synonymous.

Optionally you can put the word \*Qonerror\*U after the keys. This will cause tscreen
to monitor exit status of the process running in the window. If it exits normally ('0'),
the window disappears. Any other exit value causes the window to become a zombie.

.SH "THE MESSAGE LINE"
\fItscreen\fP displays informational messages and other diagnostics in a \fImessage line\fP.
While this line is distributed to appear at the bottom of the screen,
it can be defined to appear at the top of the screen during compilation.
If your terminal has a status line defined in its termcap, \fItscreen\fP will
use this for displaying its messages, otherwise a line of the
current tscreen will be temporarily overwritten and output will be momentarily interrupted. The
message line is automatically removed after a few seconds delay, but it
can also be removed early (on terminals without a status line) by beginning
to type.
.PP
The message line facility can be used by an application running in
the current window by means of the ANSI \fIPrivacy message\fP
control sequence.
For instance, from within the shell, try something like:
.IP
echo '<esc>^Hello world from window '$WINDOW'<esc>\e\e'
.PP
where '<esc>' is an \fIescape\fP, '^' is a literal up-arrow,
and '\e\e' turns into a single backslash.

.SH "WINDOW TYPES"
tscreen provides three different window types. New windows are created with
.IR tscreen 's
.B tscreen
command (see also the entry in chapter \*QCUSTOMIZATION\*U). The first
parameter to the
.B tscreen
command defines which type of window is created. The different window types are
all special cases of the normal type. They have been added in order
to allow
\fItscreen\fP
to be used efficiently as a console multiplexer with 100 or more windows.

.IP \(bu 3
The normal window contains a shell (default, if no parameter is given) or any
other system command that could be executed from a shell (e.g.
.BR slogin ,
etc...)

.IP \(bu
If a tty (character special device) name (e.g. \*Q/dev/ttya\*U)
is specified as the first parameter, then the window is directly connected to
this device.
This window type is similar to \*Qtscreen cu -l /dev/ttya\*U.
Read and write access is required on the device node, an exclusive open is
attempted on the node to mark the connection line as busy.
An optional parameter is allowed consisting of a comma separated list of flags
in the notation used by stty(1):
.RS
.IP <baud_rate>
Usually 300, 1200, 9600 or 19200. This affects transmission as well as receive speed.
.IP "cs8 or cs7"
Specify the transmission of eight (or seven) bits per byte.
.IP "ixon or -ixon"
Enables (or disables) software flow-control (CTRL-S/CTRL-Q) for sending data.
.IP "ixoff or -ixon"
Enables (or disables) software flow-control for receiving data.
.IP "istrip or -istrip"
Clear (or keep) the eight bit in each received byte.
.PP
You may want to specify as many of these options as applicable. Unspecified
options cause the terminal driver to make up the parameter values of the
connection.  These values are system dependent and may be in defaults or values
saved from a previous connection.
.PP
For tty windows, the
.B info
command shows some of the modem control lines
in the status line. These may include `RTS', `CTS', 'DTR', `DSR', `CD' and more.
This depends on the available ioctl()'s and system header files as well as the
on the physical capabilities of the serial board.
Signals that are logical low (inactive) have their name preceded by
an exclamation mark (!), otherwise the signal is logical high (active).
Signals not supported by the hardware but available to the ioctl() interface
are usually shown low.
.br
When the CLOCAL status bit is true, the whole set of modem signals is placed
inside curly braces ({ and }).
When the CRTSCTS or TIOCSOFTCAR bit is set, the signals `CTS' or `CD'
are shown in parenthesis, respectively.


For tty windows, the command
.B break
causes the Data transmission line (TxD) to go low for a specified period of
time. This is expected to be interpreted as break signal on the other side.
No data is sent and no modem control line is changed when a
.B break
is issued.
.RE
.IP \(bu
If the first parameter is \*Q//telnet\*U, the second parameter is expected to
be a host name, and an optional third parameter may specify a TCP port number
(default decimal 23).  tscreen will connect to a server listening on the remote
host and use the telnet protocol to communicate with that server.
.br
.br
For telnet windows, the command
.B info
shows details about the connection in square brackets ([ and ]) at the end of
the status line.
.RS
.IP b
BINARY. The connection is in binary mode.
.IP e
ECHO. Local echo is disabled.
.IP c
SGA. The connection is in `character mode' (default: `line mode').
.IP t
TTYPE. The terminal type has been requested by the remote host.
tscreen sends the name \*Qtscreen\*U unless instructed otherwise (see also
the command `term').
.IP w
NAWS. The remote site is notified about window size changes.
.IP f
LFLOW. The remote host will send flow control information.
(Ignored at the moment.)
.PP
Additional flags for debugging are x, t and n (XDISPLOC, TSPEED and
NEWENV).
.PP
For telnet windows, the command
.B break
sends the telnet code IAC BREAK (decimal 243) to the remote host.


This window type is only available if
\fItscreen\fP
was compiled with the BUILTIN_TELNET option defined.
.RE


.SH "STRING ESCAPES"
tscreen provides an escape mechanism to insert information like the
current time into messages or file names. The escape character
is '%' with one exception: inside of a window's hardstatus '^%' ('^E')
is used instead.

Here is the full list of supported escapes:
.IP %
the escape character itself
.IP a
either 'am' or 'pm'
.IP A
either 'AM' or 'PM'
.IP c
current time HH:MM in 24h format
.IP C
current time HH:MM in 12h format
.IP d
day number
.IP D
weekday name
.IP f
flags of the window
.IP F
sets %? to true if the window has the focus
.IP h
hardstatus of the window
.IP H
hostname of the system
.IP l
current load of the system
.IP m
month number
.IP M
month name
.IP n
window number
.IP S
session name
.IP s
seconds
.IP t
window title
.IP u
all other users on this window
.IP w
all window numbers and names. With '-' qualifier: up to the current
window; with '+' qualifier: starting with the window after the current
one.
.IP W
all window numbers and names except the current one
.IP y
last two digits of the year number
.IP Y
full year number
.IP ?
the part to the next '%?' is displayed only if a '%' escape
inside the part expands to a non-empty string
.IP :
else part of '%?'
.IP =
pad the string to the display's width (like TeX's hfill). If a
number is specified, pad to the percentage of the window's width.
A '0' qualifier tells tscreen to treat the number as absolute position.
You can specify to pad relative to the last absolute pad position
by adding a '+' qualifier or to pad relative to the right margin
by using '-'. The padding truncates the string if the specified
position lies before the current position. Add the 'L' qualifier
to change this.
.IP <
same as '%=' but just do truncation, do not fill with spaces
.IP >
mark the current text position for the next truncation. When
tscreen needs to do truncation, it tries to do it in a way that
the marked position gets moved to the specified percentage of
the output area. (The area starts from the last absolute pad
position and ends with the position specified by the truncation
operator.) The 'L' qualifier tells tscreen to mark the truncated
parts with '...'.
.IP {
attribute/color modifier string terminated by the next \*Q}\*U
.IP `
Substitute with the output of a 'backtick' command. The length
qualifier is misused to identify one of the commands.
.P
The 'c' and 'C' escape may be qualified with a '0' to make
\fItscreen\fP
use zero instead of space as fill character. The '0' qualifier
also makes the '=' escape use absolute positions. The 'n' and '='
escapes understand
a length qualifier (e.g. '%3n'), 'D' and 'M' can be prefixed with 'L'
to generate long names, 'w' and 'W' also show the window flags
if 'L' is given.
.PP
An attribute/color modifier is is used to change the attributes or the
color settings. Its format
is \*Q[attribute modifier] [color description]\*U. The attribute modifier
must be prefixed by a change type indicator if it can be confused with
a color description. The following change types are known:
.IP +
add the specified set to the current attributes
.IP -
remove the set from the current attributes
.IP !
invert the set in the current attributes
.IP =
change the current attributes to the specified set
.PP
The attribute set can either be specified as a hexadecimal number or
a combination of the following letters:
.IP d
dim
.PD 0
.IP u
underline
.IP b
bold
.IP r
reverse
.IP s
standout
.IP B
blinking
.PD
.PP
Colors are coded either as a hexadecimal number or two letters specifying
the desired background and foreground color (in that order). The following
colors are known:
.IP k
black
.PD 0
.IP r
red
.IP g
green
.IP y
yellow
.IP b
blue
.IP m
magenta
.IP c
cyan
.IP w
white
.IP d
default color
.IP .
leave color unchanged
.PD
.PP
The capitalized versions of the letter specify bright colors. You can also
use the pseudo-color 'i' to set just the brightness and leave the color
unchanged.
.br
A one digit/letter color description is treated as foreground or
background color dependent on the current attributes: if reverse mode is
set, the background color is changed instead of the foreground color.
If you don't like this, prefix the color with a \*Q.\*U. If you want
the same behavior for two-letter color descriptions, also prefix them
with a \*Q.\*U.
.br
As a special case, \*Q%{-}\*U restores the attributes and colors that
were set before the last change was made (i.e., pops one level of the
color-change stack).
.PP
Examples:
.IP "\*QG\*U"
set color to bright green
.IP "\*Q+b r\*U"
use bold red
.IP "\*Q= yd\*U"
clear all attributes, write in default color on yellow background.
.IP "%-Lw%{= BW}%50>%n%f* %t%{-}%+Lw%<"
The available windows centered at the current window and truncated to
the available width. The current window is displayed white on blue.
This can be used with \*Qhardstatus alwayslastline\*U.
.IP "%?%F%{.R.}%?%3n %t%? [%h]%?"
The window number and title and the window's hardstatus, if one is set.
Also use a red background if this is the active focus. Useful for
\*Qcaption string\*U.
.SH "FLOW-CONTROL"
Each window has a flow-control setting that determines how
\fItscreen\fP
deals with
the XON and XOFF characters (and perhaps the interrupt character).
When flow-control is turned off,
\fItscreen\fP
ignores the XON and XOFF characters,
which allows the user to send them to the current program by simply typing
them (useful for the \fIemacs\fP editor, for instance).
The trade-off is that it will take longer for output from a \*Qnormal\*U
program to pause in response to an XOFF.
With flow-control turned on, XON and XOFF characters are used to immediately
pause the output of the current window.
You can still send these characters to the current program, but you must use
the appropriate two-character
\fItscreen\fP
commands (typically \*QC-a q\*U (xon)
and \*QC-a s\*U (xoff)).
The xon/xoff commands are also useful for typing C-s and C-q past a terminal
that intercepts these characters.
.PP
Each window has an initial flow-control value set with either the
.B \-f
option or the \*Qdefflow\*U .tscreenrc command. Per default the windows
are set to automatic flow-switching.
It can then be toggled between the three states 'fixed on', 'fixed off'
and 'automatic' interactively with the \*Qflow\*U command bound to "C-a f".
.PP
The automatic flow-switching mode deals with
flow control using the TIOCPKT mode (like \*Qrlogin\*U does). If
the tty driver does not support TIOCPKT,
\fItscreen\fP
tries to find out
the right mode based on the current setting of the application
keypad \- when it is enabled, flow-control is turned off and visa versa.
Of course, you can still manipulate flow-control manually when needed.
.PP
If you're running with flow-control enabled and find that pressing the
interrupt key (usually C-c) does not interrupt the display until another
6-8 lines have scrolled by, try running
\fItscreen\fP
with the \*Qinterrupt\*U
option (add the \*Qinterrupt\*U flag to the \*Qflow\*U command in
your .tscreenrc, or use the
.B \-i
command-line option).
This causes the output that
\fItscreen\fP
has accumulated from the interrupted program to be flushed.
One disadvantage is that the virtual terminal's memory contains the
non-flushed version of the output, which in rare cases can cause
minor inaccuracies in the output.
For example, if you switch tscreens and return, or update the screen
with \*QC-a l\*U you would see the version of the output you would
have gotten without \*Qinterrupt\*U being on.
Also, you might need to turn off flow-control (or use auto-flow mode to turn
it off automatically) when running a program that expects you to type the
interrupt character as input, as it is possible to interrupt
the output of the virtual terminal to your physical terminal when flow-control
is enabled.
If this happens, a simple refresh of the screen with \*QC-a l\*U will
restore it.
Give each mode a try, and use whichever mode you find more comfortable.


.SH "TITLES (naming windows)"
You can customize each window's name in the window display (viewed with the
\*Qwindows\*U command (C-a w)) by setting it with one of
the title commands.
Normally the name displayed is the actual command name of the program
created in the window.
However, it is sometimes useful to distinguish various programs of the same
name or to change the name on-the-fly to reflect the current state of
the window.
.PP
The default name for all shell windows can be set with the \*Qshelltitle\*U
command in the .tscreenrc file, while all other windows are created with
a \*Qtscreen\*U command and thus can have their name set with the
.B \-t
option.
Interactively, there is the title-string escape-sequence
(<esc>k\fIname\fP<esc>\e) and the \*Qtitle\*U command (C-a A).
The former can be output from an application to control the window's name
under software control, and the latter will prompt for a name when typed.
You can also bind pre-defined names to keys with the \*Qtitle\*U command
to set things quickly without prompting.
.PP
Finally,
\fItscreen\fP
has a shell-specific heuristic that is enabled by setting the window's name
to \*Q\fIsearch|name\fP\*U and arranging to have a null title escape-sequence
output as a part of your prompt.
The \fIsearch\fP portion specifies an end-of-prompt search string, while
the \fIname\fP portion specifies the default shell name for the window.
If the \fIname\fP ends in a `:'
\fItscreen\fP
will add what it believes to be the current command running in the window
to the end of the window's shell name (e.\|g. \*Q\fIname:cmd\fP\*U).
Otherwise the current command name supersedes the shell name while it is
running.
.PP
Here's how it works:  you must modify your shell prompt to output a null
title-escape-sequence (<esc>k<esc>\e) as a part of your prompt.
The last part of your prompt must be the same as the string you specified
for the \fIsearch\fP portion of the title.
Once this is set up,
\fItscreen\fP
will use the title-escape-sequence to clear the previous command name and
get ready for the next command.
Then, when a newline is received from the shell, a search is made for the
end of the prompt.
If found, it will grab the first word after the matched string and use it
as the command name.
If the command name begins with either '!', '%', or '^'
\fItscreen\fP
will use the first word on the following line (if found) in preference to
the just-found name.
This helps csh users get better command names when using job control or
history recall commands.
.PP
Here's some .tscreenrc examples:
.IP
tscreen -t top 2 nice top
.PP
Adding this line to your .tscreenrc would start a nice-d version of the
\*Qtop\*U command in window 2 named \*Qtop\*U rather than \*Qnice\*U.
.sp
.nf
	shelltitle '> |csh'
	tscreen 1
.fi
.sp
These commands would start a shell with the given shelltitle.
The title specified is an auto-title that would expect the prompt and
the typed command to look something like the following:
.IP
/usr/joe/src/dir> trn
.PP
(it looks after the '> ' for the command name).
The window status would show the name \*Qtrn\*U while the command was
running, and revert to \*Qcsh\*U upon completion.
.IP
bind R tscreen -t '% |root:' su
.PP
Having this command in your .tscreenrc would bind the key
sequence \*QC-a R\*U to the \*Qsu\*U command and give it an
auto-title name of \*Qroot:\*U.
For this auto-title to work, the screen could look something
like this:
.sp
.nf
	% !em
	emacs file.c
.fi
.sp
Here the user typed the csh history command \*Q!em\*U which ran the
previously entered \*Qemacs\*U command.
The window status would show \*Qroot:emacs\*U during the execution
of the command, and revert to simply \*Qroot:\*U at its completion.
.PP
.nf
	bind o title
	bind E title ""
	bind u title (unknown)
.fi
.sp
The first binding doesn't have any arguments, so it would prompt you
for a title. when you type \*QC-a o\*U.
The second binding would clear an auto-title's current setting (C-a E).
The third binding would set the current window's title to \*Q(unknown)\*U
(C-a u).
.PP
One thing to keep in mind when adding a null title-escape-sequence to
your prompt is that some shells (like the csh) count all the non-control
characters as part of the prompt's length.
If these invisible characters aren't a multiple of 8 then backspacing over
a tab will result in an incorrect display.
One way to get around this is to use a prompt like this:
.IP
set prompt='^[[0000m^[k^[\e% '
.PP
The escape-sequence \*Q<esc>[0000m\*U not only normalizes the character
attributes, but all the zeros round the length of the invisible characters
up to 8.
Bash users will probably want to echo the escape sequence in the
PROMPT_COMMAND:
.IP
PROMPT_COMMAND='echo -n -e "\e033k\e033\e134"'
.PP
(I used \*Q\134\*U to output a `\e' because of a bug in bash v1.04).


.SH "THE VIRTUAL TERMINAL"
Each window in a
\fItscreen\fP
session emulates a VT100 terminal, with some extra functions added. The
VT100 emulator is hard-coded, no other terminal types can be emulated.
.br
Usually
\fItscreen\fP
tries to emulate as much of the VT100/ANSI standard
as possible. But if your terminal lacks certain capabilities,
the emulation may not be complete. In these cases
\fItscreen\fP
has to tell the applications that some of the features
are missing. This is no problem on machines using termcap,
because
\fItscreen\fP
can use the $TERMCAP variable to
customize the standard
\fItscreen\fP
termcap.
.PP
But if you do a
rlogin on another machine or your machine supports only
terminfo this method fails. Because of this,
\fItscreen\fP
offers a way to deal with these cases.
Here is how it works:
.PP
When
\fItscreen\fP
tries to figure out a terminal name for itself,
it first looks
for an entry named \*Qtscreen.<term>\*U, where <term> is
the contents of your $TERM variable.
If no such entry exists,
\fItscreen\fP
tries \*Qtscreen\*U (or \*Qtscreen-w\*U if the terminal is wide
(132 cols or more)).
If even this entry cannot be found, \*Qvt100\*U is used as a
substitute.
.PP
The idea is that if you have a terminal which doesn't
support an important feature (e.g. delete char or clear to EOS)
you can build a new termcap/terminfo entry for
\fItscreen\fP
(named \*Qtscreen.<dumbterm>\*U) in which this capability
has been disabled. If this entry is installed on your
machines you are able to do
a rlogin and still keep the correct termcap/terminfo entry.
The terminal name is put in the $TERM variable
of all new windows.
\fItscreen\fP
also sets the $TERMCAP variable reflecting the capabilities
of the virtual terminal emulated. Notice that, however, on machines
using the terminfo database this variable has no effect.
Furthermore, the variable $WINDOW is set to the window number
of each window.
.PP
The actual set of capabilities supported by the virtual terminal
depends on the capabilities supported by the physical terminal.
If, for instance, the physical terminal does not support underscore mode,
\fItscreen\fP
does not put the `us' and `ue' capabilities into the window's $TERMCAP
variable, accordingly.
However, a minimum number of capabilities must be supported by a
terminal in order to run
.IR tscreen ;
namely scrolling, clear screen, and direct cursor addressing
(in addition,
\fItscreen\fP
does not run on hardcopy terminals or on terminals that over-strike).
.PP
Also, you can customize the $TERMCAP value used by
\fItscreen\fP
by using the \*Qtermcap\*U .tscreenrc command, or
by defining the variable $TSCREENCAP prior to startup.
When the is latter defined, its value will be copied verbatim into each
window's $TERMCAP variable.
This can either be the full terminal definition, or a filename where the
terminal \*Qtscreen\*U (and/or \*Qtscreen-w\*U) is defined.
.PP
Note that
\fItscreen\fP
honors the \*Qterminfo\*U .tscreenrc command if the system uses the
terminfo database rather than termcap.
.PP
When the boolean `G0' capability is present in the termcap entry
for the terminal on which
\fItscreen\fP
has been called, the terminal emulation of
\fItscreen\fP
supports multiple character sets.
This allows an application to make use of, for instance,
the VT100 graphics character set or national character sets.
The following control functions from ISO 2022 are supported:
\fIlock shift G0\fP (\fISI\fP), \fIlock shift G1\fP (\fISO\fP),
\fIlock shift G2\fP, \fIlock shift G3\fP, \fIsingle shift G2\fP,
and \fIsingle shift G3\fP.
When a virtual terminal is created or reset, the ASCII character
set is designated as \fIG0\fP through \fIG3\fP.
When the `G0' capability is present,
\fItscreen\fP
evaluates the capabilities
`S0', `E0', and `C0' if present. `S0' is the sequence the terminal uses
to enable and start the graphics character set rather than \fISI\fP.
`E0' is the corresponding replacement for \fISO\fP. `C0' gives a character
by character translation string that is used during semi-graphics mode. This
string is built like the `acsc' terminfo capability.
.PP
When the `po' and `pf' capabilities are present in the terminal's
termcap entry, applications running in a
\fItscreen\fP
window can send output to the printer port of the terminal.
This allows a user to have an application in one window
sending output to a printer connected to the terminal, while all
other windows are still active (the printer port is enabled
and disabled again for each chunk of output).
As a side-effect, programs running in different windows can
send output to the printer simultaneously.
Data sent to the printer is not displayed in the window.  The
\fIinfo\fP
command displays a line starting `PRIN' while the printer is active.
.PP
\fItscreen\fP
maintains a hardstatus line for every window. If a window
gets selected, the display's hardstatus will be updated to match
the window's hardstatus line. If the display has no hardstatus
the line will be displayed as a standard
\fItscreen\fP
message.
The hardstatus line can be changed with the ANSI Application
Program Command (APC): \*QESC_<string>ESC\e\*U. As a convenience
for xterm users the sequence \*QESC]0..2;<string>^G\*U is
also accepted.
.PP
Some capabilities are only put into the $TERMCAP
variable of the virtual terminal if they can be efficiently
implemented by the physical terminal.
For instance, `dl' (delete line) is only put into the $TERMCAP
variable if the terminal supports either delete line itself or
scrolling regions. Note that this may provoke confusion, when
the session is reattached on a different terminal, as the value
of $TERMCAP cannot be modified by parent processes.
.PP
The "alternate screen" capability is not enabled by default.
Set the \fBaltscreen\fP .tscreenrc command to enable it.
.PP
The following is a list of control sequences recognized by
.IR tscreen .
\*Q(V)\*U and \*Q(A)\*U indicate VT100-specific and ANSI- or
ISO-specific functions, respectively.
.PP
.ta 22n
.TP 27
.B "ESC E"
Next Line
.TP 27
.B "ESC D"
Index
.TP 27
.B "ESC M"
Reverse Index
.TP 27
.B "ESC H"
Horizontal Tab Set
.TP 27
.B "ESC Z"
Send VT100 Identification String
.TP 27
.BR "ESC 7" "	(V)"
Save Cursor and Attributes
.TP 27
.BR "ESC 8" "	(V)"
Restore Cursor and Attributes
.TP 27
.BR "ESC [s" "	(A)"
Save Cursor and Attributes
.TP 27
.BR "ESC [u" "	(A)"
Restore Cursor and Attributes
.TP 27
.B "ESC c"
Reset to Initial State
.TP 27
.B "ESC g"
Visual Bell
.TP 27
.B "ESC \fPPn\fB p"
Cursor Visibility (97801)
.TP 27
\h'\w'ESC 'u'Pn = \fB6\fP
Invisible
.TP 27
\h'\w'ESC Pn = 'u'\fB7\fP
Visible
.TP 27
.BR "ESC =" "	(V)"
Application Keypad Mode
.TP 27
.BR "ESC >" "	(V)"
Numeric Keypad Mode
.TP 27
.BR "ESC # 8" "	(V)"
Fill screen with E's
.TP 27
.BR "ESC \e" "	(A)"
String Terminator
.TP 27
.BR "ESC ^" "	(A)"
Privacy Message String (Message Line)
.TP 27
.B "ESC !"
Global Message String (Message Line)
.TP 27
.B "ESC k"
A.\|k.\|a. Definition String
.TP 27
.BR "ESC P" "	(A)"
Device Control String.
Outputs a string directly to the host
terminal without interpretation.
.TP 27
.BR "ESC _" "	(A)"
Application Program Command (Hardstatus)
.TP 27
.BR "ESC ] 0 ; string ^G" "	(A)"
Operating System Command (Hardstatus, xterm title hack)
.TP 27
.BR "ESC ] 83 ; cmd ^G" "	(A)"
Execute tscreen command. This only works if multi-user support is
compiled into tscreen. The pseudo-user \*Q:window:\*U is used to
check the access control list. Use \*Qaddacl :window: -rwx #?\*U to
create a user with no rights and allow only the needed commands.
.TP 27
.BR "Control-N" "	(A)"
Lock Shift G1 (SO)
.TP 27
.BR "Control-O" "	(A)"
Lock Shift G0 (SI)
.TP 27
.BR "ESC n" "	(A)"
Lock Shift G2
.TP 27
.BR "ESC o" "	(A)"
Lock Shift G3
.TP 27
.BR "ESC N" "	(A)"
Single Shift G2
.TP 27
.BR "ESC O" "	(A)"
Single Shift G3
.TP 27
.BR "ESC ( \fPPcs" "	(A)"
Designate character set as G0
.TP 27
.BR "ESC ) \fPPcs" "	(A)"
Designate character set as G1
.TP 27
.BR "ESC * \fPPcs" "	(A)"
Designate character set as G2
.TP 27
.BR "ESC + \fPPcs" "	(A)"
Designate character set as G3
.TP 27
.B "ESC [ \fPPn\fB ; \fPPn\fB H"
Direct Cursor Addressing
.TP 27
.B "ESC [ \fPPn\fB ; \fPPn\fB f"
same as above
.TP 27
.B "ESC [ \fPPn\fB J"
Erase in Display
.TP 27
\h'\w'ESC [ 'u'Pn = None or \fB0\fP
From Cursor to End of screen
.TP 27
\h'\w'ESC [ Pn = 'u'\fB1\fP
From Beginning of screen to Cursor
.TP 27
\h'\w'ESC [ Pn = 'u'\fB2\fP
Entire screen
.TP 27
.B "ESC [ \fPPn\fB K"
Erase in Line
.TP 27
\h'\w'ESC [ 'u'Pn = None or \fB0\fP
From Cursor to End of Line
.TP 27
\h'\w'ESC [ Pn = 'u'\fB1\fP
From Beginning of Line to Cursor
.TP 27
\h'\w'ESC [ Pn = 'u'\fB2\fP
Entire Line
.TP 27
.B "ESC [ \fPPn\fB X"
Erase character
.TP 27
.B "ESC [ \fPPn\fB A"
Cursor Up
.TP 27
.B "ESC [ \fPPn\fB B"
Cursor Down
.TP 27
.B "ESC [ \fPPn\fB C"
Cursor Right
.TP 27
.B "ESC [ \fPPn\fB D"
Cursor Left
.TP 27
.B "ESC [ \fPPn\fB E"
Cursor next line
.TP 27
.B "ESC [ \fPPn\fB F"
Cursor previous line
.TP 27
.B "ESC [ \fPPn\fB G"
Cursor horizontal position
.TP 27
.B "ESC [ \fPPn\fB `"
same as above
.TP 27
.B "ESC [ \fPPn\fB d"
Cursor vertical position
.TP 27
.B "ESC [ \fPPs\fB ;\fP...\fB; \fPPs\fB m"
Select Graphic Rendition
.TP 27
\h'\w'ESC [ 'u'Ps = None or \fB0\fP
Default Rendition
.TP 27
\h'\w'ESC [ Ps = 'u'\fB1\fP
Bold
.TP 27
\h'\w'ESC [ Ps = 'u'\fB2\fP	(A)
Faint
.TP 27
\h'\w'ESC [ Ps = 'u'\fB3\fP	(A)
\fIStandout\fP Mode (ANSI: Italicized)
.TP 27
\h'\w'ESC [ Ps = 'u'\fB4\fP
Underlined
.TP 27
\h'\w'ESC [ Ps = 'u'\fB5\fP
Blinking
.TP 27
\h'\w'ESC [ Ps = 'u'\fB7\fP
Negative Image
.TP 27
\h'\w'ESC [ Ps = 'u'\fB22\fP	(A)
Normal Intensity
.TP 27
\h'\w'ESC [ Ps = 'u'\fB23\fP	(A)
\fIStandout\fP Mode off (ANSI: Italicized off)
.TP 27
\h'\w'ESC [ Ps = 'u'\fB24\fP	(A)
Not Underlined
.TP 27
\h'\w'ESC [ Ps = 'u'\fB25\fP	(A)
Not Blinking
.TP 27
\h'\w'ESC [ Ps = 'u'\fB27\fP	(A)
Positive Image
.TP 27
\h'\w'ESC [ Ps = 'u'\fB30\fP	(A)
Foreground Black
.TP 27
\h'\w'ESC [ Ps = 'u'\fB31\fP	(A)
Foreground Red
.TP 27
\h'\w'ESC [ Ps = 'u'\fB32\fP	(A)
Foreground Green
.TP 27
\h'\w'ESC [ Ps = 'u'\fB33\fP	(A)
Foreground Yellow
.TP 27
\h'\w'ESC [ Ps = 'u'\fB34\fP	(A)
Foreground Blue
.TP 27
\h'\w'ESC [ Ps = 'u'\fB35\fP	(A)
Foreground Magenta
.TP 27
\h'\w'ESC [ Ps = 'u'\fB36\fP	(A)
Foreground Cyan
.TP 27
\h'\w'ESC [ Ps = 'u'\fB37\fP	(A)
Foreground White
.TP 27
\h'\w'ESC [ Ps = 'u'\fB39\fP	(A)
Foreground Default
.TP 27
\h'\w'ESC [ Ps = 'u'\fB40\fP	(A)
Background Black
.TP 27
\h'\w'ESC [ Ps = 'u'\fB...\fP
...
.TP 27
\h'\w'ESC [ Ps = 'u'\fB49\fP	(A)
Background Default
.TP 27
.B "ESC [ \fPPn\fB g"
Tab Clear
.TP 27
\h'\w'ESC [ 'u'Pn = None or \fB0\fP
Clear Tab at Current Position
.TP 27
\h'\w'ESC [ Ps = 'u'\fB3\fP
Clear All Tabs
.TP 27
.BR "ESC [ \fPPn\fB ; \fPPn\fB r" "	(V)"
Set Scrolling Region
.TP 27
.BR "ESC [ \fPPn\fB I" "	(A)"
Horizontal Tab
.TP 27
.BR "ESC [ \fPPn\fB Z" "	(A)"
Backward Tab
.TP 27
.BR "ESC [ \fPPn\fB L" "	(A)"
Insert Line
.TP 27
.BR "ESC [ \fPPn\fB M" "	(A)"
Delete Line
.TP 27
.BR "ESC [ \fPPn\fB @" "	(A)"
Insert Character
.TP 27
.BR "ESC [ \fPPn\fB P" "	(A)"
Delete Character
.TP 27
.B "ESC [ \fPPn\fB S"
Scroll Scrolling Region Up
.TP 27
.B "ESC [ \fPPn\fB T"
Scroll Scrolling Region Down
.TP 27
.B "ESC [ \fPPn\fB ^"
same as above
.TP 27
.B "ESC [ \fPPs\fB ;\fP...\fB; \fPPs\fB h"
Set Mode
.TP 27
.B "ESC [ \fPPs\fB ;\fP...\fB; \fPPs\fB l"
Reset Mode
.TP 27
\h'\w'ESC [ 'u'Ps = \fB4\fP	(A)
Insert Mode
.TP 27
\h'\w'ESC [ Ps = 'u'\fB20\fP	(A)
\fIAutomatic Linefeed\fP Mode
.TP 27
\h'\w'ESC [ Ps = 'u'\fB34\fP
Normal Cursor Visibility
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?1\fP	(V)
Application Cursor Keys
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?3\fP	(V)
Change Terminal Width to 132 columns
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?5\fP	(V)
Reverse Video
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?6\fP	(V)
\fIOrigin\fP Mode
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?7\fP	(V)
\fIWrap\fP Mode
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?9\fP
X10 mouse tracking
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?25\fP	(V)
Visible Cursor
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?47\fP
Alternate screen (old xterm code)
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?1000\fP	(V)
VT200 mouse tracking
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?1047\fP
Alternate screen (new xterm code)
.TP 27
\h'\w'ESC [ Ps = 'u'\fB?1049\fP
Alternate screen (new xterm code)
.TP 27
.BR "ESC [ 5 i" "	(A)"
Start relay to printer (ANSI Media Copy)
.TP 27
.BR "ESC [ 4 i" "	(A)"
Stop relay to printer (ANSI Media Copy)
.TP 27
.B "ESC [ 8 ; \fPPh\fB ; \fPPw\fB t"
Resize the window to `Ph' lines and `Pw' columns (SunView special)
.TP 27
.B "ESC [ c"
Send VT100 Identification String
.TP 27
.B "ESC [ x"
Send Terminal Parameter Report
.TP 27
.B "ESC [ > c"
Send VT220 Secondary Device Attributes String
.TP 27
.B "ESC [ 6 n"
Send Cursor Position Report


.SH "INPUT TRANSLATION"
In order to do a full VT100 emulation
\fItscreen\fP
has to detect
that a sequence of characters in the input stream was generated
by a keypress on the user's keyboard and insert the VT100
style escape sequence. \fItscreen\fP has a very flexible way of doing
this by making it possible to map arbitrary commands on arbitrary
sequences of characters. For standard VT100 emulation the command
will always insert a string in the input buffer of the window
(see also command \fBstuff\fP in the command table).
Because the sequences generated by a keypress can
change after a reattach from a different terminal type, it is
possible to bind commands to the termcap name of the keys.
\fItscreen\fP will insert the correct binding after each
reattach. See the \fBbindkey\fP command for further details on the
syntax and examples.
.PP
Here is the table of the default key bindings. (A) means that the
command is executed if the keyboard is switched into application
mode.
.PP
.ta 18n 34n 50n
.nf
Key name	Termcap name	Command
\l'54n'
.ta 22n 34n 50n
Cursor up	ku	stuff \e033[A
		stuff \e033OA	(A)
Cursor down	kd	stuff \e033[B
		stuff \e033OB	(A)
Cursor right	kr	stuff \e033[C
		stuff \e033OC	(A)
Cursor left	kl	stuff \e033[D
		stuff \e033OD	(A)
Function key 0	k0	stuff \e033[10~
Function key 1	k1	stuff \e033OP
Function key 2	k2	stuff \e033OQ
Function key 3	k3	stuff \e033OR
Function key 4	k4	stuff \e033OS
Function key 5	k5	stuff \e033[15~
Function key 6	k6	stuff \e033[17~
Function key 7	k7	stuff \e033[18~
Function key 8	k8	stuff \e033[19~
Function key 9	k9	stuff \e033[20~
Function key 10	k;	stuff \e033[21~
Function key 11	F1	stuff \e033[23~
Function key 12	F2	stuff \e033[24~
Home	kh	stuff \e033[1~
End	kH	stuff \e033[4~
Insert	kI	stuff \e033[2~
Delete	kD	stuff \e033[3~
Page up	kP	stuff \e033[5~
Page down	kN	stuff \e033[6~
Keypad 0	f0	stuff 0
		stuff \e033Op	(A)
Keypad 1	f1	stuff 1
		stuff \e033Oq	(A)
Keypad 2	f2	stuff 2
		stuff \e033Or	(A)
Keypad 3	f3	stuff 3
		stuff \e033Os	(A)
Keypad 4	f4	stuff 4
		stuff \e033Ot	(A)
Keypad 5	f5	stuff 5
		stuff \e033Ou	(A)
Keypad 6	f6	stuff 6
		stuff \e033Ov	(A)
Keypad 7	f7	stuff 7
		stuff \e033Ow	(A)
Keypad 8	f8	stuff 8
		stuff \e033Ox	(A)
Keypad 9	f9	stuff 9
		stuff \e033Oy	(A)
Keypad +	f+	stuff +
		stuff \e033Ok	(A)
Keypad -	f-	stuff -
		stuff \e033Om	(A)
Keypad *	f*	stuff *
		stuff \e033Oj	(A)
Keypad /	f/	stuff /
		stuff \e033Oo	(A)
Keypad =	fq	stuff =
		stuff \e033OX	(A)
Keypad .	f.	stuff .
		stuff \e033On	(A)
Keypad ,	f,	stuff ,
		stuff \e033Ol	(A)
Keypad enter	fe	stuff \e015
		stuff \e033OM	(A)
.fi


.SH SPECIAL TERMINAL CAPABILITIES
The following table describes all terminal capabilities
that are recognized by
\fItscreen\fP
and are not in the termcap(5) manual.
You can place these capabilities in your termcap entries (in
`/etc/termcap') or use them with the commands `termcap', `terminfo' and
`termcapinfo' in your tscreenrc files. It is often not possible to place
these capabilities in the terminfo database.
.PP
.ta 5n
.TP 13
.BI LP "	(bool)"
Terminal has VT100 style margins (`magic margins'). Note that
this capability is obsolete because
\fItscreen\fP
uses the standard 'xn' instead.
.TP 13
.BI Z0 "	(str)"
Change width to 132 columns.
.TP 13
.BI Z1 "	(str)"
Change width to 80 columns.
.TP 13
.BI WS "	(str)"
Resize display. This capability has the desired width and height as
arguments. \fISunView(tm)\fP example: '\eE[8;%d;%dt'.
.TP 13
.BI NF "	(bool)"
Terminal doesn't need flow control. Send ^S and ^Q direct to
the application. Same as 'flow off'. The opposite of this
capability is 'nx'.
.TP 13
.BI G0 "	(bool)"
Terminal can deal with ISO 2022 font selection sequences.
.TP 13
.BI S0 "	(str)"
Switch charset 'G0' to the specified charset. Default
is '\eE(%.'.
.TP 13
.BI E0 "	(str)"
Switch charset 'G0' back to standard charset. Default
is '\eE(B'.
.TP 13
.BI C0 "	(str)"
Use the string as a conversion table for font '0'. See
the 'ac' capability for more details.
.TP 13
.BI CS "	(str)"
Switch cursor-keys to application mode.
.TP 13
.BI CE "	(str)"
Switch cursor-keys back to normal mode.
.TP 13
.BI AN "	(bool)"
Turn on autonuke. See the 'autonuke' command for more details.
.TP 13
.BI OL "	(num)"
Set the output buffer limit. See the 'obuflimit' command for more details.
.TP 13
.BI KJ "	(str)"
Set the encoding of the terminal. See the 'encoding' command for
valid encodings.
.TP 13
.BI AF "	(str)"
Change character foreground color in an ANSI conform way. This
capability will almost always be set to '\eE[3%dm' ('\eE[3%p1%dm'
on terminfo machines).
.TP 13
.BI AB "	(str)"
Same as 'AF', but change background color.
.TP 13
.BI AX "	(bool)"
Does understand ANSI set default fg/bg color (\eE[39m / \eE[49m).
.TP 13
.BI XC "	(str)"
Describe a translation of characters to strings depending on the
current font. More details follow in the next section.
.TP 13
.BI XT "	(bool)"
Terminal understands special xterm sequences (OSC, mouse tracking).
.TP 13
.BI C8 "	(bool)"
Terminal needs bold to display high-intensity colors (e.g. Eterm).
.TP 13
.BI TF "	(bool)"
Add missing capabilities to the termcap/info entry. (Set by default).

.SH CHARACTER TRANSLATION
\fItscreen\fP has a powerful mechanism to translate characters to arbitrary
strings depending on the current font and terminal type.
Use this feature if you want to work with a common standard character
set (say ISO8851-latin1) even on terminals that scatter the more
unusual characters over several national language font pages.

Syntax:
.nf
    \fBXC=\fP\fI<charset-mapping>\fP{\fB,,\fP\fI<charset-mapping>\fP}
    \fI<charset-mapping>\fP := \fI<designator><template>\fP{\fB,\fP\fI<mapping>\fP}
    \fI<mapping>\fP := \fI<char-to-be-mapped><template-arg>\fP
.fi

The things in braces may be repeated any number of times.

A \fI<charset-mapping>\fP tells
\fItscreen\fP
how to map characters
in font \fI<designator>\fP ('B': Ascii, 'A': UK, 'K': German, etc.)
to strings. Every \fI<mapping>\fP describes to what string a single
character will be translated. A template mechanism is used, as
most of the time the codes have a lot in common (for example
strings to switch to and from another charset). Each occurrence
of '%' in \fI<template>\fP gets substituted with the \fI<template-arg>\fP
specified together with the character. If your strings are not
similar at all, then use '%' as a template and place the full
string in \fI<template-arg>\fP. A quoting mechanism was added to make
it possible to use a real '%'. The '\e' character quotes the
special characters '\e', '%', and ','.

Here is an example:

    termcap hp700 'XC=B\eE(K%\eE(B,\e304[,\e326\e\e\e\e,\e334]'

This tells
\fItscreen\fP
how to translate ISOlatin1 (charset 'B')
upper case umlaut characters on a hp700 terminal that has a
German charset. '\e304' gets translated to '\eE(K[\eE(B' and so on.
Note that this line gets parsed *three* times before the internal
lookup table is built, therefore a lot of quoting is needed to
create a single '\e'.

Another extension was added to allow more emulation: If a mapping
translates the unquoted '%' char, it will be sent to the terminal
whenever
\fItscreen\fP
switches to the corresponding \fI<designator>\fP. In this
special case the template is assumed to be just '%' because
the charset switch sequence and the character mappings normally
haven't much in common.

This example shows one use of the extension:

    termcap xterm 'XC=K%,%\eE(B,[\e304,\e\e\e\e\e326,]\e334'

Here, a part of the German ('K') charset is emulated on an xterm.
If
\fItscreen\fP
has to change to the 'K' charset, '\eE(B' will be sent
to the terminal, i.e. the ASCII charset is used instead. The
template is just '%', so the mapping is straightforward: '['
to '\e304', '\e' to '\e326', and ']' to '\e334'.

.SH ENVIRONMENT
.PD 0
.IP COLUMNS 15
Number of columns on the terminal (overrides termcap entry).
.IP HOME
Directory in which to look for .tscreenrc.
.IP LINES
Number of lines on the terminal (overrides termcap entry).
.IP LOCKPRG
Screen lock program.
.IP NETHACKOPTIONS
Turns on nethack option.
.IP PATH
Used for locating programs to run.
.IP TSCREENCAP
For customizing a terminal's TERMCAP value.
.IP TSCREENDIR
Alternate socket directory.
.IP TSCREENRC
Alternate user tscreenrc file.
.IP SHELL
Default shell program for opening windows (default \*Q/bin/sh\*U).
.IP STY
Alternate socket name.
.IP SYSTSCREENRC
Alternate system tscreenrc file.
.IP TERM
Terminal name.
.IP TERMCAP
Terminal description.
.IP WINDOW
Window number of a window (at creation time).

.SH FILES
.PD 0
.IP etc/tscreenrc
.IP etc/etctscreenrc
Examples in the \fItscreen\fP distribution package for private and global initialization files.
.IP $TSCREENRC
.IP $SYSTSCREENRC
.IP @SYSCONF_INSTALL_DIR@/tscreenrc
\fItscreen\fP initialization commands
.IP $HOME/.tscreenrc
Read in after @SYSCONF_INSTALL_DIR@/tscreenrc
.IP @SOCKDIR@/S-<$USER>
Socket directory
.IP "@SOCKDIR@/.termcap"
Written by the "termcap" output function
.IP /tmp/tscreen-exchange
\fItscreen\fP \*Qinterprocess communication buffer\*U
.IP hardcopy.[0-9]
Screen images created by the hardcopy function
.IP tscreenlog.[0-9]
Output log files created by the log function
.IP /usr/share/terminfo
Terminal capability database
.IP /var/run/utmp
Login records
.IP $LOCKPRG
Program that locks a terminal.


.SH "SEE ALSO"
screen(1), termcap(5), utmp(5), vi(1), captoinfo(1), tic(1)


.SH AUTHORS
Originally created by Oliver Laumann, this latest version was
produced by Wayne Davison, Juergen Weigert and Michael Schroeder.

.SH COPYLEFT
.nf
Copyright (C) 1993-2003
	Juergen Weigert (jnweiger@immd4.informatik.uni-erlangen.de)
	Michael Schroeder (mlschroe@immd4.informatik.uni-erlangen.de)
Copyright (C) 1987 Oliver Laumann
.fi
.PP
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.
.PP
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
.PP
You should have received a copy of the GNU General Public License
along with this program (see the file COPYING); if not, write to the
Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA  02111-1307, USA

.SH CONTRIBUTORS
.nf
Steve Kemp (steve@steve.org.uk)
Ken Beal (kbeal@amber.ssd.csd.harris.com),
Rudolf Koenig (rfkoenig@immd4.informatik.uni-erlangen.de),
Toerless Eckert (eckert@immd4.informatik.uni-erlangen.de),
Wayne Davison (davison@borland.com),
Patrick Wolfe (pat@kai.com, kailand!pat),
Bart Schaefer (schaefer@cse.ogi.edu),
Nathan Glasser (nathan@brokaw.lcs.mit.edu),
Larry W. Virden (lvirden@cas.org),
Howard Chu (hyc@hanauma.jpl.nasa.gov),
Tim MacKenzie (tym@dibbler.cs.monash.edu.au),
Markku Jarvinen (mta@{cc,cs,ee}.tut.fi),
Marc Boucher (marc@CAM.ORG),
Doug Siebert (dsiebert@isca.uiowa.edu),
Ken Stillson (stillson@tsfsrv.mitre.org),
Ian Frechett (frechett@spot.Colorado.EDU),
Brian Koehmstedt (bpk@gnu.ai.mit.edu),
Don Smith (djs6015@ultb.isc.rit.edu),
Frank van der Linden (vdlinden@fwi.uva.nl),
Martin Schweikert (schweik@cpp.ob.open.de),
David Vrona (dave@sashimi.lcu.com),
E. Tye McQueen (tye%spillman.UUCP@uunet.uu.net),
Matthew Green (mrg@eterna.com.au),
Christopher Williams (cgw@pobox.com),
Matt Mosley (mattm@access.digex.net),
Gregory Neil Shapiro (gshapiro@wpi.WPI.EDU),
Johannes Zellner (johannes@zellner.org),
Pablo Averbuj (pablo@averbuj.com).
.fi


.SH VERSION
This is version @VERSION_STRING@. It was forked from Steve Kemp's tscreen, which was itself forked from GNU Screen.

.SH AVAILABILITY
The latest official release of \fItscreen\fP is available via mercurial from \fB@PACKAGE_URL@\fP

.SH BUGS
.PD
.IP \(bu 3
`dm' (delete mode) and `xs' are not handled
correctly (they are ignored). `xn' is treated as a magic-margin
indicator.
.IP \(bu
\fItscreen\fP has no clue about double-high or double-wide characters.
But this is the only area where
\fIvttest\fP is allowed to fail.
.IP \(bu
It is not possible to change the environment variable $TERMCAP when
reattaching under a different terminal type.
.IP \(bu
The support of terminfo based systems is very limited. Adding extra
capabilities to $TERMCAP may not have any effects.
.IP \(bu
\fItscreen\fP does not make use of hardware tabs.
.IP \(bu
\fItscreen\fP must be installed as set-uid with owner root on most systems in order
to be able to correctly change the owner of the tty device file for
each window.
Special permission may also be required to write the file \*Q/var/run/utmp\*U.
.IP \(bu
Entries in \*Q/var/run/utmp\*U are not removed when
\fItscreen\fP is killed with SIGKILL.
This will cause some programs (like "w" or "rwho")
to advertise that a user is logged on who really isn't.
.IP \(bu
\fItscreen\fP may give a strange warning when your tty has no utmp entry.
.IP \(bu
When the modem line was hung up, \fItscreen\fP may not automatically detach (or quit)
unless the device driver is configured to send a HANGUP signal.
To detach a \fItscreen\fP session use the -D or -d command line option.
.IP \(bu
If a password is set, the command line options -d and -D still detach a
session without asking.
.IP \(bu
Both \*Qbreaktype\*U and \*Qdefbreaktype\*U change the break generating
method used by all terminal devices. The first should change a window
specific setting, where the latter should change only the default for new
windows.
.IP \(bu
When attaching to a multiuser session, the user's .tscreenrc file is not
sourced. Each user's personal settings have to be included in the .tscreenrc
file from which the session is booted, or have to be changed manually.
.IP \(bu
A weird imagination is most useful to gain full advantage of all the features.
.IP \(bu
Direct bug-reports, fixes, enhancements, and snide remarks to
.BR @PACKAGE_URL@ .

