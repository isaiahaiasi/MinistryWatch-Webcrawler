CREATE VIEW public.max_compensations
AS

SELECT charity_name,
	sector,
	ein,
	full_name,
	title,
	max_compensation
FROM (
	SELECT pretty_compensations.charity_name,
		pretty_compensations.sector,
		pretty_compensations.ein,
		pretty_compensations.full_name,
		pretty_compensations.title,
		max_comps.max_compensation,
		row_number() OVER (PARTITION BY pretty_compensations.charity_name) AS row_number
	FROM (
		SELECT pretty_compensations_1.ein,
			max(pretty_compensations_1.compensation) AS max_compensation
		FROM pretty_compensations pretty_compensations_1
		GROUP BY pretty_compensations_1.charity_name, pretty_compensations_1.ein
	) max_comps
	LEFT JOIN pretty_compensations
		ON pretty_compensations.ein = max_comps.ein
		AND pretty_compensations.compensation = max_comps.max_compensation
)
WHERE row_number = 1;
