<?php
/**
* BluePay PHP Sample code.
*
* This code sample runs a report that grabs a single transaction 
* from the BluePay gateway based on certain criteria. 
* See comments below on the details of the report.
* If using TEST mode, only TEST transactions will be returned.
*/

include "BluePayPayment_BP20Post.php";

$accountID = "MERCHANT'S ACCOUNT ID HERE";
$secretKey = "MERCHANT'S SECRET KEY HERE";
$mode = "TEST";

// Merchant's Account ID
// Merchant's Secret Key
// Transaction Mode: TEST (can also be LIVE)
$query = new BluePayPayment_BP20Post(
  $accountID,
  $secretKey,
  $mode);

/* RUN A SINGLE TRANSACTION QUERY */
// Report Start Date: Jan. 1, 2013
// Report End Date: Jan. 15, 2013
// Do not include errored transactions? Yes
$query->getSingleTransQuery(
  '2013-01-01',
  '2013-01-15',
  '1');

// Query by a specific Transaction ID
$query->queryByTransactionID('100122319414');

$query->process();

# Read response from BluePay
echo 'Response: ' . $query->getResponse() . '<br />' .
'First Name: ' . $query->getName1() . '<br />' .
'Last Name:  ' . $query->getName2() . '<br />' .
'Transaction ID: ' . $query->getID() . '<br />' . 
'Payment Type ' . $query->getPaymentType() . '<br />' .
'Transaction Type: ' . $query->getTransType() . '<br />' .
'Amount: ' . $query->getAmount() . '<br />';
?>