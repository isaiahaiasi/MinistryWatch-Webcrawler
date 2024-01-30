CREATE VIEW public.charity_ranks
AS
SELECT
	rr.*,
	(gen_fund_acquisition_rank + gen_res_allocation_rank + gen_asset_utilization_rank)/3 AS gen_avg_rank,
	(tot_fund_acquisition_rank + tot_res_allocation_rank + tot_asset_utilization_rank)/3 AS tot_avg_rank,
	(sec_fund_acquisition_rank + sec_res_allocation_rank + sec_asset_utilization_rank)/3 AS sec_avg_rank
FROM (
	SELECT
		r.ein,
		r.tax_year,
		RANK() OVER(ORDER BY r.gen_fund_acquisition_ratio) AS gen_fund_acquisition_rank,
		RANK() OVER(ORDER BY r.gen_res_allocation_ratio) AS gen_res_allocation_rank,
		RANK() OVER(ORDER BY r.gen_asset_utilization_ratio) AS gen_asset_utilization_rank,
		RANK() OVER(ORDER BY r.tot_fund_acquisition_ratio) AS tot_fund_acquisition_rank,
		RANK() OVER(ORDER BY r.tot_res_allocation_ratio) AS tot_res_allocation_rank,
		RANK() OVER(ORDER BY r.tot_asset_utilization_ratio) AS tot_asset_utilization_rank,
		RANK() OVER(
			PARTITION BY charities.sector
			ORDER BY r.sec_fund_acquisition_ratio
		) AS sec_fund_acquisition_rank,
		RANK() OVER(
			PARTITION BY charities.sector
			ORDER BY r.sec_res_allocation_ratio
		) AS sec_res_allocation_rank,
		RANK() OVER(
			PARTITION BY charities.sector
			ORDER BY r.sec_asset_utilization_ratio
		) AS sec_asset_utilization_rank
	FROM ranking_ratios r
	LEFT JOIN charities ON r.ein = charities.ein
) AS rr;
