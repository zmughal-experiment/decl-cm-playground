-- SQL: PostgreSQL

\pset expanded on

SELECT
  *
FROM sources
WHERE
  source = 'tesseract-lang'
ORDER BY
  version DESC
LIMIT 1;

\pset expanded off
