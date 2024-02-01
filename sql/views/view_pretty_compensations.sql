CREATE VIEW public.pretty_compensations
AS
SELECT ch.charity_name,
	ch.sector,
	ch.ein,
	comp.full_name,
	comp.title,
	comp.compensation,
	comp.compensation_date
FROM compensations comp
LEFT JOIN charities ch ON ch.ein = comp.ein
ORDER BY ch.charity_name;
