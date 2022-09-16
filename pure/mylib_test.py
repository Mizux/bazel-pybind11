#!/usr/bin/env python3
'''Test APIs'''

import sys
import unittest

import pure
import pure.mylib as mylib
from pure.mylib import Plop

if __debug__:
    print(f'python path: {sys.path}')

    print(f'plop.python: ${dir(pure.mylib)}')

    print(f'plop.python.mylib: ${dir(pure.mylib)}')
    print(f'mylib: ${dir(mylib)}')

    print(f'plop.python.mylib.Plop: ${dir(pure.mylib.Plop)}')
    print(f'mylib.Plop: ${dir(mylib.Plop)}')

class TestPlop(unittest.TestCase):
    '''Test Plop'''
    def test_free_function(self):
        ret = mylib.free_function()
        self.assertEqual(42, ret)

    def test_class(self):
        p = Plop()
        self.assertEqual(31, p.f())

if __name__ == '__main__':
    unittest.main(verbosity=2)
