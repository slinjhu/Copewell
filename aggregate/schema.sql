PRAGMA foreign_keys = ON;


DROP TABLE IF EXISTS MeasureData;
CREATE TABLE MeasureData (
    id VARCHAR(5), fips INT,
    value FLOAT NOT NULL,
    PRIMARY KEY(id, fips),
    FOREIGN KEY(id) REFERENCES MeasureInfo(id),
    FOREIGN KEY(fips) REFERENCES County(fips)
);


DROP TABLE IF EXISTS MeasureScaledData;
CREATE TABLE MeasureScaledData (
    id VARCHAR(5), fips INT,
    value FLOAT NOT NULL,
    PRIMARY KEY(id, fips),
    FOREIGN KEY(id) REFERENCES MeasureInfo(id),
    FOREIGN KEY(fips) REFERENCES County(fips)
);

DROP TABLE IF EXISTS SubdomainData;
CREATE TABLE SubdomainData (
    id INT, fips INT,
    value FLOAT NOT NULL,
    PRIMARY KEY(id, fips),
    FOREIGN KEY(id) REFERENCES SubdomainInfo(id),
    FOREIGN KEY(fips) REFERENCES County(fips)
);

DROP TABLE IF EXISTS DomainData;
CREATE TABLE DomainData (
    id INT, fips INT,
    value FLOAT NOT NULL,
    PRIMARY KEY(id, fips),
    FOREIGN KEY(id) REFERENCES DomainInfo(id),
    FOREIGN KEY(fips) REFERENCES County(fips)
);


DROP TABLE IF EXISTS County;
CREATE TABLE County (
    fips INTEGER PRIMARY KEY,
    nameState TEXT NOT NULL,
    nameCounty TEXT NOT NULL,
    abState TEXT NOT NULL,
    population INT,
    area FLOAT
);

DROP TABLE IF EXISTS MeasureInfo;
CREATE TABLE MeasureInfo (
    id VARCHAR(5) PRIMARY KEY,
    description TEXT NOT NULL,
    sId INT NOT NULL,
    FOREIGN KEY(sId) REFERENCES SubdomainInfo(id)
);

DROP TABLE IF EXISTS SubdomainInfo;
CREATE TABLE SubdomainInfo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    dId VARCHAR(5) NOT NULL,
    FOREIGN KEY(dId) REFERENCES DomainInfo(id)
);

DROP TABLE IF EXISTS DomainInfo;
CREATE TABLE DomainInfo (
    id VARCHAR(5) PRIMARY KEY,
    description TEXT NOT NULL,
    defaultValue FLOAT DEFAULT 0.5
);



-- A temporary table for loading info.
DROP TABLE IF EXISTS MeasureBuffer;
CREATE TABLE MeasureBuffer (
    id VARCHAR(5) PRIMARY KEY,
    description TEXT NOT NULL,
    domain TEXT NOT NULL,
    subdomain TEXT NOT NULL
);