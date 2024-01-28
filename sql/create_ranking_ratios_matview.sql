-- GENERAL FA/RA/AU ratios
CREATE MATERIALIZED VIEW public.ranking_ratios
AS
SELECT
	gen.ein,
	gen.tax_year,
	gen_fund_acquisition_ratio,
	gen_res_allocation_ratio,
	gen_asset_utilization_ratio,
	tot_fund_acquisition_ratio,
	tot_res_allocation_ratio,
	tot_asset_utilization_ratio,
	sec_fund_acquisition_ratio,
	sec_res_allocation_ratio,
	sec_asset_utilization_ratio
FROM
(SELECT
	ein,
	tax_year,
 	charity_name,
	(fin.contribution_reliance_ratio/med.contribution_reliance_ratio
		- fin.fundraising_cost_ratio/med.fundraising_cost_ratio
	) as gen_fund_acquisition_ratio,
	(fin.program_output_ratio/med.program_output_ratio
		- fin.spending_ratio/med.spending_ratio
	) as gen_res_allocation_ratio,
	(fin.cur_asset_turnover/med.cur_asset_turnover
		- fin.degree_of_lt_investment/med.degree_of_lt_investment
	) as gen_asset_utilization_ratio
FROM pretty_financials fin
LEFT JOIN medians med on med.sector = 'General') gen
LEFT JOIN (SELECT
	ein,
	tax_year,
	(fin.contribution_reliance_ratio/med.contribution_reliance_ratio
		- fin.fundraising_cost_ratio/med.fundraising_cost_ratio
	) AS tot_fund_acquisition_ratio,
	(fin.program_output_ratio/med.program_output_ratio
		- fin.spending_ratio/med.spending_ratio
	) AS tot_res_allocation_ratio,
	(fin.cur_asset_turnover/med.cur_asset_turnover
		- fin.degree_of_lt_investment/med.degree_of_lt_investment
	) AS tot_asset_utilization_ratio
FROM pretty_financials fin
INNER JOIN medians med ON med.sector = 'Total') tot
ON gen.ein = tot.ein AND gen.tax_year = tot.tax_year
INNER JOIN (SELECT
	ein,
	tax_year,
	(fin.contribution_reliance_ratio/med.contribution_reliance_ratio
		- fin.fundraising_cost_ratio/med.fundraising_cost_ratio
	) AS sec_fund_acquisition_ratio,
	(fin.program_output_ratio/med.program_output_ratio
		- fin.spending_ratio/med.spending_ratio
	) AS sec_res_allocation_ratio,
	(fin.cur_asset_turnover/med.cur_asset_turnover
		- fin.degree_of_lt_investment/med.degree_of_lt_investment
	) AS sec_asset_utilization_ratio
FROM pretty_financials fin
LEFT JOIN medians med ON med.sector = fin.sector) sec
ON gen.ein = sec.ein AND gen.tax_year = sec.tax_year;
