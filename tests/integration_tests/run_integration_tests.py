import subprocess

import sys
py_path = '../../scripts/'
sys.path.insert(0, py_path)

import utils as ut
from colors import *

py_version = 'python3'

#
# Compile and run all the abm class specific tests
#

# Compile
subprocess.call([py_version + ' compilation.py'], shell=True)

# Test suite 1
ut.msg('Integration test: balancing', CYAN)
subprocess.call(['./btest'], shell=True)

# Test suite 2
ut.msg('Integration test: data collection', CYAN)
subprocess.call(['./dtest'], shell=True)

# Test suite 2
ut.msg('Integration test: average number of contacts', CYAN)
subprocess.call(['./actest'], shell=True)


