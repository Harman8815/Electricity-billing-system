# Electricity Billing System

Mainframe-style batch processing system for electricity billing using COBOL and JCL.

## Quick Start

This project simulates an electricity board's billing system with:
- Customer and meter management
- Bill generation from meter readings
- Payment processing
- Analytics and reporting

## Folder Structure

```
Electricity/
├── cobol/              # COBOL source programs (VSAM version)
│   ├── elect001.cobol      # Customer data load
│   ├── billpay.cobol       # Bill payment processing
│   ├── arearpt.cobol       # Area-wise consumption report
│   └── highcons.cobol      # High consumption alert report
├── db2/                # COBOL programs with DB2 integration
│   ├── electdb2.cobol      # Customer load with DB2
│   ├── meterdb2.cobol      # Meter load with DB2
│   ├── billpaydb2.cobol    # Payment processing with DB2
│   ├── arearptdb2.cobol    # Area report with DB2
│   ├── highconsdb2.cobol   # High consumption report with DB2
│   └── jcl/                # Execution guides for DB2 programs
├── jcl/                # JCL job scripts (VSAM version)
├── data/               # Sample data files
├── ksds/               # VSAM KSDS datasets
├── python/             # Data generation utilities
├── docs/               # Documentation
│   ├── guides/             # Setup and how-to guides
│   └── migration/          # VSAM to DB2 migration docs
└── readme.md           # This file
```

## Key Components

| Component | Description |
|-----------|-------------|
| **VSAM Version** | Sequential/VSAM file processing (`cobol/`, `jcl/`) |
| **DB2 Version** | Database-backed processing (`db2/`) |
| **Data Generator** | Python scripts to create test data (`python/`) |

## Data Flow

```
CUSTOMER (Master) → METER (Master) → READING_TXN (Input)
                                            ↓
                                      BILLGEN → BILL (Output)
                                            ↓
                                      PAYMENT → BILL_UPDATE
                                            ↓
                                      Reports (Area, High Consumption, Payment Status)
```

## Getting Started

1. **Generate Test Data**: Use `python/customer_gen.py` and `python/meter_gen.py`
2. **Run VSAM Version**: Submit JCL from `jcl/` folder
3. **Run DB2 Version**: Follow guides in `db2/jcl/` folder

## Documentation

- [Project Overview](docs/project-overview.md) - Detailed architecture and data model
- [DB2 Setup Guide](docs/guides/working%20with%20db2.md) - DB2 configuration and setup
- [DB2 Integration](docs/guides/DB2_INTEGRATION.md) - DB2 program integration details
- [Data Transfer to DB2](docs/guides/transfer-data-to-db2/) - PDS to DB2 utilities

## Datasets

| Dataset | Type | Description |
|---------|------|-------------|
| CUSTOMER | Master | Customer records (146 bytes) |
| METER | Master | Meter records (41 bytes) |
| READING_TXN | Transaction | Meter readings (29 bytes) |
| BILL | Derived | Generated bills |
| PAYMENT | Transaction | Payment records |

## Reports Generated

1. **Area-wise Consumption Report** - Consumption by geographic area
2. **High Consumption Report** - Top 5 highest consuming customers
3. **Bill Payment Status Report** - Payment tracking with status (Due/Partial/Paid)

## Technologies

- COBOL (batch programs)
- JCL (job control)
- VSAM (virtual storage)
- DB2 (relational database)
- Python (data generation)

## License

Capstone Project - Educational Use
