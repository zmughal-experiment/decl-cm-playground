-- SQL: DuckDB

.mode lines

SELECT
  *
FROM udd.sources
WHERE
  source = 'tesseract-lang'
ORDER BY
  version DESC
LIMIT 1;
