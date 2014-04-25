<?php
/**
* BluePay PHP 5 Sample Code
*
* This code sample runs a $0.00 Credit Card Auth transaction
* against a customer using test payment information, sets up
* a rebilling cycle, and also shows how to cancel that rebilling cycle. See comments below
* on the details of the initial setup of the rebilling cycle.
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
  'Apt #1009',
  'Testville',
  'IL',
  '54321',
  'USA');

// Card Number: 4111111111111111
// Card Expire: 12/15
// Card CVV2: 123
$payment->setCCInformation(
  '4111111111111111',
  '1215',
  '123');

// Rebill Start Date: Jan. 5, 2015
// Rebill Frequency: 1 MONTH
// Rebill # of Cycles: 5
// Rebill Amount: $3.50
$payment->setRebillingInformation(
  '2015-01-05',
  '1 MONTH',
  '5',
  '3.50');

// Phone #: 123-123-1234
$payment->setPhone('1231231234');

// Email Address: test@bluepay.com
$payment->setEmail('test@bluepay.com');

/* RUN A $0.00 CREDIT CARD AUTH */
$payment->auth('0.00');

$payment->process();

// If transaction was approved..
if ($payment->getStatus() == "APPROVED") {

  $cancelRebill = new BluePayPayment_BP10Emu(
    $accountID,
    $secretKey,
    $mode);

  // Cancels rebill above using Rebill ID token returned
  $cancelRebill->cancelRebillingCycle($payment->getRebillID());

  $cancelRebill->process();

  // Read response from BluePay
  echo 'Rebill ID: ' . $cancelRebill->getRebillID() . '<br />' .
  'Template ID: ' . $cancelRebill->getTemplateID() . '<br />' .
  'Rebill Status: ' . $cancelRebill->getRebStatus() . '<br />' .
  'Rebill Creation Date: ' . $cancelRebill->getCreationDate() . '<br />' .
  'Rebill Next Date: ' . $cancelRebill->getNextDate() . '<br />' .
  'Rebill Last Date: ' . $cancelRebill->getLastDate() . '<br />' .
  'Rebill Expression: ' . $cancelRebill->getSchedExpr() . '<br />' .
  'Rebill Cycles Remaining: ' . $cancelRebill->getCyclesRemaining() . '<br />' .
  'Rebill Amount: ' . $cancelRebill->getRebAmount() . '<br />' .
  'Rebill Next Amount Charged: ' . $cancelRebill->getNextAmount();
} else {
  echo $payment->getMessage();
}
?>