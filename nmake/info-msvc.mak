# NMake Makefile portion for displaying config info

!if "$(CFG)" == "release" || "$(CFG)" == "Release"
BUILD_TYPE = release
!else
BUILD_TYPE = debug
!endif

build-info-dbus-python:
	@echo.
	@echo =============================
	@echo Configuration for dbus-python
	@echo =============================
	@echo Build Type: $(BUILD_TYPE)

help:
	@echo.
	@echo ================================
	@echo Building dbus-python Using NMake
	@echo ================================
	@echo nmake /f Makefile.vc CFG=[release^|debug] ^<PREFIX=PATH^> ^<PYTHON=...^> ... ^<OPTION=...^> ...
	@echo.
	@echo Where (please note that paths with spaces should be enclosed with quotes):
	@echo --------------------------------------------------------------------------
	@echo CFG: Required, use CFG=release for an optimized build and CFG=debug
	@echo for a debug build.  PDB files are generated for all builds.
	@echo.
	@echo PREFIX: Optional, the path where dependent libraries and tools may be
	@echo found, default is ^$(srcrootdir)\..\vs^$(short_vs_ver)\^$(platform),
	@echo where ^$(short_vs_ver) is 12 for VS 2013, 14 for VS 2015 and so on; and
	@echo ^$(platform) is Win32 for 32-bit builds and x64 for x64 builds.
	@echo.
	@echo LIBDIR: Optional, the path where dependent external .lib's may be found,
	@echo default is ^$(PREFIX)\lib, as well as compiler-/system-dependent headers
	@echo of dependencies such as libdbus and GLib.
	@echo.
	@echo INCLUDEDIR: Optional, the base path where dependent external headers may
	@echo be found, default is ^$(PREFIX)\include.  Note that headers for GLib, etc,
	@echo will be searched for in ^$(INCLUDEDIR)\glib-2.0 and
	@echo ^$(LIBDIR)\glib-2.0\include.
	@echo.
	@echo PYTHON: Full path to your Python interpreter executable.  Required
	@echo if python.exe is not in your PATH; the major/minor version of the Python
	@echo interpreter used here will be the Python release series that the built
	@echo modules (.pyd's) will be linked and used against.
	@echo.
	@echo Other options:
	@echo --------------
	@echo DBUS_LIB: This defaults to dbus-1.lib, which is the libdbus library that we
	@echo need to link to.  Define this if your libdbus library .lib is named
	@echo differently, such as dbus-1.0.lib.
	@echo.
	@echo OBJDIR_BASE: Defaults
	@echo to vs^$(short_vs_ver)-^$(python_release_series)\^$(CFG)\^$(platform).  Base
	@echo directory where built object files and intermediate PDB files will go to.
	@echo Compiled object files for sources under dbus_bindings and dbus_glib_bindings
	@echo will be in their respective sub-directories of this base directory.
	@echo.
	@echo OUTDIR: Defaults
	@echo to vs^$(short_vs_ver)-^$(python_release_series)\^$(CFG)\^$(platform).
	@echo Directory where the built Python modules will reside, as well as where the
	@echo python scripts that accompany the modules will be copied accordingly when
	@echo the prep-wheel target is built.
	@echo ======
	@echo.
	@echo A 'clean' target is supported to remove all generated files, intermediate
	@echo object files and binaries for the specified configuration.
	@echo.
	@echo A 'prep-wheel' target is supported to copy the Python scripts that are used
	@echo with the built modules (under ^$(srcroot)/dbus) to ^$(OUTDIR) for use and/or
	@echo packaging.
	@echo ======
	@echo.
