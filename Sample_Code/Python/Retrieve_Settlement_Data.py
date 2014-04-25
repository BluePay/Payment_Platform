##
# BluePay Python Sample code.
#
# This code sample runs a report that grabs data from the
# BluePay gateway based on certain criteria. This will ONLY return
# transactions that have already settled. See comments below
# on the details of the report.
# If using TEST mode, only TEST transactions will be returned.
##

from BluePayPayment_BP10Emu import BluePayPayment_BP10Emu

accountID = "MERCHANT'S ACCOUNT ID HERE"
secretKey = "MERCHANT'S SECRET KEY HERE"
mode = "TEST"

# Merchant's Account ID
# Merchant's Secret Key
# Transaction Mode: TEST (can also be LIVE)
report = BluePayPayment_BP10Emu(
    accountID,
    secretKey,
    mode)

# Report Start Date: Jan. 1, 2013
# Report End Date: Jan. 15, 2013
# Also search subaccounts? Yes
# Output response without commas? Yes
# Do not include errored transactions? Yes
response = report.getSettledTransactionReport(
    '2013-01-01',
    '2013-01-15',
    '1',
    '1',
    '1')

# Get response from BluePay
print response