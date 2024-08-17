-- SQL: PostgreSQL
SELECT
  source,
  information
FROM lintian_results
WHERE
      architecture = 'source'
  AND tag_type = 'classification'
  AND tag = 'upstream-metadata'
  AND information LIKE 'Repository %'
ORDER BY source
LIMIT 10
;
