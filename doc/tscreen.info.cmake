This is tscreen.info, produced by makeinfo version 4.13 from
./tscreen.texinfo.

INFO-DIR-SECTION General Commands
START-INFO-DIR-ENTRY
* Screen: (screen).             Full-screen window manager.
END-INFO-DIR-ENTRY

   This file documents the `Screen' virtual terminal manager.

   Copyright (c) 1993-2003 Free Software Foundation, Inc.

   Permission is granted to make and distribute verbatim copies of this
manual provided the copyright notice and this permission notice are
preserved on all copies.

   Permission is granted to copy and distribute modified versions of
this manual under the conditions for verbatim copying, provided that
the entire resulting derived work is distributed under the terms of a
permission notice identical to this one.

   Permission is granted to copy and distribute translations of this
manual into another language, under the above conditions for modified
versions, except that this permission notice may be stated in a
translation approved by the Foundation.


File: tscreen.info,  Node: Top,  Next: Overview,  Prev: (dir),  Up: (dir)

Screen
******

This file documents the `Screen' virtual terminal manager, version
4.1.0.

* Menu:

* Overview::                    Preliminary information.
* Getting Started::             An introduction to `screen'.
* Invoking Screen::             Command line options for `screen'.
* Customization::               The `.screenrc' file.
* Commands::                    List all of the commands.
* New Window::                  Running a program in a new window.
* Selecting::                   Selecting a window to display.
* Session Management::          Suspend/detach, grant access, connect sessions.
* Regions::			Split-screen commands.
* Window Settings::             Titles, logging, etc.
* Virtual Terminal::            Controlling the `screen' VT100 emulation.
* Copy and Paste::              Exchanging text between windows and sessions.
* Subprocess Execution::	I/O filtering with `exec'.
* Key Binding::                 Binding commands to keys.
* Flow Control::                Trap or pass flow control characters.
* Termcap::                     Tweaking your terminal's termcap entry.
* Message Line::                The `screen' message line.
* Logging::                     Keeping a record of your session.
* Startup::                     Functions only useful at `screen' startup.
* Miscellaneous::               Various other commands.
* String Escapes::              Inserting current information into strings
* Environment::                 Environment variables used by `screen'.
* Files::                       Files used by `screen'.
* Credits::                     Who's who of `screen'.
* Bugs::                        What to do if you find a bug.
* Installation::                Getting `screen' running on your system.
* Concept Index::               Index of concepts.
* Command Index::               Index of all `screen' commands.
* Keystroke Index::             Index of default key bindings.


File: tscreen.info,  Node: Overview,  Next: Getting Started,  Prev: Top,  Up: Top

1 Overview
**********

Screen is a full-screen window manager that multiplexes a physical
terminal between several processes, typically interactive shells.  Each
virtual terminal provides the functions of the DEC VT100 terminal and,
in addition, several control functions from the ISO 6429 (ECMA 48, ANSI
X3.64) and ISO 2022 standards (e.g. insert/delete line and support for
multiple character sets).  There is a scrollback history buffer for
each virtual terminal and a copy-and-paste mechanism that allows the
user to move text regions between windows.

   When `screen' is called, it creates a single window with a shell in
it (or the specified command) and then gets out of your way so that you
can use the program as you normally would.  Then, at any time, you can
create new (full-screen) windows with other programs in them (including
more shells), kill the current window, view a list of the active
windows, turn output logging on and off, copy text between windows, view
the scrollback history, switch between windows, etc.  All windows run
their programs completely independent of each other.  Programs continue
to run when their window is currently not visible and even when the
whole screen session is detached from the user's terminal.

   When a program terminates, `screen' (per default) kills the window
that contained it.  If this window was in the foreground, the display
switches to the previously displayed window; if none are left, `screen'
exits.

   Everything you type is sent to the program running in the current
window.  The only exception to this is the one keystroke that is used to
initiate a command to the window manager.  By default, each command
begins with a control-a (abbreviated `C-a' from now on), and is
followed by one other keystroke.  The command character (*note Command
Character::) and all the key bindings (*note Key Binding::) can be fully
customized to be anything you like, though they are always two
characters in length.

   `Screen' does not understand the prefix `C-' to mean control.
Please use the caret notation (`^A' instead of `C-a') as arguments to
e.g. the `escape' command or the `-e' option. `Screen' will also print
out control characters in caret notation.

   The standard way to create a new window is to type `C-a c'.  This
creates a new window running a shell and switches to that window
immediately, regardless of the state of the process running in the
current window.  Similarly, you can create a new window with a custom
command in it by first binding the command to a keystroke (in your
`.screenrc' file or at the `C-a :' command line) and then using it just
like the `C-a c' command.  In addition, new windows can be created by
running a command like:

     screen emacs prog.c

from a shell prompt within a previously created window.  This will not
run another copy of `screen', but will instead supply the command name
and its arguments to the window manager (specified in the $STY
environment variable) who will use it to create the new window.  The
above example would start the `emacs' editor (editing `prog.c') and
switch to its window.

   If `/etc/utmp' is writable by `screen', an appropriate record will
be written to this file for each window, and removed when the window is
closed.  This is useful for working with `talk', `script', `shutdown',
`rsend', `sccs' and other similar programs that use the utmp file to
determine who you are. As long as `screen' is active on your terminal,
the terminal's own record is removed from the utmp file.  *Note Login::.


File: tscreen.info,  Node: Getting Started,  Next: Invoking Screen,  Prev: Overview,  Up: Top

2 Getting Started
*****************

Before you begin to use `screen' you'll need to make sure you have
correctly selected your terminal type, just as you would for any other
termcap/terminfo program.  (You can do this by using `tset', `qterm',
or just `set term=mytermtype', for example.)

   If you're impatient and want to get started without doing a lot more
reading, you should remember this one command: `C-a ?' (*note Key
Binding::).  Typing these two characters will display a list of the
available `screen' commands and their bindings. Each keystroke is
discussed in the section on keystrokes (*note Default Key Bindings::).
Another section (*note Customization::) deals with the contents of your
`.screenrc'.

   If your terminal is a "true" auto-margin terminal (it doesn't allow
the last position on the screen to be updated without scrolling the
screen) consider using a version of your terminal's termcap that has
automatic margins turned _off_.  This will ensure an accurate and
optimal update of the screen in all circumstances.  Most terminals
nowadays have "magic" margins (automatic margins plus usable last
column).  This is the VT100 style type and perfectly suited for
`screen'.  If all you've got is a "true" auto-margin terminal `screen'
will be content to use it, but updating a character put into the last
position on the screen may not be possible until the screen scrolls or
the character is moved into a safe position in some other way. This
delay can be shortened by using a terminal with insert-character
capability.

   *Note Special Capabilities::, for more information about telling
`screen' what kind of terminal you have.


File: tscreen.info,  Node: Invoking Screen,  Next: Customization,  Prev: Getting Started,  Up: Top

3 Invoking `Screen'
*******************

Screen has the following command-line options:

`-a'
     Include _all_ capabilities (with some minor exceptions) in each
     window's termcap, even if `screen' must redraw parts of the display
     in order to implement a function.

`-A'
     Adapt the sizes of all windows to the size of the display.  By
     default, `screen' may try to restore its old window sizes when
     attaching to resizable terminals (those with `WS' in their
     descriptions, e.g.  `suncmd' or some varieties of `xterm').

`-c FILE'
     Use FILE as the user's configuration file instead of the default
     of `$HOME/.screenrc'.

`-d [PID.SESSIONNAME]'
`-D [PID.SESSIONNAME]'
     Do not start `screen', but instead detach a `screen' session
     running elsewhere (*note Detach::).  `-d' has the same effect as
     typing `C-a d' from the controlling terminal for the session.
     `-D' is the equivalent to the power detach key.  If no session can
     be detached, this option is ignored.  In combination with the
     `-r'/`-R' option more powerful effects can be achieved:

    `-d -r'
          Reattach a session and if necessary detach it first.

    `-d -R'
          Reattach a session and if necessary detach  or  even create
          it first.

    `-d -RR'
          Reattach a session and if necessary detach or create it.  Use
          the first session if more than one session is available.

    `-D -r'
          Reattach a session. If necessary detach  and  logout remotely
          first.

    `-D -R'
          Attach here and now. In detail this means: If a session  is
          running, then reattach. If necessary detach and logout
          remotely first.  If it was not running create it and notify
          the user.  This is the author's favorite.

    `-D -RR'
          Attach here and now. Whatever that  means, just do it.

     _Note_: It is a good idea to check the status of your sessions
     with `screen -list' before using this option.

`-e XY'
     Set the command character to X, and the character generating a
     literal command character (when typed after the command character)
     to Y.  The defaults are `C-a' and `a', which can be specified as
     `-e^Aa'.  When creating a `screen' session, this option sets the
     default command character. In a multiuser session all users added
     will start off with this command character. But when attaching to
     an already running session, this option only changes the command
     character of the attaching user.  This option is equivalent to the
     commands `defescape' or `escape' respectively.  (*note Command
     Character::).

`-f'
`-fn'
`-fa'
     Set flow-control to on, off, or automatic switching mode,
     respectively.  This option is equivalent to the `defflow' command
     (*note Flow Control::).

`-h NUM'
     Set the history scrollback buffer to be NUM lines high.
     Equivalent to the `defscrollback' command (*note Copy::).

`-i'
     Cause the interrupt key (usually `C-c') to interrupt the display
     immediately when flow control is on.  This option is equivalent to
     the `interrupt' argument to the `defflow' command (*note Flow
     Control::). Its use is discouraged.

`-l'
`-ln'
     Turn login mode on or off (for `/etc/utmp' updating).  This option
     is equivalent to the `deflogin' command (*note Login::).

`-ls [MATCH]'
`-list [MATCH]'
     Do not start `screen', but instead print a list of session
     identification strings (usually of the form PID.TTY.HOST; *note
     Session Name::).  Sessions marked `detached' can be resumed with
     `screen -r'.  Those marked `attached' are running and have a
     controlling terminal.  If the session runs in multiuser mode, it
     is marked `multi'.  Sessions marked as `unreachable' either live
     on a different host or are dead.  An unreachable session is
     considered dead, when its name matches either the name of the
     local host, or the specified parameter, if any.  See the `-r' flag
     for a description how to construct matches.  Sessions marked as
     `dead' should be thoroughly checked and removed.  Ask your system
     administrator if you are not sure.  Remove sessions with the
     `-wipe' option.

`-L'
     Tell `screen' to turn on automatic output logging for the windows.

`-m'
     Tell `screen' to ignore the `$STY' environment variable.  When
     this option is used, a new session will always be created,
     regardless of whether `screen' is being called from within another
     `screen' session or not. This flag has a special meaning in
     connection with the `-d' option:
    `-d -m'
          Start `screen' in _detached_ mode. This creates a new session
          but doesn't attach to it. This is useful for system startup
          scripts.

    `-D -m'
          This also starts `screen' in _detached_ mode, but doesn't fork
          a new process. The command exits if the session terminates.

`-p NAME_OR_NUMBER'
     Preselect a window. This is useful when you want to reattach to a
     specific window or you want to send a command via the `-X' option
     to a specific window. As with screen's select command, `-' selects
     the blank window. As a special case for reattach, `=' brings up
     the windowlist on the blank window.

`-q'
     Suppress printing of error messages. In combination with `-ls' the
     exit value is set as follows: 9 indicates a directory without
     sessions. 10 indicates a directory with running but not attachable
     sessions. 11 (or more) indicates 1 (or more) usable sessions.  In
     combination with `-r' the exit value is as follows: 10 indicates
     that there is no session to resume. 12 (or more) indicates that
     there are 2 (or more) sessions to resume and you should specify
     which one to choose.  In all other cases `-q' has no effect.

`-r [PID.SESSIONNAME]'
`-r SESSIONOWNER/[PID.SESSIONNAME]'
     Resume a detached `screen' session.  No other options (except
     combinations with `-d' or `-D') may be specified, though the
     session name (*note Session Name::) may be needed to distinguish
     between multiple detached `screen' sessions.  The second form is
     used to connect to another user's screen session which runs in
     multiuser mode. This indicates that screen should look for
     sessions in another user's directory. This requires setuid-root.

`-R'
     Resume the first appropriate detached `screen' session.  If
     successful, all other command-line options are ignored.  If no
     detached session exists, start a new session using the specified
     options, just as if `-R' had not been specified.  This option is
     set by default if screen is run as a login-shell (actually screen
     uses `-xRR' in that case).  For combinations with the `-D'/`-d'
     option see there.

`-s PROGRAM'
     Set the default shell to be PROGRAM.  By default, `screen' uses
     the value of the environment variable `$SHELL', or `/bin/sh' if it
     is not defined.  This option is equivalent to the `shell' command
     (*note Shell::).

`-S SESSIONNAME'
     Set the name of the new session to SESSIONNAME.  This option can
     be used to specify a meaningful name for the session in place of
     the default TTY.HOST suffix.  This name identifies the session for
     the `screen -list' and `screen -r' commands.  This option is
     equivalent to the `sessionname' command (*note Session Name::).

`-t NAME'
     Set the title (name) for the default shell or specified program.
     This option is equivalent to the `shelltitle' command (*note
     Shell::).

`-U'
     Run screen in UTF-8 mode. This option tells screen that your
     terminal sends and understands UTF-8 encoded characters. It also
     sets the default encoding for new windows to `utf8'.

`-v'
     Print the version number.

`-wipe [MATCH]'
     List available screens like `screen -ls', but remove destroyed
     sessions instead of marking them as `dead'.  An unreachable
     session is considered dead, when its name matches either the name
     of the local host, or the explicitly given parameter, if any.  See
     the `-r' flag for a description how to construct matches.

`-x'
     Attach to a session which is already attached elsewhere
     (multi-display mode).  `Screen' refuses to attach from within
     itself.  But when cascading multiple screens, loops are not
     detected; take care.

`-X'
     Send the specified command to a running screen session. You can use
     the `-d' or `-r' option to tell screen to look only for attached
     or detached screen sessions. Note that this command doesn't work
     if the session is password protected.



File: tscreen.info,  Node: Customization,  Next: Commands,  Prev: Invoking Screen,  Up: Top

4 Customizing `Screen'
**********************

You can modify the default settings for `screen' to fit your tastes
either through a personal `.screenrc' file which contains commands to
be executed at startup, or on the fly using the `colon' command.

* Menu:

* Startup Files::               The `.screenrc' file.
* Source::                      Read commands from a file.
* Colon::                       Entering customization commands interactively.


File: tscreen.info,  Node: Startup Files,  Next: Source,  Up: Customization

4.1 The `.screenrc' file
========================

When `screen' is invoked, it executes initialization commands from the
files `.screenrc' in the user's home directory and
`/usr/local/etc/screenrc'.  These defaults can be overridden in the
following ways: For the global screenrc file `screen' searches for the
environment variable `$SYSSCREENRC' (this override feature may be
disabled at compile-time).  The user specific screenrc file is searched
for in `$SCREENRC', then ``$HOME'/.screenrc'.  The command line option
`-c' specifies which file to use (*note Invoking Screen::.  Commands in
these files are used to set options, bind commands to keys, and to
automatically establish one or more windows at the beginning of your
`screen' session.  Commands are listed one per line, with empty lines
being ignored.  A command's arguments are separated by tabs or spaces,
and may be surrounded by single or double quotes.  A `#' turns the rest
of the line into a comment, except in quotes.  Unintelligible lines are
warned about and ignored.  Commands may contain references to
environment variables.  The syntax is the shell-like `$VAR' or
`${VAR}'.  Note that this causes incompatibility with previous `screen'
versions, as now the '$'-character has to be protected with '\' if no
variable substitution is intended. A string in single-quotes is also
protected from variable substitution.

   Two configuration files are shipped as examples with your screen
distribution: `etc/screenrc' and `etc/etcscreenrc'. They contain a
number of useful examples for various commands.


File: tscreen.info,  Node: Source,  Next: Colon,  Prev: Startup Files,  Up: Customization

4.2 Source
==========

 -- Command: source file
     (none)
     Read and execute commands from file FILE. Source  commands may be
     nested to a maximum recursion level of ten. If FILE is not an
     absolute path and  screen  is already processing  a source
     command, the parent directory of the running source command file
     is used to search for the new command file  before screen's
     current directory.

     Note  that termcap/terminfo/termcapinfo commands only work at
     startup and reattach time, so they must be reached  via the
     default screenrc files to have an effect.


File: tscreen.info,  Node: Colon,  Prev: Source,  Up: Customization

4.3 Colon
=========

Customization can also be done online, with this command:

 -- Command: colon
     (`C-a :')
     Allows you to enter `.screenrc' command lines.  Useful for
     on-the-fly modification of key bindings, specific window creation
     and changing settings.  Note that the `set' keyword no longer
     exists, as of version 3.3.  Change default settings with commands
     starting with `def'.  You might think of this as the `ex' command
     mode of `screen', with `copy' as its `vi' command mode (*note Copy
     and Paste::).


File: tscreen.info,  Node: Commands,  Next: New Window,  Prev: Customization,  Up: Top

5 Commands
**********

A command in `screen' can either be bound to a key, invoked from a
screenrc file, or called from the `colon' prompt (*note
Customization::).  As of version 3.3, all commands can be bound to
keys, although some may be less useful than others.  For a number of
real life working examples of the most important commands see the files
`etc/screenrc' and `etc/etcscreenrc' of your screen distribution.

   In this manual, a command definition looks like this:

- Command: command [-n] ARG1 [ARG2] ...
     (KEYBINDINGS)
     This command does something, but I can't remember what.

   An argument in square brackets (`[]') is optional.  Many commands
take an argument of `on' or `off', which is indicated as STATE in the
definition.

* Menu:

* Default Key Bindings::	`screen' keyboard commands.
* Command Summary::             List of all commands.


File: tscreen.info,  Node: Default Key Bindings,  Next: Command Summary,  Up: Commands

5.1 Default Key Bindings
========================

As mentioned previously, each keyboard command consists of a `C-a'
followed by one other character.  For your convenience, all commands
that are bound to lower-case letters are also bound to their control
character counterparts (with the exception of `C-a a'; see below).
Thus, both `C-a c' and `C-a C-c' can be used to create a window.

   The following table shows the default key bindings:

`C-a ''
     (select)
     Prompt for a window identifier and switch.  *Note Selecting::.

`C-a "'
     (windowlist -b)
     Present a list of all windows for selection.  *Note Selecting::.

`C-a 0...9, -'
     (select 0...select 9, select -)
     Switch to window number 0...9, or the blank window.  *Note
     Selecting::.

`C-a <Tab>'
     (focus)
     Switch the input focus to the next region.  *Note Regions::.

`C-a C-a'
     (other)
     Toggle to the window displayed previously.  If this window does no
     longer exist, `other' has the same effect as `next'.  *Note
     Selecting::.

`C-a a'
     (meta)
     Send the command character (C-a) to window. See `escape' command.
     *Note Command Character::.

`C-a A'
     (title)
     Allow the user to enter a title for the current window.  *Note
     Naming Windows::.

`C-a b'
`C-a C-b'
     (break)
     Send a break to the tty.  *Note Break::.

`C-a B'
     (pow_break)
     Close and reopen the tty-line.  *Note Break::.

`C-a c'
`C-a C-c'
     (screen)
     Create a new window with a shell and switch to that window.  *Note
     Screen Command::.

`C-a C'
     (clear)
     Clear the screen.  *Note Clear::.

`C-a d'
`C-a C-d'
     (detach)
     Detach `screen' from this terminal.  *Note Detach::.

`C-a D D'
     (pow_detach)
     Detach and logout.  *Note Power Detach::.

`C-a f'
`C-a C-f'
     (flow)
     Cycle flow among `on', `off' or `auto'.  *Note Flow::.

`C-a F'
     (fit)
     Resize the window to the current region size.  *Note Window Size::.

`C-a C-g'
     (vbell)
     Toggle visual bell mode.  *Note Bell::.

`C-a h'
     (hardcopy)
     Write a hardcopy of the current window to the file "hardcopy.N".
     *Note Hardcopy::.

`C-a H'
     (log)
     Toggle logging of the current window to the file "screenlog.N".
     *Note Log::.

`C-a i'
`C-a C-i'
     (info)
     Show info about the current window.  *Note Info::.

`C-a k'
`C-a C-k'
     (kill)
     Destroy the current window.  *Note Kill::.

`C-a l'
`C-a C-l'
     (redisplay)
     Fully refresh the current window.  *Note Redisplay::.

`C-a L'
     (login)
     Toggle the current window's login state.  *Note Login::.

`C-a m'
`C-a C-m'
     (lastmsg)
     Repeat the last message displayed in the message line.  *Note Last
     Message::.

`C-a M'
     (monitor) Toggle monitoring of the current window.  *Note
     Monitor::.

`C-a <SPC>'
`C-a n'
`C-a C-n'
     (next)
     Switch to the next window.  *Note Selecting::.

`C-a N'
     (number)
     Show the number (and title) of the current window.  *Note Number::.

`C-a p'
`C-a C-p'
`C-a C-h'
`C-a <BackSpace>'
     (prev)
     Switch to the previous window (opposite of `C-a n').  *Note
     Selecting::.

`C-a q'
`C-a C-q'
     (xon)
     Send a ^Q (ASCII XON) to the current window.  *Note XON/XOFF::.

`C-a Q'
     (only)
     Delete all regions but the current one.  *Note Regions::.

`C-a r'
`C-a C-r'
     (wrap)
     Toggle the current window's line-wrap setting (turn the current
     window's automatic margins on or off).  *Note Wrap::.

`C-a s'
`C-a C-s'
     (xoff)
     Send a ^S (ASCII XOFF) to the current window.  *Note XON/XOFF::.

`C-a S'
     (split)
     Split the current region into two new ones.  *Note Regions::.

`C-a t'
`C-a C-t'
     (time)
     Show the load average and xref.  *Note Time::.

`C-a v'
     (version)
     Display the version and compilation date.  *Note Version::.

`C-a C-v'
     (digraph)
     Enter digraph.  *Note Digraph::.

`C-a w'
`C-a C-w'
     (windows)
     Show a list of active windows.  *Note Windows::.

`C-a W'
     (width)
     Toggle between 80 and 132 columns.  *Note Window Size::.

`C-a x'
`C-a C-x'
     (lockscreen)
     Lock your terminal.  *Note Lock::.

`C-a X'
     (remove)
     Kill the current region.  *Note Regions::.

`C-a z'
`C-a C-z'
     (suspend)
     Suspend `screen'.  *Note Suspend::.

`C-a Z'
     (reset)
     Reset the virtual terminal to its "power-on" values.  *Note
     Reset::.

`C-a .'
     (dumptermcap)
     Write out a `.termcap' file.  *Note Dump Termcap::.

`C-a ?'
     (help)
     Show key bindings.  *Note Help::.

`C-a C-\'
     (quit)
     Kill all windows and terminate `screen'.  *Note Quit::.

`C-a :'
     (colon)
     Enter a command line.  *Note Colon::.

`C-a ['
`C-a C-['
`C-a <ESC>'
     (copy)
     Enter copy/scrollback mode.  *Note Copy::.

`C-a ]'
`C-a C-]'
     (paste .)
     Write the contents of the paste buffer to the stdin queue of the
     current window.  *Note Paste::.

`C-a {'
`C-a }'
     (history)
     Copy and paste a previous (command) line.  *Note History::.

`C-a >'
     (writebuf)
     Write the paste buffer out to the screen-exchange file.  *Note
     Screen Exchange::.

`C-a <'
     (readbuf)
     Read the screen-exchange file into the paste buffer.  *Note Screen
     Exchange::.

`C-a ='
     (removebuf)
     Delete the screen-exchange file.  *Note Screen Exchange::.

`C-a _'
     (silence)
     Start/stop monitoring the current window for inactivity. *Note
     Silence::,

`C-a ,'
     (license)
     Show the copyright page.

`C-a *'
     (displays)
     Show the listing of attached displays.


File: tscreen.info,  Node: Command Summary,  Prev: Default Key Bindings,  Up: Commands

5.2 Command Summary
===================

`acladd USERNAMES'
     Allow other users in this session.  *Note Multiuser Session::.

`aclchg USERNAMES PERMBITS LIST'
     Change a user's permissions.  *Note Multiuser Session::.

`acldel USERNAME'
     Disallow other user in this session.  *Note Multiuser Session::.

`aclgrp USRNAME [GROUPNAME]'
     Inherit permissions granted to a group leader. *Note Multiuser
     Session::.

`aclumask [USERS]+/-BITS ...'
     Predefine access to new windows. *Note Umask::.

`activity MESSAGE'
     Set the activity notification message.  *Note Monitor::.

`addacl USERNAMES'
     Synonym to `acladd'.  *Note Multiuser Session::.

`allpartial STATE'
     Set all windows to partial refresh.  *Note Redisplay::.

`altscreen STATE'
     Enables support for the "alternate screen" terminal capability.
     *Note Redisplay::.

`at [IDENT][#|*|%] COMMAND [ARGS]'
     Execute a command at other displays or windows.  *Note At::.

`attrcolor ATTRIB [ATTRIBUTE/COLOR-MODIFIER]'
     Map attributes to colors.  *Note Attrcolor::.

`autodetach STATE'
     Automatically detach the session on SIGHUP.  *Note Detach::.

`autonuke STATE'
     Enable a clear screen to discard unwritten output.  *Note
     Autonuke::.

`backtick ID LIFESPAN AUTOREFRESH COMMAND [ARGS]'
     Define a command for the backtick string escape.  *Note Backtick::.

`bce [STATE]'
     Change background color erase.  *Note Character Processing::.

`bell_msg [MESSAGE]'
     Set the bell notification message.  *Note Bell::.

`bind [-c CLASS] KEY [COMMAND [ARGS]]'
     Bind a command to a key.  *Note Bind::.

`bindkey [OPTS] [STRING [CMD ARGS]]'
     Bind a string to a series of keystrokes. *Note Bindkey::.

`blanker'
     Blank the screen.  *Note Screen Saver::.

`blankerprg'
     Define a blanker program.  *Note Screen Saver::.

`break [DURATION]'
     Send a break signal to the current window.  *Note Break::.

`breaktype [TCSENDBREAK | TCSBRK | TIOCSBRK]'
     Specify how to generate breaks.  *Note Break::.

`bufferfile [EXCHANGE-FILE]'
     Select a file for screen-exchange.  *Note Screen Exchange::.

`c1 [STATE]'
     Change c1 code processing.  *Note Character Processing::.

`caption MODE [STRING]'
     Change caption mode and string.  *Note Regions::.

`chacl USERNAMES PERMBITS LIST'
     Synonym to `aclchg'. *Note Multiuser Session::.

`charset SET'
     Change character set slot designation.  *Note Character
     Processing::.

`chdir [DIRECTORY]'
     Change the current directory for future windows.  *Note Chdir::.

`clear'
     Clear the window screen.  *Note Clear::.

`colon'
     Enter a `screen' command.  *Note Colon::.

`command [-c CLASS]'
     Simulate the screen escape key.  *Note Command Character::.

`compacthist [STATE]'
     Selects compaction of trailing empty lines.  *Note Scrollback::.

`console [STATE]'
     Grab or ungrab console output.  *Note Console::.

`copy'
     Enter copy mode.  *Note Copy::.

`copy_reg [KEY]'
     Removed. Use `paste' instead.  *Note Registers::.

`crlf STATE'
     Select line break behavior for copying.  *Note Line Termination::.

`debug STATE'
     Suppress/allow debugging output.  *Note Debug::.

`defautonuke STATE'
     Select default autonuke behavior.  *Note Autonuke::.

`defbce STATE'
     Select background color erase.  *Note Character Processing::.

`defbreaktype [TCSENDBREAK | TCSBRK | TIOCSBRK]'
     Specify the default for generating breaks.  *Note Break::.

`defc1 STATE'
     Select default c1 processing behavior.  *Note Character
     Processing::.

`defcharset [SET]'
     Change defaul character set slot designation.  *Note Character
     Processing::.

`defencoding ENC'
     Select default window encoding.  *Note Character Processing::.

`defescape XY'
     Set the default command and `meta' characters.  *Note Command
     Character::.

`defflow FSTATE'
     Select default flow control behavior.  *Note Flow::.

`defgr STATE'
     Select default GR processing behavior.  *Note Character
     Processing::.

`defhstatus [STATUS]'
     Select default window hardstatus line.  *Note Hardstatus::.

`deflog STATE'
     Select default window logging behavior.  *Note Log::.

`deflogin STATE'
     Select default utmp logging behavior.  *Note Login::.

`defmode MODE'
     Select default file mode for ptys.  *Note Mode::.

`defmonitor STATE'
     Select default activity monitoring behavior.  *Note Monitor::.

`defnonblock STATE|NUMSECS'
     Select default nonblock mode.  *Note Nonblock::.

`defobuflimit LIMIT'
     Select default output buffer limit.  *Note Obuflimit::.

`defscrollback NUM'
     Set default lines of scrollback.  *Note Scrollback::.

`defshell COMMAND'
     Set the default program for new windows.  *Note Shell::.

`defsilence STATE'
     Select default idle monitoring behavior.  *Note Silence::.

`defslowpaste MSEC'
     Select the default inter-character timeout when pasting.  *Note
     Paste::.

`defutf8 STATE'
     Select default character encoding.  *Note Character Processing::.

`defwrap STATE'
     Set default line-wrapping behavior.  *Note Wrap::.

`defwritelock ON|OFF|AUTO'
     Set default writelock behavior.  *Note Multiuser Session::.

`defzombie [KEYS]'
     Keep dead windows.  *Note Zombie::.

`detach [-h]'
     Disconnect `screen' from the terminal.  *Note Detach::.

`digraph'
     Enter digraph sequence.  *Note Digraph::.

`dinfo'
     Display terminal information.  *Note Info::.

`displays'
     List currently active user interfaces. *Note Displays::.

`dumptermcap'
     Write the window's termcap entry to a file.  *Note Dump Termcap::.

`echo [-n] MESSAGE'
     Display a message on startup.  *Note Startup::.

`encoding ENC [DENC]'
     Set the encoding of a window.  *Note Character Processing::.

`escape XY'
     Set the command and `meta' characters.  *Note Command Character::.

`eval COMMAND1 [COMMAND2 ...]'
     Parse and execute each argument. *Note Eval::.

`exec [[FDPAT] COMMAND [ARGS ...]]'
     Run a subprocess (filter).  *Note Exec::.

`fit'
     Change window size to current display size.  *Note Window Size::.

`flow [FSTATE]'
     Set flow control behavior.  *Note Flow::.

`focus'
     Move focus to next region.  *Note Regions::.

`gr [STATE]'
     Change GR charset processing.  *Note Character Processing::.

`hardcopy [-h] [FILE]'
     Write out the contents of the current window.  *Note Hardcopy::.

`hardcopy_append STATE'
     Append to hardcopy files.  *Note Hardcopy::.

`hardcopydir DIRECTORY'
     Place, where to dump hardcopy files.  *Note Hardcopy::.

`hardstatus [STATE]'
     Use the hardware status line.  *Note Hardware Status Line::.

`height [LINES [COLS]]'
     Set display height.  *Note Window Size::.

`help [-c CLASS]'
     Display current key bindings.  *Note Help::.

`history'
     Find previous command beginning ....  *Note History::.

`hstatus STATUS'
     Change the window's hardstatus line.  *Note Hardstatus::.

`idle [TIMEOUT [CMD ARGS]]'
     Define a screen saver command.  *Note Screen Saver::.

`ignorecase [STATE]'
     Ignore character case in searches.  *Note Searching::.

`info'
     Display window settings.  *Note Info::.

`ins_reg [KEY]'
     Removed, use `paste' instead.  *Note Registers::.

`kill'
     Destroy the current window.  *Note Kill::.

`lastmsg'
     Redisplay the last message.  *Note Last Message::.

`license'
     Display licensing information.  *Note Startup::.

`lockscreen'
     Lock the controlling terminal.  *Note Lock::.

`log [STATE]'
     Log all output in the current window.  *Note Log::.

`logfile FILENAME'
     Place where to collect logfiles.  *Note Log::.

`login [STATE]'
     Log the window in `/etc/utmp'.  *Note Login::.

`logtstamp [STATE]'
     Configure logfile time-stamps.  *Note Log::.

`mapdefault'
     Use only the default mapping table for the next keystroke.  *Note
     Bindkey Control::.

`mapnotnext'
     Don't try to do keymapping on the next keystroke.  *Note Bindkey
     Control::.

`maptimeout TIMO'
     Set the inter-character timeout used for keymapping. *Note Bindkey
     Control::.

`markkeys STRING'
     Rebind keys in copy mode.  *Note Copy Mode Keys::.

`maxwin N'
     Set the maximum window number. *Note Maxwin::.

`meta'
     Insert the command character.  *Note Command Character::.

`monitor [STATE]'
     Monitor activity in window.  *Note Monitor::.

`msgminwait SEC'
     Set minimum message wait.  *Note Message Wait::.

`msgwait SEC'
     Set default message wait.  *Note Message Wait::.

`multiuser STATE'
     Go into single or multi user mode. *Note Multiuser Session::.

`nethack STATE'
     Use `nethack'-like error messages.  *Note Nethack::.

`next'
     Switch to the next unhidden window.  *Note Selecting::.

`nonblock [STATE|NUMSECS]'
     Disable flow control to the current display. *Note
     Nonblock::.|NUMSECS]

`number [N]'
     Change/display the current window's number.  *Note Number::.

`obuflimit [LIMIT]'
     Select output buffer limit.  *Note Obuflimit::.

`only'
     Kill all other regions.  *Note Regions::.

`other'
     Switch to the window you were in last.  *Note Selecting::.

`partial STATE'
     Set window to partial refresh.  *Note Redisplay::.

`password [CRYPTED_PW]'
     Set reattach password.  *Note Detach::.

`paste [SRC_REGS [DEST_REG]]'
     Paste contents of paste buffer or registers somewhere.  *Note
     Paste::.

`pastefont [STATE]'
     Include font information in the paste buffer.  *Note Paste::.

`pow_break'
     Close and Reopen the window's terminal.  *Note Break::.

`pow_detach'
     Detach and hang up.  *Note Power Detach::.

`pow_detach_msg [MESSAGE]'
     Set message displayed on `pow_detach'.  *Note Power Detach::.

`prev'
     Switch to the previous unhidden window.  *Note Selecting::.

`printcmd [CMD]'
     Set a command for VT100 printer port emulation.  *Note Printcmd::.

`process [KEY]'
     Treat a register as input to `screen'.  *Note Registers::.

`quit'
     Kill all windows and exit.  *Note Quit::.

`readbuf [-e ENCODING] [FILENAME]'
     Read the paste buffer from the screen-exchange file.  *Note Screen
     Exchange::.

`readreg [-e ENCODING] [REG [FILE]]'
     Load a register from paste buffer or file.  *Note Registers::.

`redisplay'
     Redisplay the current window.  *Note Redisplay::.

`register [-e ENCODING] KEY STRING'
     Store a string to a register.  *Note Registers::.

`remove'
     Kill current region.  *Note Regions::.

`removebuf'
     Delete the screen-exchange file.  *Note Screen Exchange::.

`reset'
     Reset the terminal settings for the window.  *Note Reset::.

`resize [(+/-)lines]'
     Grow or shrink a region

`screen [OPTS] [N] [CMD [ARGS]]'
     Create a new window.  *Note Screen Command::.

`scrollback NUM'
     Set size of scrollback buffer.  *Note Scrollback::.

`select [N]'
     Switch to a specified window.  *Note Selecting::.

`sessionname [NAME]'
     Name this session.  *Note Session Name::.

`setenv [VAR [STRING]]'
     Set an environment variable for new windows.  *Note Setenv::.

`setsid STATE'
     Controll process group creation for windows.  *Note Setsid::.

`shell COMMAND'
     Set the default program for new windows.  *Note Shell::.

`shelltitle TITLE'
     Set the default name for new windows.  *Note Shell::.

`silence [STATE|SECONDS]'
     Monitor a window for inactivity.  *Note Silence::.

`silencewait SECONDS'
     Default timeout to trigger an inactivity notify.  *Note Silence::.

`sleep NUM'
     Pause during startup.  *Note Startup::.

`slowpaste MSEC'
     Slow down pasting in windows.  *Note Paste::.

`source FILE'
     Run commands from a file.  *Note Source::.

`sorendition [ATTR [COLOR]]'
     Change text highlighting.  *Note Sorendition::.

`split'
     Split region into two parts.  *Note Regions::.

`startup_message STATE'
     Display copyright notice on startup.  *Note Startup::.

`stuff STRING'
     Stuff a string in the input buffer of a window.  *Note Paste::.

`su [USERNAME [PASSWORD [PASSWORD2]]]'
     Identify a user. *Note Multiuser Session::.

`suspend'
     Put session in background.  *Note Suspend::.

`term TERM'
     Set `$TERM' for new windows.  *Note Term::.

`termcap TERM TERMINAL-TWEAKS [WINDOW-TWEAKS]'
     Tweak termcap entries for best performance.  *Note Termcap
     Syntax::.

`terminfo TERM TERMINAL-TWEAKS [WINDOW-TWEAKS]'
     Ditto, for terminfo systems.  *Note Termcap Syntax::.

`termcapinfo TERM TERMINAL-TWEAKS [WINDOW-TWEAKS]'
     Ditto, for both systems.  *Note Termcap Syntax::.

`time [STRING]'
     Display time and load average.  *Note Time::.

`title [WINDOWTITLE]'
     Set the name of the current window.  *Note Title Command::.

`umask [USERS]+/-BITS ...'
     Synonym to `aclumask'. *Note Umask::.

`unsetenv VAR'
     Unset environment variable for new windows.  *Note Setenv::.

`utf8 [STATE [DSTATE]]'
     Select character encoding of the current window.  *Note Character
     Processing::.

`vbell [STATE]'
     Use visual bell.  *Note Bell::.

`vbell_msg [MESSAGE]'
     Set vbell message.  *Note Bell::.

`vbellwait SEC'
     Set delay for vbell message.  *Note Bell::.

`version'
     Display `screen' version.  *Note Version::.

`wall MESSAGE'
     Write a message to all displays.  *Note Multiuser Session::.

`width [COLS [LINES]]'
     Set the width of the window.  *Note Window Size::.

`windowlist [-b] | string [STRING] | title [TITLE]'
     Present a list of all windows for selection.  *Note Windowlist::.

`windows'
     List active windows.  *Note Windows::.

`wrap [STATE]'
     Control line-wrap behavior.  *Note Wrap::.

`writebuf [-e ENCODING] [FILENAME]'
     Write paste buffer to screen-exchange file.  *Note Screen
     Exchange::.

`writelock ON|OFF|AUTO'
     Grant exclusive write permission.  *Note Multiuser Session::.

`xoff'
     Send an XOFF character.  *Note XON/XOFF::.

`xon'
     Send an XON character.  *Note XON/XOFF::.

`zmodem [off|auto|catch|pass]'
     Define how screen treats zmodem requests.  *Note Zmodem::.

`zombie [KEYS [onerror] ]'
     Keep dead windows.  *Note Zombie::.


File: tscreen.info,  Node: New Window,  Next: Selecting,  Prev: Commands,  Up: Top

6 New Window
************

This section describes the commands for creating a new window for
running programs.  When a new window is created, the first available
number from the range 0...9 is assigned to it.  The number of windows
is limited at compile-time by the MAXWIN configuration parameter.

* Menu:

* Chdir::                       Change the working directory for new windows.
* Screen Command::              Create a new window.
* Setenv::                      Set environment variables for new windows.
* Shell::                       Parameters for shell windows.
* Term::                        Set the terminal type for new windows.
* Window Types::                Creating different types of windows.


File: tscreen.info,  Node: Chdir,  Next: Screen Command,  Up: New Window

6.1 Chdir
=========

 -- Command: chdir [directory]
     (none)
     Change the current directory of `screen' to the specified directory
     or, if called without an argument, to your home directory (the
     value of the environment variable `$HOME').  All windows that are
     created by means of the `screen' command from within `.screenrc'
     or by means of `C-a : screen ...' or `C-a c' use this as their
     default directory.  Without a `chdir' command, this would be the
     directory from which `screen' was invoked.  Hardcopy and log files
     are always written to the _window's_ default directory, _not_ the
     current directory of the process running in the window.  You can
     use this command multiple times in your `.screenrc' to start
     various windows in different default directories, but the last
     `chdir' value will affect all the windows you create interactively.


File: tscreen.info,  Node: Screen Command,  Next: Setenv,  Prev: Chdir,  Up: New Window

6.2 Screen Command
==================

 -- Command: screen [opts] [n] [cmd [args]]
     (`C-a c', `C-a C-c')
     Establish a new window.  The flow-control options (`-f', `-fn' and
     `-fa'), title option (`-t'), login options (`-l' and `-ln') ,
     terminal type option (`-T TERM'), the all-capability-flag (`-a')
     and scrollback option (`-h NUM') may be specified with each
     command.  The option (`-M') turns monitoring on for this window.
     The option (`-L') turns output logging on for this window.  If an
     optional number N in the range 0...9 is given, the window number N
     is assigned to the newly created window (or, if this number is
     already in-use, the next available number).  If a command is
     specified after `screen', this command (with the given arguments)
     is started in the window; otherwise, a shell is created.

     Screen has built in some functionality of `cu' and `telnet'.
     *Note Window Types::.

   Thus, if your `.screenrc' contains the lines

     # example for .screenrc:
     screen 1
     screen -fn -t foobar 2 -L telnet foobar

`screen' creates a shell window (in window #1) and a window with a
TELNET connection to the machine foobar (with no flow-control using the
title `foobar' in window #2) and will write a logfile `screenlog.2' of
the telnet session.  If you do not include any `screen' commands in
your `.screenrc' file, then `screen' defaults to creating a single
shell window, number zero.  When the initialization is completed,
`screen' switches to the last window specified in your .screenrc file
or, if none, it opens default window #0.


File: tscreen.info,  Node: Setenv,  Next: Shell,  Prev: Screen Command,  Up: New Window

6.3 Setenv
==========

 -- Command: setenv var string
     (none)
     Set the environment variable VAR to value STRING.  If only VAR is
     specified, the user will be prompted to enter a value.  If no
     parameters are specified, the user will be prompted for both
     variable and value. The environment is inherited by all
     subsequently forked shells.

 -- Command: unsetenv var
     (none)
     Unset an environment variable.


File: tscreen.info,  Node: Shell,  Next: Term,  Prev: Setenv,  Up: New Window

6.4 Shell
=========

 -- Command: shell command
 -- Command: defshell command
     (none)
     Set the command to be used to create a new shell.  This overrides
     the value of the environment variable `$SHELL'.  This is useful if
     you'd like to run a tty-enhancer which is expecting to execute the
     program specified in `$SHELL'.  If the command begins with a `-'
     character, the shell will be started as a login-shell.

     `defshell' is currently a synonym to the `shell' command.

 -- Command: shelltitle title
     (none)
     Set the title for all shells created during startup or by the C-a
     C-c command.  *Note Naming Windows::, for details about what
     titles are.


File: tscreen.info,  Node: Term,  Next: Window Types,  Prev: Shell,  Up: New Window

6.5 Term
========

 -- Command: term term
     (none)
     In each window `screen' opens, it sets the `$TERM' variable to
     `screen' by default, unless no description for `screen' is
     installed in the local termcap or terminfo data base.  In that
     case it pretends that the terminal emulator is `vt100'.  This
     won't do much harm, as `screen' is VT100/ANSI compatible.  The use
     of the `term' command is discouraged for non-default purpose.
     That is, one may want to specify special `$TERM' settings (e.g.
     vt100) for the next `screen rlogin othermachine' command. Use the
     command `screen -T vt100 rlogin othermachine' rather than setting
     and resetting the default.


File: tscreen.info,  Node: Window Types,  Prev: Term,  Up: New Window

6.6 Window Types
================

Screen provides three different window types. New windows are created
with `screen''s `screen' command (*note Screen Command::).  The first
parameter to the `screen' command defines which type of window is
created. The different window types are all special cases of the normal
type. They have been added in order to allow `screen' to be used
efficiently as a console with 100 or more windows.
   * The normal window contains a shell (default, if no parameter is
     given) or any other system command that could be executed from a
     shell.  (e.g. `slogin', etc...).

   * If a tty (character special device) name (e.g. `/dev/ttya') is
     specified as the first parameter, then the window is directly
     connected to this device.  This window type is similar to `screen
     cu -l /dev/ttya'.  Read and write access is required on the device
     node, an exclusive open is attempted on the node to mark the
     connection line as busy.  An optional parameter is allowed
     consisting of a comma separated list of flags in the notation used
     by `stty(1)':
    `<baud_rate>'
          Usually 300, 1200, 9600 or 19200. This affects transmission
          as well as receive speed.

    `cs8 or cs7'
          Specify the transmission of eight (or seven) bits per byte.

    `ixon or -ixon'
          Enables (or disables) software flow-control (CTRL-S/CTRL-Q)
          for sending data.

    `ixoff or -ixoff'
          Enables (or disables) software flow-control for receiving
          data.

    `istrip or -istrip'
          Clear (or keep) the eight bit in each received byte.

     You may want to specify as many of these options as applicable.
     Unspecified options cause the terminal driver to make up the
     parameter values of the connection. These values are
     system-dependent and may be in defaults or values saved from a
     previous connection.

     For tty windows, the `info' command shows some of the modem
     control lines in the status line.  These may include `RTS', `CTS',
     `DTR', `CD' and more. This depends rather on on the available
     `ioctl()''s and system header files than on the physical
     capabilities of the serial board.  The name of a logical low
     (inactive) signal is preceded by an exclamation mark (`!'),
     otherwise the signal is logical high (active).  Unsupported but
     shown signals are usually shown low.  When the `CLOCAL' status bit
     is true, the whole set of modem signals is placed inside curly
     braces (`{' and `}').  When the `CRTSCTS' or `TIOCSOFTCAR' bit is
     true, the signals `CTS' or `CD' are shown in parenthesis,
     respectively.

     For tty windows, the command `break' causes the Data transmission
     line (TxD) to go low for a specified period of time. This is
     expected to be interpreted as break signal on the other side.  No
     data is sent and no modem control line is changed when a `break'
     is issued.

   * If the first parameter is `//telnet', the second parameter is
     expected to be a host name, and an optional third parameter may
     specify a TCP port number (default decimal 23). Screen will
     connect to a server listening on the remote host and use the
     telnet protocol to communicate with that server.

     For telnet windows, the command `info' shows details about the
     connection in square brackets (`[' and `]') at the end of the
     status line.
    `b'
          BINARY. The connection is in binary mode.

    `e'
          ECHO. Local echo is disabled.

    `c'
          SGA. The connection is in `character mode' (default: `line
          mode').

    `t'
          TTYPE. The terminal type has been requested by the remote
          host. Screen sends the name `screen' unless instructed
          otherwise (see also the command `term').

    `w'
          NAWS. The remote site is notified about window size changes.

    `f'
          LFLOW. The remote host will send flow control information.
          (Ignored at the moment.)
     Additional flags for debugging are `x', `t' and `n' (XDISPLOC,
     TSPEED and NEWENV).

     For telnet windows, the command `break' sends the telnet code `IAC
     BREAK' (decimal 243) to the remote host.



File: tscreen.info,  Node: Selecting,  Next: Session Management,  Prev: New Window,  Up: Top

7 Selecting a Window
********************

This section describes the commands for switching between windows in an
`screen' session.  The windows are numbered from 0 to 9, and are created
in that order by default (*note New Window::).

* Menu:

* Next and Previous::           Forward or back one window.
* Other Window::                Switch back and forth between two windows.
* Select::                      Switch to a window (and to one after `kill').
* Windowlist::                  Present a list of all windows for selection.


File: tscreen.info,  Node: Next and Previous,  Next: Other Window,  Up: Selecting

7.1 Moving Back and Forth
=========================

 -- Command: next
     (`C-a <SPC>', `C-a n', `C-a C-n')
     Switch to the next window.  This command can be used repeatedly to
     cycle through the list of windows.  (On some terminals, C-<SPC>
     generates a NUL character, so you must release the control key
     before pressing space.)

 -- Command: prev
     (`C-a p', `C-a C-p')
     Switch to the previous window (the opposite of `C-a n').


File: tscreen.info,  Node: Other Window,  Next: Select,  Prev: Next and Previous,  Up: Selecting

7.2 Other Window
================

 -- Command: other
     (`C-a C-a')
     Switch to the last unhidden window displayed.  Note that this
     command defaults to the command character typed twice, unless
     overridden.  For instance, if you use the option `-e]x', this
     command becomes `]]' (*note Command Character::).


File: tscreen.info,  Node: Select,  Next: Windowlist,  Prev: Other Window,  Up: Selecting

7.3 Select
==========

 -- Command: select [n]
     (`C-a N', `C-a '')
     Switch to the window with the number N.  If no window number is
     specified, you get prompted for an identifier. This can be a
     window name (title) or a number.  When a new window is
     established, the lowest available number is assigned to this
     window.  Thus, the first window can be activated by `select 0';
     there can be no more than 10 windows present simultaneously
     (unless screen is compiled with a higher MAXWIN setting).  There
     are two special arguments, `select -' switches to the internal
     blank window and `select .' switches to the current window. The
     latter is useful if used with screen's `-X' option.



File: tscreen.info,  Node: Windowlist,  Prev: Select,  Up: Selecting

7.4 Windowlist
==============

 -- Command: windowlist [-b] [-m]
 -- Command: windowlist string [STRING]
 -- Command: windowlist title [TITLE]
     (`C-a "')
     Display all windows in a table for visual window selection.  The
     desired window can be selected via the standard movement keys
     (*note Movement::) and activated via the return key.  If the `-b'
     option is given, screen will switch to the blank window before
     presenting the list, so that the current window is also selectable.
     The `-m' option changes the order of the windows, instead of
     sorting by window numbers screen uses its internal
     most-recently-used list.

     The table format can be changed with the string and title option,
     the title is displayed as table heading, while the lines are made
     by using the string setting.  The default setting is `Num
     Name%=Flags' for the title and `%3n %t%=%f' for the lines. See the
     string escapes chapter (*note String Escapes::) for more codes
     (e.g. color settings).



File: tscreen.info,  Node: Session Management,  Next: Regions,  Prev: Selecting,  Up: Top

8 Session Management Commands
*****************************

Perhaps the most useful feature of `screen' is the way it allows the
user to move a session between terminals, by detaching and reattaching.
This also makes life easier for modem users who have to deal with
unexpected loss of carrier.

* Menu:

* Detach::                      Disconnect `screen' from your terminal.
* Power Detach::                Detach and log out.
* Lock::                        Lock your terminal temporarily.
* Multiuser Session::		Changing number of allowed users.
* Session Name::                Rename your session for later reattachment.
* Suspend::                     Suspend your session.
* Quit::                        Terminate your session.


File: tscreen.info,  Node: Detach,  Next: Power Detach,  Up: Session Management

8.1 Detach
==========

 -- Command: autodetach state
     (none)
     Sets whether `screen' will automatically detach upon hangup, which
     saves all your running programs until they are resumed with a
     `screen -r' command.  When turned off, a hangup signal will
     terminate `screen' and all the processes it contains. Autodetach is
     on by default.

 -- Command: detach
     (`C-a d', `C-a C-d')
     Detach the `screen' session (disconnect it from the terminal and
     put it into the background).  A detached `screen' can be resumed by
     invoking `screen' with the `-r' option (*note Invoking Screen::).
     The `-h' option tells screen to immediately close the connection
     to the terminal (`hangup').

 -- Command: password [crypted_pw]
     (none)
     Present a crypted password in your `.screenrc' file and screen will
     ask for it, whenever someone attempts to resume a detached
     session. This is useful, if you have privileged programs running
     under `screen' and you want to protect your session from reattach
     attempts by users that managed to assume your uid. (I.e. any
     superuser.)  If no crypted password is specified, screen prompts
     twice a password and places its encryption in the paste buffer.
     Default is `none', which disables password checking.


File: tscreen.info,  Node: Power Detach,  Next: Lock,  Prev: Detach,  Up: Session Management

8.2 Power Detach
================

 -- Command: pow_detach
     (`C-a D D')
     Mainly the same as `detach', but also sends a HANGUP signal to the
     parent process of `screen'.
     _Caution_: This will result in a logout if `screen' was started
     from your login shell.

 -- Command: pow_detach_msg [message]
     (none)
     The MESSAGE specified here is output whenever a power detach is
     performed. It may be used as a replacement for a logout message or
     to reset baud rate, etc.  Without parameter, the current message
     is shown.


File: tscreen.info,  Node: Lock,  Next: Multiuser Session,  Prev: Power Detach,  Up: Session Management

8.3 Lock
========

 -- Command: lockscreen
     (`C-a x', `C-a C-x')
     Call a screenlock program (`/local/bin/lck' or `/usr/bin/lock' or
     a builtin, if no other is available). Screen does not accept any
     command keys until this program terminates. Meanwhile processes in
     the windows may continue, as the windows are in the detached state.
     The screenlock program may be changed through the environment
     variable `$LOCKPRG' (which must be set in the shell from which
     `screen' is started) and is executed with the user's uid and gid.

     Warning: When you leave other shells unlocked and have no password
     set on `screen', the lock is void: One could easily re-attach from
     an unlocked shell. This feature should rather be called
     `lockterminal'.


File: tscreen.info,  Node: Multiuser Session,  Next: Session Name,  Prev: Lock,  Up: Session Management

8.4 Multiuser Session
=====================

These commands allow other users to gain access to one single `screen'
session. When attaching to a multiuser `screen' the sessionname is
specified as `username/sessionname' to the `-S' command line option.
`Screen' must be compiled with multiuser support to enable features
described here.

* Menu:

* Multiuser::			Enable / Disable multiuser mode.
* Acladd::			Enable a specific user.
* Aclchg::                      Change a users permissions.
* Acldel::			Disable a specific user.
* Aclgrp::			Grant a user permissions to other users.
* Displays::			List all active users at their displays.
* Umask::			Predefine access to new windows.
* Wall::                        Write a message to all users.
* Writelock::                   Grant exclusive window access.
* Su::                          Substitute user.


File: tscreen.info,  Node: Multiuser,  Next: Acladd,  Up: Multiuser Session

8.4.1 Multiuser
---------------

 -- Command: multiuser STATE
     (none)
     Switch between single-user and multi-user mode. Standard screen
     operation is single-user. In multi-user mode the commands
     `acladd', `aclchg' and `acldel' can be used to enable (and
     disable) other users accessing this `screen'.


File: tscreen.info,  Node: Acladd,  Next: Aclchg,  Prev: Multiuser,  Up: Multiuser Session

8.4.2 Acladd
------------

 -- Command: acladd USERNAMES
 -- Command: addacl USERNAMES
     (none)
     Enable users to fully access this screen session. USERNAMES can be
     one user or a comma separated list of users. This command enables
     to attach to the `screen' session and performs the equivalent of
     `aclchg USERNAMES +rwx "#?"'. To add a user with restricted access,
     use the `aclchg' command below.  `Addacl' is a synonym to `acladd'.
     Multi-user mode only.


File: tscreen.info,  Node: Aclchg,  Next: Acldel,  Prev: Acladd,  Up: Multiuser Session

8.4.3 Aclchg
------------

 -- Command: aclchg USERNAMES PERMBITS LIST
 -- Command: chacl USERNAMES PERMBITS LIST
     (none)
     Change permissions for a comma separated list of users.
     Permission bits are represented as `r', `w' and `x'.  Prefixing
     `+' grants the permission, `-' removes it. The third parameter is
     a comma separated list of commands or windows (specified either by
     number or title). The special list `#' refers to all windows, `?'
     to all commands. If USERNAMES consists of a single `*', all known
     users are affected.  A command can be executed when the user has
     the `x' bit for it. The user can type input to a window when he
     has its `w' bit set and no other user obtains a writelock for this
     window. Other bits are currently ignored.  To withdraw the
     writelock from another user in e.g. window 2: `aclchg USERNAME
     -w+w 2'. To allow read-only access to the session: `aclchg
     USERNAME -w "#"'. As soon as a user's name is known to screen, he
     can attach to the session and (per default) has full permissions
     for all command and windows. Execution permission for the acl
     commands, `at' and others should also be removed or the user may
     be able to regain write permission.  `Chacl' is a synonym to
     `aclchg'.  Multi-user mode only.


File: tscreen.info,  Node: Acldel,  Next: Aclgrp,  Prev: Aclchg,  Up: Multiuser Session

8.4.4 Acldel
------------

 -- Command: acldel USERNAME
     (none)
     Remove a user from screen's access control list. If currently
     attached, all the user's displays are detached from the session.
     He cannot attach again.  Multi-user mode only.


File: tscreen.info,  Node: Aclgrp,  Next: Displays,  Prev: Acldel,  Up: Multiuser Session

8.4.5 Aclgrp
------------

 -- Command: aclgrp USERNAME [GROUPNAME]
     (none)
     Creates groups of users that share common access rights. The name
     of the group is the username of the group leader. Each member of
     the  group  inherits  the  permissions  that  are granted  to the
     group leader. That means, if a user fails an access check, another
     check is made for the group leader.  A user is removed from all
     groups the special value `none' is used for GROUPNAME. If the
     second parameter is omitted all groups the user is in are listed.


File: tscreen.info,  Node: Displays,  Next: Umask,  Prev: Aclgrp,  Up: Multiuser Session

8.4.6 Displays
--------------

 -- Command: displays
     (`C-a *')
     Shows a tabular listing  of  all  currently  connected  user
     front-ends  (displays).   This  is most useful for multiuser
     sessions.


File: tscreen.info,  Node: Umask,  Next: Wall,  Prev: Displays,  Up: Multiuser Session

8.4.7 aclumask
--------------

 -- Command: aclumask [USERS]+/-BITS ...
 -- Command: umask [USERS]+/-BITS ...
     (none)
     This specifies the access other users have to  windows  that will
     be  created  by  the caller of the command. USERS may be no, one
     or a comma separated list of known usernames.  If  no  users  are
     specified,  a  list of all currently known users is assumed.  BITS
     is any  combination  of  access  control  bits  allowed defined
     with the `aclchg' command. The special username `?' predefines the
     access that  not  yet  known  users  will  be granted  to any
     window initially.  The special username `??' predefines the access
     that not yet known users  are  granted to any command. Rights of
     the special username nobody cannot be changed (see the `su'
     command).  `Umask' is a synonym to `aclumask'.


File: tscreen.info,  Node: Wall,  Next: Writelock,  Prev: Umask,  Up: Multiuser Session

8.4.8 Wall
----------

 -- Command: wall MESSAGE
     (none)
     Write a message to all displays. The message will appear in the
     terminal's status line.


File: tscreen.info,  Node: Writelock,  Next: Su,  Prev: Wall,  Up: Multiuser Session

8.4.9 Writelock
---------------

 -- Command: writelock ON|OFF|AUTO
     (none)
     In addition to access control lists, not all users may be able to
     write to the same window at once. Per default, writelock is in
     `auto' mode and grants exclusive input permission to the user who
     is the first to switch to the particular window. When he leaves
     the window, other users may obtain the writelock (automatically).
     The writelock of the current window is disabled by the command
     `writelock off'. If the user issues the command `writelock on' he
     keeps the exclusive write permission while switching to other
     windows.

 -- Command: defwritelock ON|OFF|AUTO
     (none)
     Sets the default writelock behavior for new windows. Initially all
     windows will be created with no writelocks.


File: tscreen.info,  Node: Su,  Prev: Writelock,  Up: Multiuser Session

8.4.10 Su
---------

 -- Command: su [USERNAME [PASSWORD [PASSWORD2]]]
     (none)
     Substitute the user of a display. The  command  prompts  for all
     parameters that are omitted. If passwords are specified as
     parameters, they have  to  be  specified  un-crypted.  The first
     password  is matched against the systems passwd database, the
     second password  is  matched  against  the `screen' password  as
     set  with the commands `acladd' or `password'.  `Su' may be useful
     for the `screen' administrator to test multiuser  setups.  When
     the  identification  fails,  the  user has access to the commands
     available for user `nobody'. These are `detach', `license',
     `version', `help' and `displays'.


File: tscreen.info,  Node: Session Name,  Next: Suspend,  Prev: Multiuser Session,  Up: Session Management

8.5 Session Name
================

 -- Command: sessionname [NAME]
     (none)
     Rename the current session. Note that for `screen -list' the name
     shows up with the process-id prepended. If the argument NAME is
     omitted, the name of this session is displayed.
     _Caution_: The `$STY' environment variable still reflects the old
     name. This may result in confusion.  The default is constructed
     from the tty and host names.


File: tscreen.info,  Node: Suspend,  Next: Quit,  Prev: Session Name,  Up: Session Management

8.6 Suspend
===========

 -- Command: suspend
     (`C-a z', `C-a C-z')
     Suspend `screen'.  The windows are in the detached state while
     `screen' is suspended.  This feature relies on the parent shell
     being able to do job control.


File: tscreen.info,  Node: Quit,  Prev: Suspend,  Up: Session Management

8.7 Quit
========

 -- Command: quit
     (`C-a C-\')
     Kill all windows and terminate `screen'.  Note that on VT100-style
     terminals the keys `C-4' and `C-\' are identical.  So be careful
     not to type `C-a C-4' when selecting window no. 4.  Use the empty
     bind command (as in `bind "^\"') to remove a key binding (*note
     Key Binding::).


File: tscreen.info,  Node: Regions,  Next: Window Settings,  Prev: Session Management,  Up: Top

9 Regions
*********

Screen has the ability to display more than one window on the user's
display. This is done by splitting the screen in regions, which can
contain different windows.

* Menu:

* Split::			Split a region into two
* Focus::			Change to the next region
* Only::			Delete all other regions
* Remove::			Delete the current region
* Resize::			Grow or shrink a region
* Caption::			Control the window's caption
* Fit::				Resize a window to fit the region


File: tscreen.info,  Node: Split,  Next: Focus,  Up: Regions

9.1 Split
=========

 -- Command: split
     (`C-a S')
     Split the current region into two new ones. All regions on the
     display are resized to make room for the new region. The blank
     window is displayed on the new region.


File: tscreen.info,  Node: Focus,  Next: Only,  Prev: Split,  Up: Regions

9.2 Focus
=========

 -- Command: focus
     (`C-a <Tab>')
     Move the input focus to the next region. This is done in a cyclic
     way so that the top region is selected after the bottom one. If no
     subcommand is given it defaults to `down'. `up' cycles in the
     opposite order, `top' and `bottom' go to the top and bottom region
     respectively. Useful bindings are (j and k as in vi)
          bind j focus down
          bind k focus up
          bind t focus top
          bind b focus bottom


File: tscreen.info,  Node: Only,  Next: Remove,  Prev: Focus,  Up: Regions

9.3 Only
========

 -- Command: only
     (`C-a Q')
     Kill all regions but the current one.


File: tscreen.info,  Node: Remove,  Next: Resize,  Prev: Only,  Up: Regions

9.4 Remove
==========

 -- Command: remove
     (`C-a X')
     Kill the current region. This is a no-op if there is only one
     region.


File: tscreen.info,  Node: Resize,  Next: Caption,  Prev: Remove,  Up: Regions

9.5 Resize
==========

 -- Command: resize [(+/-)LINES]
     (none)
     Resize the current region. The space will be removed from or added
     to the region below or if there's not enough space from the region
     above.
          resize +N       increase current region height by N
          resize -N       decrease current region height by N
          resize  N       set current region height to N
          resize  =       make all windows equally high
          resize  max     maximize current region height
          resize  min     minimize current region height


File: tscreen.info,  Node: Caption,  Next: Fit,  Prev: Resize,  Up: Regions

9.6 Caption
===========

 -- Command: caption `always'|`splitonly' [string]
 -- Command: caption `string' [string]
     (none)
     This command controls the display of the window captions. Normally
     a caption is only used if more than one window is shown on the
     display (split screen mode). But if the type is set to `always',
     `screen' shows a caption even if only one window is displayed. The
     default is `splitonly'.

     The second form changes the text used for the caption. You can use
     all string escapes (*note String Escapes::). `Screen' uses a
     default of `%3n %t'.

     You can mix both forms by providing the string as an additional
     argument.


File: tscreen.info,  Node: Fit,  Prev: Caption,  Up: Regions

9.7 Fit
=======

 -- Command: fit
     (`C-a F')
     Change the window size to the size of the current region. This
     command is needed because screen doesn't adapt the window size
     automatically if the window is displayed more than once.


File: tscreen.info,  Node: Window Settings,  Next: Virtual Terminal,  Prev: Regions,  Up: Top

10 Window Settings
******************

These commands control the way `screen' treats individual windows in a
session.  *Note Virtual Terminal::, for commands to control the
terminal emulation itself.

* Menu:

* Naming Windows::		Control the name of the window
* Console::			See the host's console messages
* Kill::                        Destroy an unwanted window
* Login::                       Control `/etc/utmp' logging
* Mode::                        Control the file mode of the pty
* Monitor::                     Watch for activity in a window
* Windows::			List the active windows
* Hardstatus::			Set a window's hardstatus line


File: tscreen.info,  Node: Naming Windows,  Next: Console,  Up: Window Settings

10.1 Naming Windows (Titles)
============================

You can customize each window's name in the window display (viewed with
the `windows' command (*note Windows::) by setting it with one of the
title commands.  Normally the name displayed is the actual command name
of the program created in the window.  However, it is sometimes useful
to distinguish various programs of the same name or to change the name
on-the-fly to reflect the current state of the window.

   The default name for all shell windows can be set with the
`shelltitle' command (*note Shell::).  You can specify the name you
want for a window with the `-t' option to the `screen' command when the
window is created (*note Screen Command::).  To change the name after
the window has been created you can use the title-string escape-sequence
(`<ESC> k NAME <ESC> \') and the `title' command (C-a A).  The former
can be output from an application to control the window's name under
software control, and the latter will prompt for a name when typed.
You can also bind predefined names to keys with the `title' command to
set things quickly without prompting.

* Menu:

* Title Command::                 The `title' command.
* Dynamic Titles::                Make shell windows change titles dynamically.
* Title Prompts::                 Set up your shell prompt for dynamic Titles.
* Title Screenrc::                Set up Titles in your `.screenrc'.


File: tscreen.info,  Node: Title Command,  Next: Dynamic Titles,  Up: Naming Windows

10.1.1 Title Command
--------------------

 -- Command: title [windowtitle]
     (`C-a A')
     Set the name of the current window to WINDOWTITLE. If no name is
     specified, screen prompts for one.


File: tscreen.info,  Node: Dynamic Titles,  Next: Title Prompts,  Prev: Title Command,  Up: Naming Windows

10.1.2 Dynamic Titles
---------------------

`screen' has a shell-specific heuristic that is enabled by setting the
window's name to SEARCH|NAME and arranging to have a null title
escape-sequence output as a part of your prompt.  The SEARCH portion
specifies an end-of-prompt search string, while the NAME portion
specifies the default shell name for the window.  If the NAME ends in a
`:' `screen' will add what it believes to be the current command
running in the window to the end of the specified name (e.g. NAME:CMD).
Otherwise the current command name supersedes the shell name while it
is running.

   Here's how it works: you must modify your shell prompt to output a
null title-escape-sequence (<ESC> k <ESC> \) as a part of your prompt.
The last part of your prompt must be the same as the string you
specified for the SEARCH portion of the title.  Once this is set up,
`screen' will use the title-escape-sequence to clear the previous
command name and get ready for the next command.  Then, when a newline
is received from the shell, a search is made for the end of the prompt.
If found, it will grab the first word after the matched string and use
it as the command name.  If the command name begins with `!', `%', or
`^', `screen' will use the first word on the following line (if found)
in preference to the just-found name.  This helps csh users get more
accurate titles when using job control or history recall commands.


File: tscreen.info,  Node: Title Prompts,  Next: Title Screenrc,  Prev: Dynamic Titles,  Up: Naming Windows

10.1.3 Setting up your prompt for shell titles
----------------------------------------------

One thing to keep in mind when adding a null title-escape-sequence to
your prompt is that some shells (like the csh) count all the non-control
characters as part of the prompt's length.  If these invisible
characters aren't a multiple of 8 then backspacing over a tab will
result in an incorrect display.  One way to get around this is to use a
prompt like this:

     set prompt='^[[0000m^[k^[\% '

   The escape-sequence `^[[0000m' not only normalizes the character
attributes, but all the zeros round the length of the invisible
characters up to 8.

   Tcsh handles escape codes in the prompt more intelligently, so you
can specify your prompt like this:

     set prompt="%{\ek\e\\%}\% "

   Bash users will probably want to echo the escape sequence in the
PROMPT_COMMAND:

     PROMPT_COMMAND='echo -n -e "\033k\033\134"'

   (I used `\134' to output a `\' because of a bug in v1.04).


File: tscreen.info,  Node: Title Screenrc,  Prev: Title Prompts,  Up: Naming Windows

10.1.4 Setting up shell titles in your `.screenrc'
--------------------------------------------------

Here are some .screenrc examples:

     screen -t top 2 nice top

   Adding this line to your .screenrc would start a niced version of the
`top' command in window 2 named `top' rather than `nice'.

     shelltitle '> |csh'
     screen 1

   This file would start a shell using the given shelltitle.  The title
specified is an auto-title that would expect the prompt and the typed
command to look something like the following:

     /usr/joe/src/dir> trn

   (it looks after the '> ' for the command name).  The window status
would show the name `trn' while the command was running, and revert to
`csh' upon completion.

     bind R screen -t '% |root:' su

   Having this command in your .screenrc would bind the key sequence
`C-a R' to the `su' command and give it an auto-title name of `root:'.
For this auto-title to work, the screen could look something like this:

     % !em
     emacs file.c

   Here the user typed the csh history command `!em' which ran the
previously entered `emacs' command.  The window status would show
`root:emacs' during the execution of the command, and revert to simply
`root:' at its completion.

     bind o title
     bind E title ""
     bind u title (unknown)

   The first binding doesn't have any arguments, so it would prompt you
for a title when you type `C-a o'.  The second binding would clear an
auto-titles current setting (C-a E).  The third binding would set the
current window's title to `(unknown)' (C-a u).


File: tscreen.info,  Node: Console,  Next: Kill,  Prev: Naming Windows,  Up: Window Settings

10.2 Console
============

 -- Command: console [STATE]
     (none)
     Grabs or un-grabs the machines console output to a window. When
     the argument is omitted the current state is displayed.  _Note_:
     Only the owner of `/dev/console' can grab the console output. This
     command is only available if the host supports the ioctl
     `TIOCCONS'.


File: tscreen.info,  Node: Kill,  Next: Login,  Prev: Console,  Up: Window Settings

10.3 Kill
=========

 -- Command: kill
     (`C-a k', `C-a C-k')
     Kill the current window.
     If there is an `exec' command running (*note Exec::) then it is
     killed.  Otherwise the process (e.g. shell) running in the window
     receives a `HANGUP' condition, the window structure is removed and
     screen (your display) switches to another window. When the last
     window is destroyed, `screen' exits.  After a kill screen switches
     to the previously displayed window.
     _Caution_: `emacs' users may find themselves killing their `emacs'
     session when trying to delete the current line.  For this reason,
     it is probably wise to use a different command character (*note
     Command Character::) or rebind `kill' to another key sequence,
     such as `C-a K' (*note Key Binding::).


File: tscreen.info,  Node: Login,  Next: Mode,  Prev: Kill,  Up: Window Settings

10.4 Login
==========

 -- Command: deflogin state
     (none)
     Same as the `login' command except that the default setting for new
     windows is changed.  This defaults to `on' unless otherwise
     specified at compile time (*note Installation::). Both commands
     are only present when `screen' has been compiled with utmp support.

 -- Command: login [state]
     (`C-a L')
     Adds or removes the entry in `/etc/utmp' for the current window.
     This controls whether or not the window is "logged in".  In
     addition to this toggle, it is convenient to have "log in" and
     "log out" keys.  For instance, `bind I login on' and `bind O login
     off' will map these keys to be `C-a I' and `C-a O' (*note Key
     Binding::).


File: tscreen.info,  Node: Mode,  Next: Monitor,  Prev: Login,  Up: Window Settings

10.5 Mode
=========

 -- Command: defmode mode
     (none)
     The mode of each newly allocated pseudo-tty is set to MODE.  MODE
     is an octal number as used by chmod(1).  Defaults to 0622 for
     windows which are logged in, 0600 for others (e.g. when `-ln' was
     specified for creation, *note Screen Command::).


File: tscreen.info,  Node: Monitor,  Next: Windows,  Prev: Mode,  Up: Window Settings

10.6 Monitoring
===============

 -- Command: activity message
     (none)
     When any activity occurs in a background window that is being
     monitored, `screen' displays a notification in the message line.
     The notification message can be redefined by means of the
     `activity' command.  Each occurrence of `%' in MESSAGE is replaced
     by the number of the window in which activity has occurred, and
     each occurrence of `^G' is replaced by the definition for bell in
     your termcap (usually an audible bell).  The default message is

          'Activity in window %n'

     Note that monitoring is off for all windows by default, but can be
     altered by use of the `monitor' command (`C-a M').

 -- Command: defmonitor state
     (none)
     Same as the `monitor' command except that the default setting for
     new windows is changed.  Initial setting is `off'.

 -- Command: monitor [state]
     (`C-a M')
     Toggles monitoring of the current window.  When monitoring is
     turned on and the affected window is switched into the background,
     the activity notification message will be displayed in the status
     line at the first sign of output, and the window will also be
     marked with an `@' in the window-status display (*note Windows::).
     Monitoring defaults to `off' for all windows.


File: tscreen.info,  Node: Windows,  Next: Hardstatus,  Prev: Monitor,  Up: Window Settings

10.7 Windows
============

 -- Command: windows
     (`C-a w', `C-a C-w')
     Uses the message line to display a list of all the windows.  Each
     window is listed by number with the name of the program running in
     the window (or its title).

     The current window is marked with a `*'; the previous window is
     marked with a `-'; all the windows that are logged in are marked
     with a `$' (*note Login::); a background window that has received
     a bell is marked with a `!'; a background window that is being
     monitored and has had activity occur is marked with an `@' (*note
     Monitor::); a window which has output logging turned on is marked
     with `(L)'; windows occupied by other users are marked with `&' or
     `&&' if the window is shared by other users; hidden windows are
     marked with `^'; windows in the zombie state are marked with `Z'.

     If this list is too long to fit on the terminal's status line only
     the portion around the current window is displayed.


File: tscreen.info,  Node: Hardstatus,  Prev: Windows,  Up: Window Settings

10.8 Hardstatus
===============

`Screen' maintains a hardstatus line for every window. If a window gets
selected, the display's hardstatus will be updated to match the
window's hardstatus line.  The hardstatus line can be changed with the
ANSI Application Program Command (APC): `ESC_<string>ESC\'. As a
convenience for xterm users the sequence `ESC]0..2;<string>^G' is also
accepted.

 -- Command: defhstatus [status]
     (none)
     The hardstatus line that all new windows will get is set to STATUS.
     This command is useful to make the hardstatus of every window
     display the window number or title or the like.  STATUS may
     contain the same directives as in the window messages, but the
     directive escape character is `^E' (octal 005) instead of `%'.
     This was done to make a misinterpretation of program generated
     hardstatus lines impossible.  If the parameter STATUS is omitted,
     the current default string is displayed.  Per default the
     hardstatus line of new windows is empty.

 -- Command: hstatus status
     (none)
     Changes the current window's hardstatus line to STATUS.


File: tscreen.info,  Node: Virtual Terminal,  Next: Copy and Paste,  Prev: Window Settings,  Up: Top

11 Virtual Terminal
*******************

Each window in a `screen' session emulates a VT100 terminal, with some
extra functions added. The VT100 emulator is hard-coded, no other
terminal types can be emulated.  The commands described here modify the
terminal emulation.

* Menu:

* Control Sequences::           Details of the internal VT100 emulation.
* Input Translation::           How keystrokes are remapped.
* Digraph::			Entering digraph sequences.
* Bell::                        Getting your attention.
* Clear::                       Clear the window display.
* Info::                        Terminal emulation statistics.
* Redisplay::                   When the display gets confusing.
* Wrap::                        Automatic margins.
* Reset::                       Recovering from ill-behaved applications.
* Window Size::                 Changing the size of your terminal.
* Character Processing::	Change the effect of special characters.


File: tscreen.info,  Node: Control Sequences,  Next: Input Translation,  Up: Virtual Terminal

11.1 Control Sequences
======================

The following is a list of control sequences recognized by `screen'.
`(V)' and `(A)' indicate VT100-specific and ANSI- or ISO-specific
functions, respectively.

     ESC E                           Next Line
     ESC D                           Index
     ESC M                           Reverse Index
     ESC H                           Horizontal Tab Set
     ESC Z                           Send VT100 Identification String
     ESC 7                   (V)     Save Cursor and Attributes
     ESC 8                   (V)     Restore Cursor and Attributes
     ESC [s                  (A)     Save Cursor and Attributes
     ESC [u                  (A)     Restore Cursor and Attributes
     ESC c                           Reset to Initial State
     ESC g                           Visual Bell
     ESC Pn p                        Cursor Visibility (97801)
         Pn = 6                      Invisible
              7                      Visible
     ESC =                   (V)     Application Keypad Mode
     ESC >                   (V)     Numeric Keypad Mode
     ESC # 8                 (V)     Fill Screen with E's
     ESC \                   (A)     String Terminator
     ESC ^                   (A)     Privacy Message String (Message Line)
     ESC !                           Global Message String (Message Line)
     ESC k                           Title Definition String
     ESC P                   (A)     Device Control String
                                     Outputs a string directly to the host
                                     terminal without interpretation.
     ESC _                   (A)     Application Program Command (Hardstatus)
     ESC ] 0 ; string ^G     (A)     Operating System Command (Hardstatus, xterm
                                     title hack)
     ESC ] 83 ; cmd ^G       (A)     Execute screen command. This only works if
                                     multi-user support is compiled into screen.
                                     The pseudo-user ":window:" is used to check
                                     the access control list. Use "addacl :window:
                                     -rwx #?" to create a user with no rights and
                                     allow only the needed commands.
     Control-N               (A)     Lock Shift G1 (SO)
     Control-O               (A)     Lock Shift G0 (SI)
     ESC n                   (A)     Lock Shift G2
     ESC o                   (A)     Lock Shift G3
     ESC N                   (A)     Single Shift G2
     ESC O                   (A)     Single Shift G3
     ESC ( Pcs               (A)     Designate character set as G0
     ESC ) Pcs               (A)     Designate character set as G1
     ESC * Pcs               (A)     Designate character set as G2
     ESC + Pcs               (A)     Designate character set as G3
     ESC [ Pn ; Pn H                 Direct Cursor Addressing
     ESC [ Pn ; Pn f                 same as above
     ESC [ Pn J                      Erase in Display
           Pn = None or 0            From Cursor to End of Screen
                1                    From Beginning of Screen to Cursor
                2                    Entire Screen
     ESC [ Pn K                      Erase in Line
           Pn = None or 0            From Cursor to End of Line
                1                    From Beginning of Line to Cursor
                2                    Entire Line
     ESC [ Pn X                      Erase character
     ESC [ Pn A                      Cursor Up
     ESC [ Pn B                      Cursor Down
     ESC [ Pn C                      Cursor Right
     ESC [ Pn D                      Cursor Left
     ESC [ Pn E                      Cursor next line
     ESC [ Pn F                      Cursor previous line
     ESC [ Pn G                      Cursor horizontal position
     ESC [ Pn `                      same as above
     ESC [ Pn d                      Cursor vertical position
     ESC [ Ps ;...; Ps m             Select Graphic Rendition
           Ps = None or 0            Default Rendition
                1                    Bold
                2            (A)     Faint
                3            (A)     Standout Mode (ANSI: Italicized)
                4                    Underlined
                5                    Blinking
                7                    Negative Image
                22           (A)     Normal Intensity
                23           (A)     Standout Mode off (ANSI: Italicized off)
                24           (A)     Not Underlined
                25           (A)     Not Blinking
                27           (A)     Positive Image
                30           (A)     Foreground Black
                31           (A)     Foreground Red
                32           (A)     Foreground Green
                33           (A)     Foreground Yellow
                34           (A)     Foreground Blue
                35           (A)     Foreground Magenta
                36           (A)     Foreground Cyan
                37           (A)     Foreground White
                39           (A)     Foreground Default
                40           (A)     Background Black
                ...                  ...
                49           (A)     Background Default
     ESC [ Pn g                      Tab Clear
           Pn = None or 0            Clear Tab at Current Position
                3                    Clear All Tabs
     ESC [ Pn ; Pn r         (V)     Set Scrolling Region
     ESC [ Pn I              (A)     Horizontal Tab
     ESC [ Pn Z              (A)     Backward Tab
     ESC [ Pn L              (A)     Insert Line
     ESC [ Pn M              (A)     Delete Line
     ESC [ Pn @              (A)     Insert Character
     ESC [ Pn P              (A)     Delete Character
     ESC [ Pn S                      Scroll Scrolling Region Up
     ESC [ Pn T                      Scroll Scrolling Region Down
     ESC [ Pn ^                      same as above
     ESC [ Ps ;...; Ps h             Set Mode
     ESC [ Ps ;...; Ps l             Reset Mode
           Ps = 4            (A)     Insert Mode
                20           (A)     `Automatic Linefeed' Mode.
                34                   Normal Cursor Visibility
                ?1           (V)     Application Cursor Keys
                ?3           (V)     Change Terminal Width to 132 columns
                ?5           (V)     Reverse Video
                ?6           (V)     `Origin' Mode
                ?7           (V)     `Wrap' Mode
                ?9                   X10 mouse tracking
                ?25          (V)     Visible Cursor
                ?47                  Alternate Screen (old xterm code)
                ?1000        (V)     VT200 mouse tracking
                ?1047                Alternate Screen (new xterm code)
                ?1049                Alternate Screen (new xterm code)
     ESC [ 5 i               (A)     Start relay to printer (ANSI Media Copy)
     ESC [ 4 i               (A)     Stop relay to printer (ANSI Media Copy)
     ESC [ 8 ; Ph ; Pw t             Resize the window to `Ph' lines and
                                     `Pw' columns (SunView special)
     ESC [ c                         Send VT100 Identification String
     ESC [ x                 (V)     Send Terminal Parameter Report
     ESC [ > c                       Send Secondary Device Attributes String
     ESC [ 6 n                       Send Cursor Position Report


File: tscreen.info,  Node: Input Translation,  Next: Digraph,  Prev: Control Sequences,  Up: Virtual Terminal

11.2 Input Translation
======================

In order to do a full VT100 emulation `screen' has to detect that a
sequence of characters in the input stream was generated by a keypress
on the user's keyboard and insert the VT100 style escape sequence.
`Screen' has a very flexible way of doing this by making it possible to
map arbitrary commands on arbitrary sequences of characters. For
standard VT100 emulation the command will always insert a string in the
input buffer of the window (see also command `stuff', *note Paste::).
Because the sequences generated by a keypress can change after a
reattach from a different terminal type, it is possible to bind
commands to the termcap name of the keys.  `Screen' will insert the
correct binding after each reattach. See *note Bindkey:: for further
details on the syntax and examples.

   Here is the table of the default key bindings. (A) means that the
command is executed if the keyboard is switched into application mode.

     Key name        Termcap name    Command
     -----------------------------------------------------
     Cursor up            ku         stuff \033[A
                                     stuff \033OA      (A)
     Cursor down          kd         stuff \033[B
                                     stuff \033OB      (A)
     Cursor right         kr         stuff \033[C
                                     stuff \033OC      (A)
     Cursor left          kl         stuff \033[D
                                     stuff \033OD      (A)
     Function key 0       k0         stuff \033[10~
     Function key 1       k1         stuff \033OP
     Function key 2       k2         stuff \033OQ
     Function key 3       k3         stuff \033OR
     Function key 4       k4         stuff \033OS
     Function key 5       k5         stuff \033[15~
     Function key 6       k6         stuff \033[17~
     Function key 7       k7         stuff \033[18~
     Function key 8       k8         stuff \033[19~
     Function key 9       k9         stuff \033[20~
     Function key 10      k;         stuff \033[21~
     Function key 11      F1         stuff \033[23~
     Function key 12      F2         stuff \033[24~
     Home                 kh         stuff \033[1~
     End                  kH         stuff \033[4~
     Insert               kI         stuff \033[2~
     Delete               kD         stuff \033[3~
     Page up              kP         stuff \033[5~
     Page down            kN         stuff \033[6~
     Keypad 0             f0         stuff 0
                                     stuff \033Op      (A)
     Keypad 1             f1         stuff 1
                                     stuff \033Oq      (A)
     Keypad 2             f2         stuff 2
                                     stuff \033Or      (A)
     Keypad 3             f3         stuff 3
                                     stuff \033Os      (A)
     Keypad 4             f4         stuff 4
                                     stuff \033Ot      (A)
     Keypad 5             f5         stuff 5
                                     stuff \033Ou      (A)
     Keypad 6             f6         stuff 6
                                     stuff \033Ov      (A)
     Keypad 7             f7         stuff 7
                                     stuff \033Ow      (A)
     Keypad 8             f8         stuff 8
                                     stuff \033Ox      (A)
     Keypad 9             f9         stuff 9
                                     stuff \033Oy      (A)
     Keypad +             f+         stuff +
                                     stuff \033Ok      (A)
     Keypad -             f-         stuff -
                                     stuff \033Om      (A)
     Keypad *             f*         stuff *
                                     stuff \033Oj      (A)
     Keypad /             f/         stuff /
                                     stuff \033Oo      (A)
     Keypad =             fq         stuff =
                                     stuff \033OX      (A)
     Keypad .             f.         stuff .
                                     stuff \033On      (A)
     Keypad ,             f,         stuff ,
                                     stuff \033Ol      (A)
     Keypad enter         fe         stuff \015
                                     stuff \033OM      (A)


File: tscreen.info,  Node: Digraph,  Next: Bell,  Prev: Input Translation,  Up: Virtual Terminal

11.3 Digraph
============

 -- Command: digraph [preset]
     (none)
     This command prompts the user for a digraph sequence. The next two
     characters typed are looked up in a builtin table and the
     resulting character is inserted in the input stream. For example,
     if the user enters `a"', an a-umlaut will be inserted. If the
     first character entered is a 0 (zero), `screen' will treat the
     following characters (up to three) as an octal number instead.
     The optional argument PRESET is treated as user input, thus one
     can create an "umlaut" key.  For example the command `bindkey ^K
     digraph '"'' enables the user to generate an a-umlaut by typing
     `CTRL-K a'.


File: tscreen.info,  Node: Bell,  Next: Clear,  Prev: Digraph,  Up: Virtual Terminal

11.4 Bell
=========

 -- Command: bell_msg [message]
     (none)
     When a bell character is sent to a background window, `screen'
     displays a notification in the message line.  The notification
     message can be re-defined by this command.  Each occurrence of `%'
     in MESSAGE is replaced by the number of the window to which a bell
     has been sent, and each occurrence of `^G' is replaced by the
     definition for bell in your termcap (usually an audible bell).
     The default message is

          'Bell in window %n'

     An empty message can be supplied to the `bell_msg' command to
     suppress output of a message line (`bell_msg ""').  Without
     parameter, the current message is shown.

 -- Command: vbell [state]
     (`C-a C-g')
     Sets or toggles the visual bell setting for the current window. If
     `vbell' is switched to `on', but your terminal does not support a
     visual bell, the visual bell message is displayed in the status
     line when the bell character is received.  Visual bell support of
     a terminal is defined by the termcap variable `vb'. *Note Visual
     Bell: (termcap)Bell, for more information on visual bells.  The
     equivalent terminfo capability is `flash'.

     Per  default, `vbell' is `off', thus the audible bell is used.

 -- Command: vbell_msg [message]
     (none)
     Sets the visual bell message. MESSAGE is printed to the status
     line if the window receives a bell character (^G), `vbell' is set
     to `on' and the terminal does not support a visual bell.  The
     default message is `Wuff, Wuff!!'.  Without parameter, the current
     message is shown.

 -- Command: vbellwait sec
     (none)
     Define a delay in seconds after each display of `screen' 's visual
     bell message. The default is 1 second.


File: tscreen.info,  Node: Clear,  Next: Info,  Prev: Bell,  Up: Virtual Terminal

11.5 Clear
==========

 -- Command: clear
     (`C-a C')
     Clears the screen and saves its contents to the scrollback buffer.


File: tscreen.info,  Node: Info,  Next: Redisplay,  Prev: Clear,  Up: Virtual Terminal

11.6 Info
=========

 -- Command: info
     (`C-a i', `C-a C-i')
     Uses the message line to display some information about the current
     window: the cursor position in the form `(COLUMN,ROW)' starting
     with `(1,1)', the terminal width and height plus the size of the
     scrollback buffer in lines, like in `(80,24)+50', the current
     state of window XON/XOFF flow control is shown like this (*note
     Flow Control::):
            +flow     automatic flow control, currently on.
            -flow     automatic flow control, currently off.
            +(+)flow  flow control enabled. Agrees with automatic control.
            -(+)flow  flow control disabled. Disagrees with automatic control.
            +(-)flow  flow control enabled. Disagrees with automatic control.
            -(-)flow  flow control disabled. Agrees with automatic control.

     The current line wrap setting (`+wrap' indicates enabled, `-wrap'
     not) is also shown. The flags `ins', `org', `app', `log', `mon'
     and `nored' are displayed when the window is in insert mode,
     origin mode, application-keypad mode, has output logging, activity
     monitoring or partial redraw enabled.

     The currently active character set (`G0', `G1', `G2', or `G3'),
     and in square brackets the terminal character sets that are
     currently designated as `G0' through `G3'.  If the window is in
     UTF-8 mode, the string `UTF-8' is shown instead.  Additional modes
     depending on the type of the window are displayed at the end of
     the status line (*note Window Types::).

     If the state machine of the terminal emulator is in a non-default
     state, the info line is started with a string identifying the
     current state.

     For system information use `time'.

 -- Command: dinfo
     (none)
     Show what screen thinks about your terminal. Useful if you want to
     know why features like color or the alternate charset don't work.


File: tscreen.info,  Node: Redisplay,  Next: Wrap,  Prev: Info,  Up: Virtual Terminal

11.7 Redisplay
==============

 -- Command: allpartial state
     (none)
     If set to on, only the current cursor line is refreshed on window
     change.  This affects all windows and is useful for slow terminal
     lines. The previous setting of full/partial refresh for each
     window is restored with `allpartial off'. This is a global flag
     that immediately takes effect on all windows overriding the
     `partial' settings. It does not change the default redraw behavior
     of newly created windows.

 -- Command: altscreen state
     (none)
     If set to on, "alternate screen" support is enabled in virtual
     terminals, just like in xterm.  Initial setting is `off'.

 -- Command: partial state
     (none)
     Defines whether the display should be refreshed (as with
     `redisplay') after switching to the current window. This command
     only affects the current window.  To immediately affect all
     windows use the `allpartial' command.  Default is `off', of
     course.  This default is fixed, as there is currently no
     `defpartial' command.

 -- Command: redisplay
     (`C-a l', `C-a C-l')
     Redisplay the current window.  Needed to get a full redisplay in
     partial redraw mode.


File: tscreen.info,  Node: Wrap,  Next: Reset,  Prev: Redisplay,  Up: Virtual Terminal

11.8 Wrap
=========

 -- Command: wrap state
     (`C-a r', `C-a C-r')
     Sets the line-wrap setting for the current window.  When line-wrap
     is on, the second consecutive printable character output at the
     last column of a line will wrap to the start of the following
     line.  As an added feature, backspace (^H) will also wrap through
     the left margin to the previous line.  Default is `on'.

 -- Command: defwrap state
     (none)
     Same as the `wrap' command except that the default setting for new
     windows is changed. Initially line-wrap is on and can be toggled
     with the `wrap' command (`C-a r') or by means of "C-a : wrap
     on|off".


File: tscreen.info,  Node: Reset,  Next: Window Size,  Prev: Wrap,  Up: Virtual Terminal

11.9 Reset
==========

 -- Command: reset
     (`C-a Z')
     Reset the virtual terminal to its "power-on" values. Useful when
     strange settings (like scroll regions or graphics character set)
     are left over from an application.


File: tscreen.info,  Node: Window Size,  Next: Character Processing,  Prev: Reset,  Up: Virtual Terminal

11.10 Window Size
=================

 -- Command: width [`-w'|`-d'] [cols [lines]]
     (`C-a W')
     Toggle the window width between 80 and 132 columns, or set it to
     COLS columns if an argument is specified.  This requires a capable
     terminal and the termcap entries `Z0' and `Z1'.  See the `termcap'
     command (*note Termcap::), for more information.  You can also
     specify a height if you want to change  both  values.  The `-w'
     option tells screen to leave the display size unchanged and just
     set the  window  size, `-d' vice versa.

 -- Command: height [`-w'|`-d'] [lines [cols]]
     (none)
     Set the display height to a specified number of lines. When no
     argument is given it toggles between 24 and 42 lines display.


File: tscreen.info,  Node: Character Processing,  Prev: Window Size,  Up: Virtual Terminal

11.11 Character Processing
==========================

 -- Command: c1 [state]
     (none)
     Change c1 code processing. `c1 on' tells screen to treat the input
     characters between 128 and 159 as control functions.  Such an
     8-bit code is normally the same as ESC followed by the
     corresponding 7-bit code. The default setting is to process c1
     codes and can be changed with the `defc1' command.  Users with
     fonts that have usable characters in the c1 positions may want to
     turn this off.


 -- Command: gr [state]
     (none)
     Turn GR charset switching on/off. Whenever screen sees an input
     char with an 8th bit set, it will use the charset stored in the GR
     slot and print the character with the 8th bit stripped. The
     default (see also `defgr') is not to process GR switching because
     otherwise the ISO88591 charset would not work.

 -- Command: bce [state]
     (none)
     Change background-color-erase setting. If `bce' is set to on, all
     characters cleared by an erase/insert/scroll/clear operation will
     be displayed in the current background color.  Otherwise the
     default background color is used.

 -- Command: encoding enc [denc]
     (none)
     Tell screen how to interpret the input/output. The first argument
     sets the encoding of the current window.  Each window can emulate
     a different encoding. The optional second parameter overwrites the
     encoding of the connected terminal.  It should never be needed as
     screen uses the locale setting to detect the encoding.  There is
     also a way to select a terminal encoding depending on the terminal
     type by using the `KJ' termcap entry. *Note Special Capabilities::.

     Supported encodings are `eucJP', `SJIS', `eucKR', `eucCN', `Big5',
     `GBK', `KOI8-R', `CP1251', `UTF-8', `ISO8859-2', `ISO8859-3',
     `ISO8859-4', `ISO8859-5', `ISO8859-6', `ISO8859-7', `ISO8859-8',
     `ISO8859-9', `ISO8859-10', `ISO8859-15', `jis'.

     See also `defencoding', which changes the default setting of a new
     window.

 -- Command: charset set
     (none)
     Change the current character set slot designation and charset
     mapping.  The first four character of SET are treated as charset
     designators while the fifth and sixth character must be in range
     `0' to `3' and set the GL/GR charset mapping. On every position a
     `.' may be used to indicate that the corresponding charset/mapping
     should not be changed (SET is padded to six characters internally
     by appending `.' chars). New windows have `BBBB02' as default
     charset, unless a `encoding' command is active.

     The current setting can be viewed with the *note Info:: command.

 -- Command: utf8 [state [dstate]]
     (none)
     Change the encoding used in the current window. If utf8 is
     enabled, the strings sent to the window will be UTF-8 encoded and
     vice versa.  Omitting the parameter toggles the setting. If a
     second parameter is given, the display's encoding is also changed
     (this should rather be done with screen's `-U' option).  See also
     `defutf8', which changes the default setting of a new window.

 -- Command: defc1 state
     (none)
     Same as the `c1' command except that the default setting for new
     windows is changed. Initial setting is `on'.

 -- Command: defgr state
     (none)
     Same as the `gr' command except that the default setting for new
     windows is changed. Initial setting is `off'.

 -- Command: defbce state
     (none)
     Same as the `bce' command except that the default setting for new
     windows is changed. Initial setting is `off'.

 -- Command: defencoding enc
     (none)
     Same as the `encoding' command except that the default setting for
     new windows is changed. Initial setting is the encoding taken from
     the terminal.

 -- Command: defcharset [set]
     Like the `charset' command except that the default setting for new
     windows is changed. Shows current default if called without
     argument.

 -- Command: defutf8 state
     (none)
     Same as the `utf8' command except that the default setting for new
     windows is changed. Initial setting is `on' if screen was started
     with `-U', otherwise `off'.


File: tscreen.info,  Node: Copy and Paste,  Next: Subprocess Execution,  Prev: Virtual Terminal,  Up: Top

12 Copy and Paste
*****************

For those confined to a hardware terminal, these commands provide a cut
and paste facility more powerful than those provided by most windowing
systems.

* Menu:

* Copy::                        Copy from scrollback to buffer
* Paste::                       Paste from buffer into window
* Registers::                   Longer-term storage
* Screen Exchange::             Sharing data between screen users
* History::                     Recalling previous input


File: tscreen.info,  Node: Copy,  Next: Paste,  Up: Copy and Paste

12.1 Copying
============

 -- Command: copy
     (`C-a [', `C-a C-[', `C-a <ESC>')
     Enter copy/scrollback mode. This allows you to copy text from the
     current window and its history into the paste buffer. In this mode
     a `vi'-like full screen editor is active, with controls as
     outlined below.

* Menu:

* Line Termination::            End copied lines with CR/LF
* Scrollback::                  Set the size of the scrollback buffer
* Copy Mode Keys::              Remap keys in copy mode
* Movement::                    Move around in the scrollback buffer
* Marking::                     Select the text you want
* Repeat count::                Repeat a command
* Searching::                   Find the text you want
* Specials::                    Other random keys


File: tscreen.info,  Node: Line Termination,  Next: Scrollback,  Up: Copy

12.1.1 CR/LF
------------

 -- Command: crlf [state]
     (none)
     This affects the copying of text regions with the `C-a [' command.
     If it is set to `on', lines will be separated by the two character
     sequence `CR'/`LF'.  Otherwise only `LF' is used.  `crlf' is off
     by default.  When no parameter is given, the state is toggled.


File: tscreen.info,  Node: Scrollback,  Next: Copy Mode Keys,  Prev: Line Termination,  Up: Copy

12.1.2 Scrollback
-----------------

 -- Command: defscrollback num
     (none)
     Same as the `scrollback' command except that the default setting
     for new windows is changed.  Defaults to 100.

 -- Command: scrollback num
     (none)
     Set the size of the scrollback buffer for the current window to
     NUM lines.  The default scrollback is 100 lines.  Use `C-a i' to
     view the current setting.

 -- Command: compacthist [state]
     (none)
     This tells screen whether to suppress trailing blank lines when
     scrolling up text into the history buffer. Turn compacting `on' to
     hold more useful lines in your scrollback buffer.


File: tscreen.info,  Node: Copy Mode Keys,  Next: Movement,  Prev: Scrollback,  Up: Copy

12.1.3 markkeys
---------------

 -- Command: markkeys string
     (none)
     This is a method of changing the keymap used for copy/history
     mode.  The string is made up of OLDCHAR=NEWCHAR pairs which are
     separated by `:'. Example: The command `markkeys h=^B:l=^F:$=^E'
     would set some keys to be more familiar to `emacs' users.  If your
     terminal sends characters, that cause you to abort copy mode, then
     this command may help by binding these characters to do nothing.
     The no-op character is `@' and is used like this: `markkeys @=L=H'
     if you do not want to use the `H' or `L' commands any longer.  As
     shown in this example, multiple keys can be assigned to one
     function in a single statement.


File: tscreen.info,  Node: Movement,  Next: Marking,  Prev: Copy Mode Keys,  Up: Copy

12.1.4 Movement Keys
--------------------

`h', `j', `k', `l' move the cursor line by line or column by column.

`0', `^' and `$' move to the leftmost column or to the first or last
non-whitespace character on the line.

`H', `M' and `L' move the cursor to the leftmost column of the top,
center or bottom line of the window.

`+' and `-' move the cursor to the leftmost column of the next or
previous line.

`G' moves to the specified absolute line (default: end of buffer).

`|' moves to the specified absolute column.

`w', `b', `e' move the cursor word by word.

`B', `E' move the cursor WORD by WORD (as in vi).

`C-u' and `C-d' scroll the display up/down by the specified amount of
lines while preserving the cursor position. (Default: half screenful).

`C-b' and `C-f' move the cursor up/down a full screen.

`g' moves to the beginning of the buffer.

`%' jumps to the specified percentage of the buffer.

   Note that Emacs-style movement keys can be specified by a .screenrc
command. (`markkeys "h=^B:l=^F:$=^E"') There is no simple method for a
full emacs-style keymap, however, as this involves multi-character
codes.


File: tscreen.info,  Node: Marking,  Next: Repeat count,  Prev: Movement,  Up: Copy

12.1.5 Marking
--------------

The copy range is specified by setting two marks. The text between these
marks will be highlighted. Press `space' to set the first or second
mark respectively.

`Y' and `y' can be used to mark one whole line or to mark from start of
line.

`W' marks exactly one word.


File: tscreen.info,  Node: Repeat count,  Next: Searching,  Prev: Marking,  Up: Copy

12.1.6 Repeat Count
-------------------

Any command in copy mode can be prefixed with a number (by pressing
digits `0...9') which is taken as a repeat count. Example: `C-a C-[ H
10 j 5 Y' will copy lines 11 to 15 into the paste buffer.


File: tscreen.info,  Node: Searching,  Next: Specials,  Prev: Repeat count,  Up: Copy

12.1.7 Searching
----------------

`/' `vi'-like search forward.

`?' `vi'-like search backward.

`C-a s' `emacs' style incremental search forward.

`C-r' `emacs' style reverse i-search.

 -- Command: ignorecase [state]
     (none)
     Tell screen to ignore the case of characters in searches. Default
     is `off'.


File: tscreen.info,  Node: Specials,  Prev: Searching,  Up: Copy

12.1.8 Specials
---------------

There are, however, some keys that act differently here from in `vi'.
`Vi' does not allow to yank rectangular blocks of text, but `screen'
does. Press

`c' or `C' to set the left or right margin respectively. If no repeat
count is given, both default to the current cursor position.
Example: Try this on a rather full text screen: `C-a [ M 20 l SPACE c
10 l 5 j C SPACE'.

This moves one to the middle line of the screen, moves in 20 columns
left, marks the beginning of the paste buffer, sets the left column,
moves 5 columns down, sets the right column, and then marks the end of
the paste buffer. Now try:
`C-a [ M 20 l SPACE 10 l 5 j SPACE'

and notice the difference in the amount of text copied.

`J' joins lines. It toggles between 4 modes: lines separated by a
newline character (012), lines glued seamless, lines separated by a
single space or comma separated lines. Note that you can prepend the
newline character with a carriage return character, by issuing a `set
crlf on'.

`v' is for all the `vi' users who use `:set numbers' - it toggles the
left margin between column 9 and 1.

`a' before the final space key turns on append mode. Thus the contents
of the paste buffer will not be overwritten, but appended to.

`A' turns on append mode and sets a (second) mark.

`>' sets the (second) mark and writes the contents of the paste buffer
to the screen-exchange file (`/tmp/screen-exchange' per default) once
copy-mode is finished.  *Note Screen Exchange::.
This example demonstrates how to dump the whole scrollback buffer to
that file:
`C-a [ g SPACE G $ >'.

`C-g' gives information about the current line and column.

`x' exchanges the first mark and the current cursor position. You can
use this to adjust an already placed mark.

`@' does nothing.  Absolutely nothing.  Does not even exit copy mode.

All keys not described here exit copy mode.


File: tscreen.info,  Node: Paste,  Next: Registers,  Prev: Copy,  Up: Copy and Paste

12.2 Paste
==========

 -- Command: paste [registers [destination]]
     (`C-a ]', `C-a C-]')
     Write the (concatenated) contents of the specified registers to
     the stdin stream of the current window.  The register `.' is
     treated as the paste buffer. If no parameter is specified the user
     is prompted to enter a single register. The paste buffer can be
     filled with the `copy', `history' and `readbuf' commands.  Other
     registers can be filled with the `register', `readreg' and `paste'
     commands.  If `paste' is called with a second argument, the
     contents of the specified registers is pasted into the named
     destination register rather than the window. If `.' is used as the
     second argument, the display's paste buffer is the destination.
     Note, that `paste' uses a wide variety of resources: Usually both,
     a current window and a current display are required. But whenever
     a second argument is specified no current window is needed. When
     the source specification only contains registers (not the paste
     buffer) then there need not be a current display (terminal
     attached), as the registers are a global resource. The paste
     buffer exists once for every user.

 -- Command: stuff string
     (none)
     Stuff the string STRING in the input buffer of the current window.
     This is like the `paste' command, but with much less overhead.
     You cannot paste large buffers with the `stuff' command. It is most
     useful for key bindings. *Note Bindkey::.

 -- Command: pastefont [state]
     Tell screen to include font information in the paste buffer. The
     default is not to do so. This command is especially useful for
     multi character fonts like kanji.

 -- Command: slowpaste msec
 -- Command: defslowpaste msec
     (none)
     Define the speed text is inserted in the current window by the
     `paste' command. If the slowpaste value is nonzero text is written
     character by character.  `screen' will pause for MSEC milliseconds
     after each write to allow the application to process the input.
     only use `slowpaste' if your underlying system exposes flow
     control problems while pasting large amounts of text.
     `defslowpaste' specifies the default for new windows.

 -- Command: readreg [-e encoding] [register [filename]]
     (none)
     Does one of two things, dependent on number of arguments: with
     zero or one arguments it it duplicates the paste buffer contents
     into the register specified or entered at the prompt. With two
     arguments it reads the contents of the named file into the
     register, just as `readbuf' reads the screen-exchange file into
     the paste buffer.  You can tell screen the encoding of the file
     via the `-e' option.  The following example will paste the
     system's password file into the screen window (using register p,
     where a copy remains):

          C-a : readreg p /etc/passwd
          C-a : paste p


File: tscreen.info,  Node: Registers,  Next: Screen Exchange,  Prev: Paste,  Up: Copy and Paste

12.3 Registers
==============

 -- Command: copy_reg [key]
     (none)
     Removed. Use `readreg' instead.

 -- Command: ins_reg [key]
     (none)
     Removed. Use `paste' instead.

 -- Command: process [key]
     (none)
     Stuff the contents of the specified register into the `screen'
     input queue. If no argument is given you are prompted for a
     register name. The text is parsed as if it had been typed in from
     the user's keyboard. This command can be used to bind multiple
     actions to a single key.

 -- Command: register [-e encoding] key string
     (none)
     Save the specified STRING to the register KEY.  The encoding of
     the string can be specified via the `-e' option.


File: tscreen.info,  Node: Screen Exchange,  Next: History,  Prev: Registers,  Up: Copy and Paste

12.4 Screen Exchange
====================

 -- Command: bufferfile [EXCHANGE-FILE]
     (none)
     Change the filename used for reading and writing with the paste
     buffer.  If the EXCHANGE-FILE parameter is omitted, `screen'
     reverts to the default of `/tmp/screen-exchange'.  The following
     example will paste the system's password file into the screen
     window (using the paste buffer, where a copy remains):

          C-a : bufferfile /etc/passwd
          C-a < C-a ]
          C-a : bufferfile

 -- Command: readbuf [-e ENCODING] [FILENAME]
     (`C-a <')
     Reads the contents of the specified file into the paste buffer.
     You can tell screen the encoding of the file via the `-e' option.
     If no file is specified, the screen-exchange filename is used.

 -- Command: removebuf
     (`C-a =')
     Unlinks the screen-exchange file.

 -- Command: writebuf [-e ENCODING] [FILENAME]
     (`C-a >')
     Writes the contents of the paste buffer to the specified file, or
     the public accessible screen-exchange file if no filename is given.
     This is thought of as a primitive means of communication between
     `screen' users on the same host.  If an encoding is specified the
     paste buffer is recoded on the fly to match the encoding.  See also
     `C-a <ESC>' (*note Copy::).


File: tscreen.info,  Node: History,  Prev: Screen Exchange,  Up: Copy and Paste

12.5 History
============

 -- Command: history
     (`C-a {')
     Usually users work with a shell that allows easy access to previous
     commands.  For example, `csh' has the command `!!' to repeat the
     last command executed.  `screen' provides a primitive way of
     recalling "the command that started ...": You just type the first
     letter of that command, then hit `C-a {' and `screen' tries to
     find a previous line that matches with the prompt character to the
     left of the cursor. This line is pasted into this window's input
     queue.  Thus you have a crude command history (made up by the
     visible window and its scrollback buffer).


File: tscreen.info,  Node: Subprocess Execution,  Next: Key Binding,  Prev: Copy and Paste,  Up: Top

13 Subprocess Execution
***********************

Control Input or Output of a window by another filter process.  Use
with care!

* Menu:

* Exec::                        The `exec' command syntax.
* Using Exec::                  Weird things that filters can do.


File: tscreen.info,  Node: Exec,  Next: Using Exec,  Up: Subprocess Execution

13.1 Exec
=========

 -- Command: exec [[FDPAT] NEWCOMMAND [ARGS ... ]]
     (none)
     Run a unix subprocess (specified by an executable path NEWCOMMAND
     and its optional arguments) in the current window. The flow of
     data between newcommands stdin/stdout/stderr, the process
     originally started (let us call it "application-process") and
     screen itself (window) is controlled by the file descriptor
     pattern FDPAT.  This pattern is basically a three character
     sequence representing stdin, stdout and stderr of newcommand. A
     dot (`.') connects the file descriptor to screen. An exclamation
     mark (`!') causes the file descriptor to be connected to the
     application-process. A colon (`:') combines both.
     User input will go to newcommand unless newcommand receives the
     application-process' output (FDPATs first character is `!' or `:')
     or a pipe symbol (`|') is added to the end of FDPAT.
     Invoking `exec' without arguments shows name and arguments of the
     currently running subprocess in this window. Only one subprocess
     can be running per window.
     When a subprocess is running the `kill' command will affect it
     instead of the windows process. Only one subprocess a time can be
     running in each window.
     Refer to the postscript file `doc/fdpat.ps' for a confusing
     illustration of all 21 possible combinations. Each drawing shows
     the digits 2, 1, 0 representing the three file descriptors of
     newcommand. The box marked `W' is usual pty that has the
     application-process on its slave side.  The box marked `P' is the
     secondary pty that now has screen at its master side.


File: tscreen.info,  Node: Using Exec,  Prev: Exec,  Up: Subprocess Execution

13.2 Using Exec
===============

Abbreviations:

   * Whitespace between the word `exec' and FDPAT and the command name
     can be omitted.

   * Trailing dots and a FDPAT consisting only of dots can be omitted.

   * A simple `|' is synonymous for the `!..|' pattern.

   * The word `exec' can be omitted when the `|' abbreviation is used.

   * The word `exec' can always be replaced by leading `!'.

Examples:

`!/bin/sh'
`exec /bin/sh'
`exec ... /bin/sh'
     All of the above are equivalent.  Creates another shell in the
     same window, while the original shell is still running. Output of
     both shells is displayed and user input is sent to the new
     `/bin/sh'.

`!!stty 19200'
`exec!stty 19200'
`exec !.. stty 19200'
     All of the above are equivalent.  Set the speed of the window's
     tty. If your stty command operates on stdout, then add another
     `!'. This is a useful command, when a screen window is directly
     connected to a serial line that needs to be configured.

`|less'
`exec !..| less'
     Both are equivalent.  This adds a pager to the window output. The
     special character `|' is needed to give the user control over the
     pager although it gets its input from the window's process. This
     works, because `less' listens on stderr (a behavior that `screen'
     would not expect without the `|') when its stdin is not a tty.
     `Less' versions newer than 177 fail miserably here; good old `pg'
     still works.

`!:sed -n s/.*Error.*/\007/p'
     Sends window output to both, the user and the sed command. The sed
     inserts an additional bell character (oct. 007) to the window
     output seen by screen.  This will cause 'Bell in window x'
     messages, whenever the string `Error' appears in the window.


File: tscreen.info,  Node: Key Binding,  Next: Flow Control,  Prev: Subprocess Execution,  Up: Top

14 Key Binding
**************

You may disagree with some of the default bindings (I know I do).  The
`bind' command allows you to redefine them to suit your preferences.

* Menu:

* Bind::                        `bind' syntax.
* Bind Examples::               Using `bind'.
* Command Character::           The character used to start keyboard commands.
* Help::                        Show current key bindings.
* Bindkey::			`bindkey' syntax.
* Bindkey Examples::		Some easy examples.
* Bindkey Control::		How to control the bindkey mechanism.


File: tscreen.info,  Node: Bind,  Next: Bind Examples,  Up: Key Binding

14.1 The `bind' command
=======================

 -- Command: bind [-c class] key [command [args]]
     (none)
     Bind a command to a key.  The KEY argument is either a single
     character, a two-character sequence of the form `^x' (meaning
     `C-x'), a backslash followed by an octal number (specifying the
     ASCII code of the character), or a backslash followed by a second
     character, such as `\^' or `\\'.  The argument can also be quoted,
     if you like.  If no further argument is given, any previously
     established binding for this key is removed.  The COMMAND argument
     can be any command (*note Command Index::).

     If a command class is specified via the `-c' option, the key is
     bound for the specified class.  Use the `command' command to
     activate a class. Command classes can be used to create multiple
     command keys or multi-character bindings.

     By default, most suitable commands are bound to one or more keys
     (*note Default Key Bindings::; for instance, the command to create
     a new window is bound to `C-c' and `c'.  The `bind' command can be
     used to redefine the key bindings and to define new bindings.


File: tscreen.info,  Node: Bind Examples,  Next: Command Character,  Prev: Bind,  Up: Key Binding

14.2 Examples of the `bind' command
===================================

Some examples:

     bind ' ' windows
     bind ^f screen telnet foobar
     bind \033 screen -ln -t root -h 1000 9 su

would bind the space key to the command that displays a list of windows
(so that the command usually invoked by `C-a C-w' would also be
available as `C-a space'), bind `C-f' to the command "create a window
with a TELNET connection to foobar", and bind <ESC> to the command that
creates an non-login window with title `root' in slot #9, with a
superuser shell and a scrollback buffer of 1000 lines.

     bind -c demo1 0 select 10
     bind -c demo1 1 select 11
     bind -c demo1 2 select 12
     bindkey "^B" command -c demo1
   makes `C-b 0' select window 10, `C-b 1' window 11, etc.

     bind -c demo2 0 select 10
     bind -c demo2 1 select 11
     bind -c demo2 2 select 12
     bind - command -c demo2
   makes `C-a - 0' select window 10, `C-a - 1' window 11, etc.


File: tscreen.info,  Node: Command Character,  Next: Help,  Prev: Bind Examples,  Up: Key Binding

14.3 Command Character
======================

 -- Command: escape xy
     (none)
     Set the command character to X and the character generating a
     literal command character (by triggering the `meta' command) to Y
     (similar to the `-e' option).  Each argument is either a single
     character, a two-character sequence of the form `^x' (meaning
     `C-x'), a backslash followed by an octal number (specifying the
     ASCII code of the character), or a backslash followed by a second
     character, such as `\^' or `\\'.  The default is `^Aa', but ```'
     is recommended by one of the authors.

 -- Command: defescape xy
     (none)
     Set the default command characters. This is equivalent to the
     command `escape' except that it is useful for multiuser sessions
     only.  In a multiuser session `escape' changes the command
     character of the calling user, where `defescape' changes the
     default command characters for users that will be added later.

 -- Command: meta
     (`C-a a')
     Send the command character (`C-a') to the process in the current
     window.  The keystroke for this command is the second parameter to
     the `-e' command line switch (*note Invoking Screen::), or the
     `escape' .screenrc directive.

 -- Command: command [-c CLASS]
     (none)
     This command has the same effect as typing the screen escape
     character (`C-a'). It is probably only useful for key bindings.
     If the `-c' option is given, select the specified command class.
     *Note Bind::, *Note Bindkey::.


File: tscreen.info,  Node: Help,  Next: Bindkey,  Prev: Command Character,  Up: Key Binding

14.4 Help
=========

 -- Command: help
     (`C-a ?')
     Displays a help screen showing you all the key bindings.  The first
     pages list all the internal commands followed by their bindings.
     Subsequent pages will display the custom commands, one command per
     key.  Press space when you're done reading each page, or return to
     exit early.  All other characters are ignored.  If the `-c' option
     is given, display all bound commands for the specified command
     class.  *Note Default Key Bindings::.


File: tscreen.info,  Node: Bindkey,  Next: Bindkey Examples,  Prev: Help,  Up: Key Binding

14.5 Bindkey
============

 -- Command: bindkey [OPTS] [STRING [CMD ARGS]]
     (none)
     This command manages screen's input translation tables. Every
     entry in one of the tables tells screen how to react if a certain
     sequence of characters is encountered. There are three tables: one
     that should contain actions programmed by the user, one for the
     default actions used for terminal emulation and one for screen's
     copy mode to do cursor movement. See *note Input Translation:: for
     a list of default key bindings.

     If the `-d' option is given, bindkey modifies the default table,
     `-m' changes the copy mode table and with neither option the user
     table is selected. The argument `string' is the sequence of
     characters to which an action is bound. This can either be a fixed
     string or a termcap keyboard capability name (selectable with the
     `-k' option).

     Some keys on a VT100 terminal can send a different string if
     application mode is turned on (e.g. the cursor keys).  Such keys
     have two entries in the translation table. You can select the
     application mode entry by specifying the `-a' option.

     The `-t' option tells screen not to do inter-character timing. One
     cannot turn off the timing if a termcap capability is used.

     `cmd' can be any of screen's commands with an arbitrary number of
     `args'. If `cmd' is omitted the key-binding is removed from the
     table.


File: tscreen.info,  Node: Bindkey Examples,  Next: Bindkey Control,  Prev: Bindkey,  Up: Key Binding

14.6 Bindkey Examples
=====================

Here are some examples of keyboard bindings:

     bindkey -d
   Show all of the default key bindings. The application mode entries
are marked with [A].

     bindkey -k k1 select 1
   Make the "F1" key switch to window one.

     bindkey -t foo stuff barfoo
   Make `foo' an abbreviation of the word `barfoo'. Timeout is disabled
so that users can type slowly.

     bindkey "\024" mapdefault
   This key-binding makes `C-t' an escape character for key-bindings. If
you did the above `stuff barfoo' binding, you can enter the word `foo'
by typing `C-t foo'. If you want to insert a `C-t' you have to press
the key twice (i.e., escape the escape binding).

     bindkey -k F1 command
   Make the F11 (not F1!) key an alternative screen escape (besides
`C-a').


File: tscreen.info,  Node: Bindkey Control,  Prev: Bindkey Examples,  Up: Key Binding

14.7 Bindkey Control
====================

 -- Command: mapdefault
     (none)
     Tell screen that the next input character should only be looked up
     in the default bindkey table.

 -- Command: mapnotnext
     (none)
     Like mapdefault, but don't even look in the default bindkey table.

 -- Command: maptimeout timo
     (none)
     Set the inter-character timer for input sequence detection to a
     timeout of TIMO ms. The default timeout is 300ms. Maptimeout with
     no arguments shows the current setting.


File: tscreen.info,  Node: Flow Control,  Next: Termcap,  Prev: Key Binding,  Up: Top

15 Flow Control
***************

`screen' can trap flow control characters or pass them to the program,
as you see fit.  This is useful when your terminal wants to use
XON/XOFF flow control and you are running a program which wants to use
^S/^Q for other purposes (i.e. `emacs').

* Menu:

* Flow Control Summary::        The effect of `screen' flow control
* Flow::                        Setting the flow control behavior
* XON/XOFF::                    Sending XON or XOFF to the window


File: tscreen.info,  Node: Flow Control Summary,  Next: Flow,  Up: Flow Control

15.1 About `screen' flow control settings
=========================================

Each window has a flow-control setting that determines how screen deals
with the XON and XOFF characters (and perhaps the interrupt character).
When flow-control is turned off, screen ignores the XON and XOFF
characters, which allows the user to send them to the current program by
simply typing them (useful for the `emacs' editor, for instance).  The
trade-off is that it will take longer for output from a "normal"
program to pause in response to an XOFF.  With flow-control turned on,
XON and XOFF characters are used to immediately pause the output of the
current window.  You can still send these characters to the current
program, but you must use the appropriate two-character screen commands
(typically `C-a q' (xon) and `C-a s' (xoff)).  The xon/xoff commands
are also useful for typing C-s and C-q past a terminal that intercepts
these characters.

   Each window has an initial flow-control value set with either the
`-f' option or the `defflow' command.  By default the windows are set
to automatic flow-switching.  It can then be toggled between the three
states 'fixed on', 'fixed off' and 'automatic' interactively with the
`flow' command bound to `C-a f'.

   The automatic flow-switching mode deals with flow control using the
TIOCPKT mode (like `rlogin' does). If the tty driver does not support
TIOCPKT, screen tries to determine the right mode based on the current
setting of the application keypad -- when it is enabled, flow-control
is turned off and visa versa.  Of course, you can still manipulate
flow-control manually when needed.

   If you're running with flow-control enabled and find that pressing
the interrupt key (usually C-c) does not interrupt the display until
another 6-8 lines have scrolled by, try running screen with the
`interrupt' option (add the `interrupt' flag to the `flow' command in
your .screenrc, or use the `-i' command-line option).  This causes the
output that `screen' has accumulated from the interrupted program to be
flushed.  One disadvantage is that the virtual terminal's memory
contains the non-flushed version of the output, which in rare cases can
cause minor inaccuracies in the output.  For example, if you switch
screens and return, or update the screen with `C-a l' you would see the
version of the output you would have gotten without `interrupt' being
on.  Also, you might need to turn off flow-control (or use auto-flow
mode to turn it off automatically) when running a program that expects
you to type the interrupt character as input, as the `interrupt'
parameter only takes effect when flow-control is enabled.  If your
program's output is interrupted by mistake, a simple refresh of the
screen with `C-a l' will restore it.  Give each mode a try, and use
whichever mode you find more comfortable.


File: tscreen.info,  Node: Flow,  Next: XON/XOFF,  Prev: Flow Control Summary,  Up: Flow Control

15.2 Flow
=========

 -- Command: defflow fstate [interrupt]
     (none)
     Same as the `flow' command except that the default setting for new
     windows is changed. Initial setting is `auto'.  Specifying `flow
     auto interrupt' has the same effect as the command-line options
     `-fa' and `-i'.  Note that if `interrupt' is enabled, all existing
     displays are changed immediately to forward interrupt signals.

 -- Command: flow [fstate]
     (`C-a f', `C-a C-f')
     Sets the flow-control mode for this window to FSTATE, which can be
     `on', `off' or `auto'.  Without parameters it cycles the current
     window's flow-control setting.  Default is set by `defflow'.


File: tscreen.info,  Node: XON/XOFF,  Prev: Flow,  Up: Flow Control

15.3 XON and XOFF
=================

 -- Command: xon
     (`C-a q', `C-a C-q')
     Send a ^Q (ASCII XON) to the program in the current window.
     Redundant if flow control is set to `off' or `auto'.

 -- Command: xoff
     (`C-a s', `C-a C-s')
     Send a ^S (ASCII XOFF) to the program in the current window.


File: tscreen.info,  Node: Termcap,  Next: Message Line,  Prev: Flow Control,  Up: Top

16 Termcap
**********

`screen' demands the most out of your terminal so that it can perform
its VT100 emulation most efficiently.  These functions provide means
for tweaking the termcap entries for both your physical terminal and
the one simulated by `screen'.

* Menu:

* Window Termcap::              Choosing a termcap entry for the window.
* Dump Termcap::                Write out a termcap entry for the window.
* Termcap Syntax::              The `termcap' and `terminfo' commands.
* Termcap Examples::            Uses for `termcap'.
* Special Capabilities::        Non-standard capabilities used by `screen'.
* Autonuke::			Flush unseen output
* Obuflimit::			Allow pending output when reading more
* Character Translation::       Emulating fonts and charsets.


File: tscreen.info,  Node: Window Termcap,  Next: Dump Termcap,  Up: Termcap

16.1 Choosing the termcap entry for a window
============================================

Usually `screen' tries to emulate as much of the VT100/ANSI standard as
possible. But if your terminal lacks certain capabilities the emulation
may not be complete. In these cases `screen' has to tell the
applications that some of the features are missing. This is no problem
on machines using termcap, because `screen' can use the `$TERMCAP'
variable to customize the standard screen termcap.

   But if you do a rlogin on another machine or your machine supports
only terminfo this method fails. Because of this `screen' offers a way
to deal with these cases. Here is how it works:

   When `screen' tries to figure out a terminal name for itself, it
first looks for an entry named `screen.TERM', where TERM is the
contents of your `$TERM' variable.  If no such entry exists, `screen'
tries `screen' (or `screen-w', if the terminal is wide (132 cols or
more)).  If even this entry cannot be found, `vt100' is used as a
substitute.

   The idea is that if you have a terminal which doesn't support an
important feature (e.g. delete char or clear to EOS) you can build a new
termcap/terminfo entry for `screen' (named `screen.DUMBTERM') in which
this capability has been disabled.  If this entry is installed on your
machines you are able to do a rlogin and still keep the correct
termcap/terminfo entry.  The terminal name is put in the `$TERM'
variable of all new windows.  `screen' also sets the `$TERMCAP'
variable reflecting the capabilities of the virtual terminal emulated.
Furthermore, the variable `$WINDOW' is set to the window number of each
window.

   The actual set of capabilities supported by the virtual terminal
depends on the capabilities supported by the physical terminal.  If, for
instance, the physical terminal does not support underscore mode,
`screen' does not put the `us' and `ue' capabilities into the window's
`$TERMCAP' variable, accordingly.  However, a minimum number of
capabilities must be supported by a terminal in order to run `screen';
namely scrolling, clear screen, and direct cursor addressing (in
addition, `screen' does not run on hardcopy terminals or on terminals
that over-strike).

   Also, you can customize the `$TERMCAP' value used by `screen' by
using the `termcap' command, or by defining the variable `$SCREENCAP'
prior to startup.  When the latter defined, its value will be copied
verbatim into each window's `$TERMCAP' variable.  This can either be
the full terminal definition, or a filename where the terminal `screen'
(and/or `screen-w') is defined.

   Note that `screen' honors the `terminfo' command if the system uses
the terminfo database rather than termcap.  On such machines the
`$TERMCAP' variable has no effect and you must use the `dumptermcap'
command (*note Dump Termcap::) and the `tic' program to generate
terminfo entries for `screen' windows.

   When the boolean `G0' capability is present in the termcap entry for
the terminal on which `screen' has been called, the terminal emulation
of `screen' supports multiple character sets.  This allows an
application to make use of, for instance, the VT100 graphics character
set or national character sets.  The following control functions from
ISO 2022 are supported: `lock shift G0' (`SI'), `lock shift G1' (`SO'),
`lock shift G2', `lock shift G3', `single shift G2', and `single shift
G3'.  When a virtual terminal is created or reset, the ASCII character
set is designated as `G0' through `G3'.  When the `G0' capability is
present, screen evaluates the capabilities `S0', `E0', and `C0' if
present. `S0' is the sequence the terminal uses to enable and start the
graphics character set rather than `SI'.  `E0' is the corresponding
replacement for `SO'. `C0' gives a character by character translation
string that is used during semi-graphics mode.  This string is built
like the `acsc' terminfo capability.

   When the `po' and `pf' capabilities are present in the terminal's
termcap entry, applications running in a `screen' window can send
output to the printer port of the terminal.  This allows a user to have
an application in one window sending output to a printer connected to
the terminal, while all other windows are still active (the printer
port is enabled and disabled again for each chunk of output).  As a
side-effect, programs running in different windows can send output to
the printer simultaneously.  Data sent to the printer is not displayed
in the window. The `info' command displays a line starting with `PRIN'
while the printer is active.

   Some capabilities are only put into the `$TERMCAP' variable of the
virtual terminal if they can be efficiently implemented by the physical
terminal.  For instance, `dl' (delete line) is only put into the
`$TERMCAP' variable if the terminal supports either delete line itself
or scrolling regions. Note that this may provoke confusion, when the
session is reattached on a different terminal, as the value of
`$TERMCAP' cannot be modified by parent processes.  You can force
`screen' to include all capabilities in `$TERMCAP' with the `-a'
command-line option (*note Invoking Screen::).

   The "alternate screen" capability is not enabled by default.  Set
the `altscreen' `.screenrc' command to enable it.


File: tscreen.info,  Node: Dump Termcap,  Next: Termcap Syntax,  Prev: Window Termcap,  Up: Termcap

16.2 Write out the window's termcap entry
=========================================

 -- Command: dumptermcap
     (`C-a .')
     Write the termcap entry for the virtual terminal optimized for the
     currently active window to the file `.termcap' in the user's
     `$HOME/.screen' directory (or wherever `screen' stores its
     sockets. *note Files::).  This termcap entry is identical to the
     value of the environment variable `$TERMCAP' that is set up by
     `screen' for each window. For terminfo based systems you will need
     to run a converter like `captoinfo' and then compile the entry with
     `tic'.


File: tscreen.info,  Node: Termcap Syntax,  Next: Termcap Examples,  Prev: Dump Termcap,  Up: Termcap

16.3 The `termcap' command
==========================

 -- Command: termcap term terminal-tweaks [window-tweaks]
 -- Command: terminfo term terminal-tweaks [window-tweaks]
 -- Command: termcapinfo term terminal-tweaks [window-tweaks]
     (none)
     Use this command to modify your terminal's termcap entry without
     going through all the hassles involved in creating a custom
     termcap entry.  Plus, you can optionally customize the termcap
     generated for the windows.  You have to place these commands in
     one of the screenrc startup files, as they are meaningless once
     the terminal emulator is booted.

     If your system uses the terminfo database rather than termcap,
     `screen' will understand the `terminfo' command, which has the
     same effects as the `termcap' command.   Two separate commands are
     provided, as there are subtle syntactic differences, e.g. when
     parameter interpolation (using `%') is required. Note that the
     termcap names of the capabilities should also be used with the
     `terminfo' command.

     In many cases, where the arguments are valid in both terminfo and
     termcap syntax, you can use the command `termcapinfo', which is
     just a shorthand for a pair of `termcap' and `terminfo' commands
     with identical arguments.

   The first argument specifies which terminal(s) should be affected by
this definition.  You can specify multiple terminal names by separating
them with `|'s.  Use `*' to match all terminals and `vt*' to match all
terminals that begin with `vt'.

   Each TWEAK argument contains one or more termcap defines (separated
by `:'s) to be inserted at the start of the appropriate termcap entry,
enhancing it or overriding existing values.  The first tweak modifies
your terminal's termcap, and contains definitions that your terminal
uses to perform certain functions.  Specify a null string to leave this
unchanged (e.g. "").  The second (optional) tweak modifies all the
window termcaps, and should contain definitions that screen understands
(*note Virtual Terminal::).


File: tscreen.info,  Node: Termcap Examples,  Next: Special Capabilities,  Prev: Termcap Syntax,  Up: Termcap

16.4 Termcap Examples
=====================

Some examples:

     termcap xterm*  xn:hs@

Informs `screen' that all terminals that begin with `xterm' have firm
auto-margins that allow the last position on the screen to be updated
(xn), but they don't really have a status line (no 'hs' - append `@' to
turn entries off).  Note that we assume `xn' for all terminal names
that start with `vt', but only if you don't specify a termcap command
for that terminal.

     termcap vt*  xn
     termcap vt102|vt220  Z0=\E[?3h:Z1=\E[?3l

Specifies the firm-margined `xn' capability for all terminals that
begin with `vt', and the second line will also add the escape-sequences
to switch into (Z0) and back out of (Z1) 132-character-per-line mode if
this is a VT102 or VT220.  (You must specify Z0 and Z1 in your termcap
to use the width-changing commands.)

     termcap vt100  ""  l0=PF1:l1=PF2:l2=PF3:l3=PF4

This leaves your vt100 termcap alone and adds the function key labels to
each window's termcap entry.

     termcap h19|z19  am@:im=\E@:ei=\EO  dc=\E[P

Takes a h19 or z19 termcap and turns off auto-margins (am@) and enables
the insert mode (im) and end-insert (ei) capabilities (the `@' in the
`im' string is after the `=', so it is part of the string).  Having the
`im' and `ei' definitions put into your terminal's termcap will cause
screen to automatically advertise the character-insert capability in
each window's termcap.  Each window will also get the delete-character
capability (dc) added to its termcap, which screen will translate into
a line-update for the terminal (we're pretending it doesn't support
character deletion).

   If you would like to fully specify each window's termcap entry, you
should instead set the `$SCREENCAP' variable prior to running `screen'.
*Note Virtual Terminal::, for the details of the `screen' terminal
emulation.  *Note Termcap: (termcap)Top, for more information on
termcap definitions.


File: tscreen.info,  Node: Special Capabilities,  Next: Autonuke,  Prev: Termcap Examples,  Up: Termcap

16.5 Special Terminal Capabilities
==================================

The following table describes all terminal capabilities that are
recognized by `screen' and are not in the termcap manual (*note
Termcap: (termcap)Top.).  You can place these capabilities in your
termcap entries (in `/etc/termcap') or use them with the commands
`termcap', `terminfo' and `termcapinfo' in your `screenrc' files. It is
often not possible to place these capabilities in the terminfo database.
`LP'
     (bool)
     Terminal has VT100 style margins (`magic margins'). Note that this
     capability is obsolete -- `screen' now uses the standard `xn'
     instead.

`Z0'
     (str)
     Change width to 132 columns.

`Z1'
     (str)
     Change width to 80 columns.

`WS'
     (str)
     Resize display. This capability has the desired width and height as
     arguments.  SunView(tm) example: `\E[8;%d;%dt'.

`NF'
     (bool)
     Terminal doesn't need flow control. Send ^S and ^Q direct to the
     application. Same as `flow off'. The opposite of this capability
     is `nx'.

`G0'
     (bool)
     Terminal can deal with ISO 2022 font selection sequences.

`S0'
     (str)
     Switch charset `G0' to the specified charset. Default is `\E(%.'.

`E0'
     (str)
     Switch charset `G0' back to standard charset. Default is `\E(B'.

`C0'
     (str)
     Use the string as a conversion table for font 0. See the `ac'
     capability for more details.

`CS'
     (str)
     Switch cursor-keys to application mode.

`CE'
     (str)
     Switch cursor-keys to cursor mode.

`AN'
     (bool)
     Enable autonuke for displays of this terminal type.  (*note
     Autonuke::).

`OL'
     (num)
     Set the output buffer limit. See the `obuflimit' command (*note
     Obuflimit::) for more details.

`KJ'
     (str)
     Set the encoding of the terminal. See the `encoding' command
     (*note Character Processing::) for valid encodings.

`AF'
     (str)
     Change character foreground color in an ANSI conform way. This
     capability will almost always be set to `\E[3%dm' (`\E[3%p1%dm' on
     terminfo machines).

`AB'
     (str)
     Same as `AF', but change background color.

`AX'
     (bool)
     Does understand ANSI set default fg/bg color (`\E[39m / \E[49m').

`XC'
     (str)
     Describe a translation of characters to strings depending on the
     current font.  (*note Character Translation::).

`XT'
     (bool)
     Terminal understands special xterm sequences (OSC, mouse tracking).

`C8'
     (bool)
     Terminal needs bold to display high-intensity colors (e.g. Eterm).

`TF'
     (bool)
     Add missing capabilities to the termcap/info entry. (Set by
     default).


File: tscreen.info,  Node: Autonuke,  Next: Obuflimit,  Prev: Special Capabilities,  Up: Termcap

16.6 Autonuke
=============

 -- Command: autonuke STATE
     (none)
     Sets whether a clear screen sequence should nuke all the output
     that has not been written to the terminal. *Note Obuflimit::.
     This property is set per display, not per window.

 -- Command: defautonuke STATE
     (none)
     Same as the `autonuke' command except that the default setting for
     new displays is also changed. Initial setting is `off'.  Note that
     you can use the special `AN' terminal capability if you want to
     have a terminal type dependent setting.


File: tscreen.info,  Node: Obuflimit,  Next: Character Translation,  Prev: Autonuke,  Up: Termcap

16.7 Obuflimit
==============

 -- Command: obuflimit [LIMIT]
     (none)
     If the output buffer contains more bytes than the specified limit,
     no more data will be read from the windows. The default value is
     256. If you have a fast display (like `xterm'), you can set it to
     some higher value. If no argument is specified, the current
     setting is displayed.  This property is set per display, not per
     window.

 -- Command: defobuflimit LIMIT
     (none)
     Same as the `obuflimit' command except that the default setting
     for new displays is also changed. Initial setting is 256 bytes.
     Note that you can use the special `OL' terminal capability if you
     want to have a terminal type dependent limit.


File: tscreen.info,  Node: Character Translation,  Prev: Obuflimit,  Up: Termcap

16.8 Character Translation
==========================

`Screen' has a powerful mechanism to translate characters to arbitrary
strings depending on the current font and terminal type.  Use this
feature if you want to work with a common standard character set (say
ISO8851-latin1) even on terminals that scatter the more unusual
characters over several national language font pages.

   Syntax:

         XC=<CHARSET-MAPPING>{,,<CHARSET-MAPPING>}
         <CHARSET-MAPPING> := <DESIGNATOR><TEMPLATE>{,<MAPPING>}
         <MAPPING> := <CHAR-TO-BE-MAPPED><TEMPLATE-ARG>

   The things in braces may be repeated any number of times.

   A <CHARSET-MAPPING> tells screen how to map characters in font
<DESIGNATOR> (`B': Ascii, `A': UK, `K': german, etc.)  to strings.
Every <MAPPING> describes to what string a single character will be
translated. A template mechanism is used, as most of the time the codes
have a lot in common (for example strings to switch to and from another
charset). Each occurrence of `%' in <TEMPLATE> gets substituted with the
TEMPLATE-ARG specified together with the character. If your strings are
not similar at all, then use `%' as a template and place the full
string in <TEMPLATE-ARG>. A quoting mechanism was added to make it
possible to use a real `%'. The `\' character quotes the special
characters `\', `%', and `,'.

   Here is an example:

         termcap hp700 'XC=B\E(K%\E(B,\304[,\326\\\\,\334]'

   This tells `screen', how to translate ISOlatin1 (charset `B') upper
case umlaut characters on a `hp700' terminal that has a German charset.
`\304' gets translated to `\E(K[\E(B' and so on.  Note that this line
gets parsed *three* times before the internal lookup table is built,
therefore a lot of quoting is needed to create a single `\'.

   Another extension was added to allow more emulation: If a mapping
translates the unquoted `%' char, it will be sent to the terminal
whenever screen switches to the corresponding <DESIGNATOR>.  In this
special case the template is assumed to be just `%' because the charset
switch sequence and the character mappings normally haven't much in
common.

   This example shows one use of the extension:
         termcap xterm 'XC=K%,%\E(B,[\304,\\\\\326,]\334'

   Here, a part of the German (`K') charset is emulated on an xterm.
If screen has to change to the `K' charset, `\E(B' will be sent to the
terminal, i.e. the ASCII charset is used instead. The template is just
`%', so the mapping is straightforward: `[' to `\304', `\' to `\326',
and `]' to `\334'.


File: tscreen.info,  Node: Message Line,  Next: Logging,  Prev: Termcap,  Up: Top

17 The Message Line
*******************

`screen' displays informational messages and other diagnostics in a
"message line" at the bottom of the screen.  If your terminal has a
status line defined in its termcap, screen will use this for displaying
its messages, otherwise the last line of the screen will be temporarily
overwritten and output will be momentarily interrupted.  The message
line is automatically removed after a few seconds delay, but it can also
be removed early (on terminals without a status line) by beginning to
type.

* Menu:

* Privacy Message::             Using the message line from your program.
* Hardware Status Line::        Use the terminal's hardware status line.
* Last Message::                Redisplay the last message.
* Message Wait::                Control how long messages are displayed.


File: tscreen.info,  Node: Privacy Message,  Next: Hardware Status Line,  Up: Message Line

17.1 Using the message line from your program
=============================================

The message line facility can be used by an application running in the
current window by means of the ANSI "Privacy message" control sequence.
For instance, from within the shell, try something like:

     echo "^[^Hello world from window $WINDOW^[\"

   where `^[' is ASCII ESC and the `^' that follows it is a literal
caret or up-arrow.


File: tscreen.info,  Node: Hardware Status Line,  Next: Last Message,  Prev: Privacy Message,  Up: Message Line

17.2 Hardware Status Line
=========================

 -- Command: hardstatus [state]
 -- Command: hardstatus [`always']`lastline'|`message'|`ignore' [string]
 -- Command: hardstatus `string' [string]
     (none)
     This command configures the use and emulation of the terminal's
     hardstatus line. The first form toggles whether `screen' will use
     the hardware status line to display messages. If the flag is set
     to `off', these messages are overlaid in reverse video mode at the
     display line. The default setting is `on'.

     The second form tells screen what to do if the terminal doesn't
     have a hardstatus line (i.e. the termcap/terminfo capabilities
     "hs", "ts", "fs" and "ds" are not set). If the type `lastline' is
     used, screen will reserve the last line of the display for the
     hardstatus. `message' uses `screen''s message mechanism and
     `ignore' tells `screen' never to display the hardstatus.  If you
     prepend the word `always' to the type (e.g., `alwayslastline'),
     `screen' will use the type even if the terminal supports a
     hardstatus line.

     The third form specifies the contents of the hardstatus line.
     `%h' is used as default string, i.e., the stored hardstatus of the
     current window (settable via `ESC]0;^G' or `ESC_\\') is displayed.
     You can customize this to any string you like including string
     escapes (*note String Escapes::).  If you leave out the argument
     STRING, the current string is displayed.

     You can mix the second and third form by providing the string as
     additional argument.


File: tscreen.info,  Node: Last Message,  Next: Message Wait,  Prev: Hardware Status Line,  Up: Message Line

17.3 Display Last Message
=========================

 -- Command: lastmsg
     (`C-a m', `C-a C-m')
     Repeat the last message displayed in the message line.  Useful if
     you're typing when a message appears, because (unless your
     terminal has a hardware status line) the message goes away when
     you press a key.


File: tscreen.info,  Node: Message Wait,  Prev: Last Message,  Up: Message Line

17.4 Message Wait
=================

 -- Command: msgminwait sec
     (none)
     Defines the time `screen' delays a new message when another is
     currently displayed.  Defaults to 1 second.

 -- Command: msgwait sec
     (none)
     Defines the time a message is displayed, if `screen' is not
     disturbed by other activity.  Defaults to 5 seconds.


File: tscreen.info,  Node: Logging,  Next: Startup,  Prev: Message Line,  Up: Top

18 Logging
**********

This section describes the commands for keeping a record of your
session.

* Menu:

* Hardcopy::                    Dump the current screen to a file
* Log::                         Log the output of a window to a file


File: tscreen.info,  Node: Hardcopy,  Next: Log,  Up: Logging

18.1 hardcopy
=============

 -- Command: hardcopy [-h] [FILE]
     (`C-a h', `C-a C-h')
     Writes out the currently displayed image to the file FILE, or, if
     no filename is specified, to `hardcopy.N' in the default
     directory, where N is the number of the current window.  This
     either appends or overwrites the file if it exists, as determined
     by the `hardcopy_append' command.  If the option `-h' is
     specified, dump also the contents of the scrollback buffer.

 -- Command: hardcopy_append state
     (none)
     If set to `on', `screen' will append to the `hardcopy.N' files
     created by the command `hardcopy'; otherwise, these files are
     overwritten each time.

 -- Command: hardcopydir directory
     (none)
     Defines a directory where hardcopy files will be placed.  If
     unset, hardcopys are dumped in screen's current working directory.


File: tscreen.info,  Node: Log,  Prev: Hardcopy,  Up: Logging

18.2 log
========

 -- Command: deflog state
     (none)
     Same as the `log' command except that the default setting for new
     windows is changed.  Initial setting is `off'.

 -- Command: log [state]
     (`C-a H')
     Begins/ends logging of the current window to the file
     `screenlog.N' in the window's default directory, where N is the
     number of the current window.  This filename can be changed with
     the `logfile' command.  If no parameter is given, the logging
     state is toggled.  The session log is appended to the previous
     contents of the file if it already exists.  The current contents
     and the contents of the scrollback history are not included in the
     session log.  Default is `off'.

 -- Command: logfile filename
 -- Command: logfile flush secs
     (none)
     Defines the name the log files will get. The default is
     `screenlog.%n'.  The second form changes the number of seconds
     `screen' will wait before flushing the logfile buffer to the
     file-system. The default value is 10 seconds.

 -- Command: logtstamp [state]
 -- Command: logtstamp `after' secs
 -- Command: logtstamp `string' string
     (none)
     This command controls logfile time-stamp mechanism of screen. If
     time-stamps are turned `on', screen adds a string containing the
     current time to the logfile after two minutes of inactivity.  When
     output continues and more than another two minutes have passed, a
     second time-stamp is added to document the restart of the output.
     You can change this timeout with the second form of the command.
     The third form is used for customizing the time-stamp string (`--
     %n:%t -- time-stamp -- %M/%d/%y %c:%s --\n' by default).


File: tscreen.info,  Node: Startup,  Next: Miscellaneous,  Prev: Logging,  Up: Top

19 Startup
**********

This section describes commands which are only useful in the
`.screenrc' file, for use at startup.

* Menu:

* echo::                        Display a message.
* sleep::                       Pause execution of the `.screenrc'.
* Startup Message::             Control display of the copyright notice.


File: tscreen.info,  Node: echo,  Next: sleep,  Up: Startup

19.1 echo
=========

 -- Command: echo [`-n'] message
     (none)
     The echo command may be used to annoy `screen' users with a
     'message of the day'. Typically installed in a global screenrc.
     The option `-n' may be used to suppress the line feed.  See also
     `sleep'.  Echo is also useful for online checking of environment
     variables.


File: tscreen.info,  Node: sleep,  Next: Startup Message,  Prev: echo,  Up: Startup

19.2 sleep
==========

 -- Command: sleep num
     (none)
     This command will pause the execution of a .screenrc file for NUM
     seconds.  Keyboard activity will end the sleep.  It may be used to
     give users a chance to read the messages output by `echo'.


File: tscreen.info,  Node: Startup Message,  Prev: sleep,  Up: Startup

19.3 Startup Message
====================

 -- Command: startup_message state
     (none)
     Select whether you want to see the copyright notice during startup.
     Default is `on', as you probably noticed.


File: tscreen.info,  Node: Miscellaneous,  Next: String Escapes,  Prev: Startup,  Up: Top

20 Miscellaneous commands
*************************

The commands described here do not fit well under any of the other
categories.

* Menu:

* At::                          Execute a command at other displays or windows.
* Break::                       Send a break signal to the window.
* Debug::                       Suppress/allow debugging output.
* License::                     Display the disclaimer page.
* Nethack::                     Use `nethack'-like error messages.
* Nonblock::			Disable flow-control to a display.
* Number::                      Change the current window's number.
* Hidden::                      Toggle a windows hidden status.
* Silence::			Notify on inactivity.
* Time::                        Display the time and load average.
* Verbose::                     Display window creation commands.
* Version::                     Display the version of `screen'.
* Zombie::                      Keep dead windows.
* Printcmd::                    Set command for VT100 printer port emulation.
* Sorendition::			Change the text highlighting method.
* Attrcolor::			Map attributes to colors.
* Setsid::			Change process group management.
* Eval::			Parse and execute arguments.
* Maxwin::			Set the maximum window number.
* Backtick::			Program a command for a backtick string escape.
* Screen Saver::		Define a screen safer.
* Zmodem::			Define how screen treats zmodem requests.


File: tscreen.info,  Node: At,  Next: Break,  Up: Miscellaneous

20.1 At
=======

 -- Command: at [identifier][#|*|%] command [args]
     (none)
     Execute a command at other displays or windows as if it had been
     entered there.  `At' changes the context (the `current window' or
     `current display' setting) of the command. If the first parameter
     describes a non-unique context, the command will be executed
     multiple times. If the first parameter is of the form
     `IDENTIFIER*' then identifier is matched against user names.  The
     command is executed once for each display of the selected user(s).
     If the first parameter is of the form `IDENTIFIER%' identifier is
     matched against displays. Displays are named after the ttys they
     attach. The prefix `/dev/' or `/dev/tty' may be omitted from the
     identifier.  If IDENTIFIER has a `#' or nothing appended it is
     matched against window numbers and titles. Omitting an identifier
     in front of the `#', `*' or `%' character selects all users,
     displays or windows because a prefix-match is performed. Note that
     on the affected display(s) a short message will describe what
     happened.  Note that the `#' character works as a comment
     introducer when it is preceded by whitespace. This can be escaped
     by prefixing `#' with a `\'.  Permission is checked for the
     initiator of the `at' command, not for the owners of the affected
     display(s).  Caveat: When matching against windows, the command is
     executed at least once per window. Commands that change the
     internal arrangement of windows (like `other') may be called
     again. In shared windows the command will be repeated for each
     attached display. Beware, when issuing toggle commands like
     `login'!  Some commands (e.g. `\*Qprocess') require that a display
     is associated with the target windows.  These commands may not
     work correctly under `at' looping over windows.


File: tscreen.info,  Node: Break,  Next: Debug,  Prev: At,  Up: Miscellaneous

20.2 Break
==========

 -- Command: break [duration]
     (none)
     Send a break signal for DURATION*0.25 seconds to this window.  For
     non-Posix systems the time interval is rounded up to full seconds.
     Most useful if a character device is attached to the window rather
     than a shell process (*note Window Types::). The maximum duration
     of a break signal is limited to 15 seconds.

 -- Command: pow_break
     (none)
     Reopen the window's terminal line and send a break condition.

 -- Command: breaktype [tcsendbreak|TIOCSBRK|TCSBRK]
     (none)
     Choose one of the available methods of generating a break signal
     for terminal devices. This command should affect the current
     window only.  But it still behaves identical to `defbreaktype'.
     This will be changed in the future.  Calling `breaktype' with no
     parameter displays the break setting for the current window.

 -- Command: defbreaktype [tcsendbreak|TIOCSBRK|TCSBRK]
     (none)
     Choose one of the available methods of generating a break signal
     for terminal devices opened afterwards. The preferred methods are
     `tcsendbreak' and `TIOCSBRK'. The third, `TCSBRK', blocks the
     complete `screen' session for the duration of the break, but it
     may be the only way to generate long breaks. `tcsendbreak' and
     `TIOCSBRK' may or may not produce long breaks with spikes (e.g. 4
     per second). This is not only system dependent, this also differs
     between serial board drivers.  Calling `defbreaktype' with no
     parameter displays the current setting.


File: tscreen.info,  Node: Debug,  Next: License,  Prev: Break,  Up: Miscellaneous

20.3 Debug
==========

 -- Command: debug [on|off]
     (none)
     Turns runtime debugging on or off. If `screen' has been compiled
     with option `-DDEBUG' debugging is available and is turned on per
     default.  Note that this command only affects debugging output
     from the main `SCREEN' process correctly. Debug output from
     attacher processes can only be turned off once and forever.


File: tscreen.info,  Node: License,  Next: Nethack,  Prev: Debug,  Up: Miscellaneous

20.4 License
============

 -- Command: license
     (none)
     Display the disclaimer page. This is done whenever `screen' is
     started without options, which should be often enough.


File: tscreen.info,  Node: Nethack,  Next: Nonblock,  Prev: License,  Up: Miscellaneous

20.5 Nethack
============

 -- Command: nethack state
     (none)
     Changes the kind of error messages used by `screen'.  When you are
     familiar with the game `nethack', you may enjoy the nethack-style
     messages which will often blur the facts a little, but are much
     funnier to read. Anyway, standard messages often tend to be
     unclear as well.

     This option is only available if `screen' was compiled with the
     NETHACK flag defined (*note Installation::). The default setting
     is then determined by the presence of the environment variable
     `$NETHACKOPTIONS'.


File: tscreen.info,  Node: Nonblock,  Next: Number,  Prev: Nethack,  Up: Miscellaneous

20.6 Nonblock
=============

 -- Command: nonblock [STATE|NUMSECS]
     Tell screen how to deal with user interfaces (displays) that cease
     to accept output. This can happen if a user presses ^S or a
     TCP/modem connection gets cut but no hangup is received. If
     nonblock is `off' (this is the default) screen waits until the
     display restarts to accept the output. If nonblock is `on', screen
     waits until the timeout is reached (`on' is treated as 1s). If the
     display still doesn't receive characters, screen will consider it
     "blocked" and stop sending characters to it. If at some time it
     restarts to accept characters, screen will unblock the display and
     redisplay the updated window contents.

 -- Command: defnonblock STATE|NUMSECS
     Same as the `nonblock' command except that the default setting for
     displays is changed. Initial setting is `off'.


File: tscreen.info,  Node: Number,  Next: Hidden,  Prev: Nonblock,  Up: Miscellaneous

20.7 Number
===========

 -- Command: number [N]
     (`C-a N')
     Change the current window's number. If the given number N is
     already used by another window, both windows exchange their
     numbers. If no argument is specified, the current window number
     (and title) is shown.


File: tscreen.info,  Node: Hidden,  Next: Silence,  Prev: Number,  Up: Miscellaneous

20.8 Hidden
===========

 -- Command: hide [N]
     (none)
     Toggles hiding of the specified window *Note Selecting::. If no
     window is specified then the current window will be toggled. When
     a window is hidden the commands `next', `prev' and `other' will
     skip the window and the window will have a status flag of `^'.


File: tscreen.info,  Node: Silence,  Next: Time,  Prev: Hidden,  Up: Miscellaneous

20.9 Silence
============

 -- Command: silence [STATE|SEC]
     (none)
     Toggles silence monitoring of windows. When silence is turned on
     and an affected window is switched into the background, you will
     receive the silence notification message in the status line after
     a specified period of inactivity (silence). The default timeout
     can be changed with the `silencewait' command or by specifying a
     number of seconds instead of `on' or `off'. Silence is initially
     off for all windows.

 -- Command: defsilence state
     (none)
     Same as the `silence' command except that the default setting for
     new windows is changed.  Initial setting is `off'.

 -- Command: silencewait SECONDS
     (none)
     Define the time that all windows monitored for silence should wait
     before displaying a message. Default is 30 seconds.


File: tscreen.info,  Node: Time,  Next: Verbose,  Prev: Silence,  Up: Miscellaneous

20.10 Time
==========

 -- Command: time [STRING]
     (`C-a t', `C-a C-t')
     Uses the message line to display the time of day, the host name,
     and the load averages over 1, 5, and 15 minutes (if this is
     available on your system).  For window-specific information use
     `info' (*note Info::).  If a STRING is specified, it changes the
     format of the time report like it is described in the string
     escapes chapter (*note String Escapes::). Screen uses a default of
     `%c:%s %M %d %H%? %l%?'.


File: tscreen.info,  Node: Verbose,  Next: Version,  Prev: Time,  Up: Miscellaneous

20.11 Verbose
=============

 -- Command: verbose [on|off]
     If verbose is switched on, the command name is echoed, whenever a
     window is created (or resurrected from zombie state). Default is
     off.  Without parameter, the current setting is shown.


File: tscreen.info,  Node: Version,  Next: Zombie,  Prev: Verbose,  Up: Miscellaneous

20.12 Version
=============

 -- Command: version
     (`C-a v')
     Display the version and modification date in the message line.


File: tscreen.info,  Node: Zombie,  Next: Printcmd,  Prev: Version,  Up: Miscellaneous

20.13 Zombie
============

 -- Command: zombie [KEYS [onerror] ]
 -- Command: defzombie [KEYS]
     (none)
     Per default windows are removed from the window list as soon as the
     windows process (e.g. shell) exits. When a string of two keys is
     specified to the zombie command, `dead' windows will remain in the
     list.  The `kill' command may be used to remove the window.
     Pressing the first key in the dead window has the same effect.
     Pressing the second key, however, screen will attempt to resurrect
     the window. The process that was initially running in the window
     will be launched again. Calling `zombie' without parameters will
     clear the zombie setting, thus making windows disappear when the
     process terminates.

     As the zombie setting is affected globally for all windows, this
     command should only be called `defzombie'. Until we need this as a
     per window setting, the commands `zombie' and `defzombie' are
     synonymous.

     Optionally you can put the word `onerror' after the keys. This will
     cause screen to monitor exit status of the process running in the
     window.  If it exits normally ('0'), the window disappears. Any
     other exit value causes the window to become a zombie.


File: tscreen.info,  Node: Printcmd,  Next: Sorendition,  Prev: Zombie,  Up: Miscellaneous

20.14 Printcmd
==============

 -- Command: printcmd [CMD]
     (none)
     If CMD is not an empty string, screen will not use the terminal
     capabilities `po/pf' for printing if it detects an ansi print
     sequence `ESC [ 5 i', but pipe the output into CMD.  This should
     normally be a command like `lpr' or `cat > /tmp/scrprint'.
     `Printcmd' without an argument displays the current setting.  The
     ansi sequence `ESC \' ends printing and closes the pipe.

     Warning: Be careful with this command! If other user have write
     access to your terminal, they will be able to fire off print
     commands.


File: tscreen.info,  Node: Sorendition,  Next: Attrcolor,  Prev: Printcmd,  Up: Miscellaneous

20.15 Sorendition
=================

 -- Command: sorendition [ATTR [COLOR]]
     (none)
     Change the way screen does highlighting for text marking and
     printing messages.  See the chapter about string escapes (*note
     String Escapes::) for the syntax of the modifiers. The default is
     currently `=s dd' (standout, default colors).


File: tscreen.info,  Node: Attrcolor,  Next: Setsid,  Prev: Sorendition,  Up: Miscellaneous

20.16 Attrcolor
===============

 -- Command: attrcolor ATTRIB [ATTRIBUTE/COLOR-MODIFIER]
     (none)
     This command can be used to highlight attributes by changing the
     color of the text. If the attribute ATTRIB is in use, the
     specified attribute/color modifier is also applied. If no modifier
     is given, the current one is deleted. See the chapter about string
     escapes (*note String Escapes::) for the syntax of the modifier.
     Screen understands two pseudo-attributes, `i' stands for
     high-intensity foreground color and `I' for high-intensity
     background color.

     Examples:
    `attrcolor b "R"'
          Change the color to bright red if bold text is to be printed.

    `attrcolor u "-u b"'
          Use blue text instead of underline.

    `attrcolor b ".I"'
          Use bright colors for bold text. Most terminal emulators do
          this already.

    `attrcolor i "+b"'
          Make bright colored text also bold.


File: tscreen.info,  Node: Setsid,  Next: Eval,  Prev: Attrcolor,  Up: Miscellaneous

20.17 Setsid
============

 -- Command: setsid state
     (none)
     Normally screen uses different sessions and process groups for the
     windows. If setsid is turned `off', this is not done anymore and
     all windows will be in the same process group as the screen
     backend process. This also breaks job-control, so be careful.  The
     default is `on', of course. This command is probably useful only
     in rare circumstances.


File: tscreen.info,  Node: Eval,  Next: Maxwin,  Prev: Setsid,  Up: Miscellaneous

20.18 Eval
==========

 -- Command: eval COMMAND1 [COMMAND2 ...]
     (none)
     Parses and executes each argument as separate command.


File: tscreen.info,  Node: Maxwin,  Next: Backtick,  Prev: Eval,  Up: Miscellaneous

20.19 Maxwin
============

 -- Command: maxwin N
     (none)
     Set the maximum window number screen will create. Doesn't affect
     already existing windows. The number may only be decreased.


File: tscreen.info,  Node: Backtick,  Next: Screen Saver,  Prev: Maxwin,  Up: Miscellaneous

20.20 Backtick
==============

 -- Command: backtick ID LIFESPAN AUTOREFRESH COMMAND [ARGS]
 -- Command: backtick ID
     (none)
     Program the backtick command with the numerical id ID.  The output
     of such a command is used for substitution of the `%`' string
     escape (*note String Escapes::).  The specified LIFESPAN is the
     number of seconds the output is considered valid. After this time,
     the command is run again if a corresponding string escape is
     encountered.  The AUTOREFRESH parameter triggers an automatic
     refresh for caption and hardstatus strings after the specified
     number of seconds. Only the last line of output is used for
     substitution.

     If both the LIFESPAN and the AUTOREFRESH parameters are zero, the
     backtick program is expected to stay in the background and
     generate output once in a while.  In this case, the command is
     executed right away and screen stores the last line of output. If
     a new line gets printed screen will automatically refresh the
     hardstatus or the captions.

     The second form of the command deletes the backtick command with
     the numerical id ID.


File: tscreen.info,  Node: Screen Saver,  Next: Zmodem,  Prev: Backtick,  Up: Miscellaneous

20.21 Screen Saver
==================

 -- Command: idle [TIMEOUT [CMD ARGS]]
     (none)
     Sets a command that is run after the specified number of seconds
     inactivity is reached. This command will normally be the `blanker'
     command to create a screen blanker, but it can be any screen
     command. If no command is specified, only the timeout is set. A
     timeout of zero (ot the special timeout `off') disables the timer.
     If no arguments are given, the current settings are displayed.

 -- Command: blanker
     (none)
     Activate the screen blanker. First the screen is cleared.  If no
     blanker program is defined, the cursor is turned off, otherwise,
     the program is started and it's output is written to the screen.
     The screen blanker is killed with the first keypress, the read key
     is discarded.

     This command is normally used together with the `idle' command.

 -- Command: blankerprg [PROGRAM ARGS]
     Defines a blanker program. Disables the blanker program if no
     arguments are given.


File: tscreen.info,  Node: Zmodem,  Prev: Screen Saver,  Up: Miscellaneous

20.22 Zmodem
============

 -- Command: zmodem [off|auto|catch|pass]
 -- Command: zmodem sendcmd [string]
 -- Command: zmodem recvcmd [string]
     (none)
     Define zmodem support for screen. Screen understands two different
     modes when it detects a zmodem request: `pass' and `catch'. If the
     mode is set to `pass', screen will relay all data to the attacher
     until the end of the transmission is reached. In `catch' mode
     screen acts as a zmodem endpoint and starts the corresponding
     rz/sz commands.  If the mode is set to `auto', screen will use
     `catch' if the window is a tty (e.g. a serial line), otherwise it
     will use `pass'.

     You can define the templates screen uses in `catch' mode via the
     second and the third form.

     Note also that this is an experimental feature.


File: tscreen.info,  Node: String Escapes,  Next: Environment,  Prev: Miscellaneous,  Up: Top

21 String Escapes
*****************

Screen provides an escape mechanism to insert information like the
current time into messages or file names. The escape character is `%'
with one exception: inside of a window's hardstatus `^%' (`^E') is used
instead.

   Here is the full list of supported escapes:

`%'
     the escape character itself

`a'
     either `am' or `pm'

`A'
     either `AM' or `PM'

`c'
     current time `HH:MM' in 24h format

`C'
     current time `HH:MM' in 12h format

`d'
     day number

`D'
     weekday name

`f'
     flags of the window

`F'
     sets %? to true if the window has the focus

`h'
     hardstatus of the window

`H'
     hostname of the system

`l'
     current load of the system

`m'
     month number

`M'
     month name

`n'
     window number

`s'
     seconds

`S'
     session name

`t'
     window title

`u'
     all other users on this window

`w'
     all window numbers and names. With `-' qualifier: up to the current
     window; with `+' qualifier: starting with the window after the
     current one.

`W'
     all window numbers and names except the current one

`y'
     last two digits of the year number

`Y'
     full year number

`?'
     the part to the next `%?' is displayed only if a `%' escape inside
     the part expands to a non-empty string

`:'
     else part of `%?'

`='
     pad the string to the display's width (like TeX's hfill). If a
     number is specified, pad to the percentage of the window's width.
     A `0' qualifier tells screen to treat the number as absolute
     position.  You can specify to pad relative to the last absolute
     pad position by adding a `+' qualifier or to pad relative to the
     right margin by using `-'. The padding truncates the string if the
     specified position lies before the current position. Add the `L'
     qualifier to change this.

`<'
     same as `%=' but just do truncation, do not fill with spaces

`>'
     mark the current text position for the next truncation. When
     screen needs to do truncation, it tries to do it in a way that the
     marked position gets moved to the specified percentage of the
     output area. (The area starts from the last absolute pad position
     and ends with the position specified by the truncation operator.)
     The `L' qualifier tells screen to mark the truncated parts with
     `...'.

`{'
     attribute/color modifier string terminated by the next `}'

``'
     Substitute with the output of a `backtick' command. The length
     qualifier is misused to identify one of the commands. *Note
     Backtick::.
   The `c' and `C' escape may be qualified with a `0' to make screen use
zero instead of space as fill character.  The `n' and `=' escapes
understand a length qualifier (e.g. `%3n'), `D' and `M' can be prefixed
with `L' to generate long names, `w' and `W' also show the window flags
if `L' is given.

   An attribute/color modifier is is used to change the attributes or
the color settings. Its format is `[attribute modifier] [color
description]'. The attribute modifier must be prefixed by a change type
indicator if it can be confused with a color description. The following
change types are known:
`+'
     add the specified set to the current attributes

`-'
     remove the set from the current attributes

`!'
     invert the set in the current attributes

`='
     change the current attributes to the specified set
   The attribute set can either be specified as a hexadecimal number or
a combination of the following letters:
`d'
     dim

`u'
     underline

`b'
     bold

`r'
     reverse

`s'
     standout

`B'
     blinking
   Colors are coded either as a hexadecimal number or two letters
specifying the desired background and foreground color (in that order).
The following colors are known:
`k'
     black

`r'
     red

`g'
     green

`y'
     yellow

`b'
     blue

`m'
     magenta

`c'
     cyan

`w'
     white

`d'
     default color

`.'
     leave color unchanged
   The capitalized versions of the letter specify bright colors. You
can also use the pseudo-color `i' to set just the brightness and leave
the color unchanged.

   A one digit/letter color description is treated as foreground or
background color dependent on the current attributes: if reverse mode is
set, the background color is changed instead of the foreground color.
If you don't like this, prefix the color with a `.'. If you want the
same behavior for two-letter color descriptions, also prefix them with
a `.'.

   As a special case, `%{-}' restores the attributes and colors that
were set before the last change was made (i.e. pops one level of the
color-change stack).

Examples:
`G'
     set color to bright green

`+b r'
     use bold red

`= yd'
     clear all attributes, write in default color on yellow background.

`%-Lw%{= BW}%50>%n%f* %t%{-}%+Lw%<'
     The available windows centered at the current win dow and
     truncated to the available width. The current window is displayed
     white on blue.  This can be used with `hardstatus alwayslastline'.

`%?%F%{.R.}%?%3n %t%? [%h]%?'
     The window number and title and the window's hardstatus, if one is
     set.  Also use a red background if this is the active focus.
     Useful for `caption string'.


File: tscreen.info,  Node: Environment,  Next: Files,  Prev: String Escapes,  Up: Top

22 Environment Variables
************************

`COLUMNS'
     Number of columns on the terminal (overrides termcap entry).

`HOME'
     Directory in which to look for .screenrc.

`LINES'
     Number of lines on the terminal (overrides termcap entry).

`LOCKPRG'
     Screen lock program.

`NETHACKOPTIONS'
     Turns on `nethack' option.

`PATH'
     Used for locating programs to run.

`SCREENCAP'
     For customizing a terminal's `TERMCAP' value.

`SCREENDIR'
     Alternate socket directory.

`SCREENRC'
     Alternate user screenrc file.

`SHELL'
     Default shell program for opening windows (default `/bin/sh').

`STY'
     Alternate socket name. If `screen' is invoked, and the environment
     variable `STY' is set, then it creates only a window in the
     running `screen' session rather than starting a new session.

`SYSSCREENRC'
     Alternate system screenrc file.

`TERM'
     Terminal name.

`TERMCAP'
     Terminal description.

`WINDOW'
     Window number of a window (at creation time).


File: tscreen.info,  Node: Files,  Next: Credits,  Prev: Environment,  Up: Top

23 Files Referenced
*******************

`.../screen-4.?.??/etc/screenrc'
`.../screen-4.?.??/etc/etcscreenrc'
     Examples in the `screen' distribution package for private and
     global initialization files.

``$SYSSCREENRC''
`/local/etc/screenrc'
     `screen' initialization commands

``$SCREENRC''
``$HOME'/.iscreenrc'
``$HOME'/.screenrc'
     Read in after /local/etc/screenrc

``$SCREENDIR'/S-LOGIN'

`/local/screens/S-LOGIN'
     Socket directories (default)

`/usr/tmp/screens/S-LOGIN'
     Alternate socket directories.

`SOCKET DIRECTORY/.termcap'
     Written by the `dumptermcap' command

`/usr/tmp/screens/screen-exchange or'
`/tmp/screen-exchange'
     `screen' interprocess communication buffer

`hardcopy.[0-9]'
     Screen images created by the hardcopy command

`screenlog.[0-9]'
     Output log files created by the log command

`/usr/lib/terminfo/?/* or'
`/etc/termcap'
     Terminal capability databases

`/etc/utmp'
     Login records

``$LOCKPRG''
     Program for locking the terminal.


File: tscreen.info,  Node: Credits,  Next: Bugs,  Prev: Files,  Up: Top

24 Credits
**********

Authors
=======

   Originally created by Oliver Laumann, this latest version was
produced by Wayne Davison, Juergen Weigert and Michael Schroeder.

Contributors
============

          Ken Beal (kbeal@amber.ssd.csd.harris.com),
          Rudolf Koenig (rfkoenig@informatik.uni-erlangen.de),
          Toerless Eckert (eckert@informatik.uni-erlangen.de),
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
          Jason Merrill (jason@jarthur.Claremont.EDU),
          Johannes Zellner (johannes@zellner.org),
          Pablo Averbuj (pablo@averbuj.com).

Version
=======

   This manual describes version 4.1.0 of the `screen' program. Its
roots are a merge of a custom version 2.3PR7 by Wayne Davison and
several enhancements to Oliver Laumann's version 2.0.  Note that all
versions numbered 2.x are copyright by Oliver Laumann.

   See also *Note Availability::.


File: tscreen.info,  Node: Bugs,  Next: Installation,  Prev: Credits,  Up: Top

25 Bugs
*******

Just like any other significant piece of software, `screen' has a few
bugs and missing features.  Please send in a bug report if you have
found a bug not mentioned here.

* Menu:

* Known Bugs::                  Problems we know about.
* Reporting Bugs::              How to contact the maintainers.
* Availability::                Where to find the latest screen version.


File: tscreen.info,  Node: Known Bugs,  Next: Reporting Bugs,  Up: Bugs

25.1 Known Bugs
===============

   * `dm' (delete mode) and `xs' are not handled correctly (they are
     ignored).  `xn' is treated as a magic-margin indicator.

   * `screen' has no clue about double-high or double-wide characters.
     But this is the only area where `vttest' is allowed to fail.

   * It is not possible to change the environment variable `$TERMCAP'
     when reattaching under a different terminal type.

   * The support of terminfo based systems is very limited. Adding extra
     capabilities to `$TERMCAP' may not have any effects.

   * `screen' does not make use of hardware tabs.

   * `screen' must be installed setuid root on most systems in order to
     be able to correctly change the owner of the tty device file for
     each window.  Special permission may also be required to write the
     file `/etc/utmp'.

   * Entries in `/etc/utmp' are not removed when `screen' is killed
     with SIGKILL.  This will cause some programs (like "w" or "rwho")
     to advertise that a user is logged on who really isn't.

   * `screen' may give a strange warning when your tty has no utmp
     entry.

   * When the modem line was hung up, `screen' may not automatically
     detach (or quit) unless the device driver sends a HANGUP signal.
     To detach such a `screen' session use the -D or -d command line
     option.

   * If a password is set, the command line options -d and -D still
     detach a session without asking.

   * Both `breaktype' and `defbreaktype' change the break generating
     method used by all terminal devices. The first should change a
     window specific setting, where the latter should change only the
     default for new windows.

   * When attaching to a multiuser session, the user's `.screenrc' file
     is not sourced. Each users personal settings have to be included
     in the `.screenrc' file from which the session is booted, or have
     to be changed manually.

   * A weird imagination is most useful to gain full advantage of all
     the features.


File: tscreen.info,  Node: Reporting Bugs,  Next: Availability,  Prev: Known Bugs,  Up: Bugs

25.2 Reporting Bugs
===================

If you find a bug in `Screen', please send electronic mail to
`screen@uni-erlangen.de', and also to `bug-gnu-utils@prep.ai.mit.edu'.
Include the version number of `Screen' which you are using.  Also
include in your message the hardware and operating system, the compiler
used to compile, a description of the bug behavior, and the conditions
that triggered the bug. Please recompile `screen' with the `-DDEBUG'
options enabled, reproduce the bug, and have a look at the debug output
written to the directory `/tmp/debug'. If necessary quote suspect
passages from the debug output and show the contents of your `config.h'
if it matters.


File: tscreen.info,  Node: Availability,  Prev: Reporting Bugs,  Up: Bugs

25.3 Availability
=================

`Screen' is available under the `GNU' copyleft.

   The latest official release of `screen' available via anonymous ftp
from `prep.ai.mit.edu', `nic.funet.fi' or any other `GNU' distribution
site.  The home site of `screen' is `ftp.uni-erlangen.de
(131.188.3.71)', in the directory `pub/utilities/screen'.  The
subdirectory `private' contains the latest beta testing release.  If
you want to help, send a note to screen@uni-erlangen.de.


File: tscreen.info,  Node: Installation,  Next: Concept Index,  Prev: Bugs,  Up: Top

26 Installation
***************

Since `screen' uses pseudo-ttys, the select system call, and
UNIX-domain sockets/named pipes, it will not run under a system that
does not include these features of 4.2 and 4.3 BSD UNIX.

* Menu:

* Socket Directory::		Where screen stores its handle.
* Compiling Screen::


File: tscreen.info,  Node: Socket Directory,  Next: Compiling Screen,  Up: Installation

26.1 Socket Directory
=====================

The socket directory defaults either to `$HOME/.screen' or simply to
`/tmp/screens' or preferably to `/usr/local/screens' chosen at
compile-time. If `screen' is installed setuid root, then the
administrator should compile screen with an adequate (not NFS mounted)
`SOCKDIR'. If `screen' is not running setuid-root, the user can specify
any mode 700 directory in the environment variable `$SCREENDIR'.


File: tscreen.info,  Node: Compiling Screen,  Prev: Socket Directory,  Up: Installation

26.2 Compiling Screen
=====================

To compile and install screen:

   The `screen' package comes with a `GNU Autoconf' configuration
script. Before you compile the package run

                           `sh ./configure'

   This will create a `config.h' and `Makefile' for your machine.  If
`configure' fails for some reason, then look at the examples and
comments found in the `Makefile.in' and `config.h.in' templates.
Rename `config.status' to `config.status.MACHINE' when you want to keep
configuration data for multiple architectures. Running `sh
./config.status.MACHINE' recreates your configuration significantly
faster than rerunning `configure'.
Read through the "User Configuration" section of `config.h', and verify
that it suits your needs.  A comment near the top of this section
explains why it's best to install screen setuid to root.  Check for the
place for the global `screenrc'-file and for the socket directory.
Check the compiler used in `Makefile', the prefix path where to install
`screen'. Then run

                                `make'

   If `make' fails to produce one of the files `term.h', `comm.h' or
`tty.c', then use `FILENAME.X.dist' instead.  For additional
information about installation of `screen' refer to the file
`INSTALLATION', coming with this package.


File: tscreen.info,  Node: Concept Index,  Next: Command Index,  Prev: Installation,  Up: Top

Concept Index
*************

 [index ]
* Menu:

* .screenrc:                             Startup Files.         (line 6)
* availability:                          Availability.          (line 6)
* binding:                               Key Binding.           (line 6)
* bug report:                            Reporting Bugs.        (line 6)
* bugs:                                  Bugs.                  (line 6)
* capabilities:                          Special Capabilities.  (line 6)
* command character:                     Command Character.     (line 3)
* command line options:                  Invoking Screen.       (line 6)
* command summary:                       Command Summary.       (line 6)
* compiling screen:                      Compiling Screen.      (line 6)
* control sequences:                     Control Sequences.     (line 6)
* copy and paste:                        Copy and Paste.        (line 6)
* customization:                         Customization.         (line 6)
* environment:                           Environment.           (line 6)
* escape character:                      Command Character.     (line 3)
* files:                                 Files.                 (line 6)
* flow control:                          Flow Control.          (line 6)
* input translation:                     Input Translation.     (line 6)
* installation:                          Installation.          (line 6)
* introduction:                          Getting Started.       (line 6)
* invoking:                              Invoking Screen.       (line 6)
* key binding:                           Key Binding.           (line 6)
* marking:                               Copy.                  (line 6)
* message line:                          Message Line.          (line 6)
* multiuser session:                     Multiuser Session.     (line 6)
* options:                               Invoking Screen.       (line 6)
* overview:                              Overview.              (line 6)
* regions:                               Regions.               (line 6)
* screenrc:                              Startup Files.         (line 6)
* scrollback:                            Copy.                  (line 6)
* socket directory:                      Socket Directory.      (line 6)
* string escapes:                        String Escapes.        (line 6)
* terminal capabilities:                 Special Capabilities.  (line 6)
* title:                                 Naming Windows.        (line 6)
* window types:                          Window Types.          (line 6)


File: tscreen.info,  Node: Command Index,  Next: Keystroke Index,  Prev: Concept Index,  Up: Top

Command Index
*************

This is a list of all the commands supported by `screen'.

 [index ]
* Menu:

* acladd:                                Acladd.               (line  7)
* aclchg:                                Aclchg.               (line  7)
* acldel:                                Acldel.               (line  7)
* aclgrp:                                Aclgrp.               (line  7)
* aclumask:                              Umask.                (line  7)
* activity:                              Monitor.              (line  7)
* addacl:                                Acladd.               (line  8)
* allpartial:                            Redisplay.            (line  7)
* altscreen:                             Redisplay.            (line 17)
* at:                                    At.                   (line  7)
* attrcolor:                             Attrcolor.            (line  7)
* autodetach:                            Detach.               (line  7)
* autonuke:                              Autonuke.             (line  7)
* backtick:                              Backtick.             (line  7)
* bce:                                   Character Processing. (line 26)
* bell_msg:                              Bell.                 (line  7)
* bind:                                  Bind.                 (line  7)
* bindkey:                               Bindkey.              (line  7)
* blanker:                               Screen Saver.         (line 16)
* blankerprg:                            Screen Saver.         (line 26)
* break:                                 Break.                (line  7)
* breaktype:                             Break.                (line 19)
* bufferfile:                            Screen Exchange.      (line  7)
* c1:                                    Character Processing. (line  7)
* caption:                               Caption.              (line  7)
* chacl:                                 Aclchg.               (line  8)
* charset:                               Character Processing. (line 51)
* chdir:                                 Chdir.                (line  7)
* clear:                                 Clear.                (line  7)
* colon:                                 Colon.                (line  9)
* command:                               Command Character.    (line 33)
* compacthist:                           Scrollback.           (line 18)
* console:                               Console.              (line  7)
* copy:                                  Copy.                 (line  7)
* copy_reg:                              Registers.            (line  7)
* crlf:                                  Line Termination.     (line  7)
* debug:                                 Debug.                (line  7)
* defautonuke:                           Autonuke.             (line 13)
* defbce:                                Character Processing. (line 83)
* defbreaktype:                          Break.                (line 27)
* defc1:                                 Character Processing. (line 73)
* defcharset:                            Character Processing. (line 94)
* defencoding:                           Character Processing. (line 88)
* defescape:                             Command Character.    (line 18)
* defflow:                               Flow.                 (line  7)
* defgr:                                 Character Processing. (line 78)
* defhstatus:                            Hardstatus.           (line 14)
* deflog:                                Log.                  (line  7)
* deflogin:                              Login.                (line  7)
* defmode:                               Mode.                 (line  7)
* defmonitor:                            Monitor.              (line 22)
* defnonblock:                           Nonblock.             (line 19)
* defobuflimit:                          Obuflimit.            (line 16)
* defscrollback:                         Scrollback.           (line  7)
* defshell:                              Shell.                (line  8)
* defsilence:                            Silence.              (line 17)
* defslowpaste:                          Paste.                (line 40)
* defutf8:                               Character Processing. (line 99)
* defwrap:                               Wrap.                 (line 15)
* defwritelock:                          Writelock.            (line 19)
* defzombie:                             Zombie.               (line  8)
* detach:                                Detach.               (line 15)
* digraph:                               Digraph.              (line  7)
* dinfo:                                 Info.                 (line 41)
* displays:                              Displays.             (line  7)
* dumptermcap:                           Dump Termcap.         (line  7)
* echo:                                  echo.                 (line  7)
* encoding:                              Character Processing. (line 33)
* escape:                                Command Character.    (line  7)
* eval:                                  Eval.                 (line  7)
* exec:                                  Exec.                 (line  7)
* fit:                                   Fit.                  (line  7)
* flow:                                  Flow.                 (line 15)
* focus:                                 Focus.                (line  7)
* gr:                                    Character Processing. (line 18)
* hardcopy:                              Hardcopy.             (line  7)
* hardcopy_append:                       Hardcopy.             (line 16)
* hardcopydir:                           Hardcopy.             (line 22)
* hardstatus:                            Hardware Status Line. (line  7)
* height:                                Window Size.          (line 17)
* help:                                  Help.                 (line  7)
* hide:                                  Hidden.               (line  7)
* history:                               History.              (line  7)
* hstatus:                               Hardstatus.           (line 26)
* idle:                                  Screen Saver.         (line  7)
* ignorecase:                            Searching.            (line 15)
* info:                                  Info.                 (line  7)
* ins_reg:                               Registers.            (line 11)
* kill:                                  Kill.                 (line  7)
* lastmsg:                               Last Message.         (line  7)
* license:                               License.              (line  7)
* lockscreen:                            Lock.                 (line  7)
* log:                                   Log.                  (line 12)
* logfile:                               Log.                  (line 23)
* login:                                 Login.                (line 14)
* logtstamp:                             Log.                  (line 31)
* mapdefault:                            Bindkey Control.      (line  7)
* mapnotnext:                            Bindkey Control.      (line 12)
* maptimeout:                            Bindkey Control.      (line 16)
* markkeys:                              Copy Mode Keys.       (line  7)
* maxwin:                                Maxwin.               (line  7)
* meta:                                  Command Character.    (line 26)
* monitor:                               Monitor.              (line 27)
* msgminwait:                            Message Wait.         (line  7)
* msgwait:                               Message Wait.         (line 12)
* multiuser:                             Multiuser.            (line  7)
* nethack:                               Nethack.              (line  7)
* next:                                  Next and Previous.    (line  7)
* nonblock:                              Nonblock.             (line  7)
* number:                                Number.               (line  7)
* obuflimit:                             Obuflimit.            (line  7)
* only:                                  Only.                 (line  7)
* other:                                 Other Window.         (line  7)
* partial:                               Redisplay.            (line 22)
* password:                              Detach.               (line 23)
* paste:                                 Paste.                (line  7)
* pastefont:                             Paste.                (line 34)
* pow_break:                             Break.                (line 15)
* pow_detach:                            Power Detach.         (line  7)
* pow_detach_msg:                        Power Detach.         (line 14)
* prev:                                  Next and Previous.    (line 14)
* printcmd:                              Printcmd.             (line  7)
* process:                               Registers.            (line 15)
* quit:                                  Quit.                 (line  7)
* readbuf:                               Screen Exchange.      (line 19)
* readreg:                               Paste.                (line 50)
* redisplay:                             Redisplay.            (line 31)
* register:                              Registers.            (line 23)
* remove:                                Remove.               (line  7)
* removebuf:                             Screen Exchange.      (line 25)
* reset:                                 Reset.                (line  7)
* resize:                                Resize.               (line  7)
* screen:                                Screen Command.       (line  7)
* scrollback:                            Scrollback.           (line 12)
* select:                                Select.               (line  7)
* sessionname:                           Session Name.         (line  7)
* setenv:                                Setenv.               (line  7)
* setsid:                                Setsid.               (line  7)
* shell:                                 Shell.                (line  7)
* shelltitle:                            Shell.                (line 18)
* silence:                               Silence.              (line  7)
* silencewait:                           Silence.              (line 22)
* sleep:                                 sleep.                (line  7)
* slowpaste:                             Paste.                (line 39)
* sorendition:                           Sorendition.          (line  7)
* source:                                Source.               (line  7)
* split:                                 Split.                (line  7)
* startup_message:                       Startup Message.      (line  7)
* stuff:                                 Paste.                (line 27)
* su:                                    Su.                   (line  7)
* suspend:                               Suspend.              (line  7)
* term:                                  Term.                 (line  7)
* termcap:                               Termcap Syntax.       (line  7)
* termcapinfo:                           Termcap Syntax.       (line  9)
* terminfo:                              Termcap Syntax.       (line  8)
* time:                                  Time.                 (line  7)
* title:                                 Title Command.        (line  7)
* umask:                                 Umask.                (line  8)
* unsetenv:                              Setenv.               (line 15)
* utf8:                                  Character Processing. (line 64)
* vbell:                                 Bell.                 (line 23)
* vbell_msg:                             Bell.                 (line 35)
* vbellwait:                             Bell.                 (line 43)
* verbose:                               Verbose.              (line  7)
* version:                               Version.              (line  7)
* wall:                                  Wall.                 (line  7)
* width:                                 Window Size.          (line  7)
* windowlist:                            Windowlist.           (line  7)
* windows:                               Windows.              (line  7)
* wrap:                                  Wrap.                 (line  7)
* writebuf:                              Screen Exchange.      (line 29)
* writelock:                             Writelock.            (line  7)
* xoff:                                  XON/XOFF.             (line 12)
* xon:                                   XON/XOFF.             (line  7)
* zmodem:                                Zmodem.               (line  7)
* zombie:                                Zombie.               (line  7)


File: tscreen.info,  Node: Keystroke Index,  Prev: Command Index,  Up: Top

Keystroke Index
***************

This is a list of the default key bindings.

   The leading escape character (*note Command Character::) has been
omitted from the key sequences, since it is the same for all bindings.

 [index ]
* Menu:

* ":                                     Windowlist.           (line  6)
* ':                                     Select.               (line  6)
* *:                                     Displays.             (line  6)
* .:                                     Dump Termcap.         (line  6)
* 0...9:                                 Select.               (line  6)
* ::                                     Colon.                (line  8)
* <:                                     Screen Exchange.      (line 18)
* =:                                     Screen Exchange.      (line 24)
* >:                                     Screen Exchange.      (line 28)
* ?:                                     Help.                 (line  6)
* [:                                     Copy.                 (line  6)
* ]:                                     Paste.                (line  6)
* a:                                     Command Character.    (line 25)
* A:                                     Title Command.        (line  6)
* C:                                     Clear.                (line  6)
* c:                                     Screen Command.       (line  6)
* C-[:                                   Copy.                 (line  6)
* C-\:                                   Quit.                 (line  6)
* C-]:                                   Paste.                (line  6)
* C-a:                                   Other Window.         (line  6)
* C-c:                                   Screen Command.       (line  6)
* C-d:                                   Detach.               (line 14)
* C-f:                                   Flow.                 (line 14)
* C-g:                                   Bell.                 (line 22)
* C-h:                                   Hardcopy.             (line  6)
* C-i:                                   Info.                 (line  6)
* C-k:                                   Kill.                 (line  6)
* C-l:                                   Redisplay.            (line 30)
* C-m:                                   Last Message.         (line  6)
* C-n:                                   Next and Previous.    (line  6)
* C-p:                                   Next and Previous.    (line 13)
* C-q:                                   XON/XOFF.             (line  6)
* C-r:                                   Wrap.                 (line  6)
* C-s:                                   XON/XOFF.             (line 11)
* C-t:                                   Time.                 (line  6)
* C-v:                                   Digraph.              (line  6)
* C-w:                                   Windows.              (line  6)
* C-x:                                   Lock.                 (line  6)
* C-z:                                   Suspend.              (line  6)
* D:                                     Power Detach.         (line  6)
* d:                                     Detach.               (line 14)
* ESC:                                   Copy.                 (line  6)
* f:                                     Flow.                 (line 14)
* F:                                     Fit.                  (line  6)
* H:                                     Log.                  (line 11)
* h:                                     Hardcopy.             (line  6)
* i:                                     Info.                 (line  6)
* k:                                     Kill.                 (line  6)
* l:                                     Redisplay.            (line 30)
* L:                                     Login.                (line 13)
* m:                                     Last Message.         (line  6)
* M:                                     Monitor.              (line 26)
* N:                                     Number.               (line  6)
* n:                                     Next and Previous.    (line  6)
* p:                                     Next and Previous.    (line 13)
* q:                                     XON/XOFF.             (line  6)
* Q:                                     Only.                 (line  6)
* r:                                     Wrap.                 (line  6)
* s:                                     XON/XOFF.             (line 11)
* S:                                     Split.                (line  6)
* SPC:                                   Next and Previous.    (line  6)
* t:                                     Time.                 (line  6)
* TAB:                                   Focus.                (line  6)
* v:                                     Version.              (line  6)
* W:                                     Window Size.          (line  6)
* w:                                     Windows.              (line  6)
* X:                                     Remove.               (line  6)
* x:                                     Lock.                 (line  6)
* Z:                                     Reset.                (line  6)
* z:                                     Suspend.              (line  6)
* {:                                     History.              (line  6)



Tag Table:
Node: Top998
Node: Overview3004
Node: Getting Started6636
Node: Invoking Screen8392
Node: Customization17210
Node: Startup Files17758
Node: Source19410
Node: Colon20105
Node: Commands20726
Node: Default Key Bindings21685
Node: Command Summary27370
Node: New Window41533
Node: Chdir42336
Node: Screen Command43317
Node: Setenv45028
Node: Shell45559
Node: Term46337
Node: Window Types47128
Node: Selecting51457
Node: Next and Previous52089
Node: Other Window52630
Node: Select53058
Node: Windowlist53883
Node: Session Management54990
Node: Detach55821
Node: Power Detach57220
Node: Lock57872
Node: Multiuser Session58768
Node: Multiuser59735
Node: Acladd60136
Node: Aclchg60716
Node: Acldel62138
Node: Aclgrp62487
Node: Displays63152
Node: Umask63460
Node: Wall64424
Node: Writelock64675
Node: Su65586
Node: Session Name66402
Node: Suspend66959
Node: Quit67301
Node: Regions67735
Node: Split68304
Node: Focus68604
Node: Only69192
Node: Remove69366
Node: Resize69584
Node: Caption70242
Node: Fit71010
Node: Window Settings71322
Node: Naming Windows72061
Node: Title Command73570
Node: Dynamic Titles73860
Node: Title Prompts75408
Node: Title Screenrc76505
Node: Console78156
Node: Kill78611
Node: Login79512
Node: Mode80342
Node: Monitor80752
Node: Windows82177
Node: Hardstatus83285
Node: Virtual Terminal84488
Node: Control Sequences85550
Node: Input Translation93258
Node: Digraph97737
Node: Bell98541
Node: Clear100435
Node: Info100650
Node: Redisplay102692
Node: Wrap104010
Node: Reset104774
Node: Window Size105104
Node: Character Processing105972
Node: Copy and Paste110322
Node: Copy110931
Node: Line Termination111790
Node: Scrollback112215
Node: Copy Mode Keys112970
Node: Movement113802
Node: Marking115021
Node: Repeat count115408
Node: Searching115734
Node: Specials116142
Node: Paste118107
Node: Registers121179
Node: Screen Exchange121987
Node: History123407
Node: Subprocess Execution124159
Node: Exec124527
Node: Using Exec126286
Node: Key Binding128136
Node: Bind128784
Node: Bind Examples130040
Node: Command Character131107
Node: Help132757
Node: Bindkey133377
Node: Bindkey Examples134940
Node: Bindkey Control135851
Node: Flow Control136463
Node: Flow Control Summary137043
Node: Flow139984
Node: XON/XOFF140771
Node: Termcap141157
Node: Window Termcap142018
Node: Dump Termcap147387
Node: Termcap Syntax148113
Node: Termcap Examples150293
Node: Special Capabilities152342
Node: Autonuke155125
Node: Obuflimit155788
Node: Character Translation156630
Node: Message Line159252
Node: Privacy Message160167
Node: Hardware Status Line160694
Node: Last Message162412
Node: Message Wait162851
Node: Logging163290
Node: Hardcopy163618
Node: Log164568
Node: Startup166364
Node: echo166775
Node: sleep167195
Node: Startup Message167548
Node: Miscellaneous167833
Node: At169340
Node: Break171322
Node: Debug172983
Node: License173472
Node: Nethack173749
Node: Nonblock174438
Node: Number175430
Node: Hidden175811
Node: Silence176236
Node: Time177186
Node: Verbose177792
Node: Version178140
Node: Zombie178363
Node: Printcmd179717
Node: Sorendition180437
Node: Attrcolor180881
Node: Setsid181945
Node: Eval182476
Node: Maxwin182699
Node: Backtick182983
Node: Screen Saver184245
Node: Zmodem185386
Node: String Escapes186287
Node: Environment191649
Node: Files192752
Node: Credits193847
Node: Bugs195865
Node: Known Bugs196338
Node: Reporting Bugs198443
Node: Availability199217
Node: Installation199769
Node: Socket Directory200163
Node: Compiling Screen200701
Node: Concept Index202101
Node: Command Index204804
Node: Keystroke Index217862

End Tag Table
