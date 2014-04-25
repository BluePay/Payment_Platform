<?php
    
    /**
     * BluePay PHP 5 Sample Code
     *
     * This code sample runs a report that grabs data from the
     * BluePay gateway based on certain criteria. See comments below
     * on the details of the report.
     * If using TEST mode, only TEST transactions will be returned.
     */
    
    include "BluePayPayment_BP10Emu.php";
    
    $accountID = "MERCHANT'S ACCOUNT ID HERE";
    $secretKey = "MERCHANT'S SECRET KEY HERE";
    $mode = "TEST";
    
    // Merchant's Account ID
    // Merchant's Secret Key
    // Transaction Mode: TEST (can also be LIVE)
    $report = new BluePayPayment_BP10Emu(
      $accountID,
      $secretKey,
      $mode);
    
    /* RUN A TRANSACTION REPORT */
    // Report Start Date: Jan. 1, 2013
    // Report End Date: Jan. 15, 2013
    // Also search subaccounts? Yes
    // Output response without commas? Yes
    // Do not include errored transactions? Yes
    $report->getTransactionReport(
      '2013-01-01',
      '2013-01-15',
      '1',
      '1',
      '1');
    
    $report->process();
    
    // Read response from BluePay
    echo 'Response: '. $report->getResponse() . '<br />';
?>