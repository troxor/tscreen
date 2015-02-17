include(CMakeDependentOption)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose build type: Debug, RelWithDebInfo, Release" FORCE)
endif(NOT CMAKE_BUILD_TYPE)
	
set(CMAKE_C_FLAGS "-O29" CACHE STRING "Flags used by the C compiler during all build types" FORCE)
set(CMAKE_C_FLAGS_DEBUG "-ggdb -Wall" CACHE STRING "Compiler flags during Debug builds" FORCE)


set(SHARE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share" CACHE PATH "($prefix/share)")

set(BIN_INSTALL_DIR	"${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "($prefix/bin)")
set(SYSCONF_INSTALL_DIR	"${CMAKE_INSTALL_PREFIX}/etc" CACHE PATH "($prefix/etc)")

set(DOC_INSTALL_DIR	"${SHARE_INSTALL_PREFIX}/doc" CACHE PATH "($share_prefix/doc)")
set(MAN_INSTALL_DIR	"${SHARE_INSTALL_PREFIX}/man" CACHE PATH "($share_prefix/man)")
set(INFO_INSTALL_DIR 	"${SHARE_INSTALL_PREFIX}/info" CACHE PATH "($share_prefix/info)")

set(DATA_INSTALL_DIR 	"${SHARE_INSTALL_PREFIX}/${APPLICATION_NAME}" CACHE PATH "($share_prefix/${APPLICATION_NAME})" FORCE)


option(ALLOW_SYSSCREENRC "Allow env variable $SYSTSCREENRC" ON)

option(CHECKLOGIN "force users to enter their Unix password in addition to the tscreen password" ON)

option(COLORS256 "256 color terminal" ON)

set(ETCTSCREENRC "${SYSCONF_INSTALL_DIR}/tscreenrc")

set(MAXWIN "100" CACHE STRING "Maximum windows per session")

set(MAX_USERNAME_LEN "50" CACHE STRING "Length of longest username")

set(SOCKDIR "/tmp/tscreen" CACHE PATH "Local directory that contains named sockets")

set(PTYMODE "0620" CACHE STRING "0622 allows public write to your pty")

set(PTYGROUP "5" CACHE STRING "numerical gid of tty if you do not want the tty to be in your uid's group")

set(SCREENENCODINGS "${DATA_INSTALL_DIR}/utf8encodings")

option(RELEASE "Build release package" FALSE)
mark_as_advanced(RELEASE)

option(SYSLOG "Select OFF if you do NOT have logging facilities. Currently used only 'su' commands" ON)

set(TTYVMIN 100)
mark_as_advanced(TTYVMIN)

set(TTYVTIME 2)
mark_as_advanced(TTYVTIME)

option(UTMP_LOGOUTOK "Allow users to log their windows out" ON)
option(UTMP_LOGINDEFAULT "Windows logged in to utmp by default" ON)
set(UTMP_USRLIMIT ${MAXWIN} "Upper limit on the number of entries to write to /var/run/utmp")

option(WITH_SETUID_ROOT "Build and install ${APPLICATION_NAME} as suid root for extra features" OFF)
cmake_dependent_option(LOCKPTY "Exclusive locking prevents others from opening your ptys, but also your subprocesses from /dev/tty" OFF
			"NOT WITH_SETUID_ROOT" ON)

option(WITH_BASH_COMPLETION "Install bash completion" OFF)
set(BASHCOMP_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/bash-completion" CACHE PATH
	"Directory containing bash completion scripts")

option(WITH_ZSH_COMPLETION "Install zsh completion" OFF)
set(ZSHCOMP_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/zsh/4.3.10/functions/Completion/Unix" CACHE PATH
	"Directory containing zsh completion scripts")

option(TOPSTAT "Place the status line on the first line of your terminal rather than the last" OFF)

option(USE_LOCALE "Use the locale names for the name of the month and day of the week" ON)

# vim: ts=4 sw=4 noet ai cindent syntax=cmake
