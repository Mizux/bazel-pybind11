"""MyLib module """

import sys


def free_function(i=42):
    print(f"free_function")
    print(f"version_info: {sys.version_info}")
    return i


class MyLib:
    """A simple example class"""

    def __init__(self, i=12345):
        self.i = i

    def method(self, i=0):
        return i + self.i
