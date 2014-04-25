<?php
/**
* BluePay PHP 5 Sample Code
*
* This code sample runs a $3.00 Credit Card Auth transaction
* against a customer using test payment information.
* If approved, a 2nd transaction is run to capture the Auth.
* If using TEST mode, odd dollar amounts will return
* an approval and even dollar amounts will return a decline.
*/

include "BluePayPayment_BP10Emu.php";

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
$payment->setCustomerInformation(
  'Bob',
  'Tester',
  '123 Test St.',
  'Apt #500',
  'Testville',
  'IL',
  '61123',
  'USA');

// Card Number: 4111111111111111
// Card Expire: 12/15
// Card CVV2: 123
$payment->setCCInformation(
  '4111111111111111',
  '1215',
  '123');

// Phone #: 123-123-1234
$payment->setPhone('1231231234');

// Email Address: test@bluepay.com
$payment->setEmail('test@bluepay.com');

/* RUN A $3.00 CREDIT CARD AUTH */
$payment->auth('3.00');

$payment->process();

// If transaction was approved..
if ($payment->getStatus() == "APPROVED") {

  $paymentCapture = new BluePayPayment_BP10Emu(
    $accountID,
    $secretKey,
    $mode);

  // Attempts to capture above Auth transaction
  $paymentCapture->capture($payment->getTransID());

  $paymentCapture->process();

  // Read response from BluePay
  echo 'Status: '. $payment->getStatus() . '<br />' .
  'Message: '. $payment->getMessage() . '<br />' .
  'Transaction ID: '. $payment->getTransID() . '<br />' .
  'AVS Response: ' . $payment->getAVSResponse() . '<br />' .
  'CVS Response: ' . $payment->getCVV2Response() . '<br />' .
  'Masked Account: ' . $payment->getMaskedAccount() . '<br />' .
  'Card Type: ' . $payment->getCardType() . '<br />' .
  'Authorization Code: ' . $payment->getAuthCode() . '<br />';
} else {
  echo $payment->getMessage();
}
?>