#!/usr/bin/env python3
"""Test APIs"""

import sys
import unittest

import pure_lib
import pure_lib.mylib as mylib
from pure_lib.mylib import MyLib

if __debug__:
    print(f"python path: {sys.path}")

    print(f"plop.python: ${dir(pure_lib.mylib)}")

    print(f"plop.python.mylib: ${dir(pure_lib.mylib)}")
    print(f"mylib: ${dir(mylib)}")

    print(f"plop.python.mylib.MyLib: ${dir(pure_lib.mylib.MyLib)}")
    print(f"mylib.MyLib: ${dir(mylib.MyLib)}")


class TestMyLib(unittest.TestCase):
    """Test MyLib"""

    def test_free_function(self):
        ret = mylib.free_function()
        self.assertEqual(42, ret)

    def test_class(self):
        p = MyLib(31)
        self.assertEqual(31, p.method())


if __name__ == "__main__":
    unittest.main(verbosity=2)
