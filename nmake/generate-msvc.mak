# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

config.h: config.h.msvc
	@echo Copying $@ from $**
	@copy $** $@

config.h.msvc: ..\configure.ac prebuild.py config.h.msvc.in
config-msvc.mak: ..\configure.ac prebuild.py config-msvc.mak.in

generate-nmake-files: config.h.msvc config-msvc.mak
	@echo If error meesages appear here you will need to pass in PYTHON=^<path_to_python.exe^>...
	@$(PYTHON) prebuild.py

remove-generated-nmake-files:
	@-del /f/q config.h.msvc
	@-del /f/q config-msvc.mak
