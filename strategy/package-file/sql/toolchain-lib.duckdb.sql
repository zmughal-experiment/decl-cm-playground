ATTACH 'package_clusters.db';

SELECT *
FROM (
    SELECT
    DISTINCT
        list_aggregate(
            str_split(file,'/')[0:4],
            'string_agg',
            '/'
        ) AS lib3
    FROM package_clusters.package_files
    WHERE file
    LIKE '/usr/lib/%/%'
)
WHERE
    lib3 LIKE '%-gnu%'
ORDER BY lib3;
