#!/bin/python
#

import numpy as np
import matplotlib.pyplot as plt
import scipy.stats
import scipy.optimize

data = np.array([-69,3, -68, 2, -67, 1, -66, 1, -60, 1, -59, 1,
                 -58, 1, -57, 2, -56, 1, -55, 1, -54, 1, -52, 1,
                 -50, 2, -48, 3, -47, 1, -46, 3, -45, 1, -43, 1,
                 0, 1, 1, 2, 2, 12, 3, 18, 4, 18, 5, 13, 6, 9,
                 7, 7, 8, 5, 9, 3, 10, 1, 13, 2, 14, 3, 15, 2,
                 16, 2, 17, 2, 18, 2, 19, 2, 20, 2, 21, 3, 22, 1,
                 24, 1, 25, 1, 26, 1, 28, 2, 31, 1, 38, 1, 40, 2])
x, y = data.reshape(-1, 2).T

def tri_norm(x, *args):
    m1, m2, m3, s1, s2, s3, k1, k2, k3 = args
    ret = k1*scipy.stats.norm.pdf(x, loc=m1 ,scale=s1)
    ret += k2*scipy.stats.norm.pdf(x, loc=m2 ,scale=s2)
    ret += k3*scipy.stats.norm.pdf(x, loc=m3 ,scale=s3)
    return ret


params = [-50, 3, 20, 1, 1, 1, 1, 1, 1]

fitted_params,_ = scipy.optimize.curve_fit(tri_norm,x, y, p0=params)

plt.plot(x, y, 'o')
xx = np.linspace(np.min(x), np.max(x), 1000)
plt.plot(xx, tri_norm(xx, *fitted_params))
plt.show()
