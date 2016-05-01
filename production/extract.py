import pandas
import sqlite3
import numpy
import copy
from scipy import stats

conn = sqlite3.connect('dataout/all.db')


query = """
    SELECT domains.fips, "Natural Systems", "Engineered Systems", PM
    FROM subdomains, domains, measures
    WHERE subdomains.fips = domains.fips AND measures.fips = domains.fips
"""
T = pandas.read_sql(query, conn).set_index('fips')
Tresult = pandas.DataFrame.from_csv('dataout/results.csv')
T = T.join(Tresult)

T.to_csv('dataout/distance.csv')


def scale(x0):
    x = copy.deepcopy(x0)
    # Box Cox transformation
    x[x0 > 0], _ = stats.boxcox(x[x0 > 0])
    x[x0 <= 0] = min(x[x0 > 0])
    # Truncation
    right_target = x.mean() + 3.5 * x.std()
    left_target = x.mean() - 3.5 * x.std()
    x[x > right_target] = right_target
    x[x < left_target] = left_target;
    x = (x - x.min()) / (x.max() - x.min())
    return x


Tdis = pandas.DataFrame.from_csv('data/measures/101.csv')
Tdis.columns = ['raw']
Tdis['scaled_raw'] = scale(Tdis['raw'])
Tdis['exp250'] = 1 - numpy.exp(- Tdis['raw'] / 0.25)
Tdis['scaled_exp250'] = scale(Tdis['exp250'])
Tdis['exp500'] = 1 - numpy.exp(- Tdis['raw'] / 0.5)
Tdis['scaled_exp500'] = scale(Tdis['exp500'])
# Tdis.to_csv('dataout/extract.csv')