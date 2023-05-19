#!/usr/bin/python
# vim: encoding=utf-8
#expand *.in files
#this script is only intended for building from git, not for building from the released tarball, which already includes all necessary files
import os
import sys
import re
import string
import subprocess
import optparse

def get_version(srcroot):
    ver = {}
    RE_VERSION = re.compile(r'^m4_define\((dbus_python_\w+),\s*(\d+)\)')
    with open(os.path.join(srcroot, 'configure.ac'), 'r') as ac:
        for i in ac:
            mo = RE_VERSION.search(i)
            if mo:
                ver[mo.group(1).upper()] = int(mo.group(2))
    ver['PACKAGE_VERSION'] = '%d.%d.%d' % (ver['DBUS_PYTHON_MAJOR_VERSION'],
                                           ver['DBUS_PYTHON_MINOR_VERSION'],
                                           ver['DBUS_PYTHON_MICRO_VERSION'])
    ver['PACKAGE'] = 'dbus-python'
    ver['PACKAGE_NAME'] = ver['PACKAGE']
    ver['PACKAGE_TARNAME'] = ver['PACKAGE']
    ver['PACKAGE_BUGREPORT'] = 'http://bugs.freedesktop.org/enter_bug.cgi?product=dbus&component=python'
    return ver

def process_in(src, dest, vars):
    RE_VARS = re.compile(r'@(\w+?)@')
    with open(src, 'r') as s:
        with open(dest, 'w') as d:
            for i in s:
                i = RE_VARS.sub(lambda x: str(vars[x.group(1)]), i)
                d.write(i)

def get_srcroot():
    if not os.path.isabs(__file__):
        path = os.path.abspath(__file__)
    else:
        path = __file__
    dirname = os.path.dirname(path)
    return os.path.abspath(os.path.join(dirname, '..'))

def main(argv):
    srcroot = get_srcroot()
    ver = get_version(srcroot)
    process_in('config.h.msvc.in', 'config.h.msvc', ver.copy())
    process_in('config-msvc.mak.in', 'config-msvc.mak', ver.copy())

if __name__ == '__main__':
    sys.exit(main(sys.argv))
