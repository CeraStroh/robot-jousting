from core import C
from singleton import S
from operations import AssocOp
from cache import cacheit
from numbers import ilcm, igcd

from collections import defaultdict

class Add(AssocOp):

    __slots__ = []

    is_Add = True

    #identity = S.Zero
    # cyclic import, so defined in numbers.py

    @classmethod
    def flatten(cls, seq):
        """
        Takes the sequence "seq" of nested Adds and returns a flatten list.

        Returns: (commutative_part, noncommutative_part, order_symbols)

        Applies associativity, all terms are commutable with respect to
        addition.

        NB: the removal of 0 is already handled by AssocOp.__new__

        See also
        ========

        sympy.core.mul.Mul.flatten

        """
        rv = None
        if len(seq) == 2:
            a, b = seq
            if b.is_Rational:
                a, b = b, a
            assert a
            if a.is_Rational:
                if b.is_Mul:
                    # if it's an unevaluated 2-arg, expand it
                    c, t = b.as_coeff_Mul()
                    if t.is_Add:
                        h, t = t.as_coeff_Add()
                        bargs = [c*ti for ti in Add.make_args(t)]
                        bargs.sort(key=hash)
                        ch = c*h
                        if ch:
                            bargs.insert(0, ch)
                        b = Add._from_args(bargs)
                if b.is_Add:
                    bargs = list(b.args)
                    if bargs[0].is_Number:
                        bargs[0] += a
                        if not bargs[0]:
                            bargs.pop(0)
                    else:
                        bargs.insert(0, a)
                    rv = bargs, [], None
                elif b.is_Mul:
                    rv = [a, b], [], None
            if rv:
                if all(s.is_commutative for s in rv[0]):
                    return rv
                return [], rv[0], None

        terms = {}      # term -> coeff
                        # e.g. x**2 -> 5   for ... + 5*x**2 + ...

        coeff = S.Zero  # standalone term (Number or zoo will always be in slot 0)
                        # e.g. 3 + ...
        order_factors = []

        for o in seq:

            # O(x)
            if o.is_Order:
                for o1 in order_factors:
                    if o1.contains(o):
                        o = None
                        break
                if o is None:
                    continue
                order_factors = [o]+[o1 for o1 in order_factors if not o.contains(o1)]
                continue

            # 3 or NaN
            elif o.is_Number:
                if o is S.NaN or coeff is S.ComplexInfinity and o.is_bounded is False:
                    # we know for sure the result will be nan
                    return [S.NaN], [], None
                if coeff.is_Number:
                    coeff += o
                    if coeff is S.NaN:
                        # we know for sure the result will be nan
                        return [S.NaN], [], None
                continue

            elif o is S.ComplexInfinity:
                if coeff.is_bounded is False:
                    # we know for sure the result will be nan
                    return [S.NaN], [], None
                coeff = S.ComplexInfinity
                continue

            # Add([...])
            elif o.is_Add:
                # NB: here we assume Add is always commutative
                seq.extend(o.args)  # TODO zerocopy?
                continue

            # Mul([...])
            elif o.is_Mul:
                c, s = o.as_coeff_Mul()

                # 3*...
                # unevaluated 2-arg Mul, but we always unfold it so
                # it can combine with other terms (just like is done
                # with the Pow below)
                if c.is_Number and s.is_Add:
                    seq.extend([c*a for a in s.args])
                    continue

            # check for unevaluated Pow, e.g. 2**3 or 2**(-1/2)
            elif o.is_Pow:
                b, e = o.as_base_exp()
                if b.is_Number and (e.is_Integer or (e.is_Rational and e.is_negative)):
                    seq.append(b**e)
                    continue
                c, s = S.One, o

            else:
                # everything else
                c = S.One
                s = o


            # now we have:
            # o = c*s, where
            #
            # c is a Number
            # s is an expression with number factor extracted

            # let's collect terms with the same s, so e.g.
            # 2*x**2 + 3*x**2  ->  5*x**2
            if s in terms:
                terms[s] += c
            else:
                terms[s] = c


        # now let's construct new args:
        # [2*x**2, x**3, 7*x**4, pi, ...]
        newseq = []
        noncommutative = False
        for s,c in terms.items():
            # 0*s
            if c is S.Zero:
                continue
            # 1*s
            elif c is S.One:
                newseq.append(s)
            # c*s
            else:
                if s.is_Mul:
                    # Mul, already keeps its arguments in perfect order.
                    # so we can simply put c in slot0 and go the fast way.
                    cs = s._new_rawargs(*((c,) + s.args))
                    newseq.append(cs)

                else:
                    # alternatively we have to call all Mul's machinery (slow)
                    newseq.append(Mul(c,s))

            noncommutative = noncommutative or not s.is_commutative

        # oo, -oo
        if coeff is S.Infinity:
            newseq = [f for f in newseq if not (f.is_nonnegative or f.is_real and
                                                (f.is_bounded or
                                                 f.is_finite or
                                                 f.is_infinitesimal))]
        elif coeff is S.NegativeInfinity:
            newseq = [f for f in newseq if not (f.is_nonpositive or f.is_real and
                                                (f.is_bounded or
                                                 f.is_finite or
                                                 f.is_infinitesimal))]
        if coeff is S.ComplexInfinity:
            # zoo might be
            #   unbounded_real + bounded_im
            #   bounded_real + unbounded_im
            #   unbounded_real + unbounded_im
            # addition of a bounded real or imaginary number won't be able to
            # change the zoo nature; if unbounded a NaN condition could result if
            # the unbounded symbol had sign opposite of the unbounded portion of zoo,
            # e.g. unbounded_real - unbounded_real
            newseq = [c for c in newseq if not (c.is_bounded and
                                                c.is_real is not None)]

        # process O(x)
        if order_factors:
            newseq2 = []
            for t in newseq:
                for o in order_factors:
                    # x + O(x) -> O(x)
                    if o.contains(t):
                        t = None
                        break
                # x + O(x**2) -> x + O(x**2)
                if t is not None:
                    newseq2.append(t)
            newseq = newseq2 + order_factors
            # 1 + O(1) -> O(1)
            for o in order_factors:
                if o.contains(coeff):
                    coeff = S.Zero
                    break


        # order args canonically
        # Currently we sort things using hashes, as it is quite fast. A better
        # solution is not to sort things at all - but this needs some more
        # fixing. NOTE: this is used in primitive and Mul.flattten, too, so if
        # it changes here it should be changed there.
        newseq.sort(key=hash)

        # current code expects coeff to be first
        if coeff is not S.Zero:
            newseq.insert(0, coeff)

        # we are done
        if noncommutative:
            return [], newseq, None
        else:
            return newseq, [], None

    @classmethod
    def class_key(cls):
        """Nice order of classes"""
        return 3, 1, cls.__name__

    def as_coefficients_dict(a):
        """Return a dictionary mapping terms to their Rational coefficient.
        Since the dictionary is a defaultdict, inquiries about terms which
        were not present will return a coefficient of 0. If an expression is
        not an Add it is considered to have a single term.

        Examples
        ========

        >>> from sympy.abc import a, x
        >>> (3*x + a*x + 4).as_coefficients_dict()
        {1: 4, x: 3, a*x: 1}
        >>> _[a]
        0
        >>> (3*a*x).as_coefficients_dict()
        {a*x: 3}
        """

        d = defaultdict(list)
        for ai in a.args:
            c, m = ai.as_coeff_Mul()
            d[m].append(c)
        for k, v in d.iteritems():
            if len(v) == 1:
                d[k] = v[0]
            else:
                d[k] = Add(*v)
        di = defaultdict(int)
        di.update(d)
        return di

    @cacheit
    def as_coeff_add(self, *deps):
        """
        Returns a tuple (coeff, args) where self is treated as an Add and coeff
        is the Number term and args is a tuple of all other terms.

        Examples
        ========

        >>> from sympy.abc import x, y
        >>> (7 + 3*x).as_coeff_add()
        (7, (3*x,))
        >>> (7*x).as_coeff_add()
        (0, (7*x,))
        """
        if deps:
            l1 = []
            l2 = []
            for f in self.args:
                if f.has(*deps):
                    l2.append(f)
                else:
                    l1.append(f)
            return self._new_rawargs(*l1), tuple(l2)
        coeff, notrat = self.args[0].as_coeff_add()
        if coeff is not S.Zero:
            return coeff, notrat + self.args[1:]
        return S.Zero, self.args

    def as_coeff_Add(self):
        """Efficiently extract the coefficient of a summation. """
        coeff, args = self.args[0], self.args[1:]

        if coeff.is_Number:
            if len(args) == 1:
                return coeff, args[0]
            else:
                return coeff, self._new_rawargs(*args)
        else:
            return S.Zero, self

    # Note, we intentionally do not implement Add.as_coeff_mul().  Rather, we
    # let Expr.as_coeff_mul() just always return (S.One, self) for an Add.  See
    # issue 2425.

    def _eval_derivative(self, s):
        return Add(*[f.diff(s) for f in self.args])

    def _eval_nseries(self, x, n, logx):
        terms = [t.nseries(x, n=n, logx=logx) for t in self.args]
        return Add(*terms)

    def _matches_simple(self, expr, repl_dict):
        # handle (w+3).matches('x+5') -> {w: x+2}
        coeff, terms = self.as_coeff_add()
        if len(terms)==1:
            return terms[0].matches(expr - coeff, repl_dict)
        return

    matches = AssocOp._matches_commutative

    @staticmethod
    def _combine_inverse(lhs, rhs):
        """
        Returns lhs - rhs, but treats arguments like symbols, so things like
        oo - oo return 0, instead of a nan.
        """
        from sympy import oo, I, expand_mul
        if lhs == oo and rhs == oo or lhs == oo*I and rhs == oo*I:
            return S.Zero
        return expand_mul(lhs - rhs)

    @cacheit
    def as_two_terms(self):
        """Return head and tail of self.

        This is the most efficient way to get the head and tail of an
        expression.

        - if you want only the head, use self.args[0];
        - if you want to process the arguments of the tail then use
          self.as_coef_add() which gives the head and a tuple containing
          the arguments of the tail when treated as an Add.
        - if you want the coefficient when self is treated as a Mul
          then use self.as_coeff_mul()[0]

        >>> from sympy.abc import x, y
        >>> (3*x*y).as_two_terms()
        (3, x*y)
        """
        if len(self.args) == 1:
            return S.Zero, self
        return self.args[0], self._new_rawargs(*self.args[1:])

    def as_numer_denom(self):

        # clear rational denominator
        content, expr = self.primitive()
        ncon, dcon = content.as_numer_denom()

        # collect numerators and denominators of the terms
        nd = defaultdict(list)
        for f in expr.args:
            ni, di = f.as_numer_denom()
            nd[di].append(ni)
        # put infinity in the numerator
        if S.Zero in nd:
            n = nd.pop(S.Zero)
            assert len(n) == 1
            n = n[0]
            nd[S.One].append(n/S.Zero)

        # check for quick exit
        if len(nd) == 1:
            d, n = nd.popitem()
            return Add(*[_keep_coeff(ncon, ni) for ni in n]), _keep_coeff(dcon, d)

        # sum up the terms having a common denominator
        for d, n in nd.iteritems():
            if len(n) == 1:
                nd[d] = n[0]
            else:
                nd[d] = Add(*n)

        # assemble single numerator and denominator
        denoms, numers = [list(i) for i in zip(*list(nd.iteritems()))]
        n, d = Add(*[Mul(*(denoms[:i]+[numers[i]]+denoms[i+1:]))
                   for i in xrange(len(numers))]), Mul(*denoms)

        return _keep_coeff(ncon, n), _keep_coeff(dcon, d)

    def _eval_is_polynomial(self, syms):
        return all(term._eval_is_polynomial(syms) for term in self.args)

    def _eval_is_rational_function(self, syms):
        return all(term._eval_is_rational_function(syms) for term in self.args)

    # assumption methods
    _eval_is_real = lambda self: self._eval_template_is_attr('is_real', when_multiple=None)
    _eval_is_antihermitian = lambda self: self._eval_template_is_attr('is_antihermitian', when_multiple=None)
    _eval_is_bounded = lambda self: self._eval_template_is_attr('is_bounded', when_multiple=None)
    _eval_is_hermitian = lambda self: self._eval_template_is_attr('is_hermitian', when_multiple=None)
    _eval_is_imaginary = lambda self: self._eval_template_is_attr('is_imaginary', when_multiple=None)
    _eval_is_integer = lambda self: self._eval_template_is_attr('is_integer', when_multiple=None)
    _eval_is_commutative = lambda self: self._eval_template_is_attr('is_commutative')

    def _eval_is_odd(self):
        l = [f for f in self.args if not (f.is_even==True)]
        if not l:
            return False
        if l[0].is_odd:
            return self._new_rawargs(*l[1:]).is_even

    def _eval_is_irrational(self):
        for t in self.args:
            a = t.is_irrational
            if a:
                others = list(self.args)
                others.remove(t)
                if all(x.is_rational is True for x in others):
                    return True
                return None
            if a is None:
                return
        return False

    def _eval_is_positive(self):
        if self.is_number:
            return super(Add, self)._eval_is_positive()
        pos = nonneg = nonpos = unknown_sign = False
        unbounded = set()
        args = [a for a in self.args if not a.is_zero]
        if not args:
            return False
        for a in args:
            ispos = a.is_positive
            ubound = a.is_unbounded
            if ubound:
                unbounded.add(ispos)
                if len(unbounded) > 1:
                    return None
            if ispos:
                pos = True
                continue
            elif a.is_nonnegative:
                nonneg = True
                continue
            elif a.is_nonpositive:
                nonpos = True
                continue
            elif a.is_zero:
                continue

            if ubound is None:
                # sign is unknown; if we don't know the boundedness
                # we're done: we don't know. That is technically true,
                # but the only option is that we have something like
                # oo - oo which is NaN and it really doesn't matter
                # what sign we apply to that because it (when finally
                # computed) will trump any sign. So instead of returning
                # None, we pass.
                pass
            else:
                return None
            unknown_sign = True

        if unbounded:
            return unbounded.pop()
        elif unknown_sign:
            return None
        elif not nonpos and not nonneg and pos:
            return True
        elif not nonpos and pos:
            return True
        elif not pos and not nonneg:
            return False

    def _eval_is_negative(self):
        if self.is_number:
            return super(Add, self)._eval_is_negative()
        neg = nonpos = nonneg = unknown_sign = False
        unbounded = set()
        args = [a for a in self.args if not a.is_zero]
        if not args:
            return False
        for a in args:
            isneg = a.is_negative
            ubound = a.is_unbounded
            if ubound:
                unbounded.add(isneg)
                if len(unbounded) > 1:
                    return None
            if isneg:
                neg = True
                continue
            elif a.is_nonpositive:
                nonpos = True
                continue
            elif a.is_nonnegative:
                nonneg = True
                continue
            elif a.is_zero:
                continue

            if ubound is None:
                # sign is unknown; if we don't know the boundedness
                # we're done: we don't know. That is technically true,
                # but the only option is that we have something like
                # oo - oo which is NaN and it really doesn't matter
                # what sign we apply to that because it (when finally
                # computed) will trump any sign. So instead of returning
                # None, we pass.
                pass
            unknown_sign = True

        if unbounded:
            return unbounded.pop()
        elif unknown_sign:
            return None
        elif not nonneg and not nonpos and neg:
            return True
        elif not nonneg and neg:
            return True
        elif not neg and not nonpos:
            return False

    def _eval_subs(self, old, new):
        if not old.is_Add:
            return None

        coeff_self, terms_self = self.as_coeff_Add()
        coeff_old, terms_old = old.as_coeff_Add()

        if coeff_self.is_Rational and coeff_old.is_Rational:
            if terms_self == terms_old:                       # (2 + a).subs( 3 + a, y) -> -1 + y
                return Add( new, coeff_self, -coeff_old)
            if terms_self == -terms_old:                      # (2 + a).subs(-3 - a, y) -> -1 - y
                return Add(-new, coeff_self,  coeff_old)

            args_old, args_self = Add.make_args(terms_old), Add.make_args(terms_self)
            if len(args_old) < len(args_self):    # (a+b+c+d).subs(b+c,x) -> a+x+d
                self_set = set(args_self)
                old_set = set(args_old)

                if old_set < self_set:
                    ret_set = self_set - old_set
                    return Add(new, coeff_self, -coeff_old,
                               *[s._subs(old, new) for s in ret_set])

                args_old = Add.make_args(-terms_old)     # (a+b+c+d).subs(-b-c,x) -> a-x+d
                old_set = set(args_old)
                if old_set < self_set:
                    ret_set = self_set - old_set
                    return Add(-new, coeff_self, coeff_old,
                               *[s._subs(old, new) for s in ret_set])

    def removeO(self):
        args = [a for a in self.args if not a.is_Order]
        return self._new_rawargs(*args)

    def getO(self):
        args = [a for a in self.args if a.is_Order]
        if args:
            return self._new_rawargs(*args)

    @cacheit
    def extract_leading_order(self, *symbols):
        """
        Returns the leading term and it's order.

        Examples
        ========

        >>> from sympy.abc import x
        >>> (x + 1 + 1/x**5).extract_leading_order(x)
        ((x**(-5), O(x**(-5))),)
        >>> (1 + x).extract_leading_order(x)
        ((1, O(1)),)
        >>> (x + x**2).extract_leading_order(x)
        ((x, O(x)),)

        """
        lst = []
        seq = [(f, C.Order(f, *symbols)) for f in self.args]
        for ef, of in seq:
            for e, o in lst:
                if o.contains(of) and o != of:
                    of = None
                    break
            if of is None:
                continue
            new_lst = [(ef, of)]
            for e, o in lst:
                if of.contains(o) and o != of:
                    continue
                new_lst.append((e, o))
            lst = new_lst
        return tuple(lst)

    def as_real_imag(self, deep=True, **hints):
        """
        returns a tuple represeting a complex numbers

        Examples
        ========

        >>> from sympy import I
        >>> (7 + 9*I).as_real_imag()
        (7, 9)
        """
        sargs, terms = self.args, []
        re_part, im_part = [], []
        for term in sargs:
            re, im = term.as_real_imag(deep=deep)
            re_part.append(re)
            im_part.append(im)
        return (self.func(*re_part), self.func(*im_part))

    def _eval_as_leading_term(self, x):
        from sympy import expand_mul, factor_terms

        old = self

        self = expand_mul(self)
        if not self.is_Add:
            return self.as_leading_term(x)

        unbounded = [t for t in self.args if t.is_unbounded]
        if unbounded:
            return Add._from_args(unbounded)

        self = Add(*[t.as_leading_term(x) for t in self.args]).removeO()
        if not self:
            # simple leading term analysis gave us 0 but we have to send
            # back a term, so compute the leading term (via series)
            return old.compute_leading_term(x)
        elif not self.is_Add:
            return self
        else:
            plain = Add(*[s for s, _ in self.extract_leading_order(x)])
            rv = factor_terms(plain, fraction=False)
            rv_fraction = factor_terms(rv, fraction=True)
            # if it simplifies to an x-free expression, return that;
            # tests don't fail if we don't but it seems nicer to do this
            if x not in rv_fraction.free_symbols:
                return rv_fraction
            return rv

    def _eval_adjoint(self):
        return Add(*[t.adjoint() for t in self.args])

    def _eval_conjugate(self):
        return Add(*[t.conjugate() for t in self.args])

    def _eval_transpose(self):
        return Add(*[t.transpose() for t in self.args])

    def __neg__(self):
        return Add(*[-t for t in self.args])

    def _sage_(self):
        s = 0
        for x in self.args:
            s += x._sage_()
        return s

    def primitive(self):
        """
        Return ``(R, self/R)`` where ``R``` is the Rational GCD of ``self```.

        ``R`` is collected only from the leading coefficient of each term.

        Examples
        ========

        >>> from sympy.abc import x, y

        >>> (2*x + 4*y).primitive()
        (2, x + 2*y)

        >>> (2*x/3 + 4*y/9).primitive()
        (2/9, 3*x + 2*y)

        >>> (2*x/3 + 4.2*y).primitive()
        (1/3, 2*x + 12.6*y)

        No subprocessing of term factors is performed:

        >>> ((2 + 2*x)*x + 2).primitive()
        (1, x*(2*x + 2) + 2)

        Recursive subprocessing can be done with the as_content_primitive()
        method:

        >>> ((2 + 2*x)*x + 2).as_content_primitive()
        (2, x*(x + 1) + 1)

        See also: primitive() function in polytools.py

        """

        terms = []
        inf = False
        for a in self.args:
            c, m = a.as_coeff_Mul()
            if not c.is_Rational:
                c = S.One
                m = a
            inf = inf or m is S.ComplexInfinity
            terms.append((c.p, c.q, m))

        if not inf:
            ngcd = reduce(igcd, [t[0] for t in terms], 0)
            dlcm = reduce(ilcm, [t[1] for t in terms], 1)
        else:
            ngcd = reduce(igcd, [t[0] for t in terms if t[1]], 0)
            dlcm = reduce(ilcm, [t[1] for t in terms if t[1]], 1)

        if ngcd == dlcm == 1:
            return S.One, self
        if not inf:
            for i, (p, q, term) in enumerate(terms):
                terms[i] = _keep_coeff(Rational((p//ngcd)*(dlcm//q)), term)
        else:
            for i, (p, q, term) in enumerate(terms):
                if q:
                    terms[i] = _keep_coeff(Rational((p//ngcd)*(dlcm//q)), term)
                else:
                    terms[i] = _keep_coeff(Rational(p, q), term)

        # we don't need a complete re-flattening since no new terms will join
        # so we just use the same sort as is used in Add.flatten. When the
        # coefficient changes, the ordering of terms may change, e.g.
        #     (3*x, 6*y) -> (2*y, x)
        #
        # We do need to make sure that term[0] stays in position 0, however.
        #
        if terms[0].is_Number or terms[0] is S.ComplexInfinity:
            c = terms.pop(0)
        else:
            c = None
        terms.sort(key=hash)
        if c:
            terms.insert(0, c)
        return Rational(ngcd, dlcm), self._new_rawargs(*terms)

    def as_content_primitive(self, radical=False):
        """Return the tuple (R, self/R) where R is the positive Rational
        extracted from self. If radical is True (default is False) then
        common radicals will be removed and included as a factor of the
        primitive expression.

        Examples
        ========

        >>> from sympy import sqrt
        >>> (3 + 3*sqrt(2)).as_content_primitive()
        (3, 1 + sqrt(2))

        Radical content can also be factored out of the primitive:

        >>> (2*sqrt(2) + 4*sqrt(10)).as_content_primitive(radical=True)
        (2, sqrt(2)*(1 + 2*sqrt(5)))

        See docstring of Expr.as_content_primitive for more examples.
        """
        con, prim = Add(*[_keep_coeff(*a.as_content_primitive(radical=radical)) for a in self.args]).primitive()
        if radical and prim.is_Add:
            # look for common radicals that can be removed
            args = prim.args
            rads = []
            common_q = None
            for m in args:
                term_rads = defaultdict(list)
                for ai in Mul.make_args(m):
                    if ai.is_Pow:
                        b, e = ai.as_base_exp()
                        if e.is_Rational and b.is_Integer and b > 0:
                            term_rads[e.q].append(int(b)**e.p)
                if not term_rads:
                    break
                if common_q is None:
                    common_q = set(term_rads.keys())
                else:
                    common_q = common_q & set(term_rads.keys())
                    if not common_q:
                        break
                rads.append(term_rads)
            else:
                # process rads
                # keep only those in common_q
                for r in rads:
                    for q in r.keys():
                        if q not in common_q:
                            r.pop(q)
                    for q in r:
                        r[q] = prod(r[q])
                # find the gcd of bases for each q
                G = []
                for q in common_q:
                    g = reduce(igcd, [r[q] for r in rads], 0)
                    if g != 1:
                        G.append(g**Rational(1, q))
                if G:
                    G = Mul(*G)
                    args = [ai/G for ai in args]
                    prim = G*Add(*args)

        return con, prim

    @property
    def _sorted_args(self):
        from sympy.utilities.misc import default_sort_key
        return sorted(self.args, key=lambda w: default_sort_key(w))

from mul import Mul, _keep_coeff, prod
from sympy.core.numbers import Rational
