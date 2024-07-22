-- SQL: PostgreSQL
SELECT
  watch_file
FROM upstream
WHERE
    source IN ( 'tesseract-lang', 'vim' )
ORDER BY
  version DESC
;
