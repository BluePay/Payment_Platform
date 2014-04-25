<?php
/**
  * BluePay PHP 5 Sample Code
  *
  * This code sample runs a $3.00 ACH Sale transaction
  * against a customer using test payment information. 
  * 
  */
include "../BluePayPayment_BP10Emu.php";

  $accountID = "MERCHANT'S ACCOUNT ID HERE";
$secretKey = "MERCHANT'S SECRET KEY HERE";
$mode = "TEST";

// Merchant's Account ID
// Merchant's Secret Key
// Transaction Mode: TEST (can also be LIVE)
$payment = new BluePayPayment_BP10Emu(
   $accountID,
   $secretKey,
   $mode);

// First Name: Bob
// Last Name: Tester
// Address1: 123 Test St.
// Address2: Apt #500
// City: Testville
// State: IL
// Zip: 54321
// Country: USA
$payment--->setCustomerInformation(
   'Bob',
   'Tester',
   '123 Test St.',
   'Apt #500',
   'Testville',
   'IL',
   '54321',
   'USA');

// Routing Number: 071923307
// Account Number: 0523421
// Account Type: Checking
// ACH Document Type: WEB
$payment-&gt;setACHInformation( 
   '071923307',
   '1234123654', 
   'C', 
   'WEB');

// Phone #: 123-123-1234
$payment-&gt;setPhone('1231231234');

// Email Address: test@bluepay.com
$payment-&gt;setEmail('test@bluepay.com');

/* RUN A $3.00 ACH SALE */
$payment-&gt;sale('3.00');

$payment-&gt;process();

# Read response from BluePay
echo 'Status: '. $payment-&gt;getStatus() . '<br />' .
'Message: '. $payment-&gt;getMessage() . '<br />' .
'Transaction ID: '. $payment-&gt;getTransID() . '<br />' .
'AVS Response: ' . $payment-&gt;getAVSResponse() . '<br />' .
'CVS Response: ' . $payment-&gt;getCVV2Response() . '<br />' .
'Masked Account: ' . $payment-&gt;getMaskedAccount() . '<br />' .
'Customer Bank: ' . $payment-&gt;getBank() . '<br />' .
'Authorization Code: ' . $payment-&gt;getAuthCode() . '<br />'; 
?>