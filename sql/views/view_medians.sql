CREATE VIEW public.medians
AS
/*
rows: sectors + general + total
*/
SELECT
	pretty_financials.sector,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_cost_ratio) fundraising_cost_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY contribution_reliance_ratio) contribution_reliance_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY spending_ratio) spending_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY program_output_ratio) program_output_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY degree_of_lt_investment) degree_of_lt_investment,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY cur_asset_turnover) cur_asset_turnover,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY program_expense_ratio) program_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY gen_admin_expense_ratio) gen_admin_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_expense_ratio) fundraising_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY gen_admin_revenue_ratio) gen_admin_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_revenue_ratio) fundraising_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY savings_revenue_ratio) savings_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY return_on_fr_effort) return_on_fr_effort,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY other_revenue_reliance) other_revenue_reliance,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY total_asset_turnover) total_asset_turnover,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY reserve_accumulation_rate) reserve_accumulation_rate,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY current_liquidity_ratio) current_liquidity_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY liquid_reserve_level) liquid_reserve_level,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY current_liabilities_ratio) current_liabilities_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY liabilities_ratio) liabilities_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY reserve_coverage_ratio) reserve_coverage_ratio
FROM pretty_financials
GROUP BY pretty_financials.sector
UNION
SELECT
	'General',
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_cost_ratio) fundraising_cost_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY contribution_reliance_ratio) contribution_reliance_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY spending_ratio) spending_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY program_output_ratio) program_output_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY degree_of_lt_investment) degree_of_lt_investment,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY cur_asset_turnover) cur_asset_turnover,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY program_expense_ratio) program_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY gen_admin_expense_ratio) gen_admin_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_expense_ratio) fundraising_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY gen_admin_revenue_ratio) gen_admin_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_revenue_ratio) fundraising_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY savings_revenue_ratio) savings_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY return_on_fr_effort) return_on_fr_effort,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY other_revenue_reliance) other_revenue_reliance,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY total_asset_turnover) total_asset_turnover,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY reserve_accumulation_rate) reserve_accumulation_rate,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY current_liquidity_ratio) current_liquidity_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY liquid_reserve_level) liquid_reserve_level,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY current_liabilities_ratio) current_liabilities_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY liabilities_ratio) liabilities_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY reserve_coverage_ratio) reserve_coverage_ratio
FROM pretty_financials
LEFT JOIN sector_flags USING (sector)
WHERE sector_flags.general = TRUE
UNION
SELECT
	'Total',
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_cost_ratio) fundraising_cost_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY contribution_reliance_ratio) contribution_reliance_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY spending_ratio) spending_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY program_output_ratio) program_output_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY degree_of_lt_investment) degree_of_lt_investment,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY cur_asset_turnover) cur_asset_turnover,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY program_expense_ratio) program_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY gen_admin_expense_ratio) gen_admin_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_expense_ratio) fundraising_expense_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY gen_admin_revenue_ratio) gen_admin_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY fundraising_revenue_ratio) fundraising_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY savings_revenue_ratio) savings_revenue_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY return_on_fr_effort) return_on_fr_effort,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY other_revenue_reliance) other_revenue_reliance,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY total_asset_turnover) total_asset_turnover,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY reserve_accumulation_rate) reserve_accumulation_rate,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY current_liquidity_ratio) current_liquidity_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY liquid_reserve_level) liquid_reserve_level,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY current_liabilities_ratio) current_liabilities_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY liabilities_ratio) liabilities_ratio,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY reserve_coverage_ratio) reserve_coverage_ratio
FROM financials;
