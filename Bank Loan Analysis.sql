SELECT *
FROM bank_loan

--A. KPI's 
--1.Total Applications.

SELECT
     COUNT(id) as Total_loan_applications
FROM bank_loan

--MTD Applications.

SELECT
     COUNT(id) as MTD_Total_loan_applications
FROM bank_loan
WHERE MONTH(issue_date) = 12

--PMTD

SELECT
     COUNT(id) as PMTD_Total_loan_applications
FROM bank_loan
WHERE MONTH(issue_date) = 11

--MOM expressed as a percentage.

SELECT
        ROUND(
            100 * (
               CAST((SELECT COUNT(id) FROM bank_loan WHERE MONTH(issue_date) = 12) AS FLOAT) -
               CAST((SELECT COUNT(id) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT))/ 
			   CAST((SELECT COUNT(id) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT),
            1
    ) AS PCT_change

--2.Total Funded Amount

SELECT 
     SUM(loan_amount) as Total_funded_amt
FROM bank_loan

--MTD Total Funded Amount

SELECT 
     SUM(loan_amount) as MTD_total_funded_amt
FROM bank_loan
WHERE MONTH(issue_date) = 12

--PMTD Total Funded Amount

SELECT 
     SUM(loan_amount) as PMTD_total_funded_amt
FROM bank_loan
WHERE MONTH(issue_date) = 11

--MoM on Total Funded Amount

SELECT
ROUND(
   100*(
       CAST((SELECT SUM(loan_amount) FROM bank_loan WHERE MONTH(issue_date) = 12) AS FLOAT)-
	   CAST((SELECT SUM(loan_amount) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT))/
	   CAST((SELECT SUM(loan_amount) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT), 2)
   AS Pct_change

--3.Total Amount Received/Collected

SELECT 
     SUM(total_payment) as Total_amt_received
FROM bank_loan

--MTD Total Amount Collected

SELECT 
     SUM(total_payment) as MTD_total_amt_collected
FROM bank_loan
WHERE MONTH(issue_date) = 12

--PMTD Total Amount Collected

SELECT 
     SUM(total_payment) as PMTD_total_amt_collected
FROM bank_loan
WHERE MONTH(issue_date) = 11

--MoM on Total Amount Collected

SELECT
ROUND(
   100*(
       CAST((SELECT SUM(total_payment) FROM bank_loan WHERE MONTH(issue_date) = 12) AS FLOAT)-
	   CAST((SELECT SUM(total_payment) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT))/
	   CAST((SELECT SUM(total_payment) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT), 1)
   AS MoM_change

--4.Average Interest Rate

SELECT 
     ROUND(AVG(int_rate) * 100, 2) as Avg_int_rate
FROM bank_loan

--MTD Avg Interest Rate

SELECT 
     ROUND(AVG(int_rate) * 100, 2) as MTD_Avg_Interest_rate
FROM bank_loan
WHERE MONTH(issue_date) = 12

--PMTD Avg Interest Rate

SELECT 
     ROUND(AVG(int_rate) * 100, 2) as PMTD_Avg_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date) = 11

--MoM on Avg Interest Rate

SELECT
 ROUND(
     100 *(
           CAST((SELECT (AVG(int_rate) * 100) FROM bank_loan WHERE MONTH(issue_date) = 12) AS FLOAT)- 
	       CAST((SELECT (AVG(int_rate) * 100) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT))/
	       CAST((SELECT (AVG(int_rate) * 100) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT), 1)
	       AS pct_change

--Average Debt-to-Income Ratio (DTI)

SELECT 
     ROUND(AVG(dti) * 100, 2) as Avg_dti
FROM bank_loan

--MTD dti

SELECT 
     ROUND(AVG(dti) * 100, 2) as Avg_MTD_DTI
FROM bank_loan
WHERE MONTH(issue_date) = 12

--PMTD DTI

SELECT 
     ROUND(AVG(dti) * 100, 2) as Avg_PMTD_DTI
FROM bank_loan
WHERE MONTH(issue_date) = 11

--MoM on DTI

SELECT
 ROUND(
     100 *(
           CAST((SELECT (AVG(dti) * 100) FROM bank_loan WHERE MONTH(issue_date) = 12) AS FLOAT)- 
	       CAST((SELECT (AVG(dti) * 100) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT))/
	       CAST((SELECT (AVG(dti) * 100) FROM bank_loan WHERE MONTH(issue_date) = 11) AS FLOAT), 1)
	       AS pct_change


--CHATS

--1.Good Loan v Bad Loan KPI’s
--Good Loan Application Percentage

SELECT
    loan_status,
    CASE
      WHEN loan_status = 'Charged Off' THEN  'BadLoan'
	  ELSE 'GoodLoan'
	  END AS Loan_Classification
FROM bank_loan

ALTER TABLE bank_loan
ADD Loan_Classification Varchar(20)

UPDATE bank_loan
SET Loan_Classification =
   (
    CASE
        WHEN loan_status = 'Charged Off' THEN 'BadLoan'
        ELSE 'GoodLoan'
    END 
   )

-- Total Good Loan Issued

SELECT 
     COUNT(Loan_Classification) as Good_Loan_issued
FROM bank_loan
WHERE Loan_Classification = 'GoodLoan'

--Percentage of Total Good Loan Applications
SELECT
  ROUND( 
        100 *
        CAST((SELECT COUNT(Loan_Classification) as Good_Loan_applications FROM bank_loan WHERE Loan_Classification = 'GoodLoan') AS FLOAT)/
		CAST((SELECT COUNT(id) as Total_loan_applications FROM bank_loan) AS FLOAT), 1) 
		as pct

--Good Loan Funded amt

SELECT
     SUM(loan_amount) as GoodLoan_Funded_amt
FROM bank_loan
WHERE Loan_Classification = 'GoodLoan'

--Good Loan Total Received Amount

SELECT
     SUM(total_payment) as GoodLoan_amt_rcvd
FROM bank_loan
WHERE Loan_Classification = 'GoodLoan'

--BAD LOAN
--Total Bad Loan Issued

SELECT 
     COUNT(Loan_Classification) as Bad_Loan_issued
FROM bank_loan
WHERE Loan_Classification = 'BadLoan'

--b. Percentage of Total Bad Loan Applications

SELECT
  ROUND( 
        100 *
        CAST((SELECT COUNT(Loan_Classification) as Good_Loan_applications FROM bank_loan WHERE Loan_Classification = 'BadLoan') AS FLOAT)/
		CAST((SELECT COUNT(id) as Total_loan_applications FROM bank_loan) AS FLOAT), 1) 
		as
		
--Bad Loan Funded amount

SELECT
     SUM(loan_amount) as BadLoan_Funded_amt
FROM bank_loan
WHERE Loan_Classification = 'BadLoan'

--Bad Loan Total Received Amount

SELECT
     SUM(total_payment) as BadLoan_amt_rcvd
FROM bank_loan
WHERE Loan_Classification = 'BadLoan'

--LOAN STATUS.
SELECT
      loan_status,
      COUNT(id) AS Total_Applications,
      SUM(total_payment) AS Total_Amount_Received,
      SUM(loan_amount) AS Total_Funded_Amount,
      AVG(int_rate * 100) AS Interest_Rate,
      AVG(dti * 100) AS DTI
 FROM bank_loan
 GROUP BY loan_status

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status

--MONTH.

SELECT 
     MONTH(issue_date) as Month_number,
	 DATENAME(MONTH, issue_date) as Month_Name,
	 COUNT(id) as Total_Applications,
	 SUM(loan_amount) as Total_funded_amt,
	 SUM(total_payment) as Total_pmt_received
FROM bank_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY 1,2
 
 --STATE

SELECT 
     address_state,
	 COUNT(id) as Total_Applications,
	 SUM(loan_amount) as Total_funded_amt,
	 SUM(total_payment) as Total_pmt_received
FROM bank_loan
GROUP BY address_state
ORDER BY 1
 
 --TERM

SELECT 
     term,
	 COUNT(id) as Total_Applications,
	 SUM(loan_amount) as Total_funded_amt,
	 SUM(total_payment) as Total_pmt_received
FROM bank_loan
GROUP BY term
ORDER BY 1

--EMPLOYMENT LENGTH

SELECT 
     emp_length,
	 COUNT(id) as Total_Applications,
	 SUM(loan_amount) as Total_funded_amt,
	 SUM(total_payment) as Total_pmt_received
FROM bank_loan
GROUP BY emp_length
ORDER BY 1
 
 --PURPOSE

SELECT 
     purpose,
	 COUNT(id) as Total_Applications,
	 SUM(loan_amount) as Total_funded_amt,
	 SUM(total_payment) as Total_pmt_received
FROM bank_loan
GROUP BY purpose
ORDER BY 1

--HOME OWNERSHIP

SELECT 
     home_ownership,
	 COUNT(id) as Total_Applications,
	 SUM(loan_amount) as Total_funded_amt,
	 SUM(total_payment) as Total_pmt_received
FROM bank_loan
GROUP BY home_ownership
ORDER BY 1

SELECT 
     id,
	 address_state,
	 application_type,
	 emp_length,
	 grade,
	 home_ownership,
	 issue_date,
	 loan_status,
	 purpose,
	 term,
	 verification_status,
	 dti,
	 int_rate,
	 loan_amount,
	 total_payment,
	 Loan_Classification
FROM bank_loan

 
 
 
 



































