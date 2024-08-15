-- SQL: PostgreSQL
SELECT
  DISTINCT tag
FROM lintian_results
WHERE
      architecture = 'source'
  AND tag_type = 'classification'
;
