##
# BluePay Ruby Sample code.
#
# This code sample runs a report that grabs data from the
# BluePay gateway based on certain criteria. This will ONLY return
# transactions that have already settled. See comments below
# on the details of the report.
# If using TEST mode, only TEST transactions will be returned.
##

require "BluePayPayment_BP10Emu"

$ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE"
$SECRET_KEY = "MERCHANT'S SECRET KEY HERE"
$MODE = "TEST"

# Merchant's Account ID
# Merchant's Secret Key
# Transaction Mode: TEST (can also be LIVE)
report = BluePayPayment_BP10Emu.new(
  $ACCOUNT_ID,
  $SECRET_KEY,
  $MODE)

# Report Start Date: Jan. 1, 2013
# Report End Date: Jan. 15, 2013
# Also search subaccounts? Yes
# Output response without commas? Yes
# Do not include errored transactions? Yes
report.get_settled_transaction_report(
  '2013-01-01',
  '2013-01-15',
  '1',
  '1',
  '1')
report.process()

# Read response from BluePay
puts report.get_response()