\pset expanded off

WITH
	t_project_package_with_distro_count AS (
		SELECT
			project_id,
			COUNT(DISTINCT distro_name) AS project_distro_count
		FROM
			packages
		GROUP BY
			project_id
	)
SELECT
	p.name,
	p.id,
	d.project_distro_count
FROM
	t_project_package_with_distro_count AS d
JOIN
	projects AS p
ON
	p.id = d.project_id
WHERE
	d.project_distro_count > 1
ORDER BY
	d.project_distro_count DESC
;
