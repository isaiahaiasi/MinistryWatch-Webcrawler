SELECT
	charities.charity_name,
	charities.sector,

	--RANKS (rank order obviously placeholder atm)
	RANK() OVER(
		PARTITION BY financials.tax_year
		ORDER BY financials.cash DESC
	) AS overall_rank,
	RANK() OVER(
		PARTITION BY charities.sector, financials.tax_year
		ORDER BY financials.cash DESC
	) as sector_rank,

	financials.*

FROM financials
LEFT JOIN charities
ON financials.ein = charities.ein
-- "Validity Heuristic"
WHERE financials.tax_year > 2015
	AND financials.total_revenue <> '$0'
	AND financials.total_current_assets <> '$0'
ORDER BY
	financials.tax_year,
	charities.sector,
	overall_rank;
