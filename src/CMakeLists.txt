include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR})

add_custom_command(OUTPUT comm.h
		COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/comm.sh)
add_custom_command(OUTPUT kmapdef.c
		COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/kmapdef.sh)
add_custom_command(OUTPUT osdef.h
		COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/osdef.sh)
add_custom_command(OUTPUT term.h
		COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/term.sh)
add_custom_command(OUTPUT tty.c	
		COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/tty.sh)

add_executable(${APPLICATION_NAME} comm.h osdef.h term.h kmapdef.c tty.c screen.c acls.c ansi.c attacher.c comm.c display.c encoding.c fileio.c help.c input.c layer.c loadav.c logfile.c mark.c misc.c process.c pty.c putenv.c resize.c sched.c search.c socket.c teln.c term.c termcap.c utmp.c window.c)
#
target_link_libraries(${APPLICATION_NAME} ${CURSES_LIBRARIES} ${PAM_LIBRARIES} ${CMAKE_REQUIRED_LIBRARIES})

if(WITH_SETUID_ROOT)
	install(TARGETS ${APPLICATION_NAME}
		RUNTIME	DESTINATION ${BIN_INSTALL_DIR})
	install(CODE "execute_process(COMMAND chgrp tty ${BIN_INSTALL_DIR}/${APPLICATION_NAME})")
	install(CODE "execute_process(COMMAND chmod g+s ${BIN_INSTALL_DIR}/${APPLICATION_NAME})")
	message(" * Install binary g+s : ${BIN_INSTALL_DIR}")
else(WITH_SETUID_ROOT)
	install(TARGETS ${APPLICATION_NAME}
		RUNTIME	DESTINATION ${BIN_INSTALL_DIR})
	message(" * Install binary     : ${BIN_INSTALL_DIR}")
endif(WITH_SETUID_ROOT)

#vim: ts=4 sw=4 noet ai cindent syntax=cmake

