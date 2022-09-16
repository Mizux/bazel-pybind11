#!/usr/bin/env python3
'''Test APIs'''

import sys
import unittest

import native_lib.python
import native_lib.python.myfoo as pyfoo
from native_lib.python.myfoo import Foo

if __debug__:
    print(f'python path: {sys.path}')

    print(f'foo.python: ${dir(native_lib.python)}')

    print(f'foo.python.myfoo: ${dir(native_lib.python.myfoo)}')
    print(f'pyfoo: ${dir(pyfoo)}')

    print(f'foo.python.myfoo.Foo: ${dir(native_lib.python.myfoo.Foo)}')
    print(f'pyfoo.Foo: ${dir(pyfoo.Foo)}')


class TestFoo(unittest.TestCase):
    '''Test Foo'''
    def test_free_function(self):
        pyfoo.free_function(2147483647)  # max int
        pyfoo.free_function(2147483647 + 1)  # max int + 1

    def test_string_vector(self):
        self.assertEqual(4, pyfoo.string_vector_input(["1", "2", "3", "4"]))

        self.assertEqual(
            5, pyfoo.string_vector_ref_input(["1", "2", "3", "4", "5"]))

        res = pyfoo.string_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(3, len(res))

    def test_string_jagged_array(self):
        self.assertEqual(
            3,
            pyfoo.string_jagged_array_input([['1'], ['2', '3'],
                                             ['4', '5', '6']]))

        self.assertEqual(
            4,
            pyfoo.string_jagged_array_ref_input([['1'], ['2', '3'],
                                                 ['4', '5', '6'], ['7']]))

        v = pyfoo.string_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i + 1, len(v[i]))

    def test_pair_vector(self):
        self.assertEqual(3, pyfoo.pair_vector_input([(1, 2), (3, 4), (5, 6)]))

        self.assertEqual(3,
                         pyfoo.pair_vector_ref_input([(1, 2), (3, 4), (5, 6)]))

        res = pyfoo.pair_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(3, len(res))

    def test_pair_jagged_array(self):
        self.assertEqual(
            2, pyfoo.pair_jagged_array_input([[(1, 1)], [(2, 2), (2, 2)]]))

        self.assertEqual(
            2, pyfoo.pair_jagged_array_ref_input([[(1, 1)], [(2, 2), (2, 2)]]))

        res = pyfoo.pair_jagged_array_output(5)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(5, len(res))
        for i in range(5):
            self.assertEqual(i + 1, len(res[i]))

    def test_Foo_static_methods(self):
        f = Foo()
        if __debug__:
            print(f'class Foo: ${dir(f)}')
        f.static_function(1)
        f.static_function(2147483647)
        f.static_function(2147483647 + 1)

    def test_Foo_int_methods(self):
        f = Foo()
        f.int = 13
        self.assertEqual(13, f.int)
        f.int = 17
        self.assertEqual(17, f.int)

    def test_Foo_int64_methods(self):
        f = Foo()
        f.int64 = 31
        self.assertEqual(31, f.int64)
        f.int64 = 42
        self.assertEqual(42, f.int64)


if __name__ == '__main__':
    unittest.main(verbosity=2)
