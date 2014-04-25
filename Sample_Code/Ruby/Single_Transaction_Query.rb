##
# BluePay Ruby Sample code.
#
# This code sample runs a report that grabs a single transaction 
# from the BluePay gateway based on certain criteria. 
# See comments below on the details of the report.
# If using TEST mode, only TEST transactions will be returned.
##

require "BluePayPayment_BP10Emu"

$ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE"
$SECRET_KEY = "MERCHANT'S SECRET KEY HERE"
$MODE = "TEST"

# Merchant's Account ID
# Merchant's Secret Key
# Transaction Mode: TEST (can also be LIVE)
query = BluePayPayment_BP10Emu.new(
  $ACCOUNT_ID,
  $SECRET_KEY,
  $MODE)

# Query Start Date: Jan. 1, 2013
# Query End Date: Jan. 15, 2013
# Do not include errored transactions? Yes
query.get_single_trans_query(
  '2013-01-01',
  '2013-01-15',
  '1')

# Query by a specific Transaction ID
query.query_by_transaction_id('ENTER A TRANSACTION ID HERE');

response = query.process()

if (query.get_id()) then

  # Read response from BluePay
  puts 'Transaction ID: ' + query.get_id()
  puts 'First Name: ' + query.get_name1()
  puts 'Last Name: ' + query.get_name2()
  puts 'Payment Type: ' + query.get_payment_type()
  puts 'Transaction Type: ' + query.get_trans_type()
  puts 'Amount: ' + query.get_amount()
else 
  puts response
end