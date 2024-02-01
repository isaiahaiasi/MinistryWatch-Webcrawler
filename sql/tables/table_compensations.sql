CREATE TABLE public.compensations
(
	ein integer NOT NULL,
	compensation_date date NOT NULL,
	full_name text NOT NULL,
	title text,
	compensation money NOT NULL,
	PRIMARY KEY(ein, compensation_date, full_name)
);
