configure_file(tscreen.1.cmake "${CMAKE_CURRENT_BINARY_DIR}/tscreen.1")
configure_file(tscreen.info.cmake "${CMAKE_CURRENT_BINARY_DIR}/tscreen.info")

install(FILES		${CMAKE_CURRENT_BINARY_DIR}/tscreen.1
		DESTINATION	${MAN_INSTALL_DIR}/man1)

install(FILES		${CMAKE_CURRENT_BINARY_DIR}/tscreen.info
		DESTINATION	${INFO_INSTALL_DIR})

install(FILES FAQ fdpat.ps window_to_display.ps ../README
		DESTINATION ${DOC_INSTALL_DIR}/${APPLICATION_NAME}-${VERSION})

message (" * Install man        : ${MAN_INSTALL_DIR}/man1")
message (" * Install info       : ${INFO_INSTALL_DIR}")
message (" * Install docs       : ${DOC_INSTALL_DIR}/${APPLICATION_NAME}-${VERSION}")

#vim: ts=4 sw=4 noet ai cindent syntax=cmake
