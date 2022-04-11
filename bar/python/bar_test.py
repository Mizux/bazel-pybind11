#!/usr/bin/env python3
'''Test APIs'''

import unittest
import bar.python
import bar.python.bar as pybar
from bar.python.bar import Bar

if __debug__:
    print(f'bar.python: ${dir(bar.python)}')
    print(f'bar.python.bar: ${dir(bar.python.bar)}')
    print(f'bar.python.bar.Bar: ${dir(bar.python.bar.Bar)}')


class TestBar(unittest.TestCase):
    '''Test Bar'''
    def test_free_function(self):
        pybar.free_function(2147483647)  # max int
        pybar.free_function(2147483647 + 1)  # max int + 1

    def test_string_vector(self):
        self.assertEqual(4, pybar.string_vector_input(["1", "2", "3", "4"]))

        self.assertEqual(
            5, pybar.string_vector_ref_input(["1", "2", "3", "4", "5"]))

        res = pybar.string_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(3, len(res))

    def test_string_jagged_array(self):
        self.assertEqual(
            3,
            pybar.string_jagged_array_input([['1'], ['2', '3'],
                                             ['4', '5', '6']]))

        self.assertEqual(
            4,
            pybar.string_jagged_array_ref_input([['1'], ['2', '3'],
                                                 ['4', '5', '6'], ['7']]))

        v = pybar.string_jagged_array_output(5)
        self.assertEqual(5, len(v))
        for i in range(5):
            self.assertEqual(i + 1, len(v[i]))

    def test_pair_vector(self):
        self.assertEqual(3, pybar.pair_vector_input([(1, 2), (3, 4), (5, 6)]))

        self.assertEqual(3,
                         pybar.pair_vector_ref_input([(1, 2), (3, 4), (5, 6)]))

        res = pybar.pair_vector_output(3)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(3, len(res))

    def test_pair_jagged_array(self):
        self.assertEqual(
            2, pybar.pair_jagged_array_input([[(1, 1)], [(2, 2), (2, 2)]]))

        self.assertEqual(
            2, pybar.pair_jagged_array_ref_input([[(1, 1)], [(2, 2), (2, 2)]]))

        res = pybar.pair_jagged_array_output(5)
        if __debug__:
            print(f"res: {res}")
        self.assertEqual(5, len(res))
        for i in range(5):
            self.assertEqual(i + 1, len(res[i]))

    def test_Bar_static_methods(self):
        f = Bar
        if __debug__:
            print(f'class Bar: ${dir(f)}')
        f.static_function(1)
        f.static_function(2147483647)
        f.static_function(2147483647 + 1)

    def test_Bar_int_methods(self):
        f = Bar()
        f.int = 13
        self.assertEqual(f.int, 13)
        f.int = 17
        self.assertEqual(f.int, 17)

    def test_Bar_int64_methods(self):
        f = Bar()
        f.int64 = 31
        self.assertEqual(f.int64, 31)
        f.int64 = 42
        self.assertEqual(f.int64, 42)


if __name__ == '__main__':
    unittest.main(verbosity=2)
