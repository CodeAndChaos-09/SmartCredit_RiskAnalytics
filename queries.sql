CREATE DATABASE smartcredit_analytics;
USE smartcredit_analytics;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    income DECIMAL(12,2),
    employment_type VARCHAR(50),
    region_id INT,
    created_at DATE
);
CREATE TABLE Regions (
    region_id INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(100),
    economic_tier VARCHAR(50)
);
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    loan_type VARCHAR(50),
    loan_date DATE,
    loan_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Repayments (
    repayment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    due_date DATE,
    payment_date DATE,
    amount_paid DECIMAL(12,2),
    payment_status VARCHAR(50),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    transaction_amount DECIMAL(12,2),
    transaction_type VARCHAR(50),
    transaction_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Credit_Score_History (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    credit_score INT,
    score_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
ALTER TABLE Customers
ADD FOREIGN KEY (region_id) REFERENCES Regions(region_id);

SELECT 
    r.region_name,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE WHEN l.loan_status = 'Defaulted' THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        (SUM(CASE WHEN l.loan_status = 'Defaulted' THEN 1 ELSE 0 END) 
        / COUNT(l.loan_id)) * 100, 2
    ) AS default_rate_percentage
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN Regions r ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY default_rate_percentage DESC;

SELECT 
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_portfolio_value,
    ROUND(AVG(loan_amount), 2) AS average_loan_size
FROM Loans;
SELECT 
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 'Defaulted' THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        (SUM(CASE WHEN loan_status = 'Defaulted' THEN 1 ELSE 0 END) 
        / COUNT(*)) * 100, 2
    ) AS overall_default_rate
FROM Loans;
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(r.repayment_id) AS total_installments,
    SUM(CASE WHEN r.payment_status = 'Missed' THEN 1 ELSE 0 END) AS missed_payments,
    ROUND(
        (SUM(CASE WHEN r.payment_status = 'Missed' THEN 1 ELSE 0 END)
        / COUNT(r.repayment_id)) * 100, 2
    ) AS missed_percentage
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
JOIN Repayments r ON l.loan_id = r.loan_id
GROUP BY c.customer_id, c.full_name
HAVING missed_payments > 0
ORDER BY missed_percentage DESC
LIMIT 10;
SELECT 
    c.customer_id,
    c.full_name,
    SUM(CASE WHEN r.payment_status = 'Late' THEN 1 ELSE 0 END) AS late_count
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
JOIN Repayments r ON l.loan_id = r.loan_id
GROUP BY c.customer_id, c.full_name
HAVING late_count >= 5
ORDER BY late_count DESC;
SELECT 
    customer_id,
    score_date,
    credit_score,
    LAG(credit_score) OVER (
        PARTITION BY customer_id 
        ORDER BY score_date
    ) AS previous_score,
    credit_score - LAG(credit_score) OVER (
        PARTITION BY customer_id 
        ORDER BY score_date
    ) AS score_change
FROM Credit_Score_History;
SELECT 
    loan_id,
    loan_amount,
    interest_rate,
    ROUND((loan_amount * interest_rate / 100), 2) AS estimated_interest
FROM Loans
ORDER BY estimated_interest DESC
LIMIT 10;
SELECT 
    r.region_name,
    ROUND(SUM(l.loan_amount * l.interest_rate / 100), 2) AS total_interest_revenue
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN Regions r ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_interest_revenue DESC;
SELECT 
    c.customer_id,
    c.full_name,
    SUM(CASE WHEN r.payment_status = 'Missed' THEN 1 ELSE 0 END) AS missed_count,
    CASE 
        WHEN SUM(CASE WHEN r.payment_status = 'Missed' THEN 1 ELSE 0 END) >= 5 THEN 'High Risk'
        WHEN SUM(CASE WHEN r.payment_status = 'Missed' THEN 1 ELSE 0 END) BETWEEN 2 AND 4 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
JOIN Repayments r ON l.loan_id = r.loan_id
GROUP BY c.customer_id, c.full_name;
SELECT 
    customer_id,
    SUM(loan_amount) AS total_exposure,
    RANK() OVER (ORDER BY SUM(loan_amount) DESC) AS exposure_rank
FROM Loans
GROUP BY customer_id;
SELECT 
    CASE 
        WHEN income < 30000 THEN 'Low Income'
        WHEN income BETWEEN 30000 AND 70000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE WHEN l.loan_status = 'Defaulted' THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        (SUM(CASE WHEN l.loan_status = 'Defaulted' THEN 1 ELSE 0 END)
        / COUNT(l.loan_id)) * 100, 2
    ) AS default_rate
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY income_group
ORDER BY default_rate DESC;