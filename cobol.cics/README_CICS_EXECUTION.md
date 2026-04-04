# CICS System Execution Guide

## Overview

This guide explains how to compile, run, and interact with the CICS Electricity Board System using mainframe CICS commands. These are the same commands your professor uses to demonstrate the system in class.

## Prerequisites

1. **CICS Region Access**: You must have access to an active CICS region
2. **TSO/E Session**: Logged into TSO/E with proper authorizations
3. **Dataset Access**: Access to the following datasets:
   - `OZA266.ELE.SOURCE.CICS.NEW` (source code)
   - `OZA266.ELE.CPYBK` (copybooks)
   - `OZA266.ELE.CUST.KSDS.FILE` (customer data)
   - `OZAADM.CICS.LOADLIB` (load library)

## Compilation Commands

### Step 1: Compile BMS Maps using CECT

**CECT** (CICS Translator) is used to compile BMS (Basic Mapping Support) maps:

```bash
// In TSO/E, enter:
CECT MAKE COPY
```

**What this does:**
- Translates BMS map definitions into executable format
- Creates physical maps for screen display
- Stores compiled maps in the CICS load library

**Example for each mapset:**
```bash
CECT MAKE COPY(EB01MSD)    // Main menu map
CECT MAKE COPY(EB02MSD)    // Customer menu map  
CECT MAKE COPY(EB03MSD)    // Customer create map
CECT MAKE COPY(EB04MSD)    // Customer read map
CECT MAKE COPY(EB05MSD)    // Customer update map
```

### Step 2: Execute/Install Maps using CECI

**CECI** (CICS Command Interpreter) is used to execute CICS commands interactively:

```bash
// In TSO/E, enter:
CECI EXEC MAP
```

**What this does:**
- Installs the compiled maps into the CICS region
- Makes the maps available for transaction processing
- Activates the mapsets for use by programs

**Example for each mapset:**
```bash
CECI EXEC MAP(EB01MSD)     // Install main menu map
CECI EXEC MAP(EB02MSD)     // Install customer menu map
CECI EXEC MAP(EB03MSD)     // Install customer create map
CECI EXEC MAP(EB04MSD)     // Install customer read map
CECI EXEC MAP(EB05MSD)     // Install customer update map
```

## Running the System

### Method 1: Using CECI for Testing

You can test individual transactions using CECI:

```bash
// Start the main menu
CECI TRANSID('EB01')

// Test customer menu directly
CECI TRANSID('EB02')

// Test customer create
CECI TRANSID('EB03')
```

### Method 2: Using CEDA for Resource Definition

For permanent installation, use CEDA (CICS Definition):

```bash
// Define transactions
CEDA DEFINE TRANSID(EB01) PROGRAM(EMNUO010)
CEDA DEFINE TRANSID(EB02) PROGRAM(EB02CUSTM)
CEDA DEFINE TRANSID(EB03) PROGRAM(EB03CUSTC)
CEDA DEFINE TRANSID(EB04) PROGRAM(EB04CUSTR)
CEDA DEFINE TRANSID(EB05) PROGRAM(EB05CUSTU)

// Define programs
CEDA DEFINE PROGRAM(EMNUO010)
CEDA DEFINE PROGRAM(EB02CUSTM)
CEDA DEFINE PROGRAM(EB03CUSTC)
CEDA DEFINE PROGRAM(EB04CUSTR)
CEDA DEFINE PROGRAM(EB05CUSTU)

// Define mapsets
CEDA DEFINE MAPSET(EB01MSD)
CEDA DEFINE MAPSET(EB02MSD)
CEDA DEFINE MAPSET(EB03MSD)
CEDA DEFINE MAPSET(EB04MSD)
CEDA DEFINE MAPSET(EB05MSD)
```

## Viewing the Screens

### Step 1: Access CICS Terminal

1. **From TSO/E**: Type `CICS` or your region name
2. **From VTAM**: Use your terminal emulator to connect to the CICS region
3. **Enter Transaction ID**: Type `EB01` to start the main menu

### Step 2: Navigate Through Screens

**Main Menu (Transaction EB01):**
```
Electricity Board of Trivandrum

PLEASE SELECT THE TABLE YOU WANT TO WORK ON:

     1. CUSTOMER
     2. METER
     3. EXIT

ENTER YOUR CHOICE: _
```

**Customer Menu (Transaction EB02):**
```
CUSTOMER MENU

SELECT OPERATION:

     C - CREATE CUSTOMER
     R - READ CUSTOMER
     U - UPDATE CUSTOMER
     3 - EXIT TO MAIN MENU

ENTER YOUR CHOICE: _
```

**Customer Create Screen (Transaction EB03):**
```
CUSTOMER CREATE SCREEN

ENTER CUSTOMER DETAILS:

FIRST NAME  : ________________
LAST NAME   : ________________
AREA CODE   : __________
ADDRESS     : ______________________________
CITY        : ________________

CUSTOMER ID : ________________
MESSAGE     : ________________________________
```

## Complete Execution Sequence

### Professor's Demonstration Workflow

Here's the exact sequence your professor likely uses:

```bash
// 1. Compile all maps
CECT MAKE COPY(EB01MSD)
CECT MAKE COPY(EB02MSD)
CECT MAKE COPY(EB03MSD)
CECT MAKE COPY(EB04MSD)
CECT MAKE COPY(EB05MSD)

// 2. Install all maps
CECI EXEC MAP(EB01MSD)
CECI EXEC MAP(EB02MSD)
CECI EXEC MAP(EB03MSD)
CECI EXEC MAP(EB04MSD)
CECI EXEC MAP(EB05MSD)

// 3. Start the system
CECI TRANSID('EB01')

// 4. Navigate through screens
// Type 1 (for Customer)
// Type C (for Create)
// Fill in customer details
// Press Enter to save
```

## Testing Individual Components

### Testing Maps Only

If you just want to see the screen layouts:

```bash
// Test map display without program logic
CECI SEND MAP('EB01MAP') MAPSET('EB01MSD')
CECI SEND MAP('EB02MAP') MAPSET('EB02MSD')
CECI SEND MAP('EB03MAP') MAPSET('EB03MSD')
```

### Testing Programs Only

If you want to test program logic:

```bash
// Test program execution (requires maps to be installed)
CECI LINK PROGRAM('EMNUO010')
CECI LINK PROGRAM('EB02CUSTM')
CECI LINK PROGRAM('EB03CUSTC')
```

## Troubleshooting

### Common Issues

1. **Map Not Found Error**
   ```bash
   // Solution: Reinstall the map
   CECI EXEC MAP(EB01MSD)
   ```

2. **Program Not Found Error**
   ```bash
   // Solution: Check if program is compiled
   CECI INQUIRE PROGRAM(EMNUO010)
   ```

3. **Transaction Not Defined**
   ```bash
   // Solution: Define the transaction
   CEDA DEFINE TRANSID(EB01) PROGRAM(EMNUO010)
   ```

### Verification Commands

```bash
// Check if map is installed
CECI INQUIRE MAPSET(EB01MSD)

// Check if program is installed
CECI INQUIRE PROGRAM(EMNUO010)

// Check if transaction is defined
CECI INQUIRE TRANSID(EB01)

// List all installed resources
CECI INQUIRE ALL
```

## Quick Reference Card

| Command | Purpose | Example |
|---------|---------|---------|
| `CECT MAKE COPY` | Compile BMS map | `CECT MAKE COPY(EB01MSD)` |
| `CECI EXEC MAP` | Install map | `CECI EXEC MAP(EB01MSD)` |
| `CECI TRANSID` | Start transaction | `CECI TRANSID('EB01')` |
| `CECI SEND MAP` | Display map only | `CECI SEND MAP('EB01MAP')` |
| `CECI INQUIRE` | Check resource | `CECI INQUIRE PROGRAM(EMNUO010)` |
| `CEDA DEFINE` | Define permanently | `CEDA DEFINE TRANSID(EB01)` |

## Tips for Students

1. **Always compile maps before installing them**
2. **Use CECI for temporary testing during development**
3. **Use CEDA for permanent definitions**
4. **Check resource status with CECI INQUIRE before testing**
5. **Start with EB01 to test the complete flow**
6. **Test each component individually before integration**

## Professor's Demo Script

Here's a script that matches what you likely saw in class:

```bash
// Professor enters these commands one by one:

// Step 1: Compile main menu
CECT MAKE COPY(EB01MSD)

// Step 2: Install main menu
CECI EXEC MAP(EB01MSD)

// Step 3: Start the application
CECI TRANSID('EB01')

// Step 4: Demonstrates navigation
// Types: 1 → C → [fills form] → Enter
// Types: 3 → R → [enters ID] → Enter
// Types: 3 → U → [enters ID] → [modifies] → Enter
// Types: 3 → 3 (exit)
```

This will give you the exact same demonstration you saw in class!
