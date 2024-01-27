CREATE TABLE public.charities
(
	ein integer PRIMARY KEY,
	charity_name text NOT NULL,
	sector text NOT NULL,
	fiscal_year_end text,
	-- Unfortunately the "EIN" ID in the MinistryWatch database
	-- is occasionally NOT an actual EIN.
	-- Both are stored so that URLs can easily be reconstructed.
	ein_query_param text NOT NULL
);
