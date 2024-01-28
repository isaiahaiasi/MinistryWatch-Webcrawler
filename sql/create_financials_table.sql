CREATE TABLE public.financials
(
	ein integer NOT NULL,
	tax_year integer NOT NULL,
	cash money,

	-- Crawled financials data
	receivables_inventories_prepaids money,
	short_term_investments money,
	other_current_assets money,
	total_current_assets money,
	long_term_investments money,
	fixed_assets money,
	other_long_term_assets money,
	total_long_term_assets money,
	total_assets money,
	payables_and_accrued_expenses money,
	other_current_liabilities money,
	total_current_liabilities money,
	debt money,
	due_to_from_affiliates money,
	other_long_term_liabilities money,
	total_long_term_liabilities money,
	total_liabilities money,
	without_donor_restrictions money,
	with_donor_restrictions money,
	net_assets money,
	total_contributions money,
	program_service_revenue money,
	membership_dues money,
	investment_income money,
	other_revenue money,
	total_other_revenue money,
	total_revenue money,
	program_services money,
	management_and_general money,
	fundraising money,
	total_expenses money,
	surplus_deficit money,
	other_changes_in_net_assets money,
	total_change_in_net_assets money,


	-- Generated columns
	/*
	Not sure best way to handle DIV-0 err...
	Constraint: non-zero columns:
	- net_assets
	- total_assets
	- total_contributions
	- total_current_assets
	- total_current_liabilities
	- total_expenses
	- total_revenue
	*/
	gen_admin_expenses 					money GENERATED ALWAYS AS (total_expenses - program_services - fundraising) STORED,
	fundraising_cost_ratio 			numeric GENERATED ALWAYS AS (fundraising				/NULLIF(total_revenue, '$0.00'::money)) STORED,
	contribution_reliance_ratio numeric GENERATED ALWAYS AS (total_contributions/NULLIF(total_revenue, '$0.00'::money)) STORED,
	spending_ratio 							numeric GENERATED ALWAYS AS (total_expenses			/NULLIF(total_revenue, '$0.00'::money)) STORED,
	program_output_ratio 				numeric GENERATED ALWAYS AS (program_services		/NULLIF(total_revenue, '$0.00'::money)) STORED,
	degree_of_lt_investment 		numeric GENERATED ALWAYS AS (total_assets				/NULLIF(total_current_assets, '$0.00'::money)) STORED,
	cur_asset_turnover 					numeric GENERATED ALWAYS AS (total_expenses			/NULLIF(total_current_assets, '$0.00'::money)) STORED,
	program_expense_ratio 			numeric GENERATED ALWAYS AS (program_services		/NULLIF(total_expenses, '$0.00'::money)) STORED,
	gen_admin_expense_ratio 		numeric GENERATED ALWAYS AS ((total_expenses - program_services - fundraising)	/NULLIF(total_expenses, '$0.00'::money)) STORED,
	fundraising_expense_ratio 	numeric GENERATED ALWAYS AS (fundraising				/NULLIF(total_expenses, '$0.00'::money)) STORED,
	gen_admin_revenue_ratio 		numeric GENERATED ALWAYS AS ((total_expenses - program_services - fundraising)	/NULLIF(total_revenue, '$0.00'::money)) STORED,
	fundraising_revenue_ratio 	numeric GENERATED ALWAYS AS (fundraising				/NULLIF(total_revenue, '$0.00'::money)) STORED,
	savings_revenue_ratio 			numeric GENERATED ALWAYS AS ((total_revenue-total_expenses)			/NULLIF(total_revenue, '$0.00'::money)) STORED,
	return_on_fr_effort 				numeric GENERATED ALWAYS AS (fundraising				/NULLIF(total_contributions, '$0.00'::money)) STORED,
	other_revenue_reliance 			numeric GENERATED ALWAYS AS ((total_revenue-total_contributions)/NULLIF(total_current_assets, '$0.00'::money)) STORED,
	total_asset_turnover 				numeric GENERATED ALWAYS AS (total_expenses			/NULLIF(total_assets, '$0.00'::money)) STORED,
	reserve_accumulation_rate 	numeric GENERATED ALWAYS AS ((total_revenue-total_expenses)			/NULLIF(net_assets, '$0.00'::money)) STORED,
	-- Liquidity/Solvency Ratios
	current_liquidity_ratio numeric GENERATED ALWAYS AS (total_current_assets /NULLIF(total_current_liabilities, '$0.00'::money)) STORED,
	liquid_reserve_level numeric GENERATED ALWAYS AS ((total_current_assets - total_current_liabilities)/NULLIF(total_expenses/12, '$0.00'::money)) STORED
	current_liabilities_ratio numeric GENERATED ALWAYS AS (total_current_liabilities /NULLIF(total_current_assets, '$0.00'::money)) STORED,
	liabilities_ratio 					numeric GENERATED ALWAYS AS ((total_assets-net_assets)					/NULLIF(total_assets, '$0.00'::money)) STORED,
	reserve_coverage_ratio 			numeric GENERATED ALWAYS AS (net_assets					/NULLIF(total_expenses, '$0.00'::money)) STORED,

	-- NOT USED:
	-- primary_revenue_growth_cn
	-- primary_expense_growth_cn
	-- age_of_assets
	-- working_capital_ratio_cn

	PRIMARY KEY(ein, tax_year)
)
