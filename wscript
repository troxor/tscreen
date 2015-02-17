
import os, sys, re

import Options
import Logs
from waflib.Task import Task

APPNAME = 'tscreen'
VERSION = '0.5.0'
MAXWINDEFAULT = 100

'''
PACKAGE_BUGREPORT = ''
PACKAGE_NAME = APPNAME
PACKAGE_STRING = ''
PACKAGE_TARNAME = APPNAME+'-'+VERSION+'tar.gz'
PACKAGE_VERSION = VERSION
'''

top = '.'
out = 'build'


# Called before any other command executes
def options(opt):
	opt.tool_options('compiler_cc')

	# Features
	opt.add_option('--enable-debug', default=False, dest='debug',
			help='Enable debug mode [default: No]')
	opt.add_option('--etctscreenrc', default='/etc/tscreenrc', dest='tscreenrc',
			help='Path to system config file')
	opt.add_option('--sockdir', default='/tmp/tscreen', dest='sockdir',
			help='Directory for tscreen\'s named sockets')
	opt.add_option('--maxwin', default=MAXWINDEFAULT, dest='maxwin',
			help='Maximum simultaneous windows per session')
	opt.add_option('--maxusernamelen', default=50,
			help='Length of longest username')
	opt.add_option('--bashcomp', default='',
			help='Directory to install Bash completion script')
	opt.add_option('--zshcomp', default='',
			help='Directory to install Zsh completion script')

	opt.add_option('--screenencodings', default='/usr/share/tscreen/utf8encodings',
			help='')
	opt.add_option('--allow_systscreenrc', default=True,
			help='Allow env variable $SYSTSCREENRC')
	opt.add_option('--checklogin', default=True,
			help='Force users to enter their Unix password in addition to the tscreen password')
	opt.add_option('--syslog', default='True', dest='syslog',
			help='Enable syslog')
	opt.add_option('--ptymode', default=0620,
			help='')
	opt.add_option('--ptygroup', default=5,
			help='')
	opt.add_option('--lockpty', default='',
			help='')
	opt.add_option('--topstat', default=False, dest='topstat',
			help='Status line on the first line of the terminal rather than the last')
	opt.add_option('--colors256', default=True,
			help='')
	opt.add_option('--utmpfile', default='/var/run/utmp',
			help='')
	opt.add_option('--utmpok', default=True,
			help='')
	opt.add_option('--utmp_logindefault', default=True,
			help='')
	opt.add_option('--utmp_logoutok', default=True,
			help='')
	opt.add_option('--carefulutmp', default='',
			help='')
	opt.add_option('--usrlimit', default=MAXWINDEFAULT,
			help='')
	opt.add_option('--ttyvmin', default=100,
			help='')
	opt.add_option('--ttyvtime', default=2,
			help='')
	opt.add_option('--use_locale', default=True,
			help='')
	opt.add_option('--use_pam', default='',
			help='')
	opt.add_option('--shadowpw', default=True,
			help='')

def configure(conf):

	def conf_get_hg_rev():
		import subprocess
		try:
			p = subprocess.Popen(['hg', 'tip', '-q'], \
						stdout=subprocess.PIPE, \
						stderr=subprocess.STDOUT,
						close_fds=False,
						env={'LANG' : 'C'}
						)
			stdout = p.communicate()[0]

			if p.returncode == 0:
				lines = stdout.splitlines(True)
				for line in lines:
					if not line.startswith('*'):
						return line
		except:
			return 'None'

	def platform(system):
		return (sys.platform.lower().rfind(system) > -1)

	conf.check_tool('gcc')

	conf.env['CFLAGS'] = ['-O2']
	conf.define('VERSION', VERSION)

	conf.define('DEBUG', Options.options.debug)
	version = VERSION
	if conf.options.debug:
		hgrev = conf_get_hg_rev().strip()
		version = VERSION+"-hg ("+hgrev+")"
		conf.define('VERSION', version)

	conf.define('PACKAGE_URL', 'http://code.google.com/p/tscreen')
	conf.define('ETCTSCREENRC', Options.options.tscreenrc)
	conf.define('SOCKDIR', Options.options.sockdir)
	conf.define('TOPSTAT', Options.options.topstat)

	conf.define('MAX_USERNAME_LEN', Options.options.maxusernamelen)
	conf.define('MAXWIN', Options.options.maxwin)

	conf.define('SCREENENCODINGS', Options.options.screenencodings)
	conf.define('ALLOW_SYSSCREENRC', Options.options.allow_systscreenrc)
	conf.define('SYSLOG', Options.options.syslog)
	conf.define('PTYGROUP', Options.options.ptygroup)
	conf.define('LOCKPTY', Options.options.lockpty)
	conf.define('COLORS256', Options.options.colors256)
	conf.define('UTMPOK', Options.options.utmpok)
	conf.define('UTMP_LOGOUTOK', Options.options.utmp_logoutok)
	conf.define('CAREFULUTMP', Options.options.carefulutmp)
	conf.define('TTYVMIN', Options.options.ttyvmin)
	conf.define('TTYVTIME', Options.options.ttyvtime)
	conf.define('USE_LOCALE', Options.options.use_locale)
	if (platform('linux')):
		conf.env.LINUX = 1
		conf.define('POSIX', 1)
	elif (platform('darwin')):
		conf.env.OSX = 1
		conf.define('POSIX', 1)
	conf.define('BSDJOBS', 1)
	conf.define('TERMIO', 1)
	conf.define('TERMINFO', 1)
	conf.define('BSDWAIT', 1)
	conf.define('LOADAV_NUM', 3)
	conf.define('LOADAV_TYPE', 'double', quote=False)
	conf.define('LOADAV_SCALE', 1)
	conf.define('LOADAV_GETLOADAVG', 1)
	conf.define('HAVE_SVR4_PTYS', 1)
	conf.define('PTYRANGE0', "abcdepqrstuvwxyz")
	conf.define('PTYRANGE1', "0123456789abcdef")
	conf.define('LOCK', 1)
	conf.define('PASSWORD', 1)
	conf.define('AUTO_NUKE', 1)
	conf.define('PSEUDOS', 1)
	conf.define('MULTI', 1)
	conf.define('MULTIUSER', 1)
	conf.define('MAPKEYS', 1)
	conf.define('ENCODINGS', 1)
	conf.define('UTF8', 1)
	conf.define('BLANKER_PRG', 1)

	# headers
	conf.check(header_name='dirent.h')
	conf.check(header_name='inttypes.h')
	conf.check(header_name='memory.h')
	conf.check(header_name='ndir.h', mandatory=False)
	conf.check(header_name='stdint.h')
	conf.check(header_name='stdlib.h')
	conf.check(header_name='string.h')
	conf.check(header_name='strings.h')
	conf.check(header_name='stropts.h')
	conf.check(header_name='sys/dir.h')
	conf.check(header_name='sys/ndir.h', mandatory=False)
	conf.check(header_name='sys/stat.h')
	conf.check(header_name='sys/types.h')
	conf.check(header_name='unistd.h')
	# functions
	conf.check_cc(function_name='alphasort', header_name='dirent.h')
	conf.check_cc(function_name='_exit', header_name='unistd.h')
	conf.check_cc(function_name='fchmod', header_name='sys/stat.h')
	conf.check_cc(function_name='fchown', header_name='unistd.h')
	conf.check_cc(function_name='fdwalk', header_name='stdlib.h', mandatory=False)
	conf.check_cc(function_name='getcwd', header_name='unistd.h')
	conf.check_cc(function_name='getpt', header_name='stdlib.h', mandatory=False)
	conf.check_cc(function_name='getutent', header_name='utmp.h', mandatory=False)
	conf.check_cc(function_name='lstat', header_name='sys/stat.h')
	conf.check_cc(function_name='nl_langinfo', header_name='langinfo.h', mandatory=True)
	print "-------------------"
	if conf.env.OSX:
		print "osx is true"
		conf.check_cc(function_name='openpty', header_name='util.h', lib='util', mandatory=True)
	elif conf.env.LINUX:
		print "linux is true"
		conf.check_cc(function_name='openpty', header_name='pty.h', lib='util', mandatory=True)
	conf.check_cc(function_name='rename', header_name='stdio.h')
	conf.check_cc(function_name='scandir', header_name='dirent.h')
	conf.check_cc(function_name='setenv', header_name='stdlib.h')
	conf.check_cc(function_name='seteuid', header_name='unistd.h')
	conf.check_cc(function_name='setlocale', header_name='locale.h')
	conf.check_cc(function_name='setresuid', header_name='unistd.h', mandatory=False)
	conf.check_cc(function_name='setreuid', header_name='unistd.h')
	conf.check_cc(function_name='strerror', header_name='string.h')
	if Options.options.syslog is True:
		conf.check_cc(function_name='syslog', header_name='syslog.h', mandatory=True)
	conf.check_cc(function_name='strftime', header_name='time.h')
	conf.check_cc(function_name='unsetenv', header_name='stdlib.h')
	conf.check_cc(function_name='utimes', header_name='sys/time.h')
	conf.check_cc(function_name='vsnprintf', header_name='stdio.h')
	# programs
	conf.find_program('utempter', var='HAVE_UTEMPTER', mandatory=False)
	conf.find_program('awk', var='HAVE_AWK')
	conf.find_program('sed', var='HAVE_SED')
	conf.find_program('hg', var='HAVE_HG', mandatory=False)

	conf.write_config_header('config.h')

	Logs.pprint('BLUE', '')
	Logs.pprint('BLUE', APPNAME+" "+version)
	Logs.pprint('BLUE', ' * Install under        : ' + Options.options.prefix)
	Logs.pprint('BLUE', ' * Global configuration : ' + Options.options.tscreenrc)
	if conf.env.DEBUG:
		Logs.pprint('BLUE', ' * Debug enabled  : ' + conf.env.DEBUG)
	if Options.options.bashcomp is not '':
		Logs.pprint('BLUE', ' * Bash completion dir  : ' + Options.options.bashcomp)
	if Options.options.zshcomp is not '':
		Logs.pprint('BLUE', ' * Zsh completion dir   : ' + Options.options.zshcomp)
	print '-----------===----'
	print conf.env
	print '-----------===----'

def build(bld):
	
	bld(rule='bash ${SRC} ${TGT}', source='src/comm.sh', target='comm.h')
	bld(rule='bash ${SRC} ${TGT}', source='src/kmapdef.sh', target='kmapdef.c')
	bld(rule='bash ${SRC} ${TGT}', source='src/osdef.sh', target='osdef.h')
	bld(rule='bash ${SRC} ${TGT}', source='src/term.sh', target='term.h')
	bld(rule='bash ${SRC} ${TGT}', source='src/tty.sh', target='tty.c')

	bld.add_group()

	bld(
			features		= 'c cprogram',
			target			= 'tscreen',
			source			= bld.path.ant_glob('src/*.c') + [out+'/tty.c'] + [out+'/kmapdef.c'],
			install_path	= '/usr/local/bin',
			vnum			= '0.5.0',
			includes		= ['.', 'src'],
			cflags			= ['-O2'],
			lib				= ['util', 'crypt', 'curses'],
			linkflags		= ['-g']
	)

	#bld.recurse('data')
	#bld.recurse('doc')

# vim: ts=4 sw=4 noet ai cindent syntax=python
