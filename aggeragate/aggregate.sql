-- Aggregate to subdomain level
INSERT INTO SubdomainData (fips, id, value)
SELECT fips, sId AS id, AVG(value) AS value
FROM MeasureScaledData JOIN MeasureInfo ON MeasureScaledData.id = MeasureInfo.id
GROUP BY fips, sId;

-- Aggregate to domain level
INSERT INTO DomainData (fips, id, value)
SELECT fips, dId AS id, AVG(value) AS value
FROM SubdomainData JOIN SubdomainInfo ON SubdomainData.id = SubdomainInfo.id
GROUP BY fips, dId;


-- Create table where domains are in columns
DROP TABLE IF EXISTS DomainOut;
CREATE TABLE DomainOut AS
SELECT County.fips, TCF.CF, TPR.PR, TPM.PM, TPVID.PVID, TSC.SC, TEvent.Event, TER.ER FROM County
LEFT OUTER JOIN (SELECT fips, value AS CF FROM DomainData WHERE id='CF') AS TCF ON County.fips = TCF.fips
LEFT OUTER JOIN (SELECT fips, value AS PR FROM DomainData WHERE id='PR') AS TPR ON County.fips = TPR.fips
LEFT OUTER JOIN (SELECT fips, value AS PM FROM DomainData WHERE id='PM') AS TPM ON County.fips = TPM.fips
LEFT OUTER JOIN (SELECT fips, value AS PVID FROM DomainData WHERE id='PVID') AS TPVID ON County.fips = TPVID.fips
LEFT OUTER JOIN (SELECT fips, value AS SC FROM DomainData WHERE id='SC') AS TSC ON County.fips = TSC.fips
LEFT OUTER JOIN (SELECT fips, value AS Event FROM DomainData WHERE id='Event') AS TEvent ON County.fips = TEvent.fips
LEFT OUTER JOIN (SELECT fips, value AS ER FROM DomainData WHERE id='ER') AS TER ON County.fips = TER.fips;