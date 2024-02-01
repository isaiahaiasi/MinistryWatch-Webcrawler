CREATE VIEW public.compensation_stats
AS
SELECT
	'Total (filtered)' as sector,
	'All' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
AND max_compensations.sector NOT LIKE ALL (ARRAY['Radio/ TV Stations', 'Colleges/Universities'])
UNION
SELECT
	'Total (filtered)' as sector,
	'< $1M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue < '$1,000,000'
AND max_compensations.sector NOT LIKE ALL (ARRAY['Radio/ TV Stations', 'Colleges/Universities'])
UNION
SELECT
	'Total (filtered)' as sector,
	'$1M - $10M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$1,000,000' and total_revenue < '$10,000,000'
AND max_compensations.sector NOT LIKE ALL (ARRAY['Radio/ TV Stations', 'Colleges/Universities'])
UNION
SELECT
	'Total (filtered)' as sector,
	'$10M - $50M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$10,000,000' and total_revenue < '$50,000,000'
AND max_compensations.sector NOT LIKE ALL (ARRAY['Radio/ TV Stations', 'Colleges/Universities'])
UNION
SELECT
	'Total (filtered)' as sector,
	'$50M - $100M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$50,000,000' and total_revenue < '$100,000,000'
AND max_compensations.sector NOT LIKE ALL (ARRAY['Radio/ TV Stations', 'Colleges/Universities'])
UNION
SELECT
	'Total (filtered)' as sector,
	'>$100M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$100,000,000'
AND max_compensations.sector NOT LIKE ALL (ARRAY['Radio/ TV Stations', 'Colleges/Universities'])
UNION

SELECT
	max_compensations.sector,
	'All' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
GROUP BY max_compensations.sector
UNION
SELECT
	max_compensations.sector,
	'< $1M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue < '$1,000,000'
GROUP BY max_compensations.sector
UNION
SELECT
	max_compensations.sector,
	'$1M - $10M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$1,000,000' and total_revenue < '$10,000,000'
GROUP BY max_compensations.sector
UNION
SELECT
	max_compensations.sector,
	'$10M - $50M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$10,000,000' and total_revenue < '$50,000,000'
GROUP BY max_compensations.sector
UNION
SELECT
	max_compensations.sector,
	'$50M - $100M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$50,000,000' and total_revenue < '$100,000,000'
GROUP BY max_compensations.sector
UNION
SELECT
	max_compensations.sector,
	'>$100M' as charity_size,
	PERCENTILE_DISC(0.5) WITHIN GROUP (
		ORDER BY max_compensation
	) AS median,
	AVG(max_compensation::numeric)::money as mean,
	STDDEV_SAMP (max_compensation::numeric)::money as std_dev
FROM max_compensations
LEFT JOIN financials
	ON max_compensations.ein = financials.ein
WHERE total_revenue >= '$100,000,000'
GROUP BY max_compensations.sector
ORDER BY sector, mean;
