# SmartCredit – Loan Risk & Portfolio Analytics

## Problem Statement
Financial institutions manage thousands of loans across customers, regions and product types.
Without proper analytics it becomes difficult to identify:
• High-risk borrowers
• Regions with high default rates
• Loan products causing financial losses
• Trends in repayment behaviour
The goal of this project was to simulate a **fintech loan analytics system** that allows analysts to monitor portfolio health and detect risk patterns using SQL and Power BI.

## Overview
SmartCredit is a fintech analytics project that simulates a loan portfolio database and analyzes credit risk using SQL and Power BI.
The project demonstrates how financial institutions can monitor loan performance, detect risk patterns and analyze portfolio profitability.

## Tech Stack
Python – synthetic financial data generation
MySQL – relational database and SQL analytics
Power BI – interactive business intelligence dashboard

## Data Pipeline
Python Data Generator → MySQL Database → SQL Risk Analysis → Power BI Dashboard

## System Architecture
The project simulates a typical fintech data pipeline:

Python Data Generator
↓
MySQL Relational Database
↓
SQL Risk Analysis Queries
↓
Power BI Dashboard for Business Intelligence
Each layer represents a real-world analytics workflow used in financial institutions.

## Database Design
The system uses a relational database structure to model financial data.
Tables:
Customers – demographic information of borrowers
Loans – loan details including amount, interest rate, and status
Repayments – payment history for each loan
Regions – geographic classification
CreditScoreHistory – credit score tracking over time
These tables allow the system to analyze repayment behaviour, loan performance, and risk exposure.

## Power BI Dashboard
Executive Overview – portfolio metrics and regional exposure
Risk Intelligence – repayment behavior and credit score trends
Profitability Analysis – loan type distribution and revenue insights
The Power BI dashboard provides three analytics layers:
### Executive Overview
Displays portfolio KPIs including:
Total Loans
Total Portfolio Value
Default Rate
Interest Revenue

### Risk Intelligence
Analyzes borrower risk patterns such as:
Missed repayment behaviour
Credit score trends
Risk category distribution

### Profitability Analysis
Evaluates financial performance:
Loan type distribution
Revenue by region
Portfolio concentration

## Repository Structure
data_generator.py – generates synthetic loan dataset
queries.sql – SQL analysis queries
project.pbix – Power BI dashboard
dashboard_screenshots – dashboard images

## Key Insights
• Total simulated loan portfolio contains over 5900 loans with a total exposure of ₹1.6B.
• Overall default rate: ~34%
• Certain regions show higher default concentration
• Missed repayments strongly correlate with loan default events.

## Business Recommendations
Based on the analysis:
• Regions with higher default rates should undergo stricter credit checks.
• Loan products with higher default frequency may require adjusted interest rates.
• Customers with repeated missed repayments should be flagged for early risk monitoring.
• Credit score trends can be used to identify borrowers likely to default in the future.

## Author
Data analytics project by Kashish Goyal
