##
# BluePay Ruby Sample code.
#
# This code sample runs a $3.00 ACH Sale transaction
# against a customer using test payment information.
##

require "BluePayPayment_BP10Emu"

$ACCOUNT_ID = "100013391447"
$SECRET_KEY = "5YRFNRBCZN/6Y4OPZNWPYDRNAVX7BMMD"
$MODE = "TEST"

# Merchant's Account ID
# Merchant's Secret Key
# Transaction Mode: TEST (can also be LIVE)
payment = BluePayPayment_BP10Emu.new(
  $ACCOUNT_ID,
  $SECRET_KEY,
  $MODE)

# Routing Number: 071923307
# Account Number: 0523421
# Account Type: Checking
# ACH Document Type: WEB
payment.set_ach_information( 
  "071923307", 
  "123456789", 
  'S',
  "WEB")

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

if (payment.get_status() == "APPROVED") then

  # Read response from BluePay
  puts "TRANSACTION STATUS: " + payment.get_status() 
  puts "TRANSACTION MESSAGE: " + payment.get_message()
  puts "TRANSACTION ID: " + payment.get_trans_id()
  puts "AVS RESPONSE: " + payment.get_avs_code()
  puts "CVV2 RESPONSE: " + payment.get_cvv2_code()
  puts "MASKED PAYMENT ACCOUNT: " + payment.get_masked_account()
  puts "CUSTOMER BANK NAME: " + payment.get_bank_name()
  puts "AUTH CODE: " + payment.get_auth_code()
else
  puts payment.get_message()
end