##
# BluePay Ruby Sample code.
#
# This code sample runs a $0.00 Credit Card Auth transaction
# against a customer using test payment information, sets up
# a rebilling cycle, and also shows how to cancel that rebilling cycle.
# See comments below on the details of the initial setup of the 
# rebilling cycle.
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

# Rebill Start Date: Jan. 5, 2015
# Rebill Frequency: 1 MONTH
# Rebill # of Cycles: 5
# Rebill Amount: $3.50
payment.add_recurring_fields(
  "2015-01-05", 
  "1 MONTH", 
  "5", 
  "3.50")

# Phone #: 123-123-1234
payment.set_phone("1231231234")

# Email Address: test@bluepay.com
payment.set_email("test@bluepay.com")

# Auth Amount: $0.00
payment.auth("0.00")

response = payment.process()

# If transaction was approved..
if (payment.get_status() == "APPROVED") then

  rebill_cancel = BluePayPayment_BP10Emu.new(
    $ACCOUNT_ID,
    $SECRET_KEY,
    $MODE)

  # Cancel rebilling cycle from above transaction
  rebill_cancel.cancel_rebilling_cycle(payment.get_rebill_id())

  rebill_cancel.process()
  
  # Read response from BluePay
  puts "REBILL STATUS: " + rebill_cancel.get_rebill_status()
  puts "REBILL ID: " + rebill_cancel.get_reb_id()
  puts "REBILL CREATION DATE: " + rebill_cancel.get_creation_date()
  puts "REBILL NEXT DATE: " + rebill_cancel.get_next_date()
  puts "REBILL LAST DATE: " + rebill_cancel.get_last_date()
  puts "REBILL SCHEDULE EXPRESSION: " + rebill_cancel.get_sched_expression()
  puts "REBILL CYCLES REMAINING: " + rebill_cancel.get_cycles_remaining()
  puts "REBILL AMOUNT: " + rebill_cancel.get_rebill_amount()
  puts "REBILL NEXT AMOUNT: " + rebill_cancel.get_next_amount()
else
  puts payment.get_message()
end