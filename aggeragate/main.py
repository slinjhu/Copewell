"""
This file prepares data for the app.
"""
import sqlite3
import csv
import pandas.io.sql as sql
import os
import pandas
import numpy
import json
from scipy.integrate import odeint



class DB():
    def __init__(self, filename):
        self.conn = sqlite3.connect(filename)
        self.c = self.conn.cursor()
        self.resetDB()


    def resetDB(self):
        with open('schema.sql', 'rU') as f:
            cmd = f.read()
            self.c.executescript(cmd)
        self.load_from_csv('sys/county_48ALHI.csv', 'County')
        self.load_from_csv('sys/domains.csv', 'DomainInfo')
        self.load_from_csv('sys/list.csv', 'MeasureBuffer')
        self.c.executescript("""
        INSERT INTO SubdomainInfo (description, dId) SELECT DISTINCT subdomain, domain FROM MeasureBuffer;
        INSERT INTO MeasureInfo (id, description, sId, direction)
        SELECT MeasureBuffer.id, MeasureBuffer.description, SubdomainInfo.id, direction
        FROM MeasureBuffer, SubdomainInfo
        WHERE SubdomainInfo.description = subdomain AND SubdomainInfo.dId = domain;
        """)
        self.load_measure_data('../data', 'MeasureData')
        self.load_measure_data('../data_scaled', 'MeasureScaledData')
        with open('aggregate.sql', 'rU') as f:
            self.c.executescript(f.read())

    def __del__(self):
        self.conn.commit()
        self.conn.close()

    def load_from_csv(self, infile, tableName, extra={}):
        with open(infile, 'rU') as f:
            dr = csv.DictReader(f)
            for row in dr:
                try:
                    row.update(extra)
                    columns = ','.join(row.keys())
                    placeholder = ','.join('?' * len(row))
                    cmd = 'INSERT INTO {} ({}) VALUES ({})'.format(tableName, columns, placeholder)
                    self.c.execute(cmd, tuple(row.values()))
                except sqlite3.IntegrityError:
                    print(row)

    def load_measure_data(self, folder, table):
        for id in self.get_all_id('measure'):
            filename = '{}/{}.csv'.format(folder, id)
            self.load_from_csv(filename, table, {'id': id})

    def get_all_id(self, level, cond=1):
        table = level.title() + 'Info'
        return self.fetch_list('SELECT id FROM {} WHERE {}'.format(table, cond))

    def fetch_list(self, cmd):
        """ Run query on single column and convert the fetch result to list
        """
        self.c.execute(cmd)
        result = self.c.fetchall()
        return [item[0] for item in result]

    def export(self):
        for domain in self.get_all_id('domain'):
            table = sql.read_sql('select fips, value from DomainData where id=\'{}\''.format(domain), self.conn)

            # scale to [0,1]?
            #x = table['value']
            #table['value'] = (x - x.min()) / (x.max() - x.min())

            table.to_csv('../data_domain/{}.csv'.format(domain), index=False)
        for subdomain in self.get_all_id('subdomain'):
            table = sql.read_sql('select fips, value from SubdomainData where id=\'{}\''.format(subdomain), self.conn)
            table.to_csv('../data_subdomain/{}.csv'.format(subdomain), index=False)
        table = sql.read_sql('select * from DomainOut', self.conn)
        table.to_csv('../data_domain/all.csv', index=False)


db = DB('copewell.db')
db.export()



