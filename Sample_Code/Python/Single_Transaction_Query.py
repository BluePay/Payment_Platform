##
# BluePay Ruby Sample code.
#
# This code sample runs a report that grabs a single transaction
# from the BluePay gateway based on certain criteria.
# See comments below on the details of the report.
# If using TEST mode, only TEST transactions will be returned.
##

from BluePayPayment_BP10Emu import BluePayPayment_BP10Emu

accountID = "MERCHANT'S ACCOUNT ID HERE"
secretKey = "MERCHANT'S SECRET KEY HERE"
mode = "TEST"

# Merchant's Account ID
# Merchant's Secret Key
# Transaction Mode: TEST (can also be LIVE)
query = BluePayPayment_BP10Emu(
    accountID,
    secretKey,
    mode)

# Query by a specific Transaction ID
query.queryByTransactionID("ENTER TRANSACTION ID HERE")

# Query Start Date: Jan. 1, 2013
# Query End Date: Jan. 15, 2013
# Do not include errored transactions? Yes
result = query.getSingleTransQuery(
    "2013-01-01",
    "2013-01-15",
    "1")

# Get response from BluePay
print result