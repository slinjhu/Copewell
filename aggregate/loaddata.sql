-- A temporary table to hold measure information
DROP TABLE IF EXISTS MeasureBuffer;
CREATE TABLE MeasureBuffer (
    id VARCHAR(5) PRIMARY KEY,
    description TEXT NOT NULL,
    domain TEXT NOT NULL,
    subdomain TEXT NOT NULL,
    direction CHAR NOT NULL
);


INSERT INTO SubdomainInfo (description, dId) SELECT DISTINCT subdomain, domain FROM MeasureBuffer;
INSERT INTO MeasureInfo (id, description, sId, direction)
SELECT MeasureBuffer.id, MeasureBuffer.description, SubdomainInfo.id, direction
FROM MeasureBuffer, SubdomainInfo
WHERE SubdomainInfo.description = subdomain AND SubdomainInfo.dId = domain;
