from sympy import residue, Symbol, Function, sin, S, I, pi, exp, log, pi, factorial
from sympy.utilities.pytest import XFAIL, raises

def test_basic1():
    x = Symbol("x")
    assert residue(1/x, x, 0) == 1
    assert residue(-2/x, x, 0) == -2
    assert residue(81/x, x, 0) == 81
    assert residue(1/x**2, x, 0) == 0
    assert residue(0, x, 0) == 0
    assert residue(5, x, 0) == 0
    assert residue(x, x, 0) == 0
    assert residue(x**2, x, 0) == 0

def test_basic2():
    x = Symbol("x")
    assert residue(1/x, x, 1) == 0
    assert residue(-2/x, x, 1) == 0
    assert residue(81/x, x, -1) == 0
    assert residue(1/x**2, x, 1) == 0
    assert residue(0, x, 1) == 0
    assert residue(5, x, 1) == 0
    assert residue(x, x, 1) == 0
    assert residue(x**2, x, 5) == 0

def _test_f():
    # FIXME: we get infinite recursion here:
    x = Symbol("x")
    f = Function("f")
    assert residue(f(x)/x**5, x, 0) == f.diff(x, 4)/24

def test_functions():
    x = Symbol("x")
    assert residue(1/sin(x), x, 0) == 1
    assert residue(2/sin(x), x, 0) == 2
    assert residue(1/sin(x)**2, x, 0) == 0
    assert residue(1/sin(x)**5, x, 0) == S(3)/8

def test_expressions():
    x = Symbol("x")
    assert residue(1/(x+1), x, 0) == 0
    assert residue(1/(x+1), x, -1) == 1
    assert residue(1/(x**2+1), x, -1) == 0
    assert residue(1/(x**2+1), x, I) == -I/2
    assert residue(1/(x**2+1), x, -I) == I/2
    assert residue(1/(x**4+1), x, 0) == 0

@XFAIL
def test_expressions_failing():
    x = Symbol('x')
    assert residue(1/(x**4+1), x, exp(I*pi/4)) == -(S(1)/4+I/4)/sqrt(2)

    z = Symbol('z')
    n = Symbol('n', integer=True, positive=True)
    a = Symbol('a')
    assert residue(exp(z)/(z - pi*I/4*a)**n, z, I*pi*a) == \
           exp(I*pi*a/4)/factorial(n-1)
    assert residue(1/(x**2 + a**2)**2, x, a*I) == -I/4/a**3

def test_NotImplemented():
    z = Symbol('z')
    raises(NotImplementedError, lambda: residue(exp(1/z), z, 0))

def test_bug():
    from sympy.abc import s, z
    assert residue(2**(z)*(s+z)*(1-s-z)/z**2, z, 0) == \
           1 + s*log(2) - s**2*log(2) - 2*s
