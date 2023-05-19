# NMake Makefile portion for compilation rules
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.  The format
# of NMake Makefiles here are different from the GNU
# Makefiles.  Please see the comments about these formats.

# Inference rules for compiling the .obj files.
# Used for libs and programs with more than a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.obj::
# 	$(CC)|$(CXX) $(cflags) /Fo$(destdir) /c @<<
# $<
# <<
{..\dbus_bindings\}.c{$(OBJDIR_BASE)\dbus_bindings\}.obj::
	@if not exist $(OBJDIR_BASE)\dbus_bindings\ md $(OBJDIR_BASE)\dbus_bindings
	$(CC) $(BASE_CFLAGS) $(BASE_BINDINGS_INCLUDES) /Fo$(OBJDIR_BASE)\dbus_bindings\ /Fd$(OBJDIR_BASE)\dbus_bindings\ /c @<<
$<
<<

{..\dbus_glib_bindings\}.c{$(OBJDIR_BASE)\dbus_glib_bindings\}.obj::
	@if not exist $(OBJDIR_BASE)\dbus_glib_bindings\ md $(OBJDIR_BASE)\dbus_glib_bindings
	$(CC) $(BASE_CFLAGS) $(GLIB_BINDINGS_INCLUDES) /Fo$(OBJDIR_BASE)\dbus_glib_bindings\ /Fd$(OBJDIR_BASE)\dbus_glib_bindings\ /c @<<
$<
<<

{..\dbus-gmain\}.c{$(OBJDIR_BASE)\dbus_glib_bindings\}.obj::
	@if not exist $(OBJDIR_BASE)\dbus_glib_bindings\ md $(OBJDIR_BASE)\dbus_glib_bindings
	$(CC) $(GLIB_BINDINGS_CFLAGS) $(GLIB_BINDINGS_INCLUDES) /Fo$(OBJDIR_BASE)\dbus_glib_bindings\ /Fd$(OBJDIR_BASE)\dbus_glib_bindings\ /c @<<
$<
<<

# Rules for linking PYDs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(DBUS_BINDINGS_PYD): $(dbus_bindings_objs)
	@if not exist $(OUTDIR)\ md $(OUTDIR)
	link /DLL $(LDFLAGS) $(BASE_DEP_LIBS)	\
	/implib:$(OBJDIR_BASE)\dbus_bindings\$(@B).lib	\
	/pdb:$(@R).pdb	\
	-out:$@ @<<
$**
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2 & del $@.manifest

$(DBUS_GLIB_BINDINGS_PYD): $(dbus_glib_bindings_objs)
	@if not exist $(OUTDIR)\ md $(OUTDIR)
	link /DLL $(LDFLAGS) $(GLIB_BINDINGS_DEP_LIBS)	\
	/implib:$(OBJDIR_BASE)\dbus_glib_bindings\$(@B).lib	\
	/pdb:$(@R).pdb	\
	-out:$@ @<<
$**
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2 & del $@.manifest

prep-wheel: all
	@-md $(OUTDIR)\dbus
	@-md $(OUTDIR)\dbus\mainloop
	@if "$(PYTHON_MAJ)" == "3" for %d in (. mainloop) do @copy ..\dbus\%d\*.py $(OUTDIR)\dbus\%d
	@if not "$(PYTHON_MAJ)" == "3" for %d in (mainloop) do @copy ..\dbus\%d\*.py $(OUTDIR)\dbus\%d
	@if not "$(PYTHON_MAJ)" == "3" for %f in (..\dbus\*.py) do @if not "%~nxf" == "gobject_service.py" copy %f $(OUTDIR)\dbus

clean:
	@-if exist ..\build\bdist.$(PYTHON_PLAT) rd ..\build\bdist.$(PYTHON_PLAT)
	@-del /f /q $(OUTDIR)\dbus\mainloop\*.py
	@-del /f /q $(OUTDIR)\dbus\*.py
	@-del /f /q $(OUTDIR)\*.pyd.manifest
	@-del /f /q $(OUTDIR)\*.pyd
	@-del /f /q $(OUTDIR)\*.pdb
	@-del /f /q $(OBJDIR_BASE)\dbus_glib_bindings\*.ilk
	@-del /f /q $(OBJDIR_BASE)\dbus_glib_bindings\*.exp
	@-del /f /q $(OBJDIR_BASE)\dbus_glib_bindings\*.lib
	@-del /s /q $(OBJDIR_BASE)\dbus_glib_bindings\*.obj
	@-del /s /q $(OBJDIR_BASE)\dbus_glib_bindings\*.pdb
	@-del /f /q $(OBJDIR_BASE)\dbus_bindings\*.ilk
	@-del /f /q $(OBJDIR_BASE)\dbus_bindings\*.exp
	@-del /f /q $(OBJDIR_BASE)\dbus_bindings\*.lib
	@-del /s /q $(OBJDIR_BASE)\dbus_bindings\*.obj
	@-del /s /q $(OBJDIR_BASE)\dbus_bindings\*.pdb
	@-rd $(OUTDIR)\dbus\mainloop
	@-rd $(OUTDIR)\dbus
	@-rd $(OUTDIR)
	@-rd $(OBJDIR_BASE)\dbus_glib_bindings
	@-rd $(OBJDIR_BASE)\dbus_bindings
	@-rd $(OBJDIR_BASE)
	@-del config.h
