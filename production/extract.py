import pandas
import sqlite3

conn = sqlite3.connect('dataout/all.db')


#query = 'SELECT raw101, scaled101 FROM measures'
query = """
    SELECT domains.fips, "Natural Systems", "Engineered Systems", PM
    FROM subdomains, domains, measures
    WHERE subdomains.fips = domains.fips AND measures.fips = domains.fips
"""
T = pandas.read_sql(query, conn).set_index('fips')
Tresult = pandas.DataFrame.from_csv('dataout/results.csv')
T = T.join(Tresult)

T.to_csv('dataout/distance.csv')
