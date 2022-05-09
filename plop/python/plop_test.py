#!/usr/bin/env python3
'''Test APIs'''

import sys
import unittest

import plop.python
import plop.python.mylib as pyplop
from plop.python.mylib import Plop

if __debug__:
    print(f'python path: {sys.path}')

    print(f'plop.python: ${dir(plop.python)}')

    print(f'plop.python.mylib: ${dir(plop.python.mylib)}')
    print(f'pyplop: ${dir(pyplop)}')

    print(f'plop.python.mylib.Plop: ${dir(plop.python.mylib.Plop)}')
    print(f'pyplop.Plop: ${dir(pyplop.Plop)}')

class TestPlop(unittest.TestCase):
    '''Test Plop'''
    def test_free_function(self):
        ret = pyplop.free_function()
        self.assertEqual(42, ret)

    def test_class(self):
        p = Plop()
        self.assertEqual(31, p.f())

if __name__ == '__main__':
    unittest.main(verbosity=2)
