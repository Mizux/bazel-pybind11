#!/usr/bin/env python3
'''Test APIs'''

import unittest
import foobar.python
import foobar.python.foobar as pyfoobar
from foobar.python.foobar import FooBar

if __debug__:
    print(f'foobar.python: ${dir(foobar.python)}')
    print(f'foobar.python.foobar: ${dir(foobar.python.foobar)}')
    print(f'foobar.python.foobar.FooBar: ${dir(foobar.python.foobar.FooBar)}')


class TestFooBar(unittest.TestCase):
    '''Test FooBar'''
    def test_free_function(self):
        pyfoobar.free_function(2147483647)  # max int
        pyfoobar.free_function(2147483647 + 1)  # max int + 1

    def test_string_vector(self):
        self.assertEqual(4, pyfoobar.string_vector_input(["1", "2", "3", "4"]))

        self.assertEqual(
            5, pyfoobar.string_vector_ref_input(["1", "2", "3", "4", "5"]))

        res = pyfoobar.string_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(8, len(res))

    def test_string_jagged_array(self):
        self.assertEqual(
            3,
            pyfoobar.string_jagged_array_input([['1'], ['2', '3'],
                                                ['4', '5', '6']]))

        self.assertEqual(
            4,
            pyfoobar.string_jagged_array_ref_input([['1'], ['2', '3'],
                                                    ['4', '5', '6'], ['7']]))

        v = pyfoobar.string_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i + 1, len(v[i]))

    def test_pair_vector(self):
        self.assertEqual(3, pyfoobar.pair_vector_input([(1, 2), (3, 4),
                                                        (5, 6)]))

        self.assertEqual(
            3, pyfoobar.pair_vector_ref_input([(1, 2), (3, 4), (5, 6)]))

        res = pyfoobar.pair_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(8, len(res))

    def test_pair_jagged_array(self):
        self.assertEqual(
            2, pyfoobar.pair_jagged_array_input([[(1, 1)], [(2, 2), (2, 2)]]))

        self.assertEqual(
            2,
            pyfoobar.pair_jagged_array_ref_input([[(1, 1)], [(2, 2), (2, 2)]]))

        res = pyfoobar.pair_jagged_array_output(5)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(5, len(res))
        for i in range(5):
            self.assertEqual(i + 1, len(res[i]))

    def test_FooBar_static_methods(self):
        f = FooBar
        if __debug__:
            print(f'class FooBar: ${dir(f)}')
        f.static_function(1)
        f.static_function(2147483647)
        f.static_function(2147483647 + 1)

    def test_FooBar_int_methods(self):
        f = FooBar()
        f.foo_int = 13
        f.bar_int = 17
        self.assertEqual(30, f.int)

    def test_FooBar_int64_methods(self):
        f = FooBar()
        f.foo_int64 = 31
        f.bar_int64 = 37
        self.assertEqual(68, f.int64)


if __name__ == '__main__':
    unittest.main(verbosity=2)
