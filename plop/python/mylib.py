'''Plop module '''

import sys

def free_function():
    print(f'plop_function')
    print(f'version_info: {sys.version_info}')
    return 42

class Plop:
    """A simple example class"""
    i = 12345

    def f(self):
        return 31
