USE northwind_dw;

Drop Table If Exists adventureworks.dim_date;

CREATE TABLE adventureworks.dim_date AS
	SELECT * FROM northwind_dw.dim_date;
