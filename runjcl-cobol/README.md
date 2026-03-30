# Electricity Billing System - JCL Procedures

## Directory Structure

```
runjcl-cobol/
├── procedures/           # Main procedures
│   └── RUNALL           # Complete system run (delete + define + all programs)
├── cluster_mgmt/         # Cluster management procedures
│   ├── DEFINECLUST      # Define VSAM clusters (3 clusters)
│   └── DELETECLUST      # Delete VSAM clusters (3 clusters)
├── runjcl001           # Original customer JCL
├── runjcl002           # Original meter JCL
├── runjcl003           # Original bill JCL
├── runjcl004           # Original area JCL
└── runjcl005           # Original high consumers JCL
```

## Usage

### Complete System Run
```jcl
//SUBMIT JOB=RUNALL,HLQ='YOURHLQ'
```
This will:
1. Delete existing clusters (calls DELETECLUST)
2. Define new clusters (calls DEFINECLUST)
3. Run all COBOL programs in sequence:
   - CUST001 (Customer processing)
   - MID001 (Meter processing)
   - BILLGEN (Bill generation)
   - AREARPT (Area report)
   - HIGHCONS (High consumers report)

### Individual Operations
```jcl
//SUBMIT JOB=DELETECLUST,HLQ='YOURHLQ'    # Delete all clusters
//SUBMIT JOB=DEFINECLUST,HLQ='YOURHLQ'    # Define all clusters
```

## Execution Order

1. **DELETECLUST** - Clean up existing VSAM files
2. **DEFINECLUST** - Create new VSAM clusters
3. **RUNALL** - Execute all COBOL programs

## VSAM Clusters Managed

### DELETECLUST Handles:
- `&HLQ..ELE.CUST.KSDS.FILE` - Customer master
- `&HLQ..ELE.METER.KSDS.FILE` - Meter master  
- `&HLQ..ELE.BILL.KSDS.FILE` - Bill master

### DEFINECLUST Creates:
- `&HLQ..ELE.CUST.KSDS.FILE` - Customer master (83 bytes, KEY: 12 bytes)
- `&HLQ..ELE.METER.KSDS.FILE` - Meter master (38 bytes, KEY: 12 bytes)
- `&HLQ..ELE.BILL.KSDS.FILE` - Bill master (104 bytes, KEY: 12 bytes)

## COBOL Programs in RUNALL

| Step | Program | Purpose | Input | Output |
|-------|----------|---------|---------|
| STEP3 | CUST001 | Customer PS file | Customer KSDS |
| STEP4 | MID001 | Meter PS file | Meter KSDS |
| STEP5 | BILLGEN | Customer + Meter KSDS | Bill KSDS + Report |
| STEP6 | AREARPT | Customer + Meter KSDS | Area Report |
| STEP7 | HIGHCONS | Customer + Meter KSDS | High Cons Report |

## Data Sets Created

- **Customer Master**: `&HLQ..ELE.CUST.KSDS.FILE` (83 bytes)
- **Meter Master**: `&HLQ..ELE.METER.KSDS.FILE` (38 bytes)
- **Bill Master**: `&HLQ..ELE.BILL.KSDS.FILE` (104 bytes)
- **Reports**: 
  - `&HLQ..ELE.BILL.RPT` (72 columns)
  - `&HLQ..ELE.AREA.RPT` (72 columns)
  - `&HLQ..ELE.HIGHCONS.RPT` (72 columns)

## Symbolic Parameters

- **&HLQ** - High-level qualifier for all datasets
- **&SYSUID** - User ID for job notifications
- **CLASS** - Job class (A)
- **MSGCLASS** - Message class (A)

## Benefits

- **Modular Design** - Separate procedures for cluster management
- **Symbolic Parameters** - Environment independent (uses &HLQ)
- **Single Point of Control** - RUNALL handles complete workflow
- **Error Handling** - SET MAXCC=0 for graceful cluster deletion
2. Define new clusters
3. Run all COBOL programs in sequence

### Individual Program Runs
```jcl
//SUBMIT JOB=PROGCUST     # Customer processing
//SUBMIT JOB=PROGMETER    # Meter processing
//SUBMIT JOB=PROGBILL     # Bill generation
//SUBMIT JOB=PROGAREA     # Area report
//SUBMIT JOB=PROGHIGH     # High consumers report
```

### Cluster Management Only
```jcl
//SUBMIT JOB=DELETECLUST  # Delete all clusters
//SUBMIT JOB=DEFINECLUST  # Define all clusters
```

## Execution Order

1. **DELETECLUST** - Clean up existing VSAM files
2. **DEFINECLUST** - Create new VSAM clusters
3. **PROGCUST** - Load customer data (CUST001)
4. **PROGMETER** - Load meter data (MID001)
5. **PROGBILL** - Generate bills (BILLGEN)
6. **PROGAREA** - Create area report (AREARPT)
7. **PROGHIGH** - Create high consumers report (HIGHCONS)

## Data Sets Created

- **OZA265.ELE.CUST.KSDS.FILE** - Customer master (83 bytes)
- **OZA265.ELE.METER.KSDS.FILE** - Meter master (38 bytes)
- **OZA265.ELE.BILL.KSDS.FILE** - Bill master (104 bytes)
- **OZA265.ELE.CUSTERR.PS** - Customer errors (71 bytes)
- **OZA265.ELE.METERERR.PS** - Meter errors (12 bytes)
- **OZA265.ELE.BILL.RPT** - Billing report (72 columns)
- **OZA265.ELE.AREA.RPT** - Area report (72 columns)
- **OZA265.ELE.HIGHCONS.RPT** - High consumers report (72 columns)
