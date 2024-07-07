-- 1. Data Cleaning and Preparation

SELECT * FROM loan_risk.loan_risk;

-- Check for missing values in some column 
SELECT 
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_income
FROM loan_risk;

SELECT
	sum(case when loan_amnt is null then 1 else 0 end) as missing_loan
    from loan_risk;
-- chekin for duplicates  

select
row_number() over(
	partition by customer_id, customer_income, loan_amnt) as row_num
from loan_risk;

with duplicate_cte as
	(SELECT *,
		row_number() over(
		partition by customer_id, customer_income, loan_amnt) as row_num
from loan_risk
	)

select *
from duplicate_cte
where row_num > 1 ;
-- cheking from customer_id 323
select *
from loan_risk
where customer_id = 323 ;
-- delete duplictes 
CREATE TABLE `loan_risk2` (
  `customer_id` int DEFAULT NULL,
  `customer_age` int DEFAULT NULL,
  `customer_income` int DEFAULT NULL,
  `home_ownership` text,
  `employment_duration` int DEFAULT NULL,
  `loan_intent` text,
  `loan_grade` text,
  `loan_amnt` text,
  `loan_int_rate` double DEFAULT NULL,
  `term_years` int DEFAULT NULL,
  `historical_default` text,
  `cred_hist_length` int DEFAULT NULL,
  `Current_loan_status` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from loan_risk2; 

insert into loan_risk2
SELECT *,
		row_number() over(
		partition by customer_id, customer_income, loan_amnt) as row_num
from loan_risk;
select *
from loan_risk2
where row_num > 1;

delete 
from loan_risk2
where row_num > 1;
select *
from loan_risk2
where customer_id = 323 ;
-- fix laon_amount 
select *
from loan_risk2; 
select 
	max(loan_amnt)
from loan_risk2;
UPDATE loan_risk2
SET loan_amnt = CAST(SUBSTRING(loan_amnt, 3) AS UNSIGNED);




