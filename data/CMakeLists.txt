install(FILES tscreenrc
		DESTINATION ${SYSCONF_INSTALL_DIR})
message(" * Install tscreenrc  : ${SYSCONF_INSTALL_DIR}")

install(DIRECTORY utf8encodings
		DESTINATION ${DATA_INSTALL_DIR})

install(FILES terminfo/screencap terminfo/screeninfo.src
		DESTINATION ${DATA_INSTALL_DIR})
message(" * Install data       : ${DATA_INSTALL_DIR}")

if(WITH_BASH_COMPLETION)
	install(FILES tscreen.bashcomp
			DESTINATION ${BASHCOMP_INSTALL_DIR}
			RENAME tscreen)
	message("   + bash completion  : ${BASHCOMP_INSTALL_DIR}")
endif(WITH_BASH_COMPLETION)

if(WITH_ZSH_COMPLETION)
	install(FILES tscreen.zshcomp
			DESTINATION ${ZSHCOMP_INSTALL_DIR}
			RENAME _tscreen)
	message("   + zsh completion   : ${ZSHCOMP_INSTALL_DIR}")
endif(WITH_ZSH_COMPLETION)

#vim: ts=4 sw=4 noet ai cindent syntax=cmake
