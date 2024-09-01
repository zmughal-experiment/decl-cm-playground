-- SQL: PostgreSQL
SELECT
  source,
  tag_type,
  tag,
  information
FROM lintian_results
WHERE
      (
            source IN ('tesseract', 'tesseract-lang' )
      -- OR source LIKE 'tesseract%'
      )
  AND architecture = 'source'
  AND tag_type = 'classification'
  AND tag IN ('upstream-metadata', 'vcs', 'vcs-uri')
;
