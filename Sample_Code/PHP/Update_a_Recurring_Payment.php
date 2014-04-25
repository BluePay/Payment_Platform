<?php
/**
* BluePay PHP 5 Sample Code
*
* This code sample runs a $0.00 Credit Card Auth transaction
* against a customer using test payment information.
* Once the rebilling cycle is created, this sample shows how to
* update the rebilling cycle. See comments below
* on the details of the initial setup of the rebilling cycle as well as the
* updated rebilling cycle.
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

  $updateRebillPaymentInformation = new BluePayPayment_BP10Emu(
    $accountID,
    $secretKey,
    $mode);

  // Creates a new transaction that reflects a customer's updated card expiration date
  // Card Number: 4111111111111111
  // Card Expire: 01/21
  $updateRebillPaymentInformation->setCCInformation(
    '4111111111111111',
    '0121');

  // Stores new card expiration date
  $updateRebillPaymentInformation->auth("0.00", $payment->getTransID());

  $updateRebillPaymentInformation->process();

  $updateRebill = new BluePayPayment_BP10Emu(
    $accountID,
    $secretKey,
    $mode);

  // Updates rebill using Rebill ID token returned
  // Rebill Start Date: March 1, 2015
  // Rebill Frequency: 1 MONTH
  // Rebill # of Cycles: 8
  // Rebill Amount: $5.15
  // Rebill Next Amount: $1.50
  $updateRebill->updateRebillingCycle(
    $payment->getRebillID(),
    '2015-03-01',
    '1 MONTH',
    '8',
    '5.15',
    '1.50');

  // Updates the payment information portion of the rebilling cycle to the
  // new card expiration date entered above
  $updateRebill->updateRebillingPaymentInformation($updateRebillPaymentInformation->getTransID());

  $updateRebill->process();

  # Read response from BluePay
  echo 'Rebill ID: ' . $updateRebill->getRebillID() . '<br />' .
  'Template ID: ' . $updateRebill->getTemplateID() . '<br />' .
  'Rebill Status: ' . $updateRebill->getRebStatus() . '<br />' .
  'Rebill Creation Date: ' . $updateRebill->getCreationDate() . '<br />' .
  'Rebill Next Date: ' . $updateRebill->getNextDate() . '<br />' .
  'Rebill Last Date: ' . $updateRebill->getLastDate() . '<br />' .
  'Rebill Expression: ' . $updateRebill->getSchedExpr() . '<br />' .
  'Rebill Cycles Remaining: ' . $updateRebill->getCyclesRemaining() . '<br />' .
  'Rebill Amount: ' . $updateRebill->getRebAmount() . '<br />' .
  'Rebill Next Amount Charged: ' . $updateRebill->getNextAmount();
} else {
  echo $payment->getMessage();
}
?>