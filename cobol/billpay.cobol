       IDENTIFICATION DIVISION.
       PROGRAM-ID.  BILLPAY.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TI01-BILL-KSDS   ASSIGN TO BILLKSDS
           ORGANIZATION           IS INDEXED
           ACCESS MODE            IS SEQUENTIAL
           RECORD KEY             IS BILL-ID
           FILE STATUS            IS WS-BILL-STATUS.

           SELECT TI01-PAYMENT     ASSIGN TO PAYMENT
           ORGANIZATION           IS SEQUENTIAL
           ACCESS MODE            IS SEQUENTIAL
           FILE STATUS            IS WS-PAY-STATUS.

           SELECT MO01-BILL-UPD    ASSIGN TO BILLUPD
           ORGANIZATION           IS INDEXED
           ACCESS MODE            IS RANDOM
           RECORD KEY             IS UPD-BILL-ID
           FILE STATUS            IS WS-UPD-STATUS.

           SELECT TO01-PAY-REPORT  ASSIGN TO PAYRPT
           ORGANIZATION           IS SEQUENTIAL
           ACCESS MODE            IS SEQUENTIAL
           FILE STATUS            IS WS-RPT-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD TI01-BILL-KSDS
           RECORD CONTAINS         85   CHARACTERS.

       01 TI01-BILL-RECORD.
          05 BILL-ID            PIC X(14).
          05 BILL-CUST-ID       PIC X(9).
          05 BILL-CUST-NAME     PIC X(30).
          05 BILL-METER-ID      PIC X(14).
          05 BILL-READ-DATE     PIC X(10).
          05 BILL-UNITS         PIC 9(7)V99.
          05 BILL-AMOUNT        PIC 9(9)V99.
          05 BILL-STATUS        PIC X(2).

       FD TI01-PAYMENT
           RECORD CONTAINS         33   CHARACTERS.

       01 TI01-PAY-RECORD.
          05 PAY-PAYMENT-ID     PIC X(8).
          05 PAY-BILL-ID        PIC X(14).
          05 PAY-AMOUNT         PIC 9(7)V99.
          05 PAY-DATE           PIC X(10).

       FD MO01-BILL-UPD
           RECORD CONTAINS         95   CHARACTERS.

       01 MO01-BILL-UPD-RECORD.
          05 UPD-BILL-ID        PIC X(14).
          05 UPD-CUST-ID        PIC X(9).
          05 UPD-CUST-NAME      PIC X(30).
          05 UPD-METER-ID       PIC X(14).
          05 UPD-READ-DATE      PIC X(10).
          05 UPD-UNITS          PIC 9(7)V99.
          05 UPD-AMOUNT         PIC 9(9)V99.
          05 UPD-PAID           PIC 9(9)V99.
          05 UPD-BALANCE        PIC 9(9)V99.
          05 UPD-STATUS         PIC X(2).

       FD TO01-PAY-REPORT
           RECORDING MODE          IS F
           RECORD CONTAINS         133  CHARACTERS.

       01 TO01-PAY-RPT-RECORD   PIC X(133).

       WORKING-STORAGE SECTION.

       01 WS-FILE-STATUS-CODES.
          05 WS-BILL-STATUS        PIC X(02).
             88 BILL-IO-STATUS     VALUE '00'.
             88 BILL-EOF           VALUE '10'.
          05 WS-PAY-STATUS         PIC X(02).
             88 PAY-IO-STATUS      VALUE '00'.
             88 PAY-EOF            VALUE '10'.
          05 WS-UPD-STATUS         PIC X(02).
             88 UPD-IO-STATUS      VALUE '00'.
          05 WS-RPT-STATUS         PIC X(02).
             88 RPT-IO-STATUS      VALUE '00'.

       01 WS-DATE-VARIABLES.
          05 WS-DATE               PIC 9(08).
          05 WS-DATE-FMT.
             10 WS-CC              PIC 99.
             10 FILLER              PIC X VALUE '-'.
             10 WS-YY              PIC 99.
             10 FILLER              PIC X VALUE '-'.
             10 WS-MM              PIC 99.
             10 FILLER              PIC X VALUE '-'.
             10 WS-DD              PIC 99.

       01 WS-PAGE-CONTROL.
          05 WS-PAGE-NUM           PIC 9(02) VALUE ZERO.
          05 WS-LINE-CNT           PIC 9(02) VALUE 60.
          05 WS-LINES-PER-PAGE     PIC 9(02) VALUE 55.

       01 WS-PAYMENT-TOTALS.
          05 WS-CURR-BILL-ID       PIC X(14) VALUE SPACES.
          05 WS-CURR-AMOUNT        PIC 9(9)V99 VALUE ZERO.
          05 WS-TOTAL-PAID         PIC 9(9)V99 VALUE ZERO.
          05 WS-BALANCE            PIC 9(9)V99 VALUE ZERO.
          05 WS-PAY-CNT            PIC 9(03) VALUE ZERO.

       01 WS-COUNTERS.
          05 WS-BILL-CNT           PIC 9(06) VALUE ZERO.
          05 WS-DUE-CNT            PIC 9(06) VALUE ZERO.
          05 WS-PP-CNT             PIC 9(06) VALUE ZERO.
          05 WS-PAID-CNT           PIC 9(06) VALUE ZERO.
          05 WS-PAY-PROC-CNT       PIC 9(06) VALUE ZERO.
          05 WS-TOTAL-AMOUNT       PIC 9(11)V99 VALUE ZERO.
          05 WS-TOTAL-PAID-ALL     PIC 9(11)V99 VALUE ZERO.
          05 WS-TOTAL-BALANCE      PIC 9(11)V99 VALUE ZERO.

       01 WS-FLAGS.
          05 WS-FIRST-PAY          PIC X VALUE 'Y'.

       01 WS-REPORT-HEADERS.
          05 WS-REPORT-TITLE       PIC X(40) VALUE
             '  ABC ELECTRICITY - BILL PAYMENT STATUS REPORT'.
          05 WS-DATE-STR           PIC X(10) VALUE SPACES.
          05 WS-PAGE-STR           PIC X(03) VALUE SPACES.

       01 WS-HEADER-LINE1.
          05 FILLER                PIC X(40) VALUE
             '----------------------------------------'.
          05 FILLER                PIC X(40) VALUE
             '----------------------------------------'.
          05 FILLER                PIC X(53) VALUE
             '---------------------------------------------'.

       01 WS-HEADER-LINE2.
          05 FILLER                PIC X(40) VALUE
             'BILL ID       CUSTOMER ID   BILL AMOUNT     '.
          05 FILLER                PIC X(40) VALUE
             'PAID AMOUNT   BALANCE DUE    STATUS       '.
          05 FILLER                PIC X(53) VALUE
             'PAYMENTS  '.

       01 WS-HEADER-LINE3.
          05 FILLER                PIC X(40) VALUE
             '------------- -----------   -----------     '.
          05 FILLER                PIC X(40) VALUE
             '-----------   -----------    --------      '.
          05 FILLER                PIC X(53) VALUE
             '--------  '.

       01 WS-DETAIL-LINE.
          05 WS-D-BILLID           PIC X(14).
          05 FILLER                PIC X(2) VALUE SPACES.
          05 WS-D-CUSTID           PIC X(9).
          05 FILLER                PIC X(3) VALUE SPACES.
          05 WS-D-BILL-AMT         PIC $$,$$$,$$9.99.
          05 FILLER                PIC X(3) VALUE SPACES.
          05 WS-D-PAID             PIC $$,$$$,$$9.99.
          05 FILLER                PIC X(3) VALUE SPACES.
          05 WS-D-BALANCE          PIC $$,$$$,$$9.99.
          05 FILLER                PIC X(2) VALUE SPACES.
          05 WS-D-STATUS           PIC X(2).
          05 FILLER                PIC X(5) VALUE SPACES.
          05 WS-D-PAY-CNT          PIC Z9.

       01 WS-SUMMARY-LINE1.
          05 FILLER                PIC X(40) VALUE
             '*** PAYMENT STATUS SUMMARY ***           '.
          05 FILLER                PIC X(93) VALUE SPACES.

       01 WS-SUMMARY-LINE2.
          05 FILLER                PIC X(20) VALUE 'DUE (D):        '.
          05 WS-S-DUE              PIC ZZ,ZZZ9.
          05 FILLER                PIC X(20) VALUE '    PARTIAL (PP): '.
          05 WS-S-PP               PIC ZZ,ZZZ9.
          05 FILLER                PIC X(15) VALUE '    PAID (P): '.
          05 WS-S-PAID             PIC ZZ,ZZZ9.

       01 WS-TOTAL-LINE.
          05 FILLER                PIC X(40) VALUE
             '*** GRAND TOTAL ***                      '.
          05 WS-T-BILLS            PIC ZZ,ZZZ9.
          05 FILLER                PIC X(10) VALUE ' BILLS   '.
          05 WS-T-AMOUNT           PIC $$,$$$,$$9.99.
          05 FILLER                PIC X(2) VALUE SPACES.
          05 WS-T-PAID            PIC $$,$$$,$$9.99.
          05 FILLER                PIC X(2) VALUE SPACES.
          05 WS-T-BALANCE          PIC $$,$$$,$$9.99.

       PROCEDURE DIVISION.
       0000-MAIN-LINE   SECTION.

           PERFORM 1000-INITIALIZE.

           PERFORM 2000-PROCESS.

           PERFORM 9000-TERMINATE.

       1000-INITIALIZE  SECTION.

           ACCEPT WS-DATE FROM DATE YYYYMMDD.
           MOVE WS-CC TO WS-DATE-FMT(1:2).
           MOVE WS-YY TO WS-DATE-FMT(4:2).
           MOVE WS-MM TO WS-DATE-FMT(7:2).
           MOVE WS-DD TO WS-DATE-FMT(10:2).

           PERFORM 2100-OPEN-FILES.

       2100-OPEN-FILES  SECTION.

           OPEN INPUT TI01-BILL-KSDS.
           IF NOT BILL-IO-STATUS
              DISPLAY 'ERROR OPENING BILL KSDS: ' WS-BILL-STATUS
              STOP RUN
           END-IF.

           OPEN INPUT TI01-PAYMENT.
           IF NOT PAY-IO-STATUS
              DISPLAY 'ERROR OPENING PAYMENT FILE: ' WS-PAY-STATUS
              STOP RUN
           END-IF.

           OPEN OUTPUT MO01-BILL-UPD.
           IF NOT UPD-IO-STATUS
              DISPLAY 'ERROR OPENING UPDATED BILL KSDS: ' WS-UPD-STATUS
              STOP RUN
           END-IF.

           OPEN OUTPUT TO01-PAY-REPORT.
           IF NOT RPT-IO-STATUS
              DISPLAY 'ERROR OPENING REPORT FILE: ' WS-RPT-STATUS
              STOP RUN
           END-IF.

       2000-PROCESS     SECTION.

           PERFORM 3000-PRINT-HEADERS.

           PERFORM 2200-READ-PAYMENT.

           PERFORM 2300-READ-BILL.

           PERFORM UNTIL BILL-EOF

               ADD 1 TO WS-BILL-CNT
               MOVE BILL-ID TO WS-CURR-BILL-ID
               MOVE BILL-AMOUNT TO WS-CURR-AMOUNT
               MOVE ZERO TO WS-TOTAL-PAID
               MOVE ZERO TO WS-PAY-CNT

               PERFORM 2400-PROCESS-PAYMENTS
                   UNTIL PAY-EOF
                       OR PAY-BILL-ID NOT = WS-CURR-BILL-ID

               COMPUTE WS-BALANCE = WS-CURR-AMOUNT - WS-TOTAL-PAID

               PERFORM 2500-UPDATE-BILL-STATUS

               PERFORM 2600-WRITE-UPDATED-BILL

               PERFORM 2700-PRINT-DETAIL

               PERFORM 2300-READ-BILL

           END-PERFORM.

           PERFORM 4000-PRINT-SUMMARY.

       2200-READ-PAYMENT  SECTION.

           READ TI01-PAYMENT
                AT END  SET PAY-EOF TO TRUE
                NOT AT END  CONTINUE
           END-READ.

       2300-READ-BILL  SECTION.

           READ TI01-BILL-KSDS
                AT END  SET BILL-EOF TO TRUE
                NOT AT END  CONTINUE
           END-READ.

       2400-PROCESS-PAYMENTS  SECTION.

           ADD PAY-AMOUNT TO WS-TOTAL-PAID
           ADD 1 TO WS-PAY-CNT
           ADD 1 TO WS-PAY-PROC-CNT

           PERFORM 2200-READ-PAYMENT.

       2500-UPDATE-BILL-STATUS  SECTION.

           EVALUATE TRUE
               WHEN WS-TOTAL-PAID = ZERO
                   MOVE 'D' TO UPD-STATUS
                   ADD 1 TO WS-DUE-CNT
               WHEN WS-TOTAL-PAID < WS-CURR-AMOUNT
                   MOVE 'PP' TO UPD-STATUS
                   ADD 1 TO WS-PP-CNT
               WHEN OTHER
                   MOVE 'P' TO UPD-STATUS
                   ADD 1 TO WS-PAID-CNT
           END-EVALUATE.

       2600-WRITE-UPDATED-BILL  SECTION.

           MOVE BILL-ID TO UPD-BILL-ID
           MOVE BILL-CUST-ID TO UPD-CUST-ID
           MOVE BILL-CUST-NAME TO UPD-CUST-NAME
           MOVE BILL-METER-ID TO UPD-METER-ID
           MOVE BILL-READ-DATE TO UPD-READ-DATE
           MOVE BILL-UNITS TO UPD-UNITS
           MOVE BILL-AMOUNT TO UPD-AMOUNT
           MOVE WS-TOTAL-PAID TO UPD-PAID
           MOVE WS-BALANCE TO UPD-BALANCE

           WRITE MO01-BILL-UPD-RECORD.

           ADD BILL-AMOUNT TO WS-TOTAL-AMOUNT
           ADD WS-TOTAL-PAID TO WS-TOTAL-PAID-ALL
           ADD WS-BALANCE TO WS-TOTAL-BALANCE.

       2700-PRINT-DETAIL  SECTION.

           IF WS-LINE-CNT >= WS-LINES-PER-PAGE
              PERFORM 3000-PRINT-HEADERS
           END-IF.

           MOVE BILL-ID TO WS-D-BILLID
           MOVE BILL-CUST-ID TO WS-D-CUSTID
           MOVE BILL-AMOUNT TO WS-D-BILL-AMT
           MOVE WS-TOTAL-PAID TO WS-D-PAID
           MOVE WS-BALANCE TO WS-D-BALANCE
           MOVE UPD-STATUS TO WS-D-STATUS
           MOVE WS-PAY-CNT TO WS-D-PAY-CNT

           MOVE WS-DETAIL-LINE TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           ADD 1 TO WS-LINE-CNT.

       3000-PRINT-HEADERS  SECTION.

           ADD 1 TO WS-PAGE-NUM
           MOVE WS-PAGE-NUM TO WS-PAGE-STR
           MOVE WS-DATE-FMT TO WS-DATE-STR.

           MOVE SPACES TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           STRING WS-REPORT-TITLE '    DATE: ' WS-DATE-STR
                  '    PAGE: ' WS-PAGE-STR
                  DELIMITED BY SIZE
                  INTO TO01-PAY-RPT-RECORD
           END-STRING.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-HEADER-LINE1 TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-HEADER-LINE2 TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-HEADER-LINE3 TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE 6 TO WS-LINE-CNT.

       4000-PRINT-SUMMARY  SECTION.

           IF WS-LINE-CNT >= WS-LINES-PER-PAGE - 4
              PERFORM 3000-PRINT-HEADERS
           END-IF.

           MOVE SPACES TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-HEADER-LINE1 TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-SUMMARY-LINE1 TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-DUE-CNT TO WS-S-DUE
           MOVE WS-PP-CNT TO WS-S-PP
           MOVE WS-PAID-CNT TO WS-S-PAID

           MOVE WS-SUMMARY-LINE2 TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE SPACES TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

           MOVE WS-BILL-CNT TO WS-T-BILLS
           MOVE WS-TOTAL-AMOUNT TO WS-T-AMOUNT
           MOVE WS-TOTAL-PAID-ALL TO WS-T-PAID
           MOVE WS-TOTAL-BALANCE TO WS-T-BALANCE

           MOVE WS-TOTAL-LINE TO TO01-PAY-RPT-RECORD.
           WRITE TO01-PAY-RPT-RECORD.

       9000-TERMINATE   SECTION.

           CLOSE TI01-BILL-KSDS,
                 TI01-PAYMENT,
                 MO01-BILL-UPD,
                 TO01-PAY-REPORT.

           DISPLAY 'BILL PAYMENT STATUS PROCESSING COMPLETE'.
           DISPLAY 'TOTAL BILLS: ' WS-BILL-CNT.
           DISPLAY 'DUE: ' WS-DUE-CNT.
           DISPLAY 'PARTIALLY PAID: ' WS-PP-CNT.
           DISPLAY 'FULLY PAID: ' WS-PAID-CNT.
           DISPLAY 'PAYMENTS PROCESSED: ' WS-PAY-PROC-CNT.
           DISPLAY 'TOTAL BILL AMOUNT: ' WS-TOTAL-AMOUNT.
           DISPLAY 'TOTAL PAID: ' WS-TOTAL-PAID-ALL.
           DISPLAY 'TOTAL BALANCE: ' WS-TOTAL-BALANCE.

           STOP RUN.
