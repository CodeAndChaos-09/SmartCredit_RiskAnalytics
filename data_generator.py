import mysql.connector
from faker import Faker
import random
import numpy as np
from datetime import datetime, timedelta

# -----------------------------------
# CONNECT TO MYSQL
# -----------------------------------

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="kashi2321",  # CHANGE THIS
    database="smartcredit_analytics"
)

cursor = connection.cursor()
print("Connected to MySQL successfully!")

fake = Faker()

# -----------------------------------
# INSERT REGIONS
# -----------------------------------

regions = [
    ("Mumbai", "Tier 1 Urban"),
    ("Delhi", "Tier 1 Urban"),
    ("Kolkata", "Tier 2 Urban"),
    ("Bangalore", "Tier 1 Urban"),
    ("Patna", "Semi-Urban"),
    ("Lucknow", "Semi-Urban"),
    ("Ranchi", "Rural")
]

cursor.executemany(
    "INSERT INTO Regions (region_name, economic_tier) VALUES (%s, %s)",
    regions
)
connection.commit()
print("Regions inserted.")

# -----------------------------------
# INSERT CUSTOMERS
# -----------------------------------

employment_types = ["Salaried", "Self-Employed", "Business", "Unemployed"]

for _ in range(1000):
    name = fake.name()
    age = random.randint(21, 60)
    gender = random.choice(["Male", "Female"])
    income = round(abs(np.random.normal(50000, 20000)), 2)
    employment = random.choice(employment_types)
    region_id = random.randint(1, 7)
    created_at = fake.date_between(start_date='-3y', end_date='today')

    cursor.execute("""
        INSERT INTO Customers 
        (full_name, age, gender, income, employment_type, region_id, created_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (name, age, gender, income, employment, region_id, created_at))

connection.commit()
print("Customers inserted.")

# -----------------------------------
# INSERT LOANS
# -----------------------------------

loan_types = ["Personal Loan", "Business Loan", "Education Loan", "Home Loan"]

for customer_id in range(1, 1001):
    for _ in range(random.randint(1, 3)):
        loan_amount = round(random.uniform(50000, 500000), 2)
        interest_rate = round(random.uniform(8, 18), 2)
        loan_type = random.choice(loan_types)
        loan_date = fake.date_between(start_date='-2y', end_date='today')
        loan_status = random.choice(["Active", "Closed", "Defaulted"])

        cursor.execute("""
            INSERT INTO Loans
            (customer_id, loan_amount, interest_rate, loan_type, loan_date, loan_status)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (customer_id, loan_amount, interest_rate, loan_type, loan_date, loan_status))

connection.commit()
print("Loans inserted.")

# -----------------------------------
# GENERATE REPAYMENTS
# -----------------------------------

cursor.execute("SELECT loan_id, loan_date FROM Loans")
loans = cursor.fetchall()

for loan in loans:
    loan_id = loan[0]
    loan_date = loan[1]

    number_of_installments = random.randint(6, 24)

    for i in range(number_of_installments):
        due_date = loan_date + timedelta(days=30 * i)

        payment_behavior = random.choices(
            ["Paid", "Late", "Missed"],
            weights=[70, 20, 10],
            k=1
        )[0]

        if payment_behavior == "Paid":
            payment_date = due_date
            amount_paid = round(random.uniform(5000, 20000), 2)

        elif payment_behavior == "Late":
            payment_date = due_date + timedelta(days=random.randint(5, 15))
            amount_paid = round(random.uniform(5000, 20000), 2)

        else:
            payment_date = None
            amount_paid = 0

        cursor.execute("""
            INSERT INTO Repayments
            (loan_id, due_date, payment_date, amount_paid, payment_status)
            VALUES (%s, %s, %s, %s, %s)
        """, (loan_id, due_date, payment_date, amount_paid, payment_behavior))

connection.commit()
print("Repayments inserted.")

# -----------------------------------
# GENERATE CREDIT SCORE HISTORY
# -----------------------------------

for customer_id in range(1, 1001):
    base_score = random.randint(550, 800)

    number_of_updates = random.randint(6, 12)

    for i in range(number_of_updates):
        score_date = datetime.now() - timedelta(days=90 * i)
        fluctuation = random.randint(-30, 30)
        credit_score = max(300, min(900, base_score + fluctuation))

        cursor.execute("""
            INSERT INTO Credit_Score_History
            (customer_id, credit_score, score_date)
            VALUES (%s, %s, %s)
        """, (customer_id, credit_score, score_date))

connection.commit()
print("Credit score history inserted.")

# -----------------------------------
# CLOSE CONNECTION
# -----------------------------------

cursor.close()
connection.close()

print("Data generation completed successfully!")