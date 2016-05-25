# -*- coding: utf-8 -*-
"""
Created on Fri Apr  1 18:11:14 2016

@author: xjshao
"""

from sympy import *
print pi*Symbol('r')**2
print integrate(Symbol('x'))
print Symbol('k')*Symbol('m')/Symbol('s')
print 3

x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = map(Function, 'fgh')


print Add(x,y)
print Add(k,m).doit()
print Sum(x(n),(n,1,6))
print Sum(x(n),(n,1,6)).doit()


def f(m):
    return Sum(x(n),(n,1,m))/m
def g(m):
    return Sum((x(n)-f(m))**2,(n,1,m))/(m-1)
    
    
h=(x(1)-x(2))**2+(x(3)-x(4))**2+(x(5)-x(6))**2
print simplify(g(6)-h)

def y(n):
    return (x(n)+x(n+1))/2
    
def z(n):
    return (x(n)-y(n))
    
def mean(x,m):
    return Sum(x(n),(n,1,m))/m
def variance(x,m):
    return Sum((x(n)-mean(x,m))**2,(n,1,m))/(m-1)

h=simplify((variance(x,m)-variance(y,m)).doit())
"""
g(n)=(f(n)+f(n+1))/2
h(n)=f(n)-g(n)
Sum((h(n)-Sum(h(n),(n,1,6))/6),(n,1,6))^(1/2)
"""