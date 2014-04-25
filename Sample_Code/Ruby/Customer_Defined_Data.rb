##
# BluePay Ruby Sample code.
#
# This code sample runs a $15.00 Credit Card Sale transaction
# against a customer using test payment information.
# Optional transaction data is also sent.
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

# Sale Amount: $15.00
payment.sale("15.00")

# Custom ID1: 12345
payment.set_custom_id1("12345")

# Custom ID2: 09866
payment.set_custom_id2("09866")

# Invoice ID: 50000
payment.set_invoice_id("500000")

# Order ID: 10023145
payment.set_order_id("10023145")

# Tip Amount: $6.00
payment.set_amount_tip("6.00")

# Tax Amount: $3.50
payment.set_amount_tax("3.50")

# Food Amount: $3.11
payment.set_amount_food("3.11")

# Miscellaneous Amount: $5.00
payment.set_amount_misc("5.00")

response = payment.process()

# If transaction was approved..
if (payment.get_status() == "APPROVED") then

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