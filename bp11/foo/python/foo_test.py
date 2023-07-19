#!/usr/bin/env python3
'''Test APIs'''

import sys
import unittest

import bp11.foo.python as fp
import bp11.foo.python.pyfoo as fpf
from bp11.foo.python.pyfoo import Foo

if __debug__:
    print(f'python path: {sys.path}')

    print(f'foo.python: ${dir(fp)}')
    print(f'foo.python.pyfoo: ${dir(fpf)}')
    print(f'foo.python.pyfoo.Foo: ${dir(fpf.Foo)}')


class TestFoo(unittest.TestCase):
    '''Test Foo'''
    def test_free_function(self):
        fpf.free_function(2147483647)  # max int
        fpf.free_function(2147483647 + 1)  # max int + 1

    def test_string_vector(self):
        self.assertEqual(4, fpf.string_vector_input(["1", "2", "3", "4"]))

        self.assertEqual(
            5, fpf.string_vector_ref_input(["1", "2", "3", "4", "5"]))

        res = fpf.string_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(3, len(res))

    def test_string_jagged_array(self):
        self.assertEqual(
            3,
            fpf.string_jagged_array_input([['1'], ['2', '3'],
                                             ['4', '5', '6']]))

        self.assertEqual(
            4,
            fpf.string_jagged_array_ref_input([['1'], ['2', '3'],
                                                 ['4', '5', '6'], ['7']]))

        v = fpf.string_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i + 1, len(v[i]))

    def test_pair_vector(self):
        self.assertEqual(3, fpf.pair_vector_input([(1, 2), (3, 4), (5, 6)]))

        self.assertEqual(3,
                         fpf.pair_vector_ref_input([(1, 2), (3, 4), (5, 6)]))

        res = fpf.pair_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(3, len(res))

    def test_pair_jagged_array(self):
        self.assertEqual(
            2, fpf.pair_jagged_array_input([[(1, 1)], [(2, 2), (2, 2)]]))

        self.assertEqual(
            2, fpf.pair_jagged_array_ref_input([[(1, 1)], [(2, 2), (2, 2)]]))

        res = fpf.pair_jagged_array_output(5)
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
