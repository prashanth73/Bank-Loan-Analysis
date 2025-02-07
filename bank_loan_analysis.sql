create schema BankDB;
use BankDB;

SET SQL_SAFE_UPDATES = 0;

UPDATE bank_loan_data
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE bank_loan_data MODIFY COLUMN issue_date DATE;

UPDATE bank_loan_data
SET last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y');

ALTER TABLE bank_loan_data MODIFY COLUMN last_credit_pull_date DATE;

UPDATE bank_loan_data
SET last_payment_date = STR_TO_DATE(last_payment_date , '%d-%m-%Y');

ALTER TABLE bank_loan_data MODIFY COLUMN last_payment_date  DATE;

UPDATE bank_loan_data
SET next_payment_date = STR_TO_DATE(next_payment_date , '%d-%m-%Y');

ALTER TABLE bank_loan_data MODIFY COLUMN next_payment_date DATE;

SET SQL_SAFE_UPDATES = 1;

select count(*) from bank_loan_data;

-- Total Loan Applications
select count(id) as Total_loan_Applications from bank_loan_data;

-- Month to Date loan Applications (MTD)
select count(id) as MTD_loan_Applications from bank_loan_data
where month(issue_date) = 10 and year(issue_date) = 2021;

-- Previous Month to Date loan Applications
select count(id) as PMTD_loan_Applications from bank_loan_data
where month(issue_date) = 9 and year(issue_date) = 2021;

-- Month on Month(MoM) percentage = ((MTD-PMTD)/PMTD)*100

-- Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount from bank_loan_data;

-- Month to Date Funded Amount
select sum(loan_amount) as MTD_Funded_Amount from bank_loan_data
where month(issue_date) = 10 and year(issue_date) = 2021;

-- Previous Month to Date Funded Amount
select sum(loan_amount) as PMTD_Funded_Amount from bank_loan_data
where month(issue_date) = 9 and year(issue_date) = 2021;

-- Total Received Amount
select sum(total_payment) as Total_Received_Amount from bank_loan_data;

-- Month to Date Received Amount
select sum(total_payment) as MTD_Received_Amount from bank_loan_data
where month(issue_date) = 10 and year(issue_date) = 2021;

-- Previous Month to Date Received Amount
select sum(total_payment) as PMTD_Received_Amount from bank_loan_data
where month(issue_date) = 9 and year(issue_date) = 2021;

-- Average interst rate
select avg(int_rate)*100 as Avg_Interest_Rate from bank_loan_data;

-- Month to Date Average Interest Rate
select avg(int_rate)*100 as MTD_Avg_Interest_Rate from bank_loan_data
where month(issue_date) = 10 and year(issue_date) = 2021;

-- Previous Month to Date Average Interest Rate
select avg(int_rate)*100 as PMTD_Avg_Interest_Rate from bank_loan_data
where month(issue_date) = 9 and year(issue_date) = 2021;

-- Average Debt to Income Ratio
select avg(dti)*100 as Avg_DTI from bank_loan_data;

-- Month to Date Average Debt to Income Ratio
select avg(dti)*100 as MTD_Avg_DTI from bank_loan_data
where month(issue_date) = 10 and year(issue_date) = 2021;

-- Previous Month to Date Average Debt to Income Ratio
select avg(dti)*100 as PMTD_Avg_DTI from bank_loan_data
where month(issue_date) = 9 and year(issue_date) = 2021;

-- Good Loan Total Applications
select count(id) as Total_Good_Loan_Applications from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good Loan Percentage
select
	(count(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id end)*100) / count(id) 
as Good_Load_percentage 
from bank_loan_data;

-- Good Loan Funded Amount
select sum(loan_amount) as Total_Good_Loan_Funded_Amount from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good Loan Received Amount
select sum(total_payment) as Total_Good_Loan_Received_Amount from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Bad Loan Percentage
select
	(count(case when loan_status = 'Charged Off' then id end)*100) / count(id) 
as Bad_Load_percentage 
from bank_loan_data;

-- Bad Loan Total Applications
select count(id) as Total_Bad_Loan_Applications from bank_loan_data
where loan_status = 'Charged Off';

-- Bad Loan Funded Amount
select sum(loan_amount) as Total_Bad_Loan_Funded_Amount from bank_loan_data
where loan_status = 'Charged Off';

-- Bad Loan Received Amount
select sum(total_payment) as Total_Bad_Loan_Received_Amount from bank_loan_data
where loan_status = 'Charged Off';

-- Loan Status Review
select loan_status,
	count(id) as Total_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Received_Amount,
    avg(int_rate)*100 as Avg_Interest_Rate,
    avg(dti)*100 as Avg_Debt_to_Income_Ratio
from bank_loan_data
group by loan_status;

-- Month Report
select 
	loan_status,
	count(id) as Total_Applications,
    sum(loan_amount) as MTD_Total_Funded_Amount,
    sum(total_payment) as MTD_Total_Received_Amount
from bank_loan_data
where month(issue_date) = 10
group by loan_status;

-- Bank Report
select
	month(issue_date) as Month_Number,
	date_format(issue_date, '%M') as Month_Name,
	count(id) as Total_Applications,
    sum(loan_amount) as MTD_Total_Funded_Amount,
    sum(total_payment) as MTD_Total_Received_Amount
from bank_loan_data
group by Month_Number, Month_Name
order by Month_Number;

-- State Analysis Report
select
	address_state as State,
	count(id) as Total_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by State;

-- Term Analysis Report
select
	term as Term,
	count(id) as Total_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by Term;

-- Employee Length Analysis Report
select
	emp_length as Employee_Experience,
	count(id) as Total_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by Employee_Experience
order by Employee_Experience asc;

-- Purpose Analysis Report
select
	purpose as Purpose,
	count(id) as Total_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by Purpose
order by Purpose;

-- Home Ownership Analysis Report
select
	home_ownership as Ownership_Status,
	count(id) as Total_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by Ownership_Status
order by Ownership_Status;