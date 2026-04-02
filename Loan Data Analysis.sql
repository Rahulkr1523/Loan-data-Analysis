CREATE DATABASE loan_analysis;
USE loan_analysis;

CREATE TABLE loan_data (
    Loan_ID VARCHAR(20),
    Gender VARCHAR(10),
    Married VARCHAR(10),
    Dependents INT,
    Education VARCHAR(20),
    Self_Employed VARCHAR(10),
    ApplicantIncome INT,
    CoapplicantIncome INT,
    LoanAmount FLOAT,
    Loan_Amount_Term INT,
    Credit_History INT,
    Property_Area VARCHAR(20)
);
select * from loan_data limit 10;

# 1. Find total number of applicants;
select count(Loan_id) as Total_Applicants from loan_data;

# 2. “Find how many applicants have a good credit history (1) and how many have a poor credit history (0).
SELECT 
    CASE 
        WHEN Credit_History = 0 THEN 'Bad Credit History'
        ELSE 'Good Credit History'
    END AS Credit_History_Status,
    COUNT(*) AS Applicants
FROM loan_data
GROUP BY Credit_History;

# 3. “Find the average applicant income for each education level.”
select * from loan_data;
select Education as Education_Level, avg(ApplicantIncome) as Avg_Applicant_income from loan_data Group by(Education) ;

# 4. “Find the average loan amount for applicants based on property area.”
select Property_Area , Round(avg(LoanAmount),2) as Avg_Loan_Amount from loan_data group by Property_Area ;

# 5. “Find the top 3 applicants with the highest income in each property area.”
with Ranked_Applicants as (
select Loan_id, Property_Area, ApplicantIncome,
RANK() Over(Partition by Property_Area order by ApplicantIncome desc) as Income_Rank
from loan_data
)
select * from Ranked_applicants where Income_Rank <= 3;

# 6. “Find all applicants whose income is higher than the average income of all applicants.”
SELECT Loan_ID,ApplicantIncome
FROM loan_data WHERE ApplicantIncome > (
    SELECT AVG(ApplicantIncome) 
    FROM loan_data
);

# 7.Categorize applicants into Low, Medium, and High income groups based on their income, and count how many applicants fall into each category.
select * from loan_data;
SELECT 
    CASE
        WHEN ApplicantIncome < 3000 THEN 'Low Income'
        WHEN ApplicantIncome BETWEEN 3000 AND 6000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS Income_Category,
    COUNT(Loan_ID) AS Applicant_Count
    FROM loan_data GROUP BY Income_Category;
    
# 8. Calculate cumulative (running) total of ApplicantIncome ordered by income.    
select Loan_ID,ApplicantIncome,
sum(ApplicantIncome) over(order by ApplicantIncome ) as Running_Total from loan_data;

# 9.Find the highest income applicant in each education level.
WITH Applicant_income_by_Education AS (
    SELECT  Education, Loan_ID, ApplicantIncome,
        RANK() OVER (
            PARTITION BY Education 
            ORDER BY ApplicantIncome DESC
        ) AS Income_by_Education
    FROM loan_data
)
SELECT * FROM Applicant_income_by_Education WHERE Income_by_Education = 1;

