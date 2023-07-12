import cmakepybind11
from cmakepybind11.foo import pyFoo
from cmakepybind11.bar import pyBar
from cmakepybind11.foobar import pyFooBar

print(f'version: {cmakepybind11.__version__}')

# foo
print(f'Foo: {dir(pyFoo.Foo)}')

pyFoo.free_function(2147483647) # max int
pyFoo.free_function(2147483647+1) # max int + 1

f = pyFoo.Foo()
print(f'class Foo: {dir(f)}')
f.static_function(1)
f.static_function(2147483647)
f.static_function(2147483647+1)
f.int = 13
assert(f.int == 13)
f.int64 = 31
assert(f.int64 == 31)

# bar
print(f'Bar: {dir(pyBar.Bar)}')

pyBar.free_function(2147483647) # max int
pyBar.free_function(2147483647+1) # max int + 1

b = pyBar.Bar()
print(f'class Bar: {dir(b)}')
b.static_function(1)
b.static_function(2147483647)
b.static_function(2147483647+1)
b.int = 13
assert(b.int == 13)
b.int64 = 31
assert(b.int64 == 31)

# foobar
print(f'FooBar: {dir(pyFooBar.FooBar)}')

pyFooBar.free_function(2147483647) # max int
pyFooBar.free_function(2147483647+1) # max int + 1

fb = pyFooBar.FooBar()
print(f'class FooBar: {dir(fb)}')
fb.static_function(1)
fb.static_function(2147483647)
fb.static_function(2147483647+1)
fb.foo_int = 13
fb.bar_int = 17
assert(fb.int == 30)
fb.foo_int64 = 31
fb.bar_int64 = 37
assert(fb.int64 == 68)
