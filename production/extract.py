import pandas
import sqlite3
import numpy
import copy
from scipy import stats



T = pandas.DataFrame.from_csv('dataout/results.csv')

def toquantile(x0):
    x = copy.deepcopy(x0)
    x = stats.rankdata(x) / len(x)
    N = 4.0
    x = numpy.floor(x * N) / N
    x[x==1] = 1 - 1/N
    return x

T['Quantitle resistance'] = toquantile(T['resistance'])
T['Quantitle recovery'] = toquantile(T['recovery'])
T['Quantitle resilience'] = toquantile(T['resilience'])

T.to_csv('dataout/results.csv')