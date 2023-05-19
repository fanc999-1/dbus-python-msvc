# set up Python directories

import os
import sys

pyver_maj_s = sys.version_info[0]
pyver_min_s = sys.version_info[1]
pyver = int('%s%s' % (pyver_maj_s, pyver_min_s))

if hasattr(sys, 'base_prefix'):
    prefix = sys.base_prefix
else:
    prefix = sys.prefix

print('PYTHON_MAJ=%s' % pyver_maj_s)
print('PYTHON_MIN=%s' % pyver_min_s)
print('PYTHON_RELEASE=%s' % pyver)
print('PYTHON_PREFIX=%s' % prefix)
print('PYTHON_INCDIR=%s' % os.path.join(prefix, 'include'))
print('PYTHON_LIBDIR=%s' % os.path.join(prefix, 'libs'))
