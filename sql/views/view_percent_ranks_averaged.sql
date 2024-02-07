CREATE VIEW public.percent_ranks_averaged
 AS
 WITH avg_ratios AS (
		 SELECT ranking_ratios.ein,
			avg(ranking_ratios.gen_fund_acquisition_ratio) AS gen_fund_acquisition_ratio,
			avg(ranking_ratios.gen_res_allocation_ratio) AS gen_res_allocation_ratio,
			avg(ranking_ratios.gen_asset_utilization_ratio) AS gen_asset_utilization_ratio,
			avg(ranking_ratios.tot_fund_acquisition_ratio) AS tot_fund_acquisition_ratio,
			avg(ranking_ratios.tot_res_allocation_ratio) AS tot_res_allocation_ratio,
			avg(ranking_ratios.tot_asset_utilization_ratio) AS tot_asset_utilization_ratio,
			avg(ranking_ratios.sec_fund_acquisition_ratio) AS sec_fund_acquisition_ratio,
			avg(ranking_ratios.sec_res_allocation_ratio) AS sec_res_allocation_ratio,
			avg(ranking_ratios.sec_asset_utilization_ratio) AS sec_asset_utilization_ratio
		FROM ranking_ratios
		GROUP BY ranking_ratios.ein
		)
SELECT ein,
	charity_name,
	sector,
	gen_fund_acquisition_rank,
	gen_res_allocation_rank,
	gen_asset_utilization_rank,
	tot_fund_acquisition_rank,
	tot_res_allocation_rank,
	tot_asset_utilization_rank,
	sec_fund_acquisition_rank,
	sec_res_allocation_rank,
	sec_asset_utilization_rank,
	(gen_fund_acquisition_rank + gen_res_allocation_rank + gen_asset_utilization_rank) / 3 AS gen_avg_rank,
	(tot_fund_acquisition_rank + tot_res_allocation_rank + tot_asset_utilization_rank) / 3 AS tot_avg_rank,
	(sec_fund_acquisition_rank + sec_res_allocation_rank + sec_asset_utilization_rank) / 3 AS sec_avg_rank
FROM ( SELECT r.ein,
	charities.charity_name,
	charities.sector,
	percent_rank() OVER (ORDER BY r.gen_fund_acquisition_ratio) AS gen_fund_acquisition_rank,
	percent_rank() OVER (ORDER BY r.gen_res_allocation_ratio) AS gen_res_allocation_rank,
	percent_rank() OVER (ORDER BY r.gen_asset_utilization_ratio) AS gen_asset_utilization_rank,
	percent_rank() OVER (ORDER BY r.tot_fund_acquisition_ratio) AS tot_fund_acquisition_rank,
	percent_rank() OVER (ORDER BY r.tot_res_allocation_ratio) AS tot_res_allocation_rank,
	percent_rank() OVER (ORDER BY r.tot_asset_utilization_ratio) AS tot_asset_utilization_rank,
	percent_rank() OVER (PARTITION BY charities.sector ORDER BY r.sec_fund_acquisition_ratio) AS sec_fund_acquisition_rank,
	percent_rank() OVER (PARTITION BY charities.sector ORDER BY r.sec_res_allocation_ratio) AS sec_res_allocation_rank,
	percent_rank() OVER (PARTITION BY charities.sector ORDER BY r.sec_asset_utilization_ratio) AS sec_asset_utilization_rank
	FROM avg_ratios r
		LEFT JOIN charities USING (ein)
)
ORDER BY charity_name;
