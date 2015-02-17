set(VERSION "0.5.0")
set(PACKAGE_URL "http://code.google.com/p/tscreen")

include(MacroEnsureOutOfSourceBuild)
macro_ensure_out_of_source_build("${PROJECT_NAME} requires an out of source build. Please create a separate build directory and run 'cmake /path/to/${PROJECT_NAME} [options]' there.")

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	set(OSX TRUE)
	set(CAREFULUTMP FALSE)
	set(UTMPFILE "/var/run/utmpx")
	set(WITH_SETUID_ROOT FALSE)	# /usr/bin/screen is not g+s
endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

if(CMAKE_BUILD_TYPE MATCHES "Debug|RelWithDebInfo")
	set(DEBUG TRUE)
endif(CMAKE_BUILD_TYPE MATCHES "Debug|RelWithDebInfo")

if(CMAKE_BUILD_TYPE MATCHES "Debug")
	find_program(APP_HG hg)
	if(NOT APP_HG)
		message(FATAL_ERROR "Mercurial not installed, try setting CMAKE_BUILD_TYPE=RelWithDebInfo")
	endif(NOT APP_HG)
	mark_as_advanced(APP_HG)
	execute_process(
		COMMAND ${APP_HG} tip --template {rev}
		WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
		OUTPUT_VARIABLE HG_REVISION_ID
	)
	set(VERSION_STRING "${VERSION}-hg (${HG_REVISION_ID})")
else(CMAKE_BUILD_TYPE MATCHES "Debug")
	set(VERSION_STRING "${VERSION}")
endif(CMAKE_BUILD_TYPE MATCHES "Debug")

#vim: ts=4 sw=4 noet ai cindent syntax=cmake
