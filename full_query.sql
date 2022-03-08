-- single log file for whole db
CREATE TEMP TABLE joined_logs AS
(

SELECT
    "date" as "Date", 
    logs."userid",
    logs."ip" as "IP",
    "file" as "Path",
    "size" as "Size",
    ("size" / 1024^3) as "Size (GB)",
    "first" as "FirstName",
    "last" as "LastName",
    "country" as "Country",
    "isp",

    CASE WHEN file LIKE '%dmsp%'
        THEN 'DMSP'
    WHEN file LIKE '%j01%'
        THEN 'J01'
    WHEN file LIKE '%npp%'
        THEN 'NPP'
    ELSE 
        NULL
    END
    as "Satellite",

    CASE WHEN file LIKE '%VBD%'
        THEN 'VBD'
    WHEN file LIKE '%VNF%'
        THEN 'VNF'
    WHEN file LIKE '%VNL%'
        THEN 'VNL'
    WHEN file LIKE '%SVDNB%'
        THEN 'VNL'
    WHEN file LIKE '%dmsp%'
        THEN 'NTL'
    ELSE
        NULL
    END
    as "Product",

    CASE WHEN file LIKE '%-ez.csv%'
        THEN 'ezCSV'
    WHEN file LIKE '%.csv%'
        THEN 'fullCSV'
    WHEN file LIKE '%.kmz%'
        THEN 'KMZ'
    WHEN file LIKE '%.tgz%'
        THEN 'TGZ'
    WHEN file LIKE '%.tif%'
        THEN 'TIF'
    ELSE
        NULL
    END
    as "filetype"

FROM
    logs LEFT JOIN userid_to_id
        ON logs.userid = userid_to_id.userid
    LEFT JOIN ip_to_country
        ON logs.ip = ip_to_country.ip
    LEFT JOIN ip_to_isp
        ON logs.ip = ip_to_isp.ip

WHERE
    "date" >= '2021-01-01'::date
    AND "date" < '2022-01-01'
    AND size IS NOT NULL

ORDER BY "date" ASC

);


\copy joined_logs to 'logs_2021.csv' csv header
