\pset expanded off

WITH
	t_name_with_count AS (
		SELECT
			name,
			COUNT(name) AS name_count
		FROM
			projects
		GROUP BY
			name
		ORDER BY
			name_count DESC
	)
SELECT
	*
FROM
	t_name_with_count
WHERE
	name_count > 1
;
