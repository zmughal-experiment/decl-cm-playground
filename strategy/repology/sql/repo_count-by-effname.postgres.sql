-- SQL: PostgreSQL
WITH
	param AS (
		SELECT unnest(ARRAY[
			'geos',
			'r:rgeos',
			'vim'
		]) AS p_effname
	),
	metapackages_count AS (
		SELECT
			effname,
			num_repos AS repo_count
		FROM metapackages
		JOIN param
		ON effname = p_effname
	),
	packages_count AS (
		SELECT
			effname,
			COUNT(DISTINCT repo) AS repo_count
		FROM packages
		JOIN param
		ON effname = p_effname
		GROUP BY effname
	),
	compare_counts AS (
		SELECT
			param.p_effname                            ,
			m.repo_count AS "metapackages.repo_count"  ,
			p.repo_count AS "packages.repo_count"    --,
		FROM param
		JOIN metapackages_count m
		ON p_effname = m.effname
		JOIN packages_count p
		ON p_effname = p.effname
	),
	are_counts_equal AS (
		SELECT
			every(
				"metapackages.repo_count"
				= "packages.repo_count" )
			AS all_repo_counts_equal
		FROM compare_counts
	)
SELECT * FROM compare_counts
;
