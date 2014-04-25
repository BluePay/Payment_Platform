##
# BluePay Ruby Sample code.
#
# This code sample runs a $3.00 Credit Card Sale transaction
# against a customer using test payment information.
# If approved, a 2nd transaction is run to cancel this transaction.
# If using TEST mode, odd dollar amounts will return
# an approval and even dollar amounts will return a decline.
##

require "BluePayPayment_BP10Emu"

$ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE"
$SECRET_KEY = "MERCHANT'S SECRET KEY HERE"
$MODE = "TEST"

# Merchant's Account ID
# Merchant's Secret Key
# Transaction Mode: TEST (can also be LIVE)
payment = BluePayPayment_BP10Emu.new(
  $ACCOUNT_ID,
  $SECRET_KEY,
  $MODE)

# Card Number: 4111111111111111
# Card Expire: 12/15
# Card CVV2: 123
payment.set_cc_information(
  "4111111111111111", 
  "1215", 
  "123")

# First Name: Bob
# Last Name: Tester
# Address1: 123 Test St.
# Address2: Apt #500
# City: Testville
# State: IL
# Zip: 54321
# Country: USA
payment.set_customer_information(
  "Bob",
  "Tester",
  "123 Test St.",
  "Testville",
  "IL",
  "54321",
  "Apt #500",
  "USA")

# Phone #: 123-123-1234
payment.set_phone("1231231234")

# Email Address: test@bluepay.com
payment.set_email("test@bluepay.com")

# Sale Amount: $3.00
payment.sale("3.00")

response = payment.process()

# If transaction was approved..
if (payment.get_status() == "APPROVED") then

  payment_void = BluePayPayment_BP10Emu.new(
    $ACCOUNT_ID,
    $SECRET_KEY,
    $MODE)

  # Attempts to void above Sale transaction
  payment_void.void(payment.get_trans_id())

  payment_void.process()

  # Read response from BluePay
  puts "TRANSACTION STATUS: " + payment.get_status() 
  puts "TRANSACTION MESSAGE: " + payment.get_message()
  puts "TRANSACTION ID: " + payment.get_trans_id()
  puts "AVS RESPONSE: " + payment.get_avs_code()
  puts "CVV2 RESPONSE: " + payment.get_cvv2_code()
  puts "MASKED PAYMENT ACCOUNT: " + payment.get_masked_account()
  puts "CARD TYPE: " + payment.get_card_type()
  puts "AUTH CODE: " + payment.get_auth_code()
else
  puts payment.get_message()
end