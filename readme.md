
# Electricity Billing System (Mainframe Project)

## Overview

This project is a simple electricity billing system designed for a mainframe environment using COBOL, JCL, and VSAM. The focus is on keeping the system minimal, easy to understand, and straightforward to implement.

The system handles basic customer data, meter readings, and generates a monthly bill based on usage. It avoids unnecessary complexity such as historical data tracking, multiple relationships, or advanced database features.

---

## System Architecture

The system follows a simple linear flow:

Customer → Meter → Bill

- Customer stores user information  
- Meter stores current and previous readings  
- Bill stores calculated data for the current month  

---

## ER Diagram

```mermaid
erDiagram

    CUSTOMER {
        string cust_id PK
        string first_name
        string last_name
        string area_code
        string address_line
        string city
        number total_units
    }

    METER {
        string cust_id PK, FK
        string meter_id
        number prev_read
        number curr_read
    }

    BILL {
        string cust_id PK, FK
        string meter_id
        string first_name
        string last_name
        number units_used
        number bill_amount
    }

    CUSTOMER ||--|| METER : "assigned"
    CUSTOMER ||--|| BILL : "generates"
    METER ||--|| BILL : "used for billing"
````

---

## Table Description

### Customer Table

The Customer table stores basic information about each user. It acts as the main reference point for the entire system.

It includes:

- Unique customer ID
    
- First and last name
    
- Area code
    
- Address
    
- City
    
- Total units consumed so far
    

This table is used whenever customer-related data is required.

---

### Meter Table

The Meter table stores the electricity readings for each customer.

It includes:

- Customer ID
    
- Meter ID
    
- Previous reading
    
- Current reading
    

Only the latest readings are stored. There is no historical tracking, which keeps the design simple and efficient.

---

### Bill Table

The Bill table stores the calculated bill for the current month only.

It includes:

- Customer ID
    
- Meter ID
    
- Customer name (for reporting)
    
- Units consumed
    
- Final bill amount
    

This table is used for generating reports and displaying billing information.

---

---

# 📘 Data Processing Programs

1. Customer ID Generation
    
2. Meter ID Generation
    
3. Bill Generation
    
4. Area-wise Report
    
5. Highest Units Customer
    

---